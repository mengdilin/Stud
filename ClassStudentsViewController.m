//
//  ClassStudentsViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/12/14.
//
//

#import "ClassStudentsViewController.h"
#import "MMMChatViewController.h"
@interface ClassStudentsViewController ()
@end

@implementation ClassStudentsViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        self.navigationItem.title = @"Students";
    }
    return self;
}

-(void)findStudyPartners
{
    PFRelation *relation = [self.classObject relationforKey:@"students"];
    PFQuery *getStudents = [relation query];
    [getStudents findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects)
        {
            data = [[NSMutableArray alloc] initWithArray:objects];
            self.filteredObjects2 = [data copy];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        }
    }];
}

@end
