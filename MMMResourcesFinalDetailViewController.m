//
//  MMMResourcesFinalDetailViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 8/11/14.
//
//

#import "FindGroupDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AllClassesTableViewController.h"
#import "MembersTableViewController.h"
#import "CustomUIButton.h"
#import "EventTableViewController.h"
#import "MMMResourcesFinalDetailViewController.h"
#import "MMMLinkViewController.h"

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

@interface MMMResourcesFinalDetailViewController ()

@property (nonatomic) CustomUIButton *saveButton;
@property (nonatomic) CustomUIButton *unsaveButton;
@property (nonatomic) UIBarButtonItem *myResourceButtonItem;

@end

@implementation MMMResourcesFinalDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
        _linkToSite = [[MMMLinkViewController alloc] init];
        self.navigationItem.title = @"Full Post";
    }
    return self;
}


-(void)signUp
{
    _linkToSite.url = self.urlLabel.text;
    
    [self.navigationController pushViewController:_linkToSite animated:YES];
}

//Save resource button was pressed
-(void)save: (id)sender
{
    PFUser *user = [PFUser currentUser];
    
    //save post as a relation in the user's savedPosts
    PFRelation *userToPostRelation = [user relationforKey:@"savedPosts"];
    [userToPostRelation addObject:self.classObject];
    [user saveInBackground];
    
    //save user as a person who liked this post
    PFRelation *postToUserRelation = [self.classObject relationforKey:@"Likes"];
    [postToUserRelation addObject:user];
    [self.classObject saveInBackground];
    
    UIBarButtonItem *myResourceButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.unsaveButton];
    [self setToolbarItems:@[myResourceButtonItem]];
    [self.navigationItem setRightBarButtonItem:_bookmarked animated:YES];
    
}

//Unsave
-(void)unlike: (id)sender
{
    //unlike/remove post from save resources
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"savedPosts"];
    [relation removeObject:self.classObject];
    [user saveInBackground];
    self.myResourceButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    [self setToolbarItems:@[self.myResourceButtonItem]];
    [self.navigationItem setRightBarButtonItem:_saveItem animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.saveButton = [[CustomUIButton alloc] init];
    self.unsaveButton = [[CustomUIButton alloc] init];
    
    [self.saveButton setTitle:@"Save Resource" forState:UIControlStateNormal];
    [self.unsaveButton setTitle:@"Remove Resource" forState:UIControlStateNormal];
    
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.unsaveButton addTarget:self action:@selector(unlike:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set up the remove/save resource toolbar
    self.navigationController.toolbar.frame = self.tabBarController.tabBar.frame;
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.saveButton.frame = CGRectMake(self.navigationController.toolbar.frame.origin.x+joinButtonXOffSet, self.navigationController.toolbar.frame.origin.y+joinButtonYOffSet, self.navigationController.toolbar.frame.size.width-joinButtonWidthOffSet, self.navigationController.toolbar.frame.size.height-joinButtonHeightOffSet);
    self.unsaveButton.frame = self.saveButton.frame;
    
    //finds if this post is already saved in user's savedPosts
    PFUser *user = [PFUser currentUser];
    PFRelation *relationSaved = [user relationforKey:@"savedPosts"];
    PFQuery *querySaved = [relationSaved query];
    [querySaved whereKey:@"objectId" equalTo:[self.classObject objectId]];
    NSInteger countSaved = [querySaved countObjects];
    
    //If the post is present
    if (countSaved == 1)
    {
        self.myResourceButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.unsaveButton];
        [self setToolbarItems:@[self.myResourceButtonItem]];
        [self.navigationItem setRightBarButtonItem:_bookmarked animated:YES];
    }
    
    //If the post is not saved
    if (countSaved == 0)
    {
        self.myResourceButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
        [self setToolbarItems:@[self.myResourceButtonItem]];
        [self.navigationItem setRightBarButtonItem:_saveItem animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Setting up the views
    
    //get post user profile image
    [self showImage];
    
    //set up label font and color
    [self.userName setFont:[UIFont fontWithName:@"GillSans-Bold" size:22]];
    self.userName.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    [self.postTitle setFont:[UIFont fontWithName:@"GillSans-Bold" size:17]];
    self.postTitle.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    [self.likes setFont:[UIFont fontWithName:@"GillSans-Bold" size:22]];
    self.likes.textColor = Rgb2UIColor(250,128,114); //Salmon
    [self.subjectLabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:25]];
    self.subjectLabel.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    
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
    NSString *descriptionDetail = self.classObject[@"text"];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:descriptionDetail attributes:@{ NSParagraphStyleAttributeName : style}];
    self.descriptionLabel.attributedText = attrText;
    
    PFUser *puser = [self.classObject objectForKey:@"user"];
    [puser fetchIfNeeded];
    NSString *fullName = [puser objectForKey:@"FullName"];

    self.userName.text = fullName;
    self.postTitle.text = self.classObject[@"PostTitle"];
    
    if (self.classObject[@"subject"] != NULL)
    {
        self.subjectLabel.text = [NSString stringWithFormat:@"Subject: %@",
    self.classObject[@"subject"]];
    }
   
    [self.view setNeedsDisplay];
    self.scrollView.contentSize = [self.contentView sizeThatFits:CGSizeZero];
    
    //set the text of the post
    self.postText.text = self.classObject[@"text"];
    self.urlLabel.text = self.classObject[@"PostURL"];
    self.nonurlLabel.text = [NSString stringWithFormat:@"Keywords: %@", self.classObject[@"nonURLSource"]];
    
    [self.classObject[@"Picture"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            [self.picturePost setContentMode:UIViewContentModeScaleToFill];
            self.picturePost.image = image;
            [self.view setNeedsDisplay];
        }
    }];

    self.nonurlLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.nonurlLabel.layer.borderWidth = borderWidth;
    self.nonurlLabel.layer.cornerRadius = cornerRadius;
    self.nonurlLabel.clipsToBounds = YES;
    
    //gets the users who liked this post
    PFRelation *relationLike = [self.classObject relationforKey:@"Likes"];
    PFQuery *queryLike = [relationLike query];
    NSInteger countlike = [queryLike countObjects];
    
    self.likes.text = [NSString stringWithFormat:@"%d Saved",countlike];
    
    if (self.classObject[@"PostURL"]== nil)
    {
        self.linkButton.hidden = YES;
    }
    else
    {
        self.linkButton.hidden = NO;
    }
    
    if ([self.classObject[@"nonURLSource"] isEqual: NULL])
    {
        self.nonurlLabel.hidden = YES;
    }
    else
    {
        self.nonurlLabel.hidden = NO;
    }
}

//open url in safari
- (IBAction)goToLink:(id)sender {
        
    _linkToSite.url = self.classObject[@"PostURL"];
    
    [self.navigationController pushViewController:_linkToSite animated:YES];
}

//if there is a non https source then prompt user to look up source in Google
- (IBAction)googleIt:(id)sender {
    
    _linkToSite.url = @"http://www.google.com/";
    
    [self.navigationController pushViewController:_linkToSite animated:YES];
}

-(void)showImage
{
    PFUser *puser = [self.classObject objectForKey:@"user"];
    [puser fetchIfNeeded];

    [puser[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            [self.profileImageView setContentMode:UIViewContentModeScaleToFill];
            self.profileImageView.image = image;
            [self.view setNeedsDisplay];
        }
    }];
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

@end
