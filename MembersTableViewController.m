//
//  MembersTableViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/30/14.
//
//

#import "MembersTableViewController.h"
#import "ClassTableViewCell.h"
#import "EventDetailViewController.h"
#import "EventTableViewCell.h"
#import "UserProfileViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
@interface MembersTableViewController ()

@end

static CGFloat cellHeight = 60.0f;

@implementation MembersTableViewController
{
    NSMutableArray *profileImages;
    NSMutableArray *userObjects;
    NSMutableArray *filteredUserObjects;
    NSMutableArray *invites;
    NSMutableArray *invitesPFObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[EventTableViewCell class] forCellReuseIdentifier:@"ThumbnailTableViewCell"];
    [self.searchDisplayController.searchResultsTableView registerClass:[EventTableViewCell class]  forCellReuseIdentifier:@"ThumbnailTableViewCell"];
    
    self.searchDisplayController.searchBar.barTintColor = Rgb2UIColor(255, 232, 229);
    self.searchDisplayController.searchBar.tintColor = [UIColor blackColor];

    if ([self.keyForParse isEqualToString:@"Invitee"])
    {
        self.navigationItem.title = @"Invites";
    }
    else
    {
        self.navigationItem.title = @"Members";
    }
    invites = [[NSMutableArray alloc] init];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateTableData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    self.tableView.backgroundColor = Rgb2UIColor(230, 255, 249);
    [self updateTableData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.navigationController setToolbarHidden:YES animated:animated];

}
-(void)updateTableData
{
    userObjects = [[NSMutableArray alloc] init];
    
    PFQuery *query;
    if ([self.keyForParse isEqualToString:@"Invitee"])
    {
        query = [self findInvitationsQuery];
    }
    else
    {
        query = [self findStudyGroupMembersQuery];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0)
        {
            if ([self.keyForParse isEqualToString:@"Invitee"])
            {
                PFRelation *relation = [objects[0] relationforKey:@"invite"];
                PFQuery *innerQuery = [relation query];
                [innerQuery findObjectsInBackgroundWithBlock:^(NSArray *innerObjects, NSError *error) {
                    for (id innerObject in innerObjects)
                    {
                        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
                        [tmpDict setObject:[innerObject objectId] forKey:@"inviteId"];
                        [innerObject[@"inviter"] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            [tmpDict setObject:innerObject[@"inviter"][@"FullName"] forKey:@"name"];
                            [innerObject[@"inviter"][@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                if (data)
                                {
                                    [tmpDict setObject:data forKey:@"imageData"];
                                    [userObjects addObject:tmpDict];
                                    [self.tableView reloadData];
                                }
                            }];
                        }];
                        [innerObject[@"event"] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            [tmpDict setObject:innerObject[@"event"] forKey:@"event"];
                            [self.tableView reloadData];
                            [self.refreshControl endRefreshing];
                        }];
                    }
                }];
            }
            else
            {
                for (PFUser *user in objects)
                {
                    //if tableview is showing a list of possible invitees, exclude current user
                    if ([self.keyForParse isEqualToString:@"Invite"] && [[user objectId] isEqualToString:[[PFUser currentUser] objectId]])
                    {
                        continue;
                    }
                    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setObject:user forKey:@"info"];
                    [tmpDict setObject:user[@"FullName"] forKey:@"name"];
                    [user[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if(data)
                        {
                            [tmpDict setObject:data forKey:@"imageData"];
                            [userObjects addObject:tmpDict];
                            [self.tableView reloadData];
                            [self.refreshControl endRefreshing];
                        }
                    }];
                }
            }
        }
    }];
}

-(PFQuery *)findAllUsersQuery
{
    PFQuery *query = [PFUser query];
    userObjects = [[NSMutableArray alloc] init];
    
    return query;
}

-(PFQuery *)findStudyGroupMembersQuery
{
    PFRelation *relation = [self.groupObject relationforKey:@"members"];
    PFQuery *query = [relation query];
    
    return query;
}

-(PFQuery *)findInvitationsQuery
{
    PFQuery *query = [PFQuery queryWithClassName:@"Invitee"];
    [query whereKey:@"invitee" equalTo:[PFUser currentUser]];
    return query;
}

-(void)sendInvite
{
    PFPush *push = [[PFPush alloc] init];
    PFObject *invite = [PFObject objectWithClassName:@"Invite"];
    invite[@"inviter"] = [PFUser currentUser];
    invite[@"event"] = self.eventObject;
    NSString *message = [NSString stringWithFormat:@"You got invited to %@ by %@",self.eventObject[@"name"],[PFUser currentUser][@"FullName"]];
    [invite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            for (NSMutableDictionary *item in invites)
            {
                PFUser *receiver = item[@"info"];
                PFQuery *inviteeQuery = [PFQuery queryWithClassName:@"Invitee"];
                [inviteeQuery whereKey:@"invitee" equalTo:receiver];
                [inviteeQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    {
                        if (object)
                        {
                            PFRelation *relation = [object relationforKey:@"invite"];
                            PFQuery *relationQuery = [relation query];
                            [relationQuery whereKey:@"event" equalTo:self.eventObject];
                            
                             [relationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *innerObject, NSError *error) {
                                 if (!innerObject)
                                 {
                                     [relation addObject:invite];
                                     [object saveInBackground];
                                 }
                             }];
                        }
                        else
                        {
                            PFObject *invitee = [PFObject objectWithClassName:@"Invitee"];
                            object = invitee;
                            object[@"invitee"] = receiver;
                            PFRelation *relation = [object relationforKey:@"invite"];
                            [relation addObject:invite];
                            [object saveInBackground];
                        }
                        
                    }
                }];
                PFQuery *innerQuery = [PFUser query];
                [innerQuery whereKey:@"objectId" equalTo:[receiver objectId]];
                PFQuery *query = [PFInstallation query];
                [query whereKey:@"user" matchesQuery:innerQuery];
                [push setQuery:query];
                [push setMessage:message];
                [push sendPushInBackground];
                
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully invited others" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self clickedResetButton];
        }
    }];
}

- (void)clickedResetButton {
    for (int section = 0, sectionCount = self.tableView.numberOfSections; section < sectionCount; ++section) {
        for (int row = 0, rowCount = [self.tableView numberOfRowsInSection:section]; row < rowCount; ++row) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredUserObjects count];
    }
    else
    {
        return [userObjects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ThumbnailTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ThumbnailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([userObjects count] > 0)
    {
        PFObject *class;
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            class = filteredUserObjects[indexPath.row];
        }
        else
        {
            class = userObjects[indexPath.row];
        }
    
        NSString *cellText;
        UIImage *cellImage;
        NSString *eventName = nil;
        if ([self.keyForParse isEqualToString:@"Invitee"])
        {
            cellText = class[@"name"];
            eventName = [NSString stringWithFormat:@"invited you to %@", userObjects[indexPath.row][@"event"][@"name"]];
            cellImage = [UIImage imageWithData:class[@"imageData"]];
        }
        else
        {
            cellText = class[@"info"][@"FullName"];
            cellImage = [UIImage imageWithData:class[@"imageData"]];
        }

        cell.nameLabel.text = cellText;
        cell.descriptionLabel.text = eventName;
        cell.imageview.image = cellImage;
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([self.keyForParse isEqualToString:@"Invitee"])
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
        if ([userObjects count] > 0)
        {
            NSString *deleteEventId = userObjects[indexPath.row][@"inviteId"];
            PFQuery *query = [self findInvitationsQuery];
            [userObjects removeObjectAtIndex:indexPath.row];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object)
                {
                    PFRelation *inviteRelation = [object relationforKey:@"invite"];
                    PFQuery *innerQuery = [inviteRelation query];
                    [innerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (objects)
                        {
                            for (PFObject *invite in objects)
                            {
                                if ([[invite objectId] isEqualToString:deleteEventId])
                                {
                                    [invite deleteInBackground];
                                }
                            }
                        }
                    }];
                }
            }];

        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *class;
    
    if ([userObjects count] > 0)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            class = filteredUserObjects[indexPath.row];
            
        }
        else
        {
            class = userObjects[indexPath.row];
        }
    }
    
    if ([self.keyForParse isEqualToString:@"Invite"])
    {
        UITableViewCellAccessoryType type = [tableView cellForRowAtIndexPath:indexPath].accessoryType;
        
        if (type == UITableViewCellAccessoryCheckmark)
        {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [invites removeObject:class];
            
            if ([invites count] == 0)
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
        else
        {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [invites addObject:class];
            
            if ([invites count] == 1)
            {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(sendInvite)];
            }
        }
    }
    else if ([self.keyForParse isEqualToString:@"Invitee"] && [userObjects count] > 0)
    {
        EventDetailViewController *eventDetail = [[EventDetailViewController alloc] init];
        eventDetail.eventObject = userObjects[indexPath.row][@"event"];
        eventDetail.hideInvite = YES;
        eventDetail.hideJoin = NO;
        eventDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:eventDetail animated:YES];
    }
    else
    {
        UserProfileViewController *userProfileController = [[UserProfileViewController alloc] init];
        userProfileController.userObject = userObjects[indexPath.row][@"info"];
        
        PFUser *currentUser = [PFUser currentUser];
        PFRelation *relStudyPartners = [currentUser relationforKey:@"studyPartners"];
        PFQuery *queryStudyPartners = [relStudyPartners query];
        [queryStudyPartners whereKey:@"username"
                             equalTo:userObjects[indexPath.row][@"info"][@"username"]];
        if (![userObjects[indexPath.row][@"info"][@"username"] isEqualToString:currentUser[@"username"]])
              {
                  [queryStudyPartners findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                      if ([objects count] > 0)
                      {
                          userProfileController.add = NO;
                          [userProfileController.joinButton setTitle:@"Remove from Study Partners" forState:UIControlStateNormal];
                      }
                      else
                      {
                          userProfileController.add = YES;
                          [userProfileController.joinButton setTitle:@"Add to Study Partners" forState:UIControlStateNormal];
                      }
                      [self.navigationController pushViewController:userProfileController
                                                 animated:YES];
                  }];
              }
        else
        {
            [self.navigationController pushViewController:userProfileController
                                                 animated:YES];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //Update the filtered array based on the search text and scope
    //Remove all objects from the filtered search array
    [filteredUserObjects removeAllObjects];
    
    //fil†er array using predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"name", searchText];
    filteredUserObjects = [NSMutableArray arrayWithArray:[userObjects filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    //return YES to cause the search result table view to be reloaded
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    //return YES to cause the search result table to be reloaded
    return YES;
}


@end
