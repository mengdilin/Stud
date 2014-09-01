//
//  MPViewController.m
//  MPSkewed
//
//  Created by Alex Manzella on 23/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPViewController.h"
#import "MMMVideoViewController.h"
#import "MPSkewedCell.h"
#import "MPSkewedParallaxLayout.h"
#import "PostStepViewController.h"
#import "RPSlidingMenuLayout.h"
#import "RPViewController.h"

static NSString *kCell=@"cell";
static int kArrayCount;

#define PARALLAX_ENABLED 1

@interface MPViewController ()


@end

@implementation MPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *image = [UIImage imageNamed:@"info_32.png"];

        self.tabBarItem.image = image;
        self.tabBarItem.title = @"News Feed";
        self.navigationItem.title = @"News Feed Page";
        
        //layout for the news feed collection view
        RPSlidingMenuLayout *layout = [[RPSlidingMenuLayout alloc] init];
        _tipsvc = [[MMMTipsViewController alloc] initWithCollectionViewLayout:layout];
        _webVC = [[MMMWebViewController alloc] initWithCollectionViewLayout:layout];
        _allVC = [[MMMAllPostsTableViewController alloc] initWithCollectionViewLayout:layout];
        _steps = [[PostStepViewController alloc] init];
        _recentViewController = [[ScrollViewController alloc] init];
        _newsfeedweb = [[RPViewController alloc] initWithCollectionViewLayout:layout];
        _vidVC = [[MMMVideoViewController alloc] initWithCollectionViewLayout:layout];

        
        //array to move to different view controllers at index
        _vcs = @[_steps, _webVC, _vidVC, _tipsvc, _allVC, _recentViewController];

        
        kArrayCount = [_vcs count];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;

    
   //So that the fields reset
    _steps = [[PostStepViewController alloc] init];
    
    
    //array to move to different view controllers at index
    _vcs = @[_steps, _webVC, _vidVC, _tipsvc, _allVC, _recentViewController];
    
    
    kArrayCount = [_vcs count];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chosen =- 1;
    
#ifndef PARALLAX_ENABLED
    // you can use that if you don't need parallax
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width, 230);
    layout.minimumLineSpacing =- layout.itemSize.height/3; // must be always the itemSize/3
    //use the layout you want as soon as you recalculate the proper spacing if you made different sizes
#else
    
    MPSkewedParallaxLayout *layout = [[MPSkewedParallaxLayout alloc] init];

    
#endif
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MPSkewedCell class] forCellWithReuseIdentifier:kCell];
    [self.view addSubview:_collectionView];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //makes repeating sections
    return chosen >= 0 ? 1 : 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MPSkewedCell* cell = (MPSkewedCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%li",(long) (chosen >= 0 ? chosen : indexPath.item%6 + 1)]];
    
    NSString *text;
    
    NSInteger index = chosen >= 0 ? chosen : indexPath.row % kArrayCount;
    
    switch (index) {
        case 0:
            text = @"POST A\n RESOURCE";
            break;
        case 1:
            text = @"WEB\n RESOURCES";
            break;
        case 2:
            text = @"VIDEO\n RESOURCES";
            break;
        case 3:
            text = @"STUDY\n TIPS";
            break;
        case 4:
            text = @"ALL\n RESOURCES";
            break;
            
        case 5:
            text = @"PHONE \n CONTACTS";
            break;
            
        default:
            break;
            
    }
    
    cell.text = text;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = chosen >= 0 ? chosen : indexPath.row % kArrayCount;
    
    if (index == 0)
    {
        PostStepViewController *stepViewCont = _vcs[index];
        stepViewCont.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:stepViewCont animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:_vcs[index] animated:YES];
    }
    
    self.navigationController.navigationBarHidden = NO;
   }

@end
