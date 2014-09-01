//
//  UserProfileViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/11/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"
@interface UserProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *studyingClassesLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (strong, nonatomic) PFObject *userObject;
@property (assign, nonatomic) BOOL add;
@property (strong, nonatomic) CustomUIButton *joinButton;
@property (assign, nonatomic) BOOL isMyPartners;
@property (assign, nonatomic) BOOL isSelf;
-(void)addStudyPartner;
@end

