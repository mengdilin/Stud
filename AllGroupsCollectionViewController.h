//
//  AllGroupsCollectionViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/4/14.
//
//

#import <UIKit/UIKit.h>
#import "CollectionViewController.h"

@interface AllGroupsCollectionViewController : CollectionViewController
{
    NSMutableArray *dataObjects;
    NSMutableArray *filteredDataObjects;
}
-(void)updateData;
@end
