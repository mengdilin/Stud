//
//  FindGroupDetailViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/24/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"

@interface FindGroupDetailViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *upcomingEventsButton;
@property (weak, nonatomic) IBOutlet UILabel *upcomingEventsLabel;
@property (weak, nonatomic) IBOutlet UIButton *pastEventsButton;
@property (weak, nonatomic) IBOutlet UILabel *pastEventsLabel;
@property (weak, nonatomic) IBOutlet UIButton *membersButton;
@property (weak, nonatomic) IBOutlet UIButton *createEventsButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *addPropicButton;
@property (weak, nonatomic) IBOutlet CustomUIButton *dropButton;
@property (strong, nonatomic) PFObject *groupObject;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (assign, nonatomic) BOOL isAllGroups;
@end
