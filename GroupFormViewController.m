//
//  GroupFormViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import "GroupFormViewController.h"
#import "RMStepsController/RMStepsController.h"

@interface GroupFormViewController ()

@end

@implementation GroupFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.stepCount == 0 )
    {
        self.nameLabel.text = @"Group Name:";
    }
    else
    {
        self.nameLabel.text = @"Event Name:";
    }
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.minimumScaleFactor = 0.5;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameField.delegate = self;
    self.descriptionField.delegate = self;
    self.descriptionField.returnKeyType = UIReturnKeyDone;
    self.nameField.returnKeyType = UIReturnKeyDone;
    
    //customizing description textview to look similar to textfield
    [self.descriptionField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.descriptionField.layer setBorderWidth:0.5];
    
    self.descriptionField.layer.cornerRadius = 5;
    self.descriptionField.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;

    if (location != NSNotFound)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.descriptionText = textView.text;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.nameText = textField.text;
}

-(IBAction)nextStepTapped:(id)sender
{
    if ([self.nameField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Name field cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (self.stepCount == 0)
        {
            self.stepsController.results[@"group name"] = self.nameField.text;
            self.stepsController.results[@"group description"] = self.descriptionField.text;
        }
        else if (self.stepCount == 1)
        {
            self.stepsController.results[@"event name"] = self.nameField.text;
            self.stepsController.results[@"event description"] = self.descriptionField.text;
        }
        [self.stepsController showNextStep];
    }
}

-(IBAction)previousStepTapped:(id)sender
{
    [self.stepsController showPreviousStep];
}
@end
