//
//  EventTableViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/8/14.
//
//

#import "EventTableViewController.h"
#import "EventTableViewCell.h"
#import "EventDetailViewController.h"
#import "GroupStepViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface EventTableViewController ()
{
    NSMutableArray *upcomingEvents;
    NSMutableArray *pastEvents;
    NSMutableArray *filteredUpcomingEvents;
    UISearchDisplayController *searchDisplayController2;
}
@end

static NSString *CellIdentifier = @"Cell";
static const CGFloat cellHeight = 60.0f;
static const float searchBarHeight = 64.0f;

@implementation EventTableViewController

-(void)loadView
{
    self.navigationItem.title = @"Events";
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, searchBarHeight)];
    searchBar.barTintColor = Rgb2UIColor(255, 232, 229);
    searchBar.tintColor = [UIColor blackColor];

    searchDisplayController2 =[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [searchDisplayController2.searchResultsTableView registerClass:[EventTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[EventTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    searchDisplayController2.delegate = self;
    searchDisplayController2.searchResultsDataSource = self;
    searchDisplayController2.searchResultsDelegate = self;
    self.tableView.tableHeaderView = searchBar;
    self.tableView.backgroundColor = Rgb2UIColor(230, 255, 249);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateEvent) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self updateEvent];
}

-(void)updateEvent
{
    upcomingEvents = [[NSMutableArray alloc] init];
    pastEvents = [[NSMutableArray alloc] init];
    PFRelation *relation = [self.parentObject relationforKey:@"events"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *event in objects)
        {
            NSDate *eventDate = event[@"time"];
            if ([eventDate timeIntervalSinceNow] < 0.0)
            {
                //date has not passed
                [pastEvents addObject:event];
            }
            else
            {
                [upcomingEvents addObject:event];
            }
        }
        filteredUpcomingEvents = [upcomingEvents copy];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == searchDisplayController2.searchResultsTableView)
    {
        return [filteredUpcomingEvents count];
    }
    else
    {
        return [upcomingEvents count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *event;
    if (tableView == searchDisplayController2.searchResultsTableView)
    {
        event = filteredUpcomingEvents[indexPath.row];
    }
    else
    {
        event = upcomingEvents[indexPath.row];
    }
    cell.nameLabel.text = event[@"name"];
    cell.descriptionLabel.text = event[@"description"];
    [event[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            cell.imageview.image = image;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *event;
    if (tableView == searchDisplayController2.searchResultsTableView)
    {
        event = filteredUpcomingEvents[indexPath.row];
    }
    else
    {
        event = upcomingEvents[indexPath.row];
    }
    EventDetailViewController *detailViewController = [[EventDetailViewController alloc] init];
    detailViewController.eventObject = event;
    detailViewController.hideInvite = self.hideInvite;
    detailViewController.hideJoin = self.hideJoin;
    if (self.isMyEvent)
    {
        detailViewController.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMyEvent)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([upcomingEvents count] > 0)
        {
            PFObject *deleteEvent = upcomingEvents[indexPath.row];
            PFQuery *query = [PFQuery queryWithClassName:@"Event"];
            [query whereKey:@"objectId" equalTo:[deleteEvent objectId]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object)
                {
                    [object deleteInBackground];
                }
            }];
            [upcomingEvents removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //Update the filtered array based on the search text and scope
    //fil†er array using predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@" , @"name", searchText];
    
    filteredUpcomingEvents = [NSMutableArray arrayWithArray:[upcomingEvents filteredArrayUsingPredicate:predicate]];
    
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:[[searchDisplayController2.searchBar scopeButtonTitles] objectAtIndex:[searchDisplayController2.searchBar selectedScopeButtonIndex]]];
    
    //return YES to cause the search result table view to be reloaded
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:searchDisplayController2.searchBar.text scope:[[searchDisplayController2.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    //return YES to cause the search result table to be reloaded
    return YES;
}

@end
