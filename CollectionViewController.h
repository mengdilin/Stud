//
//  CollectionViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/4/14.
//
//

#import <UIKit/UIKit.h>
@class CollectionViewCell;

@interface CollectionViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UISearchBar *searchBar;
    UIRefreshControl *refreshControl;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@end
