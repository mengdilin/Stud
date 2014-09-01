//
//  AllClassesTableViewController.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/16/14.
//
//

#import <UIKit/UIKit.h>

@interface AllClassesTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *allClassesSearchBar;
@property (copy, nonatomic) NSString *keyForParse;
@property (copy, nonatomic) NSArray *allClasses;
@end
