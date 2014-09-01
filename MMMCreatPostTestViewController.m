//
//  MMMCreatPostTestViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/16/14.
//
//

#import "MMMCreatPostTestViewController.h"
#import "ParseStarterProjectAppDelegate.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface MMMCreatPostTestViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MMMCreatPostTestViewController

@synthesize textView;
@synthesize postButton;
@synthesize urlField;
@synthesize nonURLField;
@synthesize cancelButton;

    NSArray *post;


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
    
    // THIS CHUNK OF CODE IS VERY IMPORTANT. The key to saving current location to database. So when the post view loads then it saves locaitons
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            
            [[PFUser currentUser] setObject:geoPoint forKey:@"location"];
            [[PFUser currentUser] saveInBackground];
        }
        else NSLog(@"success");
    }];

    // Do any additional setup after loading the view from its nib.
}


- (IBAction)postPost:(id)sender;
{
    // Dismiss keyboard and capture any auto-correct
    [textView resignFirstResponder];
    [urlField resignFirstResponder];
    // Get the post's message, and other details
    NSString *postMessage = textView.text;
    NSString *nonURLSource = nonURLField.text;
    NSString *urlString = urlField.text;
    NSString *postTypeString = _type;

    //boolean to check if link can open
    BOOL canOpenGivenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]];
    
    //Get the currently logged in PFUser
    PFUser *user = [PFUser currentUser];

    PFGeoPoint *testPoint = [[PFUser currentUser] objectForKey:@"location"];
    
    // Keys are saved in Posts class
    PFObject *postObject = [PFObject objectWithClassName:@"Posts"];
    
    //added a relation between the post and user
    PFRelation *relation = [postObject relationforKey:@"UsersPost"];
    [relation addObject:user];
    
    [postObject setObject:postTypeString forKey:@"PostType"];
    [postObject setObject:postMessage forKey:@"text"];
    [postObject setObject:user forKey:@"user"];
    [postObject setObject:testPoint forKey:@"location"];
    [postObject setObject:nonURLSource forKey:@"nonURLSource"];

    //if this link can open then save it to database
    if (canOpenGivenURL)
    {
        [postObject setObject:urlString forKey:@"PostURL"];
    }

    // Set the access control list on the postObject to restrict future modifications
    // to this object
    PFACL *acl = [PFACL ACL];
    [acl setPublicReadAccess:YES]; // Create read-only permissions
    [acl setPublicWriteAccess:YES]; // Set as yes only to update the Like relations
    [postObject setACL:acl]; // Set the permissions on the postObject
    
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error) // Failed to save, show an alert view with the error message
         {
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"]
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
             [alertView show];
             return;
         }
         if (succeeded) // Successfully saved, post a notification to tell other view controllers
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PostCreatedNotification
                                                                     object:nil];
             });
         }
     }];
    
    // User's location
    PFGeoPoint *userGeoPoint = user[@"location"];
    
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    // Interested in locations near user.
    [query whereKey:@"location" nearGeoPoint:userGeoPoint];
    // Limit what could be a lot of points.
    query.limit = 10;
    
    // Final list of objects
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            post = objects;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Fetching" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    
    // Dismiss this view controller and return to the map view
    [self dismissModalViewControllerAnimated:YES];
    
    //reset the post fields
    textView.text = @"";
    nonURLField.text = @"";
    urlField.text = @"";
}


//abandon a post
- (IBAction)leavePost:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)backgroundTapped:(id)sender {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
