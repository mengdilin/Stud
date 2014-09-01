//
//  ClassTimePickerViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/17/14.
//
//

#import "ClassTimePickerViewController.h"
#import "RMStepsController/RMStepsController.h"

@interface ClassTimePickerViewController ()
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSString *weekday;
@property (strong, nonatomic) NSString *hour;
@property (strong, nonatomic) NSString *min;
@end

@implementation ClassTimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSArray *weekday = [dateFormatter shortWeekdaySymbols];
        NSMutableArray *min = [NSMutableArray array];
        
        for (int i = 0; i < 59; i = i+5)
        {
            if (i<10)
            {
                [min addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else
            {
                [min addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        NSMutableArray *hour = [NSMutableArray array];
        for (int i = 0; i < 23; i++)
        {
            if (i<10)
            {
                [hour addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else
            {
                [hour addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        self.array = @[weekday,hour,min];
        self.weekday = @"Sun";
        self.hour = @"00";
        self.min = @"00";
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.doneButton.hidden = YES;
    
}
#pragma mark Picker Delegate Methods
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        // This method provides the data for a specific row in a specific component.
    return [self.array[component] objectAtIndex:row];
}


 //need to work on component wrapping and maybe automatically increase to next date when at max row
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int col = (unsigned long)component;
    if (col == 0)
    {
        self.weekday = self.array[component][row];
    }
    else if (col == 1)
    {
        self.hour = self.array[component][row];
    }
    else if (col == 2)
    {
        self.min = self.array[component][row];
    }
    NSLog(@"%@, %@, %@",self.weekday, self.hour, self.min);
}



#pragma Picker Data Source Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // This method returns the number of components we want in our Picker.
    // The components are the colums.
    return [self.array count];
}

-(void)addTime:(NSString *)timeKey
{
    [self.timePicker reloadAllComponents];
    for (int i = 0; i < [self.array count]; i++)
    {
        [self.timePicker selectRow:0 inComponent:i animated:YES];
    }
    NSString *startTime = [NSString stringWithFormat:@"%@ : %@", self.hour, self.min];
    NSDictionary *dict = @{@"weekday":self.weekday,@"time":startTime};
    if (self.stepsController.results[timeKey] == nil)
    {
        self.stepsController.results[timeKey] = [[NSMutableArray alloc] initWithObjects:dict, nil];
    }
    else
    {
        [self.stepsController.results[timeKey] addObject:dict];
    }
    
    self.weekday = @"Sun";
    self.hour = @"00";
    self.min = @"00";
}

-(IBAction)addStartTime:(id)sender
{
    [self addTime:@"startTime"];
    [self.addTimeButton setTitle:@"Add End Time" forState:UIControlStateNormal];
    [self.addTimeButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.addTimeButton addTarget:self action:@selector(addEndTime:) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.hidden = YES;
    [self.view setNeedsDisplay];
    
}

-(void)addEndTime:(id)sender
{
    [self addTime:@"endTime"];
    [self.addTimeButton setTitle:@"Add Start Time" forState:UIControlStateNormal];
    [self.addTimeButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.addTimeButton addTarget:self action:@selector(addStartTime:) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.hidden = NO;
}

-(IBAction)nextStepTapped:(id)sender
{
    [self.stepsController showNextStep];
}

-(IBAction)previousStepTapped:(id)sender
{
    [self.stepsController showPreviousStep];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.array[component] count];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
