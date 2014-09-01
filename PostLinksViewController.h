//
//  PostLinksViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/29/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"

@interface PostLinksViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITextField *nonURLField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *camButton;
@property (weak, nonatomic) CustomUIButton *next;
@property (weak, nonatomic) CustomUIButton *prev;

@end
