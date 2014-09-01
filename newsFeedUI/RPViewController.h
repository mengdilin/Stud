//
//  RPViewController.h
//  RPSlidingMenuDemo
//
//  Created by Paul Thorsteinson on 2/24/2014.
//  Copyright (c) 2014 Robots and Pencils Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSlidingMenu.h"
#import "PostStepViewController.h"

@interface RPViewController : RPSlidingMenuViewController 

@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIBarButtonItem *addPostButtonItem;
@property (nonatomic) PostStepViewController *steps;
@property (nonatomic, readonly) NSString *cellNibName;
@property (nonatomic) NSString *queryPostType;
@property (nonatomic) NSArray *allPosts;


@end
