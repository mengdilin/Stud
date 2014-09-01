//
//  GroupStepViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import <UIKit/UIKit.h>
#import "RMStepsController/RMStepsController.h"

@interface GroupStepViewController : RMStepsController
@property (assign, nonatomic) BOOL isGroupViewController;
@property (strong, nonatomic) PFObject *superObject;
@end
