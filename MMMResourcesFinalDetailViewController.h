//
//  MMMResourcesFinalDetailViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 8/11/14.
//
//

#import <UIKit/UIKit.h>
#import "MMMLinkViewController.h"

@interface MMMResourcesFinalDetailViewController : UIViewController < UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UIImageView *picturePost;
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

