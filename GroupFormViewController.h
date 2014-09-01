//
//  GroupFormViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import <UIKit/UIKit.h>

@interface GroupFormViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (copy, nonatomic) NSString *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (copy, nonatomic) NSString *nameText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (assign, nonatomic) int stepCount;
@end

