//
//  GroupStepViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import "GroupStepViewController.h"
#import "GroupFormViewController.h"
#import "EventDatePickerViewController.h"
#import "EventLocationViewController.h"
#import "AllClassesTableViewController.h"

@interface GroupStepViewController ()

@end

@implementation GroupStepViewController

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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)stepViewControllers
{
    
    GroupFormViewController *groupForm2 = [[GroupFormViewController alloc] init];
    groupForm2.stepCount = 1;
    EventDatePickerViewController *datePickerController = [[EventDatePickerViewController alloc] init];
    EventLocationViewController *locationController = [[EventLocationViewController alloc] init];
    NSArray *stepArray;
    if (self.isGroupViewController)
    {
        GroupFormViewController *groupForm1 = [[GroupFormViewController alloc] init];
        groupForm1.stepCount = 0;
        groupForm1.step.title = @"First";
        groupForm2.step.title = @"Second";
        datePickerController.step.title = @"Third";
        locationController.step.title = @"Fourth";
        stepArray = @[groupForm1, groupForm2, datePickerController, locationController];
    }
    else
    {
        groupForm2.step.title = @"First";
        datePickerController.step.title = @"Second";
        locationController.step.title = @"Third";
        stepArray = @[groupForm2, datePickerController, locationController];
    }
    return stepArray;
}

-(void)finishedAllSteps
{
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"name"] = self.results[@"event name"];
    event[@"description"] = self.results[@"event description"];
    event[@"time"] = self.results[@"time"];
    double latitude = [self.results[@"latitude"] doubleValue];
    double longitude = [self.results[@"longitude"] doubleValue];
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    geoPoint.latitude = latitude;
    geoPoint.longitude = longitude;
    event[@"location"] = geoPoint;
    
    if (self.results[@"address"])
    {
        event[@"address"] = self.results[@"address"];
    }
    else
    {
        event[@"address"] = [NSNull null];
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    int length = [viewControllers count];
    
    //viewControllers[length-1] returns the current view controller
    //viewControllers[length-2] returns the view controller right before the current view controller in the navigation stack. That's the view controller I am trying to access.
    UIImage *image = [UIImage imageNamed:@"event_icon2.png"];
    NSData *data = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithData:data];
    event[@"image"] = imageFile;
    AllClassesTableViewController *allGroups = viewControllers[length-2];
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            if (self.isGroupViewController)
            {
                PFObject *studyGroup = [PFObject objectWithClassName:@"StudyGroup"];
                studyGroup[@"name"] = self.results[@"group name"];
                studyGroup[@"description"] = self.results[@"group description"];
                UIImage *image = [UIImage imageNamed:@"group_default.jpg"];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
                PFFile *imageFile = [PFFile fileWithData:imageData];
                studyGroup[@"profileImage"] = imageFile;
                PFRelation *relation = [studyGroup relationforKey:@"events"];
                [relation addObject:event];
                [studyGroup saveInBackground];
                [allGroups viewWillAppear:YES];
            }
            else
            {
                PFRelation *relation = [self.superObject relationforKey:@"events"];
                [relation addObject:event];
                
                [self.superObject saveInBackground];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

-(void)canceled
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
