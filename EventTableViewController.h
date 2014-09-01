//
//  EventTableViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/8/14.
//
//

#import <UIKit/UIKit.h>

@interface EventTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) PFObject *parentObject;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL hideInvite;
@property (assign, nonatomic) BOOL hideJoin;
@property (assign, nonatomic) BOOL isMyEvent;
@end
