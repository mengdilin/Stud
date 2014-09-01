//
//  MMMVideoTableViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/15/14.
//
//

#import "MMMVideoViewController.h"

@interface MMMVideoViewController ()

@end

@implementation MMMVideoViewController

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        self.navigationItem.title = @"Vid";
        self.navigationItem.rightBarButtonItem = self.addPostButtonItem;
        self.queryPostType = @"Vid";
    }
    
    return self;
}

@end
