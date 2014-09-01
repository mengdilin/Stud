//
//  ClassTimePickerViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/17/14.
//
//

#import <UIKit/UIKit.h>

@interface ClassTimePickerViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) IBOutlet UILabel *viewName;
@property (weak, nonatomic) IBOutlet UIButton *addTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;


@end
