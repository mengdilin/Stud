//
//  MMMMapsTestViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/16/14.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MMMMapsTestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLocate;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView_;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@end
