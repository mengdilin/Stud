//
//  OthersStudyingMapViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/31/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface OthersStudyingMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) PFGeoPoint *userGeoPoint;
@property (nonatomic) NSArray *allLocations;
@property (nonatomic, strong)PFObject *classObject;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStudents;

-(void)addAnnotations:(NSArray *)allLocations;


@end
