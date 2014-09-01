//
//  ClassDetailViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/16/14.
//
//

#import "ClassDetailViewController.h"
#import "ClassStudentsViewController.h"

static const float borderWidth = 2.0f;
static const float cornerRadius = 8.0f;
static const float descriptionHeadMargin = 10.0f;
static const float descriptionTailMargin = -10.0f;
static const float joinButtonWidthOffSet = 30;
static const float joinButtonHeightOffSet = 20;
static const float joinButtonXOffSet = 10;
static const float joinButtonYOffSet = 10;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface ClassDetailViewController ()

@end

@implementation ClassDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)signUp
{
    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    [query whereKey:@"objectId" equalTo:[self.classObject objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFUser *user = [PFUser currentUser];
        PFRelation *relation = [user relationforKey:@"class"];
        [relation addObject:object];
        PFRelation *classRelation = [self.classObject relationforKey:@"students"];
        [classRelation addObject:user];
        [self.classObject saveInBackground];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have joined the class!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }];
}

-(void)getStudents
{
    ClassStudentsViewController *studentsDetailView = [[ClassStudentsViewController alloc] init];
    studentsDetailView.classObject = self.classObject;
    [self.navigationController pushViewController:studentsDetailView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbar.frame = self.tabBarController.tabBar.frame;
    [self.navigationController setToolbarHidden:NO animated:YES];
    CustomUIButton *joinButton = [[CustomUIButton alloc] init];
    [joinButton setTitle:@"Join Class" forState:UIControlStateNormal];
    joinButton.frame = CGRectMake(self.navigationController.toolbar.frame.origin.x+joinButtonXOffSet, self.navigationController.toolbar.frame.origin.y+joinButtonYOffSet, self.navigationController.toolbar.frame.size.width-joinButtonWidthOffSet, self.navigationController.toolbar.frame.size.height-joinButtonHeightOffSet);
    [joinButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *joinButtonItem = [[UIBarButtonItem alloc] initWithCustomView:joinButton];
    [self setToolbarItems:@[joinButtonItem]];
    [self.studentsButton addTarget:self action:@selector(getStudents) forControlEvents:UIControlEventTouchUpInside];
    
    [self.name setFont:[UIFont fontWithName:@"GillSans-Bold" size:36]];
    self.name.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    
    self.location.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.location.layer.borderWidth = borderWidth;
    self.location.layer.cornerRadius = cornerRadius;
    self.location.clipsToBounds = YES;
    
    self.professor.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.professor.layer.borderWidth = borderWidth;
    self.professor.layer.cornerRadius = cornerRadius;
    self.professor.clipsToBounds = YES;
    
    self.startTime.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.startTime.layer.borderWidth = borderWidth;
    self.startTime.layer.cornerRadius = cornerRadius;
    self.startTime.clipsToBounds = YES;
    
    self.endTime.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.endTime.layer.borderWidth = borderWidth;
    self.endTime.layer.cornerRadius = cornerRadius;
    self.endTime.clipsToBounds = YES;
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = descriptionHeadMargin;
    style.headIndent = descriptionHeadMargin;
    style.tailIndent = descriptionTailMargin;
    
    self.name.text = self.classObject[@"name"];
    
    NSString *locationText = [NSString stringWithFormat:@"Location: %@",self.classObject[@"location"]];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:locationText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.location.attributedText = attrText;
    
    NSString *professorText = [NSString stringWithFormat:@"Professor: %@",self.classObject[@"professor"]];
    attrText = [[NSAttributedString alloc] initWithString:professorText attributes:@{ NSParagraphStyleAttributeName : style}];
    self.professor.attributedText = attrText;
    
    NSArray *startTimes = self.classObject[@"starTime"];
    NSArray *endTimes = self.classObject[@"endTime"];
    
    NSMutableString *startTimeString = [[NSMutableString alloc] initWithString:@" Start Time:"];
    NSMutableString *endTimeString = [[NSMutableString alloc] initWithString:@" End Time:"];
    
    for (int i=0; i<[startTimes count]; i++)
    {
        NSString *startString = [NSString stringWithFormat:@"\n %@: %@    ", startTimes[i][@"weekday"], startTimes[i][@"time"]];
        [startTimeString appendString:startString];
        
        NSString *endString = [NSString stringWithFormat:@"\n %@: %@    ", endTimes[i][@"weekday"], endTimes[i][@"time"]];
        [endTimeString appendString:endString];
    }
    self.startTime.text = startTimeString;
    self.endTime.text = endTimeString;
    
    [self.view setNeedsDisplay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
