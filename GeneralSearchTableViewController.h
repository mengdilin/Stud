//
//  GeneralSearchTableViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/30/14.
//
//

#import <UIKit/UIKit.h>

@interface GeneralSearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, readonly) NSString *cellNibName;
@property (nonatomic) NSMutableArray *allObjects;
@property (nonatomic) NSMutableArray *filteredObjects;
@property (nonatomic) NSString *relationKey;
@property (nonatomic) NSString *keyInRelation;

-(instancetype)initWithCellNibName: (NSString *)cellNibName;

@end
