//
//  MyClassDetailViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/18/14.
//
//

#import "MyClassDetailViewController.h"
#import "MyClassGradesTableViewController.h"
#import "ClassViewController.h"
#import "MPPlot/MPGraphView.h"
#import "MPPlot/MPPlot.h"
#import "OthersStudyingMapViewController.h"
#import "CustomUIButton.h"

static const float borderWidth = 2.0f;
static const float cornerRadius = 8.0f;
static const float joinButtonWidthOffSet = 30;
static const float joinButtonHeightOffSet = 20;
static const float joinButtonXOffSet = 10;
static const float joinButtonYOffSet = 10;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface MyClassDetailViewController ()
{
    NSMutableArray *gradesInfo, *gradesScore, *classGradesInfo;
    
   //MPPlot supports two types of graphs: one with a single line that has points on the line, another that just has a background but without points or a concrete line . "graph" vdraws the line. "filledGraph" paints the background.
    MPGraphView *graph,*filledGraph;
}

@end

@implementation MyClassDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gradeEntry = [[UIAlertView alloc] initWithTitle:@"Add Your Grade" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.name.text = self.classObject[@"name"];
    self.location.text = [NSString stringWithFormat:@" Location: %@ ", self.classObject[@"location"]];
    self.professor.text = [NSString stringWithFormat:@" Professor: %@ ", self.classObject[@"professor"]];
    [self.view setNeedsDisplay];
    [self updateGraph];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)updateGraph
{
    gradesInfo = [PFUser currentUser][@"grades"];
    gradesScore = [[NSMutableArray alloc] init];
    classGradesInfo = [[NSMutableArray alloc] init];
    for (id item in gradesInfo)
    {
        if ([item[@"class id"] isEqualToString:[self.classObject objectId]])
        {
            [gradesScore addObject:item[@"grade"]];
            [classGradesInfo addObject:@{@"grade":item[@"grade"],@"exam type":item[@"exam type"]}];
        }
    }
    
    if ([gradesScore count] != 0)
    {
        graph = [MPPlot plotWithType:MPPlotTypeGraph frame:CGRectMake(0, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height)];
        graph.fillColors = @[[UIColor colorWithRed:0.251 green:0.232 blue:1.000 alpha:1.000],[UIColor colorWithRed:0.282 green:0.945 blue:1.000 alpha:1.000]];
        graph.values = gradesScore;
        graph.graphColor = [UIColor colorWithRed:0.500 green:0.158 blue:1.000 alpha:1.000];
        graph.detailBackgroundColor = [UIColor colorWithRed:0.444 green:0.842 blue:1.000 alpha:1.000];
        graph.graphColor = [UIColor clearColor];
        graph.curved = YES;
        [self.containerView addSubview:graph];
        
        filledGraph = [[MPGraphView alloc] initWithFrame:graph.frame];
        filledGraph.waitToUpdate = YES;
        filledGraph.values = gradesScore;
        filledGraph.graphColor = [UIColor redColor];
        filledGraph.curved = YES;
        [self.containerView addSubview:filledGraph];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [filledGraph animate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.gradeEntry setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [self.dropClassButton setBackgroundColor:[UIColor redColor]];
    [self.addGradesButton addTarget:self action:@selector(addGrade:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsButton addTarget:self action:@selector(viewGradeDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.dropClassButton addTarget:self action:@selector(dropClass) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.toolbar.frame = self.tabBarController.tabBar.frame;
    [self.navigationController setToolbarHidden:NO animated:YES];
    CustomUIButton *joinButton = [[CustomUIButton alloc] init];
    [joinButton setTitle:@"Find Nearby Study Partners" forState:UIControlStateNormal];
    joinButton.frame = CGRectMake(self.navigationController.toolbar.frame.origin.x+joinButtonXOffSet, self.navigationController.toolbar.frame.origin.y+joinButtonYOffSet, self.navigationController.toolbar.frame.size.width-joinButtonWidthOffSet, self.navigationController.toolbar.frame.size.height-joinButtonHeightOffSet);
    [joinButton addTarget:self action:@selector(goToMapView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *joinButtonItem = [[UIBarButtonItem alloc] initWithCustomView:joinButton];
    [self setToolbarItems:@[joinButtonItem]];
    
    
    //set up group name label font and color
    [self.name setFont:[UIFont fontWithName:@"GillSans-Bold" size:36]];
    self.name.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    
    self.professor.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.professor.layer.borderWidth = borderWidth;
    self.professor.layer.cornerRadius = cornerRadius;
    self.professor.clipsToBounds = YES;
    
    self.location.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.location.layer.borderWidth = borderWidth;
    self.location.layer.cornerRadius = cornerRadius;
    self.location.clipsToBounds = YES;
    
    
}

-(void)dropClass
{
    [self.dropClassButton setBackgroundColor:[UIColor redColor]];
    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    [query whereKey:@"objectId" equalTo:[self.classObject valueForKey:@"objectId"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFUser *user = [PFUser currentUser];
        PFRelation *relation = [user relationforKey:@"class"];
        [relation removeObject:object];
        
        
        PFRelation *relation2 = [object relationforKey:@"students"];
        //relation = [object relationforKey:@"students"];
        [relation2 removeObject:user];
        
        PFRelation *relation3 = [object relationforKey:@"studentsStudying"];
        [relation3 removeObject:user];
        
        //Remove history of currently studying
        PFRelation *relation4 = [user relationforKey:@"currentlyStudying"];
        [relation4 removeObject:object];
        
        [user saveInBackground];
        [object saveInBackground];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)viewGradeDetail
{
    MyClassGradesTableViewController *mcgtvc = [[MyClassGradesTableViewController alloc] init];
    mcgtvc.gradesInfo  = [[NSArray alloc] initWithArray:classGradesInfo];
    
    [self.navigationController pushViewController:mcgtvc animated:YES];
}

-(void)addGrade:(id)sender
{
    [[self.gradeEntry textFieldAtIndex:1] setSecureTextEntry:NO];
    [[self.gradeEntry textFieldAtIndex:0] setPlaceholder:@"Exam Type"];
    [[self.gradeEntry textFieldAtIndex:1] setPlaceholder:@"Score"];
    [self.gradeEntry textFieldAtIndex:1].keyboardType = UIKeyboardTypeDecimalPad;
    [self.gradeEntry show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *examType = [alertView textFieldAtIndex:0].text;
        NSString *grade = [alertView textFieldAtIndex:1].text;
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        BOOL isDecimal = [numFormat numberFromString:grade] != nil;
        if (isDecimal == NO)
        {
            UIAlertView *invalidEntry = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"grade must be a number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [invalidEntry show];
        }
        else
        {
            PFUser *user = [PFUser currentUser];
            NSDictionary *dict = @{@"exam type":examType, @"grade":grade, @"class":self.classObject[@"name"], @"class id": [self.classObject objectId]};
            if (user[@"grades"] == nil)
            {
                user[@"grades"] = [[NSMutableArray alloc] initWithObjects:dict, nil];
                
            }
            else
            {
                [user[@"grades"] addObject:dict];
            }
            [user saveInBackground];
            [graph removeFromSuperview];
            [filledGraph removeFromSuperview];
            [self updateGraph];
            [self viewDidAppear:YES];
        }
    }
    [alertView textFieldAtIndex:0].text = nil;
    [alertView textFieldAtIndex:1].text = nil;
    
}

- (UIView *)customDetailView{
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderColor = label.textColor.CGColor;
    label.layer.borderWidth = .5;
    label.layer.cornerRadius = label.width*.5;
    
    label.adjustsFontSizeToFitWidth = YES;
    label.clipsToBounds = YES;
    
    return label;
}

-(void)goToMapView:(id)sender
{
    OthersStudyingMapViewController *othersMapVC = [[OthersStudyingMapViewController alloc] init];
    othersMapVC.classObject = self.classObject;
    [self.navigationController pushViewController:othersMapVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end