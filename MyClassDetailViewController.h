//
//  MyClassDetailViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/18/14.
//
//

#import <UIKit/UIKit.h>

@interface MyClassDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *goToMapView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *professor;
@property (weak, nonatomic) IBOutlet UIButton *dropClassButton;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (weak, nonatomic) IBOutlet UIButton *addGradesButton;
@property (strong, nonatomic) UIAlertView *gradeEntry;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong)PFObject *classObject;
@end
