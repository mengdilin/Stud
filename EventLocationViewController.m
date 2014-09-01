//
//  EventLocationViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import "EventLocationViewController.h"
#import "RMStepsController/RMStepsController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "CustomUIButton.h"
#import "EventDetailViewController.h"

@interface EventLocationViewController ()
{
    CustomUIButton *doneButton;
}
@end

const float RADIUS = 100.0;
const float SPAN_X = 0.1;
const float SPAN_Y = 0.1;
@implementation EventLocationViewController
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    BOOL shouldBeginEditing;
    CGRect searchTableRect;
    NSString *myAddress;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
        searchQuery.radius = RADIUS;
        shouldBeginEditing = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchDisplayController.searchBar.placeholder = @"Search address";
    self.mapView.delegate = self;
    if (self.isEdit)
    {
        doneButton = [[CustomUIButton alloc] initWithFrame:self.nextButton.frame];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        self.previousButton.hidden = YES;
        self.nextButton.hidden = YES;
        [doneButton addTarget:self action:@selector(saveLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: doneButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveLocation
{
    PFGeoPoint *geopoint = [[PFGeoPoint alloc] init];
    if (myPlacemark != nil)
    {
        geopoint.longitude = myPlacemark.location.coordinate.longitude;
        geopoint.latitude = myPlacemark.location.coordinate.latitude;
        self.eventObject[@"location"] = geopoint;
        self.eventObject[@"address"] = myAddress;
        int length = [self.navigationController.viewControllers count];
        
        //getting the previous view controller in the navigation stack
        EventDetailViewController *eventDetailController = self.navigationController.viewControllers[length-2];
        [self.eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                eventDetailController.eventObject = self.eventObject;
                [eventDetailController updateViewLocation:geopoint];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else
    {
        NSLog(@"nil");
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultPlaces count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    ;
    cell.textLabel.text = ((SPGooglePlacesAutocompletePlace *) searchResultPlaces[indexPath.row]).name;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPGooglePlacesAutocompletePlace *place =  searchResultPlaces[indexPath.row];
    
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if (placemark)
        {
            myPlacemark = placemark;
            myAddress = addressString;
            [self addAnnotation:placemark address:addressString];
            [self updateMap:placemark];
            [self dismissSearchBar];
        }
    }];
}

- (void)addAnnotation:(CLPlacemark *)placemark address:(NSString *)address
{
    [self.mapView removeAnnotation:selectedPlaceAnnotation];
    selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    selectedPlaceAnnotation.title = address;
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


- (void) dismissSearchBar
{
    //sets searchResultsTableView to transparent
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController setActive:NO animated:YES];

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearchBar];
}

#pragma mark UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    searchQuery.location = self.mapView.userLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (places)
        {
            searchResultPlaces = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot find places" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    return YES;
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    controller.active = YES;
    [self.view bringSubviewToFront:controller.searchBar];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    //repositioning searchResultsTableView so that it aligns with search bar
    /**
    [tableView setContentInset:UIEdgeInsetsMake(0.0f,0.0f,0.0f,0.0f)];
    if (CGRectIsEmpty(searchTableRect))
    {
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.origin.y += self.searchDisplayController.searchBar.frame.size.height + self.searchDisplayController.searchBar.frame.origin.y - (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
        tableViewFrame.size.height -= self.searchDisplayController.searchBar.frame.size.height + self.searchDisplayController.searchBar.frame.origin.y - (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
        searchTableRect = tableViewFrame;
    }
    
    [tableView setFrame:searchTableRect];
     **/
}

- (void)updateMap:(CLPlacemark *)placemark
{
    //zoom to location
    
    //through trial and error, setting spanX and spanY to 0.1 provides the ideal zoom level for the map
    float spanX = SPAN_X;
    float spanY = SPAN_Y;
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center = placemark.location.coordinate;
    [self.mapView setRegion:region];
}

-(IBAction)nextStepTapped:(id)sender
{
    if (myPlacemark != nil)
    {
        self.stepsController.results[@"latitude"] = [NSNumber numberWithDouble:myPlacemark.location.coordinate.latitude];
        self.stepsController.results[@"longitude"] = [NSNumber numberWithDouble:myPlacemark.location.coordinate.longitude];
        self.stepsController.results[@"address"] = myAddress;
    }
    [self.stepsController showNextStep];
}

-(IBAction)previousStepTapped:(id)sender
{
    [self.stepsController showPreviousStep];
}

@end
