//
//  MMMTipsTableViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/22/14.
//
//

#import "MMMTipsViewController.h"
#import "MMMCreatPostTestViewController.h"
#import "MMMResourcesDetailViewController.h"

@interface MMMTipsViewController ()

@end

@implementation MMMTipsViewController


-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        self.navigationItem.title = @"Tips";
        self.navigationItem.rightBarButtonItem = self.addPostButtonItem;
        self.queryPostType = @"Tips";
    }
    
    return self;
}

@end
