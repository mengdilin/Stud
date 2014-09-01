//
//  GroupsCollectionViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/5/14.
//
//

#import "GroupsCollectionViewController.h"
#import "AllGroupsCollectionViewController.h"
#import "GroupStepViewController.h"
#import "FindGroupDetailViewController.h"
@interface GroupsCollectionViewController ()

@end

@implementation GroupsCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonSystemItemAdd target:self action:@selector(createItem)];
        self.navigationItem.title = @"All Groups";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PFQuery *)getQuery
{
    PFQuery *query = [PFQuery queryWithClassName:@"StudyGroup"];
    return query;
}

-(void)loadView
{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonSystemItemAdd target:self action:@selector(createItem)];
    self.navigationItem.title = @"All Groups";
}

-(void)createItem
{
    GroupStepViewController *gfvc = [[GroupStepViewController alloc] init];
    gfvc.hidesBottomBarWhenPushed = YES;
    gfvc.isGroupViewController = YES;
    [self.navigationController pushViewController:gfvc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    FindGroupDetailViewController *groupDetailView = [[FindGroupDetailViewController alloc] init];
    groupDetailView.groupObject = dataObjects[indexPath.row][@"data"];
    groupDetailView.isAllGroups = YES;
    groupDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupDetailView animated:YES];
}

@end
