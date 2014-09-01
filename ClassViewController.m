//
//  ClassViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/14/14.
//
//

#import "ClassViewController.h"
#import "ClassStepViewController.h"
#import "AllClassesTableViewController.h"
#import "ClassTableViewCell.h"
#import "MyClassDetailViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface ClassViewController ()

@property (nonatomic) UIBarButtonItem *selectBbi;
@property (nonatomic) UIBarButtonItem *doneBbi;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ClassViewController
{
    NSArray *classes;
    NSMutableArray *filteredClasses;
    BOOL selectMode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.navigationItem.title = @"My Classes";
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        _selectBbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"studying.png"] style:UIBarButtonItemStylePlain target:self action:@selector(selectCurrentlyStudying:)];
        
        _doneBbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSelecting:)];
        
        self.navigationItem.rightBarButtonItem=_selectBbi;
    }
    return self;
}


-(IBAction)selectCurrentlyStudying:(id)sender
{
    selectMode = true;
    self.navigationItem.rightBarButtonItem = _doneBbi;
    
    // reset accessory types to nothing
    for (int section = 0, sectionCount = self.tableView.numberOfSections; section < sectionCount; ++section) {
        for (int row = 0, rowCount = [self.tableView numberOfRowsInSection:section]; row < rowCount; ++row) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            if (cell.accessoryType != UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.accessoryView = nil;
        }
    }
}

-(IBAction)doneSelecting:(id)sender
{
    selectMode = false;
    self.navigationItem.rightBarButtonItem= _selectBbi;
    
    // reset accessory types to disclosure indicator
    for (int section = 0, sectionCount = self.tableView.numberOfSections; section < sectionCount; ++section) {
        for (int row = 0, rowCount = [self.tableView numberOfRowsInSection:section]; row < rowCount; ++row) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            if (cell.accessoryType != UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.accessoryView = nil;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = Rgb2UIColor(230, 255, 249);
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateTableData) forControlEvents:UIControlEventValueChanged];
    self.myClassSearchBar.barTintColor = Rgb2UIColor(255, 232, 229);
    self.myClassSearchBar.tintColor = [UIColor blackColor];
    [self updateTableData];
}

-(void)updateTableData
{
    PFUser *user = [PFUser currentUser];
    [user refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFRelation *relation = user[@"class"];
        PFQuery *query = [relation query];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                classes = objects;
                filteredClasses = [NSMutableArray arrayWithCapacity:[classes count]];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
            else
            {
                NSLog(@"error %@",[error userInfo][@"error"]);
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PFUser *user = [PFUser currentUser];
    PFRelation *userToClassRelation = [user relationforKey:@"currentlyStudying"];
    PFRelation *classToUserRelation = [classes[indexPath.row] relationforKey:@"studentsStudying"];
    
        // if the user is in selecting mode, they will check what they currently want to study and uncheck what they are not studying, sends test confirmation alerts
    if (selectMode)
    {
        if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.backgroundColor = Rgb2UIColor(80, 195, 174);
            [userToClassRelation addObject:classes[indexPath.row]];
            [classToUserRelation addObject:user];
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Row Selected" message:@"You are currently studying this subject" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            // Display Alert Message
            [messageAlert show];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor clearColor];
            [userToClassRelation removeObject:classes[indexPath.row]];
            [classToUserRelation removeObject:user];
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Row Selected" message:@"No longer studying this subject" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            // Display Alert Message
            [messageAlert show];
        }
        
        [user saveInBackground];
        [classes[indexPath.row] saveInBackground];
    }
    
    // background color will always be yellow when the user is currently studying that subject
    else
    {
    // Create the next view controller.
        MyClassDetailViewController *detailViewController = [[MyClassDetailViewController alloc] initWithNibName:@"MyClassDetailViewController" bundle:nil];
    
        PFObject *class;
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            class = filteredClasses[indexPath.row];
        }
        else
        {
            class = classes[indexPath.row];
        }
    
        // Pass the selected object to the new view controller.
        detailViewController.classObject = class;
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassTableViewCell *cell = (ClassTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ClassTableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    PFObject *class;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        class = filteredClasses[indexPath.row];
    }
    else
    {
        class = classes[indexPath.row];
    }
    
    //keeps what you are studying highlighted when you come back to the tableview
    PFUser *user = [PFUser currentUser];
    PFRelation *studyingRelation = [user relationforKey:@"currentlyStudying"];
    PFQuery *checkedQuery =[studyingRelation query];
    [checkedQuery whereKey:@"objectId" equalTo:[class objectId]];
    
    [checkedQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            //not in the relation
        }
        else {
            //in the relation
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.backgroundColor = Rgb2UIColor(80, 195, 174);
        }
    }];
    
    cell.textLabel.text = class[@"name"];
    cell.detailTextLabel.text = class[@"location"];
    cell.backgroundColor = Rgb2UIColor(230, 255, 249);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredClasses count];
    }
    else
    {
        return [classes count];
    }
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //Update the filtered array based on the search text and scope
    //Remove all objects from the filtered search array
    [filteredClasses removeAllObjects];
    
    //fil†er array using predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"name", searchText];
    filteredClasses = [NSMutableArray arrayWithArray:[classes filteredArrayUsingPredicate:predicate]];

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
