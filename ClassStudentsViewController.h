//
//  ClassStudentsViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/12/14.
//
//

#import <UIKit/UIKit.h>
#import "MMMChatViewController.h"
@interface ClassStudentsViewController : MMMChatViewController
@property (strong, nonatomic) PFObject *classObject;
@end
