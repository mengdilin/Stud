//
//  UserProfileViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/11/14.
//
//

#import "UserProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomUIButton.h"
#import "MMMChatViewController.h"

static const float borderWidth = 2.0f;
static const float cornerRadius = 8.0f;
static const float LabelHeadMargin = 10.0f;
static const float LabelTailMargin = -10.0f;
static const float joinButtonWidthOffSet = 30;
static const float joinButtonHeightOffSet = 20;
static const float joinButtonXOffSet = 10;
static const float joinButtonYOffSet = 10;

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation UserProfileViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.joinButton = [[CustomUIButton alloc] init];
        [self.joinButton setTitle:@"" forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.nameLabel.layer.borderWidth = borderWidth;
    self.nameLabel.layer.cornerRadius = cornerRadius;
    self.nameLabel.clipsToBounds = YES;
    self.nameLabel.textColor = Rgb2UIColor(250,128,114);
    
    self.schoolLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.schoolLabel.layer.borderWidth = borderWidth;
    self.schoolLabel.layer.cornerRadius = cornerRadius;
    self.schoolLabel.clipsToBounds = YES;
    
    self.emailLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.emailLabel.layer.borderWidth = borderWidth;
    self.emailLabel.layer.cornerRadius = cornerRadius;
    self.emailLabel.clipsToBounds = YES;
    
    self.studyingClassesLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.studyingClassesLabel.layer.borderWidth = borderWidth;
    self.studyingClassesLabel.layer.cornerRadius = cornerRadius;
    self.studyingClassesLabel.clipsToBounds = YES;
    
    self.phoneNumber.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.phoneNumber.layer.borderWidth = borderWidth;
    self.phoneNumber.layer.cornerRadius = cornerRadius;
    self.phoneNumber.clipsToBounds = YES;
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.firstLineHeadIndent = LabelHeadMargin;
    style.headIndent = LabelHeadMargin;
    style.tailIndent = LabelTailMargin;
    
    NSString *nameText = self.userObject[@"FullName"];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:nameText attributes:@{ NSParagraphStyleAttributeName : style, NSFontAttributeName: [UIFont fontWithName:@"GillSans-Bold" size:36]}];
    self.nameLabel.attributedText = attrText;
    [self.nameLabel sizeToFit];
    
    NSString *phoneText;
    if (self.userObject[@"phoneNumber"])
    {
        phoneText = self.userObject[@"phoneNumber"];
    }
    else
    {
        phoneText = @"Phone Number: None";
    }
    attrText = [[NSAttributedString alloc] initWithString:phoneText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.phoneNumber.attributedText = attrText;
    [self.phoneNumber sizeToFit];
    
    NSString *schoolText;
    if (self.userObject[@"School"])
    {
        schoolText = self.userObject[@"School"];
    }
    else
    {
        schoolText = @"School: None";
    }
    attrText = [[NSAttributedString alloc] initWithString:schoolText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.schoolLabel.attributedText = attrText;
    [self.schoolLabel sizeToFit];
    
    NSString *emailText = self.userObject[@"email"];
    attrText = [[NSAttributedString alloc] initWithString:emailText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.emailLabel.attributedText = attrText;
    [self.emailLabel sizeToFit];
    
    [self.userObject[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            self.profileImageView.image = [UIImage imageWithData:data];
            [self.view setNeedsDisplay];
        }
    }];
    
    self.navigationController.toolbar.frame = self.tabBarController.tabBar.frame;
    
    if (![self.userObject[@"username"] isEqualToString:[PFUser currentUser][@"username"]])
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    else
    {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }

    self.joinButton.frame = CGRectMake(self.navigationController.toolbar.frame.origin.x+joinButtonXOffSet, self.navigationController.toolbar.frame.origin.y+joinButtonYOffSet, self.navigationController.toolbar.frame.size.width-joinButtonWidthOffSet, self.navigationController.toolbar.frame.size.height-joinButtonHeightOffSet);
    [self.joinButton addTarget:self action:@selector(addRemoveStudyPartner) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *joinButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.joinButton];
    [self setToolbarItems:@[joinButtonItem]];

    PFRelation *studyingClasses = self.userObject[@"currentlyStudying"];
    PFQuery *query = [studyingClasses query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects)
        {
            NSMutableString *classes = [[NSMutableString alloc] initWithString:@"Currently Studying:"];
            
            for (PFObject *class in objects)
            {
                NSString *className = [NSString stringWithFormat:@"\n%@",class[@"name"]];
                [classes appendString:className];
            }
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:classes attributes:@{ NSParagraphStyleAttributeName : style}];
            self.studyingClassesLabel.attributedText = attrText;
            [self.view setNeedsDisplay];
        }
    }];
    [self.view setNeedsDisplay];

    self.scrollView.contentSize = [self.view sizeThatFits:CGSizeZero];
}

-(void)addStudyPartner
{
    
    // Check if the selected user is among the current user's study partners
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relStudyPartners = [currentUser relationforKey:@"studyPartners"];
    PFQuery *queryStudyPartners = [relStudyPartners query];
    [queryStudyPartners whereKey:@"username"
                         equalTo:self.userObject[@"username"]];
    
    // 'self.add' is YES iff the query finds anything
    [queryStudyPartners findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects)
        {
            self.add = NO;
            [self.joinButton setTitle:@"Remove from Study Partners" forState:UIControlStateNormal];
        }
        else
        {
            self.add = YES;
            [self.joinButton setTitle:@"Add to Study Partners" forState:UIControlStateNormal];
        }
    }];
}

- (void)addRemoveStudyPartner {
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relStudyPartners = [currentUser relationforKey:@"studyPartners"];
    
    // Add or remove the selected user ('self.user')
    if (self.add) {
        [relStudyPartners addObject:self.userObject];
    }
    else {
        [relStudyPartners removeObject:self.userObject];
    }
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            self.add = !self.add;
            [self setAddRemoveButtonTitle];
        }
    }];
    // Update 'self.add' and the addRemoveButton title
}

- (void)setAddRemoveButtonTitle {
    if (self.add) {
        // Offer to add the selected user to the list of study partners
        [self.joinButton setTitle:@"Add to Study Partners"
                              forState:UIControlStateNormal];
    }
    else {
        // Offer to remove the selected user from the list of study partners
        [self.joinButton setTitle:@"Remove from Study Partners"
                              forState:UIControlStateNormal];
    }
    [self.view setNeedsDisplay];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.userObject[@"username"] isEqualToString:[PFUser currentUser][@"username"]])
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    else
    {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMyPartners)
    {
        int length = [self.navigationController.viewControllers count];
        MMMChatViewController *parentViewController = self.navigationController.viewControllers[length-1];
        
        [parentViewController findStudyPartners];
    }
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
