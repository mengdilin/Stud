//
//  MPViewController.h
//  MPSkewed
//
//  Created by Alex Manzella on 23/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMAllPostsTableViewController.h"
#import "MMMTipsViewController.h"
#import "MMMVideoViewController.h"
#import "MMMWebViewController.h"
#import "PostStepViewController.h"
#import "RPViewController.h"
#import "ScrollViewController.h"
#import "UIView+Frame.h"

@interface MPViewController : UIViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    NSInteger chosen;
}

@property (nonatomic) ScrollViewController* recentViewController;
@property (nonatomic) MMMTipsViewController *tipsvc;
@property (nonatomic) MMMWebViewController *webVC;
@property (nonatomic) MMMVideoViewController *vidVC;
@property (nonatomic) MMMAllPostsTableViewController *allVC;
@property (nonatomic) PostStepViewController *steps;
@property (nonatomic) RPViewController *newsfeedweb;
@property (strong, nonatomic) NSArray *vcs;

@end
