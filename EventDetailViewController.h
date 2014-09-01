//
//  EventDetailViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/29/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RSTransitionEffectViewController.h"

@interface EventDetailViewController : RSTransitionEffectViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) PFObject *eventObject;
@property (assign, nonatomic) BOOL hideInvite;
@property (assign, nonatomic) BOOL hideJoin;

-(void)updateViewLocation:(PFGeoPoint *)newLocation;
@end
