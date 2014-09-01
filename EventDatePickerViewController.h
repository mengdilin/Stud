//
//  EventDatePickerViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import <UIKit/UIKit.h>

@interface EventDatePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *previouButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
