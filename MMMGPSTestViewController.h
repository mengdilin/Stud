//
//  MMMGPSTestViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/16/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MMMGPSTestViewController : UIViewController <CLLocationManagerDelegate>


{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;

}
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCurrentLocation;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

@end
