//
//  ClassDetailViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/16/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"

@interface ClassDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *professor;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet CustomUIButton *studentsButton;
@property (weak, nonatomic) PFObject *classObject;
@property (copy, nonatomic) NSString *objectId;
@end
