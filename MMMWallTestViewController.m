//
//  MMMWallTestViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/16/14.
//
//

#import "MMMWallTestViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ParseStarterProjectAppDelegate.h"
#import "MMMCreatPostTestViewController.h"
#import <Parse/Parse.h>

@interface MMMWallTestViewController ()

@end

@implementation MMMWallTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _postvc = [[MMMCreatPostTestViewController alloc] init];
    }
    return self;
}
- (IBAction)goCreatePost:(id)sender {

       [self presentViewController: _postvc animated:YES completion:NULL];

}


- (IBAction)dismiss:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
