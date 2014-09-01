//
//  MMMWebTableViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/15/14.
//
//

#import "MMMWebViewController.h"

@interface MMMWebViewController ()

@end

@implementation MMMWebViewController


-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        self.navigationItem.title = @"Web";
        self.navigationItem.rightBarButtonItem = self.addPostButtonItem;
        self.queryPostType = @"Web";
    }
    
    return self;
}

@end
