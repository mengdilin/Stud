//
//  FindGroupDetailViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/24/14.
//
//

#import "FindGroupDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AllClassesTableViewController.h"
#import "GroupStepViewController.h"
#import "MembersTableViewController.h"
#import "CustomUIButton.h"
#import "EventTableViewController.h"
#import "AllGroupsCollectionViewController.h"

static const float borderWidth = 2.0f;
static const float cornerRadius = 8.0f;
static const float descriptionHeadMargin = 10.0f;
static const float descriptionTailMargin = -10.0f;
static const float gestureDuration = 0.2f;
static const float gestureAllowableMovement = 600;
static const float joinButtonWidthOffSet = 30;
static const float joinButtonHeightOffSet = 20;
static const float joinButtonXOffSet = 10;
static const float joinButtonYOffSet = 10;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface FindGroupDetailViewController ()
-(void)takePhotoFromCamera;
- (void)addFromLibrary;
-(void)updateGroupImage;
@end

@implementation FindGroupDetailViewController
{
    NSMutableArray *upcomingEvents;
    NSMutableArray *pastEvents;
    NSMutableArray *allEvents;
    NSArray *members;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        upcomingEvents = [[NSMutableArray alloc] init];
        pastEvents = [[NSMutableArray alloc] init];
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.isAllGroups = NO;

    }
    return self;
}

-(void)signUp
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [self.groupObject relationforKey:@"members"];
    [relation addObject:user];
    relation = [user relationforKey:@"groups"];
    [relation addObject:self.groupObject];
    
    [self.groupObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have joined this study group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    [user saveInBackground];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateGroupImage];
    if (self.isAllGroups)
    {
        self.navigationController.toolbar.frame = self.tabBarController.tabBar.frame;
        [self.navigationController setToolbarHidden:NO animated:YES];
        CustomUIButton *joinButton = [[CustomUIButton alloc] init];
        [joinButton setTitle:@"Join Group" forState:UIControlStateNormal];
        joinButton.frame = CGRectMake(self.navigationController.toolbar.frame.origin.x+joinButtonXOffSet, self.navigationController.toolbar.frame.origin.y+joinButtonYOffSet, self.navigationController.toolbar.frame.size.width-joinButtonWidthOffSet, self.navigationController.toolbar.frame.size.height-joinButtonHeightOffSet);
        [joinButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *joinButtonItem = [[UIBarButtonItem alloc] initWithCustomView:joinButton];
        [self setToolbarItems:@[joinButtonItem]];
        self.createEventsButton.hidden = YES;
    }
    self.upcomingEventsLabel.text = nil;
    self.pastEventsLabel.text = nil;
    
    //set up group name label font and color
    [self.groupNameLabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:36]];
    self.groupNameLabel.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    
    self.descriptionLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.descriptionLabel.layer.borderWidth = borderWidth;
    self.descriptionLabel.layer.cornerRadius = cornerRadius;
    self.descriptionLabel.clipsToBounds = YES;

    [self.scrollView addSubview:self.contentView];
    
    //set up left and right text margins for description label
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = descriptionHeadMargin;
    style.headIndent = descriptionHeadMargin;
    style.tailIndent = descriptionTailMargin;
    NSString *descriptionDetail = self.groupObject[@"description"];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:descriptionDetail attributes:@{ NSParagraphStyleAttributeName : style}];
    self.descriptionLabel.attributedText = attrText;
    
    self.groupNameLabel.text = self.groupObject[@"name"];
    [self.createEventsButton addTarget:self action:@selector(createEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.membersButton addTarget:self action:@selector(displayMembers) forControlEvents:UIControlEventTouchUpInside];
    [self.view setNeedsDisplay];
    self.scrollView.contentSize = [self.contentView sizeThatFits:CGSizeZero];
    
    [self.profileImageView setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = gestureDuration;
    longPress.allowableMovement = gestureAllowableMovement;
    [self.profileImageView addGestureRecognizer:longPress];
    [self.dropButton setBackgroundColor:[UIColor redColor]];
    if (self.isAllGroups)
    {
        [self.dropButton setHidden:YES];
    }
    [self.dropButton addTarget:self action:@selector(dropGroup) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dropGroup
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"groups"];
    PFQuery *getGroup = [relation query];
    [getGroup whereKey:@"objectId" equalTo:[self.groupObject objectId]];
    [getGroup getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object)
        {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    [self.dropButton setBackgroundColor:[UIColor redColor]];
                    int length = [self.navigationController.viewControllers count];
                    AllGroupsCollectionViewController *previousController = self.navigationController.viewControllers[length-2];
                    [previousController updateData];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
}

-(void)showActionSheet:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Change Group Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take New", @"Open Photo Library", nil];
        sheet.delegate = self;
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self takePhotoFromCamera];
            break;
        }
        case 1:
        {
            [self addFromLibrary];
        }
        default:
            break;
    }
}

    
- (void)displayMembers
{
    MembersTableViewController *membersTableView = [[MembersTableViewController alloc] init];
    membersTableView.groupObject = self.groupObject;
    [self.navigationController pushViewController:membersTableView animated:YES];
}

-(void)createEvent
{
    GroupStepViewController *gfvc = [[GroupStepViewController alloc] init];
    gfvc.isGroupViewController = NO;
    gfvc.superObject = self.groupObject;
    [self.navigationController pushViewController:gfvc animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isAllGroups)
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

-(void)updateGroupImage
{
    [self.groupObject[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            [self.profileImageView setContentMode:UIViewContentModeScaleToFill];
            self.profileImageView.image = image;
            [self.view setNeedsDisplay];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    // Add the image to the Parse database
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.05f);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.groupObject[@"profileImage"] = imageFile;
    [self.groupObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self updateGroupImage];
        }
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)eventsDetail:(UIButton *)sender
{
    EventTableViewController *eventTableView = [[EventTableViewController alloc] initWithStyle:UITableViewStylePlain];
    eventTableView.parentObject = self.groupObject;
    if (self.isAllGroups)
    {
        eventTableView.hideInvite = YES;
        eventTableView.hideJoin = YES;
    }
    else
    {
        eventTableView.hideInvite = NO;
        eventTableView.hideJoin = NO;
    }
    [self.navigationController pushViewController:eventTableView animated:YES];
    
}

- (void)addFromLibrary
{

    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

-(void)takePhotoFromCamera
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}


@end
