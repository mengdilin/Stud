//
//  EventLocationViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/28/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

extern const float RADIUS;
extern const float SPAN_X;
extern const float SPAN_Y;
@interface EventLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate>
{
    CLPlacemark *myPlacemark;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (assign, nonatomic) BOOL isEdit;
@property (strong, nonatomic) PFObject *eventObject;
@end
