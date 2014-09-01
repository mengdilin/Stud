//
//  MMMChatViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/15/14.
//
//

#import "MMMChatViewController.h"
#import "EventTableViewCell.h"
#import "UserProfileViewController.h"

static CGFloat cellHeight = 60.0f;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface MMMChatViewController ()
@property (nonatomic) NSArray *studentUsernames;
@property (nonatomic) NSArray *studentClasses;
@property (nonatomic) NSArray *studentNames;
@end


@implementation MMMChatViewController

#pragma - ViewController

// Designated initializer
- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = @"Find study partners";
        self.tabBarItem.title = @"Find";
        UIImage *image = [UIImage imageNamed:@"Light_Chat.png"];
        self.tabBarItem.image = image;
        isMyPartners = NO;
    }
    return self;
}

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.tableView = tableView;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, 320, 64)];
   
    searchDisplayController2 =[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [searchDisplayController2.searchResultsTableView registerClass:[EventTableViewCell class] forCellReuseIdentifier:@"StudyPartner"];
    [self.tableView registerClass:[EventTableViewCell class]
           forCellReuseIdentifier:@"StudyPartner"];
    searchDisplayController2.delegate = self;
    searchDisplayController2.searchResultsDataSource = self;
    searchDisplayController2.searchResultsDelegate = self;
    searchBar.barTintColor = Rgb2UIColor(255, 232, 229);
    searchBar.tintColor = [UIColor blackColor];
    self.tableView.tableHeaderView = searchBar;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = Rgb2UIColor(230, 255, 249);
    self.filteredObjects2 = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self findStudyPartners];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(findStudyPartners) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:refreshControl];
}

#pragma - Delegate methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == searchDisplayController2.searchResultsTableView)
    {
        return [self.filteredObjects2 count];
    }
    else
    {
        return [data count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyPartner"
                                                            forIndexPath:indexPath];
    
    PFObject *partner;
    if (tableView == searchDisplayController2.searchResultsTableView)
    {
        partner = self.filteredObjects2[indexPath.row];
    }
    else
    {
        partner = data[indexPath.row];
    }
    
    cell.imageview.image = nil;
    cell.nameLabel.text = partner[@"FullName"];
    cell.descriptionLabel.text = partner[@"email"];
    [partner[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (imageData)
        {
            cell.imageview.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
}

// Displays more information about the selected user.
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PFUser *partner;
    if (tableView == searchDisplayController2.searchResultsTableView)
    {
        partner = self.filteredObjects2[indexPath.row];
    }
    else
    {
        partner = data[indexPath.row];
    }

 
    UserProfileViewController *fpc = [[UserProfileViewController alloc] init];
    fpc.userObject = partner;
    fpc.hidesBottomBarWhenPushed = YES;
    fpc.isMyPartners = isMyPartners;
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relStudyPartners = [currentUser relationforKey:@"studyPartners"];
    PFQuery *queryStudyPartners = [relStudyPartners query];
    [queryStudyPartners whereKey:@"username"
                         equalTo:partner[@"username"]];
    [queryStudyPartners findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0)
        {
            fpc.add = NO;
            [fpc.joinButton setTitle:@"Remove from Study Partners" forState:UIControlStateNormal];
        }
        else
        {
            fpc.add = YES;
            [fpc.joinButton setTitle:@"Add to Study Partners" forState:UIControlStateNormal];
        }
        [self.navigationController pushViewController:fpc
                                             animated:YES];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

#pragma - Find study partners

// Returns an array of classes that the current user is currently studying.
- (NSArray *)findClasses {
    PFUser *user = [PFUser currentUser];
    PFRelation *relClasses = [user objectForKey:@"currentlyStudying"];
    PFQuery *queryClasses = [relClasses query];
    NSArray *classes = [queryClasses findObjects];
    return classes;
}

// Finds an array of potential study partners for the current user and the classes they have in common.
- (void)findStudyPartners {
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relClasses = [user relationforKey:@"currentlyStudying"];
    PFQuery *queryClasses = [relClasses query];
    storeData = [[NSMutableDictionary alloc] init];
    [queryClasses findObjectsInBackgroundWithBlock:^(NSArray *studyingClasses, NSError *error) {
        if (studyingClasses)
        {
            for (PFObject *class in studyingClasses)
            {
                PFQuery *getClass = [PFQuery queryWithClassName:@"Class"];
                [getClass whereKey:@"objectId" equalTo:[class objectId]];
                [getClass getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    PFRelation *studentsCurrentlyStudying = [object relationforKey:@"studentsStudying"];
                    PFQuery *queryStudentsCurrentlyStudying = [studentsCurrentlyStudying query];
                    [queryStudentsCurrentlyStudying findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        for (PFUser *student in objects)
                        {
                            [storeData setObject:student forKey:[student objectId]];
                        }
                        data = [[NSMutableArray alloc] init];
                        for (id key in storeData)
                        {
                            if (![key isEqualToString:[[PFUser currentUser] objectId]])
                                 {
                                     [data addObject:storeData[key]];
                                 }
                        }
                        [refreshControl endRefreshing];
                        [self.tableView reloadData];
                    }];
                }];
            }
            [refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //Update the filtered array based on the search text and scope
    //Remove all objects from the filtered search array
    [self.filteredObjects2 removeAllObjects];
    
    //fil†er array using predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@" , @"FullName", searchText];

    self.filteredObjects2 = [NSMutableArray arrayWithArray:[data filteredArrayUsingPredicate:predicate]];
    
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
