//
//  MMMCreatPostTestViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/16/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MMMCreatPostTestViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *nonURLField;
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) NSString *type;
@property (nonatomic) UIImagePickerController *imagePicker;
- (IBAction)postPost:(id)sender;

@end
