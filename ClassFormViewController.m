//
//  ClassFormViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/15/14.
//
//

#import "ClassFormViewController.h"
#import "RMStepsController/RMStepsController.h"
@interface ClassFormViewController ()<UITextFieldDelegate>
{

}

@end

@implementation ClassFormViewController



-(void)loadView
{
    [super loadView];
    self.field1.delegate=self;
    self.field2.delegate=self;
    
    //view=[[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 430)];

}

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
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextStepTapped:(id)sender
{
    int step =(unsigned long)self.stepsController.stepsBar.indexOfSelectedStep;
    if(step==0)
    {
        if (![self.field1.text isEqualToString:@""])
        {
            self.stepsController.results[@"name"]=self.field1.text;
            self.stepsController.results[@"classcode"]=self.field2.text;
            [self.stepsController showNextStep];
        }
        else
        {
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error" message:@"You must enter all fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            // Display Alert Message
            [messageAlert show];
        }
        //NSLog(@"%@",self.field1.text);
    }
    if(step==1)
    {
        if (![self.field1.text isEqualToString:@""] && ![self.field2.text isEqualToString:@""])
        {
            self.stepsController.results[@"professor"]=self.field1.text;
            self.stepsController.results[@"location"]=self.field2.text;
            [self.stepsController showNextStep];
        }
        else
        {
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error" message:@"You must enter all fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            // Display Alert Message
            [messageAlert show];
        }

        //NSLog(@"%@",self.field2.text);
    }
    //NSLog(@"step name %lu",(unsigned long)self.stepsController.stepsBar.indexOfSelectedStep);
    //NSLog(@"%@",self.stepsController.results);
}

-(IBAction)previousStepTapped:(id)sender
{
    [self.stepsController showPreviousStep];
}
@end
