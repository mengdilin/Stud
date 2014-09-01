//
//  ViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 8/4/14.
//
//

#import "RSDetailViewController2.h"
#import <Parse/Parse.h>

@interface RSDetailViewController2 ()

@property (nonatomic) UIBarButtonItem *saved;
@property (nonatomic) UIBarButtonItem *signUp;

@end

@implementation RSDetailViewController2

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        self.signUp = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action:@selector(signUp:)];
        
        self.navigationItem.rightBarButtonItem = self.signUp;
        
        self.saved = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Blue_check.png"] style:UIBarButtonItemStylePlain target:self action:@selector(unSignUp:)];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //check if the user is already signed up for this class
    PFUser *user = [PFUser currentUser];
    PFRelation *classRelation = [user relationforKey:@"class"];
    PFQuery *existsQuery = [classRelation query];
    [existsQuery whereKey:@"objectId" equalTo:[self.classObject objectId]];
    if ([[existsQuery findObjects] count] != 0) {
        
        self.navigationItem.rightBarButtonItem = self.saved;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//If user is already signed up for a class, they have the option to drop the class
-(void)unSignUp:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    [query whereKey:@"objectId" equalTo:[self.classObject valueForKey:@"objectId"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFUser *user = [PFUser currentUser];
        PFRelation *relation = [user relationforKey:@"class"];
        [relation removeObject:object];
        [user saveInBackground];
    }];
    
    self.navigationItem.rightBarButtonItem = self.signUp;
}


//Student can sign up for a class
-(void)signUp:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Class"];
    [query whereKey:@"objectId" equalTo:[self.classObject valueForKey:@"objectId"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFUser *user = [PFUser currentUser];
        PFRelation *relation = [user relationforKey:@"class"];
        [relation addObject:object];
        [user saveInBackground];
    }];
    
    self.navigationItem.rightBarButtonItem = self.saved;
}

@end
