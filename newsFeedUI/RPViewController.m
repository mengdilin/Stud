//
//  RPViewController.m
//  RPSlidingMenuDemo
//
//  Created by Paul Thorsteinson on 2/24/2014.
//  Copyright (c) 2014 Robots and Pencils Inc. All rights reserved.
//

#import "RPViewController.h"
#import "MMMResourcesFinalDetailViewController.h"
#import "PostStepViewController.h"

@interface RPViewController ()

@end

//Thai Teal
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation RPViewController


- (void)viewDidLoad{
    [super viewDidLoad];

    //add bar button
    _addPostButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    self.navigationItem.rightBarButtonItem = _addPostButtonItem;
    
    // Example of changing the feature height and collapsed height for all
    self.featureHeight = 300.0f;
    self.collapsedHeight = 100.0f;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    _steps = [[PostStepViewController alloc] init];
    //sets all posts as the Post objects in Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    //find specific posts
    [query whereKey:@"PostType" equalTo:self.queryPostType];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            _allPosts = objects;
            
            [self.collectionView reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Fetching" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    
}


#pragma mark - RPSlidingMenuViewController


-(NSInteger)numberOfItemsInSlidingMenu{
    // 10 for demo purposes, typically the count of some array
    return [_allPosts count];
}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row{
 
    // alternate for demo.  Simply set the properties of the passed in cell
    PFUser *puser = [_allPosts[row] objectForKey:@"user"];
    [puser fetchIfNeeded];
    //get that user's name
    NSString *fullname =[puser objectForKey:@"FullName"];
    slidingMenuCell.textLabel.text = fullname;
    slidingMenuCell.detailTextLabel.text = _allPosts[row][@"text"];
    slidingMenuCell.textLabel.textColor = Rgb2UIColor(80, 195, 174);
    
    [puser[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            [self.view setNeedsDisplay];
            slidingMenuCell.profileImage.image = image;
        }
    }];

    
    
    slidingMenuCell.backgroundColor = Rgb2UIColor(80, 195, 174);
    
}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row{

    [super slidingMenu:slidingMenu didSelectItemAtRow:row];

    // Navigation logic may go here, for example:
    // Create the next view controller.
    MMMResourcesFinalDetailViewController *detailViewController = [[MMMResourcesFinalDetailViewController alloc] init];

    // Pass the selected object to the new view controller.
    detailViewController.classObject = self.allPosts[row];
    detailViewController.hidesBottomBarWhenPushed = YES;
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//Add post
-(void)add: (id)sender
{
    //puts this post in the category of Web Resources

    _steps.type = _queryPostType;
    _steps.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: _steps animated:YES];
}

@end
