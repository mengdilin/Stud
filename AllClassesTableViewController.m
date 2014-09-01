//
//  AllClassesTableViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/16/14.
//
//

#import "AllClassesTableViewController.h"
#import "ClassStepViewController.h"
#import "ClassDetailViewController.h"
#import "ClassTableViewCell.h"
#import "RSDetailViewController2.h"
#import "UITableView+Frames.h"
#import "RSBasicItem.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
const float animationDuration = 0.8f;

@interface AllClassesTableViewController ()

@end

@implementation AllClassesTableViewController
{
    NSMutableArray *filteredAllClasses;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

-(IBAction)addNewClass:(id)sender
{
    ClassStepViewController *csvc = [[ClassStepViewController alloc] init];
    csvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:csvc animated:YES];
        
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allClassesSearchBar.barTintColor = Rgb2UIColor(255, 232, 229);
    self.allClassesSearchBar.tintColor = [UIColor blackColor];

    [self.tableView registerNib:[UINib nibWithNibName:@"ClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassTableViewCell"];

    self.navigationItem.title = @"All Classes";
    [self addCreateButtonItem];
    self.tableView.backgroundColor = Rgb2UIColor(230, 255, 249);
}


-(void)addCreateButtonItem
{
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewClass:) ];
    self.navigationItem.rightBarButtonItem = add;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    PFQuery *query = [PFQuery queryWithClassName:self.keyForParse];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            self.allClasses = objects;
            filteredAllClasses = [NSMutableArray arrayWithCapacity:[self.allClasses count]];
            [self.tableView reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Fetching" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredAllClasses count];
    }
    else
    {
        return [self.allClasses count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassTableViewCell *cell = (ClassTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ClassTableViewCell" forIndexPath:indexPath];
    
    PFObject *class;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        class = filteredAllClasses[indexPath.row];
    }
    else
    {
        class = self.allClasses[indexPath.row];
    }
    
    cell.textLabel.text = class[@"name"];
    cell.detailTextLabel.text = class[@"location"];
    cell.backgroundColor = Rgb2UIColor(230, 255, 249);
    return cell;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //Update the filtered array based on the search text and scope
    //Remove all objects from the filtered search array
    [filteredAllClasses removeAllObjects];
    
    //fil†er array using predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"name", searchText];
    filteredAllClasses = [NSMutableArray arrayWithArray:[self.allClasses filteredArrayUsingPredicate:predicate]];
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

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    // Pass the selected object to the new view controller.
    PFObject *class;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        class = filteredAllClasses[indexPath.row];
    }
    else
    {
        class = self.allClasses[indexPath.row];
    }
    
    //save data to use in the transition effect view controller
    ClassDetailViewController *detailView = [[ClassDetailViewController alloc] init];
    detailView.classObject = class;
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:NO];
}



@end
