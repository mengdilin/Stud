//
//  MyStudyPartnersViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/12/14.
//
//

#import "MyStudyPartnersViewController.h"
#import "MMMChatViewController.h"

@interface MyStudyPartnersViewController ()
@end

@implementation MyStudyPartnersViewController

-(id)init
{
    if (self = [super init])
    {
        isMyPartners = YES;
    }
    return self;
}

-(void)findStudyPartners
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"studyPartners"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects)
        {
            data = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        }
    }];
}


@end
