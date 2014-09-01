//
//  MMMLoginViewController.m
//  FBUProject
//
//  Created by Michelle Adjangba on 7/10/14.
//  Copyright (c) 2014 Michelle Adjangba. All rights reserved.
//

#import "MMMLoginViewController.h"
#import "MMMSignUpPageViewController.h"
#import "MMMProfilePageViewController.h"
#import "ClassViewController.h"
#import "AllClassesTableViewController.h"
#import "MMMChatViewController.h"
#import "MPViewController.h"
#import "GroupsCollectionViewController.h"
#import "SWRevealViewController.h"
#import "MMMProfilePageMenuController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

// For the side menu with buttons on the profile page.
static const CGFloat kProfilePageMenuWidth = 150.0;

@interface MMMLoginViewController () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *usernameField;
@property (nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *facebookLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLogin;

@end


@implementation MMMLoginViewController

#pragma - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        self.navigationItem.title = @"Log in";
        
        _usernameField.delegate = self;
        _passwordField.delegate = self;
        
        _signUpVC = [[MMMSignUpPageViewController alloc] init];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:Rgb2UIColor(250, 128, 114)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    // Hide activity indicator when view is first loaded
    self.activityLogin.hidden = YES;
    
    // Reset the text in the text fields
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    
    // If the user is already logged in, proceed to the profile page
    if ([PFUser currentUser]) {
        [self createControllers];
        [self presentViewController:self.tabBarController
                           animated:NO
                         completion:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma - Create controllers

// Creates the view controllers for 'self.tabBarController', used after the user logs in.
- (void)createControllers {
    // Set up the tab bar controller
    self.tabBarController = [[UITabBarController alloc] init];
    
    // Set up the reveal view controller for the profile page. 'menu' will control a side menu view with buttons
    MMMProfilePageViewController *profVC = [[MMMProfilePageViewController alloc] init];
    MMMProfilePageMenuController *menu = [[MMMProfilePageMenuController alloc] init];
    menu.profilePage = profVC;
    SWRevealViewController *rvc = [[SWRevealViewController alloc] initWithRearViewController:menu
                                                                         frontViewController:profVC];
    rvc.rearViewRevealWidth = kProfilePageMenuWidth;
    profVC.revealViewController = rvc;
    rvc.tabBarItem.title = @"Profile";
    UIImage *rvcImage = [UIImage imageNamed:@"user_folder.png"];
    rvc.tabBarItem.image = rvcImage;
    rvc.navigationItem.title = @"Profile";
    // Button for displaying or hiding the side menu
    rvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburgerIcon.png"]
                                                                                                style:UIBarButtonItemStylePlain
                                                                                                target:rvc
                                                                                                action:@selector(revealToggle:)];
    // Button for editing the profile page
    rvc.navigationItem.rightBarButtonItem = profVC.editButtonItem;
    
    MPViewController *notifvc = [[MPViewController alloc] init];
    
    // Reusing AllClassesTableViewController for findStudyGroup view since both views have the same functionalities with different data
    GroupsCollectionViewController *findGroupVC = [[GroupsCollectionViewController alloc] init];
    findGroupVC.tabBarItem.title = @"Study Groups";
    UIImage *image = [UIImage imageNamed:@"connect.png"];
    findGroupVC.tabBarItem.image = image;
    
    AllClassesTableViewController *findClassVC = [[AllClassesTableViewController alloc] init];
    findClassVC.keyForParse = @"Class";
    findClassVC.tabBarItem.title = @"Classes";
    UIImage *classImage = [UIImage imageNamed:@"classicon2.png"];
    findClassVC.tabBarItem.image = classImage;
    
    MMMChatViewController *chatvc = [[MMMChatViewController alloc] init];
    
    self.navControllerProf = [[UINavigationController alloc] initWithRootViewController:rvc];
    self.navControllerNotif = [[UINavigationController alloc] initWithRootViewController:notifvc];
    self.navControllerFindGroups = [[UINavigationController alloc] initWithRootViewController:findGroupVC];
    self.navControllerChat = [[UINavigationController alloc] initWithRootViewController:chatvc];
    self.navControllerClass = [[UINavigationController alloc] initWithRootViewController:findClassVC];
    
    
    self.navControllerClass.navigationBar.barTintColor = Rgb2UIColor(80, 195, 174);
    self.navControllerChat.navigationBar.barTintColor = Rgb2UIColor(80, 195, 174);
    self.navControllerProf.navigationBar.barTintColor = Rgb2UIColor(80, 195, 174);
    self.navControllerFindGroups.navigationBar.barTintColor = Rgb2UIColor(80, 195, 174);
    self.navControllerNotif.navigationBar.barTintColor = Rgb2UIColor(80, 195, 174);
    
    self.navControllerChat.navigationBar.tintColor = [UIColor whiteColor];
     self.navControllerClass.navigationBar.tintColor = [UIColor whiteColor];
     self.navControllerProf.navigationBar.tintColor = [UIColor whiteColor];
     self.navControllerFindGroups.navigationBar.tintColor = [UIColor whiteColor];
    self.navControllerNotif.navigationBar.tintColor = [UIColor whiteColor];
   
    
    [self.navControllerFindGroups.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navControllerProf.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navControllerClass.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navControllerChat.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navControllerNotif.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [[UITabBar appearance] setBarTintColor:Rgb2UIColor(80, 195, 174)];
    [[UITabBar appearance] setTintColor:Rgb2UIColor(250,128,114)];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                       dictionaryWithObjectsAndKeys: [UIColor greenColor] ,
                                                       UITextAttributeTextColor, nil]
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]
                                             forState:UIControlStateNormal];
    
    
    // All tabs are navigation controllers
    self.tabBarController.viewControllers = @[ self.navControllerNotif, self.navControllerFindGroups, self.navControllerChat, self.navControllerClass, self.navControllerProf];
}


#pragma - End editing

// Dismisses the keyboard when the "Return" key is tapped.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Dismisses the keyboard when the background is tapped.
- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}


#pragma - IBAction

// Logs the user in, or displays an error message if the login fails.
- (IBAction)logIn:(id)sender {
    PFUser *student = [PFUser logInWithUsername:self.usernameField.text
                                       password:self.passwordField.text];
    if (student) {
        self.activityLogin.hidden = NO;
        [self.activityLogin startAnimating];
        
        [self createControllers];
        
        [self.activityLogin stopAnimating];
        self.activityLogin.hidden = YES;
        
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
        [[PFInstallation currentInstallation] saveEventually];
        [self presentViewController:self.tabBarController
                           animated:YES
                         completion:nil];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Incorrect username or password"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

// Displays the signup page.
- (IBAction)signUp:(id)sender {
    [self.navigationController pushViewController:self.signUpVC
                                         animated:YES];
}
@end
