//
//  MMMMapsTestViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/16/14.
//
//

#import "MMMMapsTestViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface MMMMapsTestViewController ()

@end

@implementation MMMMapsTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
//                                                                longitude:151.20
//                                                                     zoom:6];
//        
//        // Indicating the map frame bounds
//        self.mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera: camera];
//        self.mapView_.myLocationEnabled = YES;
//        
//        // Add as subview the mapview
//        [self.mapView addSubview: self.mapView_];
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
