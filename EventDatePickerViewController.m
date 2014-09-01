//
//  EventDatePickerViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import "EventDatePickerViewController.h"
#import "RMStepsController/RMStepsController.h"

@interface EventDatePickerViewController ()

@end

@implementation EventDatePickerViewController

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
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextStepTapped:(id)sender
{
    NSDate *date = [self.datePicker date];
    self.stepsController.results[@"time"] = date;
    NSLog(@"%@",self.stepsController.results[@"time"]);
    [self.stepsController showNextStep];
}

-(IBAction)previousStepTapped:(id)sender
{
    [self.stepsController showPreviousStep];
}
@end
