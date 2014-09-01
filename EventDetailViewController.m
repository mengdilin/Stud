//
//  EventDetailViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/29/14.
//
//

#import <QuartzCore/QuartzCore.h>
#import "EventDetailViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "EventLocationViewController.h"
#import "MembersTableViewController.h"
#import "FindGroupDetailViewController.h"
#import "CustomUIButton.h"

static const float descriptionHeadMargin = 10.0f;
static const float descriptionTailMargin = -10.0f;
static const float borderWidth = 2.0f;
static const float cornerRadius = 8.0f;
static const float joinButtonWidthOffSet = 30;
static const float joinButtonHeightOffSet = 20;
static const float joinButtonXOffSet = 10;
static const float joinButtonYOffSet = 10;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
{
    MKPointAnnotation *selectedPlaceAnnotation;
    PFGeoPoint *location;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.hideJoin = NO;
        self.hideInvite = NO;
    }
    return self;
}

-(void)inviteMembers
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    int length = [viewControllers count];
    
    //Retrieving FindGroupDetailViewController which is the third to last in the navigation stack
    FindGroupDetailViewController *groupDetail = viewControllers[length-3];
    MembersTableViewController *inviteTableView = [[MembersTableViewController alloc] init];
    inviteTableView.keyForParse = @"Invite";
    inviteTableView.eventObject = self.eventObject;
    inviteTableView.groupObject = groupDetail.groupObject;
    [self.navigationController pushViewController:inviteTableView animated:YES];
}

-(void)signUp
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"events"];
    [relation addObject:self.eventObject];
    relation = [self.eventObject relationforKey:@"members"];
    [relation addObject:user];
    [self.eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have signed up for the event" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    [user saveInBackground];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!self.hideJoin)
    {
        self.navigationController.toolbar.frame = self.tabBarController.tabBar.frame;
        [self.navigationController setToolbarHidden:NO animated:YES];
        CustomUIButton *joinButton = [[CustomUIButton alloc] init];
        [joinButton setTitle:@"Join Event" forState:UIControlStateNormal];
        joinButton.frame = CGRectMake(self.navigationController.toolbar.frame.origin.x+joinButtonXOffSet, self.navigationController.toolbar.frame.origin.y+joinButtonYOffSet, self.navigationController.toolbar.frame.size.width-joinButtonWidthOffSet, self.navigationController.toolbar.frame.size.height-joinButtonHeightOffSet);
        [joinButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *joinButtonItem = [[UIBarButtonItem alloc] initWithCustomView:joinButton];
        [self setToolbarItems:@[joinButtonItem]];
    }
    
    if (!self.hideInvite)
    {
        UIBarButtonItem *inviteButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonSystemItemAdd target:self action:@selector(inviteMembers)];
        self.navigationItem.rightBarButtonItem = inviteButtonItem;
    }
    
    self.locationLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMap)];
    [self.inviteButton addTarget:self action:@selector(inviteMembers) forControlEvents:UIControlEventTouchUpInside];
    [self.locationLabel addGestureRecognizer:tapGesture];
    
    [self.nameLabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:36]];
    self.nameLabel.textColor = Rgb2UIColor(80, 195, 174); //Thai Teal
    
    self.descriptionLabel.layer.borderColor = Rgb2UIColor(80, 195, 174).CGColor;
    self.descriptionLabel.layer.borderWidth = borderWidth;
    self.descriptionLabel.layer.cornerRadius = cornerRadius;
    self.descriptionLabel.clipsToBounds = YES;
    
    //set up left and right text margins for description label
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = descriptionHeadMargin;
    style.headIndent = descriptionHeadMargin;
    style.tailIndent = descriptionTailMargin;
    NSString *descriptionDetail = self.eventObject[@"description"];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:descriptionDetail attributes:@{ NSParagraphStyleAttributeName : style}];
    self.descriptionLabel.attributedText = attrText;
    
    self.nameLabel.text = self.eventObject[@"name"];
    self.descriptionLabel.attributedText = attrText;
    
    if (!self.hideJoin)
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    if ([self.eventObject[@"address"] isKindOfClass:[NSNull class]])
    {
        self.locationLabel.text = @"Add Location";
    }
    else
    {
        self.locationLabel.text = self.eventObject[@"address"];
    }
    location = self.eventObject[@"location"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *formatedDateString = [dateFormatter stringFromDate:self.eventObject[@"time"]];
    self.timeLabel.text = formatedDateString;
    self.scrollView.contentSize = [self.contentView sizeThatFits:CGSizeZero];
    [self addAnnotation];
    [self updateMap];
    [self.view setNeedsDisplay];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
}

-(void)updateViewLocation:(PFGeoPoint*) newLocation
{
    if (!self.hideJoin)
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    if ([self.eventObject[@"address"] isKindOfClass:[NSNull class]])
    {
        self.locationLabel.text = @"Add Location";
    }
    else
    {
        self.locationLabel.text = self.eventObject[@"address"];
    }
    location = newLocation;
    self.scrollView.contentSize = [self.contentView sizeThatFits:CGSizeZero];
    [self addAnnotation];
    [self updateMap];
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
    region.center.longitude = location.longitude;
    region.center.latitude = location.latitude;
    [self.mapView setRegion:region];
}

-(void)showMap
{
    CLLocationCoordinate2D coords;
    coords.longitude = location.longitude;
    coords.latitude = location.latitude;
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:place];
    if ([self.eventObject[@"address"] isKindOfClass:[NSNull class]])
    {
        EventLocationViewController *editAddressController = [[EventLocationViewController alloc] init];
        editAddressController.eventObject = self.eventObject;
        editAddressController.isEdit = YES;
        [self.navigationController pushViewController:editAddressController animated:YES];
    }
    else
    {
        destination.name = self.eventObject[@"address"];
        NSArray *items = @[destination];
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
}

- (void)addAnnotation
{
    [self.mapView removeAnnotation:selectedPlaceAnnotation];
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = location.latitude;
    pinCoordinate.longitude = location.longitude;
    selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    selectedPlaceAnnotation.coordinate = pinCoordinate;
    [self.mapView addAnnotation:selectedPlaceAnnotation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Location"];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Location"];
            annotationView.enabled = YES;
            annotationView.animatesDrop = YES;
            
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}


@end
