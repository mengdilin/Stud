//
//  MMMProfilePageMenuController.m
//  ParseStarterProject
//
//  Created by Milica Kolundzija on 8/11/14.
//
//

#import "MMMProfilePageMenuController.h"
#import "CustomUIButton.h"

// Constants for creating frames.
static const CGFloat kLeftMargin = -7.0;
static const CGFloat kTopMargin = 100;
static const CGFloat kVerticalOffset = 50; // y-coordinate difference between neighboring buttons
static const CGFloat kLogOutButtonOffset = 100; // y-coordinate difference between the study partners button and the log out button
static const CGFloat kButtonWidth = 150.0;
static const CGFloat kButtonHeight = 30.0;

@interface MMMProfilePageMenuController ()

@property (weak, nonatomic) CustomUIButton *invitesButton;
@property (weak, nonatomic) CustomUIButton *resourcesButton;
@property (weak, nonatomic) CustomUIButton *classesButton;
@property (weak, nonatomic) CustomUIButton *studyGroupsButton;
@property (weak, nonatomic) CustomUIButton *studyPartnersButton;
@property (weak, nonatomic) CustomUIButton *logOutButton;
@property (weak, nonatomic) CustomUIButton *eventsButton;

@end


@implementation MMMProfilePageMenuController

// Sets up 'self.view'; adds all the buttons.
- (void)loadView {
    // Set up 'self.view'
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Set up all the buttons
    self.invitesButton = [CustomUIButton buttonWithType:UIButtonTypeSystem];
    [self.invitesButton setTitle:@"Invites"
                        forState:UIControlStateNormal];
    [self.invitesButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [self.invitesButton addTarget:self.profilePage
                     action:@selector(goToInvites:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.invitesButton];
    
    self.resourcesButton = [CustomUIButton buttonWithType:UIButtonTypeSystem];
    [self.resourcesButton setTitle:@"My Resources"
                          forState:UIControlStateNormal];
    [self.resourcesButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [self.resourcesButton addTarget:self.profilePage
                     action:@selector(goToResources:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resourcesButton];
    
    self.classesButton = [CustomUIButton buttonWithType:UIButtonTypeSystem];
    [self.classesButton setTitle:@"My Classes"
                        forState:UIControlStateNormal];
    [self.classesButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [self.classesButton addTarget:self.profilePage
                       action:@selector(goToClasses:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.classesButton];
    
    self.studyGroupsButton = [CustomUIButton buttonWithType:UIButtonTypeSystem];
    [self.studyGroupsButton setTitle:@"My Groups"
                            forState:UIControlStateNormal];
    [self.studyGroupsButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [self.studyGroupsButton addTarget:self.profilePage
                       action:@selector(goToStudyGroups:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.studyGroupsButton];
    
    self.studyPartnersButton = [CustomUIButton buttonWithType:UIButtonTypeSystem];
    [self.studyPartnersButton setTitle:@"My Partners"
                              forState:UIControlStateNormal];
    [self.studyPartnersButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [self.studyPartnersButton addTarget:self.profilePage
                       action:@selector(goToStudyPartners:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.studyPartnersButton];
    
    self.logOutButton = [CustomUIButton buttonWithType:UIButtonTypeSystem];
    [self.logOutButton setTitle:@"Log out"
                       forState:UIControlStateNormal];
    [self.logOutButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [self.logOutButton addTarget:self.profilePage
                          action:@selector(logOut:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logOutButton];
    
    self.eventsButton = [CustomUIButton buttonWithType:UIButtonTypeSystem];
    [self.eventsButton setTitle:@"My Events"
                       forState:UIControlStateNormal];
    [self.eventsButton addTarget:self.profilePage action:@selector(goToEvents) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.eventsButton];
}

// Creates frames for the subviews.
- (void)viewWillLayoutSubviews {
    self.invitesButton.frame = CGRectMake(kLeftMargin, kTopMargin, kButtonWidth, kButtonHeight);
    self.resourcesButton.frame = CGRectMake(kLeftMargin, kTopMargin + kVerticalOffset, kButtonWidth, kButtonHeight);
    self.classesButton.frame = CGRectMake(kLeftMargin, kTopMargin + 2 * kVerticalOffset, kButtonWidth, kButtonHeight);
    self.studyGroupsButton.frame = CGRectMake(kLeftMargin, kTopMargin + 3 * kVerticalOffset, kButtonWidth, kButtonHeight);
    self.studyPartnersButton.frame = CGRectMake(kLeftMargin, kTopMargin + 4 * kVerticalOffset, kButtonWidth, kButtonHeight);
    self.eventsButton.frame = CGRectMake(kLeftMargin, kTopMargin + 5 * kVerticalOffset, kButtonWidth, kButtonHeight);
    self.logOutButton.frame = CGRectMake(kLeftMargin, kTopMargin + 5 * kVerticalOffset + kLogOutButtonOffset, kButtonWidth, kButtonHeight);
}

@end
