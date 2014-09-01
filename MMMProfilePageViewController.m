//
//  MMMProfilePageViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/11/14.
//
//

#import "MMMProfilePageViewController.h"
#import "ClassViewController.h"
#import "AllClassesTableViewController.h"
#import "MMMStudyPartnersTableViewController.h"
#import "MMMResourcesTableViewController.h"
#import "MMMLoginViewController.h"
#import "MembersTableViewController.h"
#import "AllGroupsCollectionViewController.h"
#import "MMMChatViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomUIButton.h"

static const float borderWidth = 2.0f;
static const float cornerRadius = 8.0f;
static const float LabelHeadMargin = 10.0f;
static const float LabelTailMargin = -10.0f;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
@interface MMMProfilePageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    NSMutableParagraphStyle *style;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *schoolField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (nonatomic) PFUser *currentUser;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *school;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phoneNumber;

@end


@implementation MMMProfilePageViewController

#pragma - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create view controllers that take over when the menu buttons are tapped
        _classVC = [[ClassViewController alloc] init];
        _studyGroupVC = [[AllGroupsCollectionViewController alloc] init];
        _studyPartnersVC = [[MyStudyPartnersViewController alloc] init];
        _resourcesVC = [[MMMResourcesTableViewController alloc] init];
        _invitationVC = [[MembersTableViewController alloc] init];
        _invitationVC.keyForParse = @"Invitee";
        _eventsVC = [[EventTableViewController alloc] init];
        _eventsVC.parentObject = [PFUser currentUser];
        _eventsVC.isMyEvent = YES;
        _eventsVC.hideJoin = YES;
        _eventsVC.hideInvite = YES;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.navigationItem.title = @"Profile";
        
        self.tabBarItem.title = @"Profile";
        UIImage *image = [UIImage imageNamed:@"user_folder.png"];
        self.tabBarItem.image = image;
        
        style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Enable "sliding" the side menu onto/off screen by dragging right/left
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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
    
    self.phoneNumberLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.phoneNumberLabel.layer.borderWidth = borderWidth;
    self.phoneNumberLabel.layer.cornerRadius = cornerRadius;
    self.phoneNumberLabel.clipsToBounds = YES;
    
    style.alignment = NSTextAlignmentCenter;
    style.firstLineHeadIndent = LabelHeadMargin;
    style.headIndent = LabelHeadMargin;
    style.tailIndent = LabelTailMargin;
    
    NSString *nameText;
    if (![[PFUser currentUser][@"FullName"] isEqualToString:@""])
    {
        nameText = [PFUser currentUser][@"FullName"];
    }
    else
    {
        nameText = @"Full Name";
    }
    self.name = nameText;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:nameText attributes:@{ NSParagraphStyleAttributeName : style, NSFontAttributeName: [UIFont fontWithName:@"GillSans-Bold" size:36]}];
    self.nameLabel.attributedText = attrText;
    [self.nameLabel sizeToFit];
    
    NSString *schoolText;
    if(![[PFUser currentUser][@"School"] isEqualToString:@""])
    {
        schoolText = [PFUser currentUser][@"School"];
    }
    else
    {
        schoolText = @"School: None";
    }
    self.school = schoolText;
    attrText = [[NSAttributedString alloc] initWithString:schoolText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.schoolLabel.attributedText = attrText;
    [self.schoolLabel sizeToFit];
    
    NSString *emailText = [PFUser currentUser][@"email"];
    attrText = [[NSAttributedString alloc] initWithString:emailText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.emailLabel.attributedText = attrText;
    self.email = emailText;
    [self.emailLabel sizeToFit];
    
    NSString *phoneText;
    if (![[PFUser currentUser][@"phoneNumber"] isEqualToString:@""] )
    {
        phoneText = [PFUser currentUser][@"phoneNumber"];
    }
    else
    {
        phoneText = @"Phone Number: None";
    }
    self.phoneNumber = phoneText;
    attrText = [[NSAttributedString alloc] initWithString:phoneText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.phoneNumberLabel.attributedText = attrText;
    [self.phoneNumberLabel sizeToFit];
    
    // Set the properties to the current user's attributes
    self.currentUser = [PFUser currentUser];
    
    // For making the keyboard go away
    self.nameField.delegate = self;
    self.schoolField.delegate = self;
    self.emailField.delegate = self;
    self.phoneNumberField.delegate = self;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    [[self.currentUser objectForKey:@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            self.imageView.image = [UIImage imageWithData:data];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.nameLabel.attributedText =[[NSAttributedString alloc] initWithString:self.name attributes:@{ NSParagraphStyleAttributeName : style, NSFontAttributeName: [UIFont fontWithName:@"GillSans-Bold" size:36]}];
    
    self.schoolLabel.attributedText = [[NSAttributedString alloc] initWithString:self.school attributes:@{ NSParagraphStyleAttributeName : style}];
    self.emailLabel.attributedText = [[NSAttributedString alloc] initWithString:self.email attributes:@{ NSParagraphStyleAttributeName : style}];
    self.phoneNumberLabel.attributedText = [[NSAttributedString alloc] initWithString:self.phoneNumber attributes:@{ NSParagraphStyleAttributeName : style}];
    self.nameField.text = self.name;
    self.schoolField.text = self.school;
    self.emailField.text = self.email;
    
    if ([self.phoneNumber isEqualToString:@"Phone Number: None"])
    {
        self.phoneNumberField.text = @"";
    }
    else
    {
        self.phoneNumberField.text = self.phoneNumber;
    }
    [self setEditing:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    // If the view disappears, exit editing mode
    [self setEditing:NO];
}


#pragma - Profile edit mode

// Makes changes while switching into/out of editing mode.
- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated {
    [super setEditing:editing
             animated:animated];
    
    // Show/hide labels, buttons and text fields
    [self updateView:editing];
    
    if (self.editing) {
        // Enter editing mode; fill the text fields with current information
        self.nameField.text = self.name;
        self.schoolField.text = self.school;
        self.emailField.text = self.email;
        if ([self.phoneNumber isEqualToString:@"Phone Number: None"])
        {
            self.phoneNumberField.text = @"";
        }
        else
        {
            self.phoneNumberField.text = self.phoneNumber;
        }
        
        // Show the camera button
        self.revealViewController.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                          target:self
                                                          action:@selector(camera:)];
    }
    else {
        // Exit editing mode; save entered text and update labels
        if (![self.nameField.text isEqualToString:@""]) {
            self.name = self.nameField.text;
            self.currentUser[@"FullName"] = self.name;
            self.nameLabel.attributedText = [[NSAttributedString alloc] initWithString:self.name attributes:@{ NSParagraphStyleAttributeName : style, NSFontAttributeName: [UIFont fontWithName:@"GillSans-Bold" size:36]}];;
        }
        if (![self.schoolField.text isEqualToString:@""]) {
            self.school = self.schoolField.text;
            self.currentUser[@"School"] = self.school;
            self.schoolLabel.attributedText = [[NSAttributedString alloc] initWithString:self.school attributes:@{ NSParagraphStyleAttributeName : style}];;
        }
        if (![self.phoneNumberField.text isEqualToString:@""]) {
            self.phoneNumber = self.phoneNumberField.text;
            self.currentUser[@"phoneNumber"] = self.phoneNumber;
            self.phoneNumberLabel.attributedText = [[NSAttributedString alloc] initWithString:self.phoneNumber attributes:@{ NSParagraphStyleAttributeName : style}];
        }
        
        // Check whether the email is proper
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:self.email]) {
            self.email = self.emailField.text;
            self.currentUser[@"email"] = self.email;
            self.emailLabel.attributedText = [[NSAttributedString alloc] initWithString:self.email attributes:@{ NSParagraphStyleAttributeName : style}];
        }
        
        [[PFUser currentUser] saveInBackground];
        
        // Show the "hamburger icon" (for revealing/hiding the side menu)
        self.revealViewController.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburgerIcon.png"]
                                             style:UIBarButtonItemStylePlain
                                            target:self.revealViewController
                                            action:@selector(revealToggle:)];
        
        // Dismiss the keyboard using already existing method
        [self backgroundTap:self.view];
    }
}


// Updates the view according to the current mode (editing/not editing).
- (void)updateView:(BOOL)isEditing {
    self.nameLabel.hidden = isEditing;
    self.schoolLabel.hidden = isEditing;
    self.emailLabel.hidden = isEditing;
    self.phoneNumberLabel.hidden = isEditing;
    self.nameField.hidden = !isEditing;
    self.schoolField.hidden = !isEditing;
    self.emailField.hidden = !isEditing;
    self.phoneNumberField.hidden = !isEditing;
}


#pragma - End editing

// Makes the keyboard go away if "Done" is tapped on the keyboard.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneNumberField])
    {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else
    {
        [textField setKeyboardType:UIKeyboardTypeDefault];
    }
}

// Makes the keyboard go away if the background is tapped.
- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}


#pragma - Menu button actions

- (IBAction)goToInvites:(id)sender {
    [self.navigationController pushViewController:self.invitationVC animated:YES];
}

- (IBAction)goToResources:(id)sender {
    [self.navigationController pushViewController:self.resourcesVC animated:YES];
}

- (IBAction)goToClasses:(id)sender {
    [self.navigationController pushViewController:self.classVC animated:YES];
}

- (IBAction)goToStudyGroups:(id)sender {
    [self.navigationController pushViewController:self.studyGroupVC animated:YES];
}

- (IBAction)goToStudyPartners:(id)sender {
    [self.navigationController pushViewController:self.studyPartnersVC animated:YES];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    // Dismiss the tab bar controller
    [self.tabBarController.presentingViewController dismissViewControllerAnimated:YES
                                                                       completion:nil];
}

-(void)goToEvents
{
    [self.navigationController pushViewController:self.eventsVC animated:YES];
}

#pragma - Camera

// Called when the user taps the Camera button.
- (IBAction)camera:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise, just pick from the photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker
                       animated:YES
                     completion:nil];
}


// Updates the user's profile image and the imageView after a new image is chosen.
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Add the image to the Parse database
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Update the user's profile image
            [[PFUser currentUser] setObject:imageFile
                                     forKey:@"profileImage"];
            [[PFUser currentUser] saveInBackground];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    // saveInBackground is not very fast, but we should display the new image right away
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
