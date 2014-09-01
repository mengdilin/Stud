//
//  MMMResourcesDetailViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/21/14.
//
//

#import <UIKit/UIKit.h>
#import "MMMLinkViewController.h"

@interface MMMResourcesDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userProfPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *tellUser;
@property (weak, nonatomic) IBOutlet UILabel *nonurlLabel;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (nonatomic, retain) UIBarButtonItem *saveItem;
@property (nonatomic, retain) UIBarButtonItem *bookmarked;
@property (weak, nonatomic) PFObject *classObject;
@property (nonatomic) MMMLinkViewController *linkToSite;

@end
