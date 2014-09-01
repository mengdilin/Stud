//
//  MMMSignUpPageViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/11/14.
//
//

#import "MMMSignUpPageViewController.h"
#import <Parse/Parse.h>
#import "MMMLoginViewController.h"
#import "CustomUIButton.h"

static const CGFloat kLeftMargin = 30.0;
static const CGFloat kTopMargin = 30.0;
static const CGFloat kLabelHeight = 20.0;
static const CGFloat kFieldHeight = 30.0;
static const CGFloat kLabelToFieldDistance = 2.0;
static const CGFloat kFieldToLabelDistance = 5.0;
static const CGFloat kButtonYCoordinate = 420.0;
static const CGFloat kButtonWidth = 120.0;
static const CGFloat kButtonHeight = 40.0;
static const CGFloat kExtraScrollingSpace = 50.0;
static const CGFloat kScrollViewTopMargin = 64.0; // 20.0 for the iPhone bar + 44.0 for the navigation bar
static const CGFloat kOffsetAboveKeyboard = 10.0; // space between the selected text field and the keyboard

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface MMMSignUpPageViewController ()

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UITextField *activeField;
@property (nonatomic) UILabel *fullNameLabel;
@property (nonatomic) IBOutlet UITextField *fullNameField;
@property (nonatomic) UILabel *usernameLabel;
@property (nonatomic) IBOutlet UITextField *usernameField;
@property (nonatomic) UILabel *passwordLabel;
@property (nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic) UILabel *confirmPasswordLabel;
@property (nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (nonatomic) UILabel *emailLabel;
@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) UILabel *phoneNumberLabel;
@property (nonatomic) IBOutlet UITextField *phoneNumberField;
@property (nonatomic) IBOutlet UILabel *warningLabel;
@property (nonatomic) UIButton *signUpButton;

@end


@implementation MMMSignUpPageViewController

#pragma - ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Sign up";
        
        // Register for keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

// Sets up 'self.view'.
- (void)loadView {
    // Create a scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    scrollView.backgroundColor = Rgb2UIColor(250, 128, 114); // Salmon color
    // Add extra space at the bottom
    CGSize size = scrollView.bounds.size;
    size.height += kExtraScrollingSpace;
    scrollView.contentSize = size;
    // 'self.scrollView' and 'self.view' are both set to 'scrollView'; 'self.scrollView' is used later for clarity
    self.scrollView = scrollView;
    self.view = scrollView;
    // Add a tap recognizer that will cause the keyboard to get hidden
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // Set up all the labels and text fields and the signup button
    self.fullNameLabel = [[UILabel alloc] init];
    self.fullNameLabel.text = @"Full name";
    [scrollView addSubview:self.fullNameLabel];
    
    self.fullNameField = [[UITextField alloc] init];
    self.fullNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.fullNameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.fullNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.fullNameField.delegate = self;
    [scrollView addSubview:self.fullNameField];
    
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.text = @"Username";
    [scrollView addSubview:self.usernameLabel];
    
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameField.delegate = self;
    [scrollView addSubview:self.usernameField];
    
    self.passwordLabel = [[UILabel alloc] init];
    self.passwordLabel.text = @"Password";
    [scrollView addSubview:self.passwordLabel];
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    [scrollView addSubview:self.passwordField];
    
    self.confirmPasswordLabel = [[UILabel alloc] init];
    self.confirmPasswordLabel.text = @"Confirm password";
    [scrollView addSubview:self.confirmPasswordLabel];
    
    self.confirmPasswordField = [[UITextField alloc] init];
    self.confirmPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.confirmPasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.confirmPasswordField.secureTextEntry = YES;
    self.confirmPasswordField.delegate = self;
    [scrollView addSubview:self.confirmPasswordField];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.text = @"Email";
    [scrollView addSubview:self.emailLabel];
    
    self.emailField = [[UITextField alloc] init];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.delegate = self;
    [scrollView addSubview:self.emailField];
    
    self.phoneNumberLabel = [[UILabel alloc] init];
    self.phoneNumberLabel.text = @"Phone number (optional)";
    [scrollView addSubview:self.phoneNumberLabel];
    
    self.phoneNumberField = [[UITextField alloc] init];
    self.phoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberField.delegate = self;
    [scrollView addSubview:self.phoneNumberField];
    
    self.signUpButton = [[CustomUIButton alloc] init];
    [self.signUpButton setTitle:@"Sign up"
                        forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [self.signUpButton addTarget:self
                           action:@selector(signUp:)
                 forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.signUpButton];
}

// Deletes any leftover text from the text fields.
- (void)viewWillDisappear:(BOOL)animated {
    self.fullNameField.text = @"";
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.confirmPasswordField.text = @"";
    self.emailField.text = @"";
    self.phoneNumberField.text = @"";
}

// Creates frames for the subviews.
- (void)viewWillLayoutSubviews {
    CGFloat viewWidth = self.view.bounds.size.width;
    // The 'width' value causes the right margin to be equal to the left margin
    CGFloat width = viewWidth - 2 * kLeftMargin;
    // 'verticalSpacing' is the difference in height between consecutive labels or consecutive text fields
    CGFloat verticalSpacing = kLabelHeight + kLabelToFieldDistance + kFieldHeight + kFieldToLabelDistance;
    // 'fieldTopMargin' is the y-coordinate of the first text field
    CGFloat fieldTopMargin = kTopMargin + kLabelHeight + kLabelToFieldDistance;
    // 'buttonLeftMargin' is the x-coordinate of the signup button; the button is centered horizontally
    CGFloat buttonLeftMargin = (viewWidth - kButtonWidth) / 2;
    
    self.fullNameLabel.frame = CGRectMake(kLeftMargin, kTopMargin, width, kLabelHeight);
    self.fullNameField.frame = CGRectMake(kLeftMargin, fieldTopMargin, width, kFieldHeight);
    self.usernameLabel.frame = CGRectMake(kLeftMargin, kTopMargin + verticalSpacing, width, kLabelHeight);
    self.usernameField.frame = CGRectMake(kLeftMargin, fieldTopMargin + verticalSpacing, width, kFieldHeight);
    self.passwordLabel.frame = CGRectMake(kLeftMargin, kTopMargin + 2 * verticalSpacing, width, kLabelHeight);
    self.passwordField.frame = CGRectMake(kLeftMargin, fieldTopMargin + 2 * verticalSpacing, width, kFieldHeight);
    self.confirmPasswordLabel.frame = CGRectMake(kLeftMargin, kTopMargin + 3 * verticalSpacing, width, kLabelHeight);
    self.confirmPasswordField.frame = CGRectMake(kLeftMargin, fieldTopMargin + 3 * verticalSpacing, width, kFieldHeight);
    self.emailLabel.frame = CGRectMake(kLeftMargin, kTopMargin + 4 * verticalSpacing, width, kLabelHeight);
    self.emailField.frame = CGRectMake(kLeftMargin, fieldTopMargin + 4 * verticalSpacing, width, kFieldHeight);
    self.phoneNumberLabel.frame = CGRectMake(kLeftMargin, kTopMargin + 5 * verticalSpacing, width, kLabelHeight);
    self.phoneNumberField.frame = CGRectMake(kLeftMargin, fieldTopMargin + 5 * verticalSpacing, width, kFieldHeight);
    self.signUpButton.frame = CGRectMake(buttonLeftMargin, kButtonYCoordinate, kButtonWidth, kButtonHeight);
}


#pragma - End editing

// Called when the user taps the "Return" key. Dismisses the keyboard.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Called when the user taps the background. Dismisses the keyboard.
- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}


#pragma - Manage 'self.activeField'

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}


#pragma - Keyboard notifications

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Inform 'self.scrollView' that there are bars covering up the top of the screen and a keyboard covering up the bottom
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(kScrollViewTopMargin, 0.0, keyboardSize.height + kOffsetAboveKeyboard, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent.
- (void)keyboardWillBeHidden:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    // Account for the bars at the top
    contentInsets.top += kScrollViewTopMargin;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma - IBAction

- (IBAction)signUp:(id)sender {
    // For checking whether the email address is valid
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    // Check that the text fields are filled in properly
    if ([self.fullNameField.text isEqual:@""] || [self.usernameField.text isEqual:@""]
        || [self.passwordField.text isEqual:@""] || [self.confirmPasswordField.text  isEqual:@""]
        || [self.emailField.text  isEqual:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please fill out all required fields."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else if(![self.passwordField.text isEqual:self.confirmPasswordField.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Passwords don't match."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else if (![emailTest evaluateWithObject:self.emailField.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Invalid email address."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else {
        // Create a new user
        PFUser *student = [PFUser user];
        
        // Set up a default profile image
        UIImage *profileImage = [UIImage imageNamed:@"anonymous.jpg"];
        NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.5f);
        PFFile *file = [PFFile fileWithData:imageData];
        [student setObject:file forKey:@"profileImage"];
        
        // Save other information
        [student setObject:self.fullNameField.text
                    forKey:@"FullName"];
        [student setEmail:self.emailField.text];
        [student setUsername:self.usernameField.text];
        [student setPassword:self.passwordField.text];
        [student setObject:self.phoneNumberField.text
                    forKey:@"phoneNumber"];
        [student signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[PFInstallation currentInstallation] setObject:student
                                                         forKey:@"user"];
                [[PFInstallation currentInstallation] saveEventually];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Username already taken"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }];
    }
}

@end
