//
//  ClassStepViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/15/14.
//
//

#import "ClassStepViewController.h"
#import "ClassFormViewController.h"
#import "ClassViewController.h"
#import "ClassTimePickerViewController.h"
@interface ClassStepViewController ()

@end

@implementation ClassStepViewController

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
    ClassFormViewController *cfvc1 = [[ClassFormViewController alloc] initWithNibName:@"ClassFormViewController" bundle:nil];
    
    ClassFormViewController *cfvc2 = [[ClassFormViewController alloc] initWithNibName:@"ClassFormView2Controller" bundle:nil];
    ClassTimePickerViewController *ctpvc = [[ClassTimePickerViewController alloc] init];
    cfvc1.step.title=@"First";
    cfvc2.step.title=@"Second";
    ctpvc.step.title=@"Third";
    return @[cfvc1,cfvc2,ctpvc];
}

-(void)finishedAllSteps
{
    NSLog(@"%@",self.results);
    PFObject *class = [PFObject objectWithClassName:@"Class"];
    class[@"name"]=self.results[@"name"];
    class[@"location"]=self.results[@"location"];
    class[@"classcode"]=self.results[@"classcode"];
    class[@"professor"]=self.results[@"professor"];
    class[@"starTime"]=self.results[@"startTime"];
    class[@"endTime"]=self.results[@"endTime"];
    [class saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            PFUser *user = [PFUser currentUser];
            PFRelation *relation = [user relationforKey:@"class"];
            [relation addObject:class];
            relation=[class relationforKey:@"students"];
            [relation addObject:user];
            [class saveInBackground];
            [user saveInBackground];
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
