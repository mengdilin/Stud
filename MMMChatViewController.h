//
//  MMMChatViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/15/14.
//
//

#import <UIKit/UIKit.h>

@interface MMMChatViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UISearchDisplayController *searchDisplayController2;
    NSMutableArray *data;
    NSMutableDictionary *storeData;
    UIRefreshControl *refreshControl;
    BOOL isMyPartners;
}
@property (nonatomic) NSMutableArray *filteredObjects2;
- (void)findStudyPartners;
@end
