//
//  MMMAllPostsTableViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/22/14.
//
//

#import "MMMAllPostsTableViewController.h"

@interface MMMAllPostsTableViewController ()

@end

@implementation MMMAllPostsTableViewController


-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        self.navigationItem.title = @"All";
        self.navigationItem.rightBarButtonItem = self.addPostButtonItem;
        self.queryPostType = @"All";
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //sets all posts as the Post objects in Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            self.allPosts = objects;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Fetching" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    
    
}


@end
