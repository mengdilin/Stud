//
//  PostTextViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/28/14.
//
//

#import "PostTextViewController.h"
#import "RMStepsController/RMStepsController.h"
#import "CustomUIButton.h"

static const CGFloat kViewDistanceFromTop2 = 150.0;
static const CGFloat kViewShiftAndHeight2 = 50;
static const CGFloat kViewStepWidth2 = 80;
static const CGFloat kButtonDistanceFromBottom = 120;


@interface PostTextViewController ()

@end

@implementation PostTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //create the next and previous button programmatically
        _next = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];
        _prev = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];

        [_next addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [_prev addTarget:self action:@selector(prevStep:) forControlEvents:UIControlEventTouchUpInside];


        [_next setTitle:@"NEXT" forState:UIControlStateNormal];
        [_prev setTitle:@"PREV" forState:UIControlStateNormal];

       
        CGFloat screenLength = self.view.frame.size.height;
        CGFloat screenWidth = self.view.frame.size.width;
        
        _prev.frame = CGRectMake(kViewShiftAndHeight2, screenLength - kButtonDistanceFromBottom, kViewStepWidth2, kViewShiftAndHeight2);
        
        _next.frame = CGRectMake(screenWidth - kViewShiftAndHeight2 - kViewStepWidth2, screenLength - kButtonDistanceFromBottom, kViewStepWidth2, kViewShiftAndHeight2);
        

        self.view.backgroundColor = [UIColor whiteColor];


        [self.view addSubview:_next];
        [self.view addSubview:_prev];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.delegate = self;
    _postTitleField.delegate = self;
    [self.textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textView.layer setBorderWidth:0.5];
    
    //added a scrollView
    [_textView setScrollEnabled:YES];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    [scrollView addSubview:_textView];
    [self.view addSubview:_postTitleField];

    // Do any additional setup after loading the view from its nib.
}

-(void)nextStep: (id)selector
{
    if (_textView.text)
    {
        self.stepsController.results[@"text"]=_textView.text;
    }
    
    //if post title is not empty
    if (![_postTitleField.text isEqual: @""])
    {
        self.stepsController.results[@"PostTitle"]=_postTitleField.text;
        [self.stepsController showNextStep];
    }
}

-(void)prevStep: (id)selector
{
    [self.stepsController showPreviousStep];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Makes the keyboard go away if "Done" is tapped on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

@end
