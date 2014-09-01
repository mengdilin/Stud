//
//  OthersStudyingMapViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/31/14.
//
//

#import "OthersStudyingMapViewController.h"
#import "JPSThumbnailAnnotation.h"
#import "JPSThumbnail.h"
#import "JPSThumbnailAnnotationView.h"
#import "UserProfileViewController.h"

static const float RADIUS = 100.0;
static const float SPAN_X = 0.1;
static const float SPAN_Y = 0.1;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface OthersStudyingMapViewController ()
@property (weak, nonatomic) IBOutlet UILabel *peopleStudyingLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStudentsLabel;

@end

@implementation OthersStudyingMapViewController

{
    MKPointAnnotation *selectedPlaceAnnotation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *checkin = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Check In" style:UIBarButtonItemStylePlain target:self action:@selector(checkin:)];
        
        self.navigationItem.rightBarButtonItem = checkin;

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)checkin: (id)sender
{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            
            [[PFUser currentUser] setObject:geoPoint forKey:@"location"];
            [[PFUser currentUser] saveInBackground];
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Location Checked In" message:@"Your studying location will now be displayed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            // Display Alert Message
            [messageAlert show];
        }
        else NSLog(@"success");
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.mapView.delegate = self;

    //set up label font and color
    [self.peopleStudyingLabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:20]];
    self.peopleStudyingLabel.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    [self.classLabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:17]];
    self.classLabel.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    [self.numberOfStudents setFont:[UIFont fontWithName:@"GillSans-Bold" size:20]];
    self.numberOfStudents.textColor = Rgb2UIColor(250,128,114); //Salmon
    
    
    //get user's location
    PFUser *user = [PFUser currentUser];
    PFGeoPoint *geoPoint = user[@"location"];
    _userGeoPoint = geoPoint;

    PFQuery *findStudent = [[self.classObject relationforKey:@"studentsStudying"] query];
    //Put the students in array to find all of their locations
    _allLocations = [findStudent findObjects];

    self.numberOfStudents.text = [NSString stringWithFormat:@"%d",[_allLocations count]];
    self.nameLabel.text = self.classObject[@"name"];
    
    self.scrollView.contentSize = [self.contentView sizeThatFits:CGSizeZero];
    [self addAnnotations:_allLocations];
    [self updateMap];
    [self.view setNeedsDisplay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMap
{
    //zoom to location
    float spanX = SPAN_X;
    float spanY = SPAN_Y;
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.longitude = _userGeoPoint.longitude;
    region.center.latitude = _userGeoPoint.latitude;
    [self.mapView setRegion:region];
}

//Shows map at current user's location
-(void)showMap
{
    CLLocationCoordinate2D coords;
    coords.latitude = _userGeoPoint.latitude;
    coords.longitude = _userGeoPoint.longitude;
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:place];
    NSArray *items = @[destination];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

//add multiple annotations for different students
- (void)addAnnotations: (NSMutableArray *)allLocations
{
    for (PFUser *location in allLocations)
    {
        //takes the geopoint of all the studying students in the array
        PFGeoPoint *userlocation =location[@"location"];
        CLLocationCoordinate2D pinCoordinate;
        pinCoordinate.latitude = userlocation.latitude;
        pinCoordinate.longitude = userlocation.longitude;
        JPSThumbnail *studentThumbnail = [[JPSThumbnail alloc] init];
        
        PFFile *imageFile = location[@"profileImage"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                studentThumbnail.image = [UIImage imageWithData:data];
                
                //Add annotation in block so the image will appear quickly
                [self.mapView addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:studentThumbnail]];
            }
        }];
        
        studentThumbnail.title = location[@"FullName"];
        studentThumbnail.subtitle = location[@"email"];
        studentThumbnail.coordinate = pinCoordinate;
        
        //when user clicks disclosure button, view goes to student profile
        studentThumbnail.disclosureBlock = ^{
            
            UserProfileViewController *userProfileController = [[UserProfileViewController alloc] init];
            userProfileController.userObject = location;
            PFUser *currentUser = [PFUser currentUser];
            PFRelation *relStudyPartners = [currentUser relationforKey:@"studyPartners"];
            PFQuery *queryStudyPartners = [relStudyPartners query];
            [queryStudyPartners whereKey:@"username"
                                 equalTo:location[@"username"]];
            if (![location[@"username"] isEqualToString:currentUser[@"username"]])
            {
                [queryStudyPartners findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if ([objects count] > 0)
                    {
                        userProfileController.add = NO;
                        [userProfileController.joinButton setTitle:@"Remove from Study Partners" forState:UIControlStateNormal];
                    }
                    else
                    {
                        userProfileController.add = YES;
                        [userProfileController.joinButton setTitle:@"Add to Study Partners" forState:UIControlStateNormal];
                    }
                    [self.navigationController pushViewController:userProfileController
                                                         animated:YES];
                }];
            }
            else
            {
                [self.navigationController pushViewController:userProfileController
                                                     animated:YES];
            }
 
        };
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}


@end
