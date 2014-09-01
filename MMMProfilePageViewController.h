//
//  MMMProfilePageViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/11/14.
//
//

#import <UIKit/UIKit.h>
#import "AllClassesTableViewController.h"
#import "MembersTableViewController.h"
#import "SWRevealViewController.h"
#import "MMMChatViewController.h"
#import "EventTableViewController.h"
#import "MyStudyPartnersViewController.h"

@class AllGroupsCollectionViewController;

@interface MMMProfilePageViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) SWRevealViewController *revealViewController;
@property (nonatomic) UITabBarController *tabBar;
@property (nonatomic) UINavigationController *navCont;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UITableViewController *classVC;
@property (nonatomic) AllGroupsCollectionViewController *studyGroupVC;
@property (nonatomic) MyStudyPartnersViewController *studyPartnersVC;
@property (nonatomic) UITableViewController *resourcesVC;
@property (nonatomic) MembersTableViewController *invitationVC;
@property (nonatomic) EventTableViewController *eventsVC;
@end
