//
//  PostTypeViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/28/14.
//
//

#import "PostTypeViewController.h"
#import "RMStepsController/RMStepsController.h"
#import "CustomUIButton.h"

static const CGFloat kViewDistanceFromTop = 150.0;
static const CGFloat kViewShiftAndHeight = 50;
static const CGFloat kViewStepWidth = 80;
static const CGFloat kViewDistanceFromTopMultiple = 60;
static const CGFloat kButtonDistanceFromBottom = 120;

@interface PostTypeViewController ()

@end

@implementation PostTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Creating the buttons programatically
        _video = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];
        _web = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];
        _tips = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];
        _all = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];
        _next = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];
        _prev = [CustomUIButton buttonWithType:UIButtonTypeRoundedRect];

        [_video addTarget:self action:@selector(setVid:) forControlEvents:UIControlEventTouchUpInside];
        [_web addTarget:self action:@selector(setWeb:) forControlEvents:UIControlEventTouchUpInside];
        [_tips addTarget:self action:@selector(setTips:) forControlEvents:UIControlEventTouchUpInside];
        [_all addTarget:self action:@selector(setAll:) forControlEvents:UIControlEventTouchUpInside];
        [_next addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [_prev addTarget:self action:@selector(prevStep:) forControlEvents:UIControlEventTouchUpInside];


        [_video setTitle:@"Video" forState:UIControlStateNormal];
        [_web setTitle:@"Web" forState:UIControlStateNormal];
        [_tips setTitle:@"Tips" forState:UIControlStateNormal];
        [_all setTitle:@"All" forState:UIControlStateNormal];
        [_next setTitle:@"NEXT" forState:UIControlStateNormal];
        [_prev setTitle:@"PREV" forState:UIControlStateNormal];

        [self.view setBackgroundColor:[UIColor whiteColor]];

        CGFloat screenLength = self.view.frame.size.height;
        CGFloat screenWidth = self.view.frame.size.width;
        CGFloat typeWidth = screenWidth - kViewShiftAndHeight * 2;
        
        _video.frame = CGRectMake(kViewShiftAndHeight, kViewDistanceFromTop, typeWidth, kViewShiftAndHeight);
        _web.frame = CGRectMake(kViewShiftAndHeight, kViewDistanceFromTop + kViewDistanceFromTopMultiple , typeWidth, kViewShiftAndHeight);
        _tips.frame = CGRectMake(kViewShiftAndHeight, kViewDistanceFromTop + kViewDistanceFromTopMultiple * 2, typeWidth, kViewShiftAndHeight);
        _all.frame = CGRectMake(kViewShiftAndHeight, kViewDistanceFromTop + kViewDistanceFromTopMultiple * 3, typeWidth, kViewShiftAndHeight);
    
        _prev.frame = CGRectMake(kViewShiftAndHeight, screenLength - kButtonDistanceFromBottom, kViewStepWidth, kViewShiftAndHeight);
        
        _next.frame = CGRectMake(screenWidth - kViewShiftAndHeight - kViewStepWidth, screenLength - kButtonDistanceFromBottom, kViewStepWidth, kViewShiftAndHeight);

        [self.view addSubview:_video];
        [self.view addSubview:_web];
        [self.view addSubview:_tips];
        [self.view addSubview:_all];
        [self.view addSubview:_next];
        [self.view addSubview:_prev];

    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)nextStep: (id)selector
{
    if (_type){
        self.stepsController.results[@"PostType"]=_type;
        [self.stepsController showNextStep];
    }
    else
    {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"NOOO" message:@"You must select a post type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display Alert Message
        [messageAlert show];

    }
}

-(void)prevStep: (id)selector
{
    [self.stepsController showPreviousStep];
}

//These will set the post type
-(void)setWeb:(id)selector
{
    _type = @"Web";
    [_web setSelected:YES];
    [_all setSelected:NO];
    [_video setSelected:NO];
    [_tips setSelected:NO];
}

-(void)setVid:(id)selector
{
    _type = @"Vid";
    [_video setSelected:YES];
    [_all setSelected:NO];
    [_web setSelected:NO];
    [_tips setSelected:NO];
}

-(void)setTips:(id)selector
{
    _type = @"Tips";
    [_tips setSelected:YES];
    [_all setSelected:NO];
    [_video setSelected:NO];
    [_web setSelected:NO];
}

-(void)setAll:(id)selector
{
    _type = @"All";
    [_all setSelected:YES];
    [_web setSelected:NO];
    [_video setSelected:NO];
    [_tips setSelected:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
