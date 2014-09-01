//
//  PostLinksViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/29/14.
//
//

#import "PostLinksViewController.h"
#import "RMStepsController/RMStepsController.h"
#import "CustomUIButton.h"

static const CGFloat kViewDistanceFromTop2 = 150.0;
static const CGFloat kViewShiftAndHeight2 = 50;
static const CGFloat kViewStepWidth2 = 80;

@interface PostLinksViewController () <UIScrollViewDelegate>

@end

@implementation PostLinksViewController

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
        
        
        //300 is a temporary arbitrary distance from the top
        _prev.frame = CGRectMake(kViewShiftAndHeight2, kViewDistanceFromTop2 + 300, kViewStepWidth2, kViewShiftAndHeight2);
        
        //170 is temporary distance horizontally from the frame
        _next.frame = CGRectMake(170, kViewDistanceFromTop2 + 300, kViewStepWidth2, kViewShiftAndHeight2);
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_next];
        [self.view addSubview:_prev];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.subjectField.delegate = self;
    self.urlField.delegate = self;
    self.nonURLField.delegate = self;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    [scrollView addSubview: _next];
    [scrollView addSubview: _prev];
    [scrollView addSubview:self.urlField];
    [scrollView addSubview:self.nonURLField];
    [scrollView addSubview:self.subjectField];
    [scrollView addSubview:_camButton];

    // Do any additional setup after loading the view from its nib.
}

// Makes the keyboard go away if the background is tapped
- (IBAction)backgroundTap:(id)sender {
    [self.nonURLField resignFirstResponder];
    [self.urlField resignFirstResponder];
}

// Makes the keyboard go away if "Done" is tapped on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// Called when the user taps the Camera icon
- (IBAction)camera:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise, just pick from the photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker
                       animated:YES
                     completion:NULL];
}


// Updates the user's profile image and the imageView after a new image is chosen
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Add the image to the Parse database
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //Implement in next diff
            self.stepsController.results[@"Picture"]= imageFile;
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    // saveInBackground is not very fast, but we should display the new image right away
    _imageView.image = image;
    
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Save the text in the fields
-(void)nextStep: (id)selector
{
    if (_nonURLField.text)
    {
        self.stepsController.results[@"nonURLSource"]= _nonURLField.text;
    }
    
    if (![_subjectField.text isEqual: @""])
    {
        self.stepsController.results[@"subject"]= _subjectField.text;
        
        if (_urlField.text)
        {
            NSString *urlString = _urlField.text;
            //boolean to check if link can open
            BOOL canOpenGivenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]];
            if ([urlString isEqualToString:@""])
            {
                [self.stepsController showNextStep];
            }
            //if this link can open then save it to database
            else if (canOpenGivenURL)            {
                self.stepsController.results[@"PostURL"]= _urlField.text;
                [self.stepsController showNextStep];
            }
            
            else
            {
                UIAlertView *messageAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Error" message:@"Invalid URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                // Display Alert Message
                [messageAlert show];
            }
            
        }
}
    else
    {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Error" message:@"Must specify a subject." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display Alert Message
        [messageAlert show];
    }
}

-(void)prevStep: (id)selector
{
    [self.stepsController showPreviousStep];
}


@end
