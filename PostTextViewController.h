//
//  PostTextViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/28/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"

@interface PostTextViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *postTitleField;

@property (weak, nonatomic) CustomUIButton *next;
@property (weak, nonatomic) CustomUIButton *prev;


@end
