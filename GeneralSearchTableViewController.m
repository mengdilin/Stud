//
//  GeneralSearchTableViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/30/14.
//
//

#import "GeneralSearchTableViewController.h"
#import "EventTableViewCell.h"

static const CGFloat cellHeight = 60.0f;

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
@interface GeneralSearchTableViewController ()

@end

@implementation GeneralSearchTableViewController

-(instancetype)initWithCellNibName:(NSString *)cellNibName {
    self = [super init];
    if (self)
    {
        _cellNibName = cellNibName;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self.tableView registerClass:[EventTableViewCell class] forCellReuseIdentifier:_cellNibName];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, 320, 64)];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchBar.barTintColor = Rgb2UIColor(255, 232, 229);
    searchBar.tintColor = [UIColor blackColor];

    self.tableView.tableHeaderView = searchBar;
    self.tableView.backgroundColor = Rgb2UIColor(230, 255, 249);
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = user[_relationKey];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            _allObjects =
           [[NSMutableArray alloc] initWithArray:objects];
            _filteredObjects = [NSMutableArray arrayWithCapacity:[_allObjects count]];
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"error %@",[error userInfo][@"error"]);
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_cellNibName forIndexPath:indexPath];
    if(cell==nil)
    {
        cell = [[EventTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:_cellNibName];
        
    }
    
    
    //cell.text.f
    
    PFObject *object;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        object = _filteredObjects[indexPath.row];
    }
    else
    {
        object = _allObjects[indexPath.row];
    }
    // alternate for demo.  Simply set the properties of the passed in cell
    PFUser *puser = [object objectForKey:@"user"];
    [puser fetchIfNeeded];
    //get that user's name
    NSString *fullname =[puser objectForKey:@"FullName"];
    //cell.textLabel.textColor = Rgb2UIColor(80, 195, 174);
    
    [puser[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            [self.view setNeedsDisplay];
            cell.imageview.image = image;
        }
    }];
    

    cell.nameLabel.text = fullname;
    cell.descriptionLabel.text = object[_keyInRelation];
    cell.backgroundColor = Rgb2UIColor(230, 255, 249);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_filteredObjects count];
    }
    else
    {
        return [_allObjects count];
    }
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //Update the filtered array based on the search text and scope
    //Remove all objects from the filtered search array
    [_filteredObjects removeAllObjects];
    
    //fil†er array using predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"text", searchText];
    _filteredObjects = [NSMutableArray arrayWithArray:[_allObjects filteredArrayUsingPredicate:predicate]];
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
