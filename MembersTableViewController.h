//
//  MembersTableViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/30/14.
//
//

#import <UIKit/UIKit.h>

@interface MembersTableViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *allUsersSearchBar;
@property (strong, nonatomic) PFObject *groupObject;
@property (copy, nonatomic) NSString *keyForParse;
@property (strong, nonatomic) PFObject *eventObject;
@end
