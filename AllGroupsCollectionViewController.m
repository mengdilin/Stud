//
//  AllGroupsCollectionViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/4/14.
//
//

#import "AllGroupsCollectionViewController.h"
#import "CollectionViewCell.h"
#import "FindGroupDetailViewController.h"
#import "CollectionViewCell.h"
#import "GroupStepViewController.h"
#import "CustomUIButton.h"

@implementation AllGroupsCollectionViewController
{
    CustomUIButton *dropButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [searchBar setPlaceholder:@"Search Your Groups"];
    [self updateData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [searchBar setText:@""];
    [searchBar setPlaceholder:@"Search Your Groups"];
}

-(void)updateData
{
    dataObjects = [[NSMutableArray alloc] init];
    PFQuery *query = [self getQuery];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (PFObject *object in objects)
            {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
                [tmpDict setObject:object forKey:@"data"];
                [tmpDict setObject:object[@"name"] forKey:@"name"];
                if (!object[@"profileImage"])
                {
                    [dataObjects addObject:tmpDict];
                }
                else
                {
                    [object[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (data)
                        {
                            [tmpDict setObject:data forKey:@"image"];
                            [dataObjects addObject:tmpDict];
                            filteredDataObjects = [[NSMutableArray alloc] initWithArray:[dataObjects copy]];
                            [self.collectionView reloadData];
                        }
                    }];
                }
                filteredDataObjects = [[NSMutableArray alloc] initWithArray:[dataObjects copy]];
                [self.collectionView reloadData];
                [refreshControl endRefreshing];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Fetching" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(PFQuery *)getQuery
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"groups"];
    PFQuery *query = [relation query];
    return query;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [filteredDataObjects count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.nameLabel.text=filteredDataObjects[indexPath.row][@"data"][@"name"];
    cell.image.image = nil;
    if ([filteredDataObjects count] > 0)
    {
        if (filteredDataObjects[indexPath.row][@"image"])
         {
             UIImage *image = [UIImage imageWithData:filteredDataObjects[indexPath.row][@"image"]];
             cell.image.image = image;
         }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    FindGroupDetailViewController *groupDetailView = [[FindGroupDetailViewController alloc] init];
    groupDetailView.groupObject = dataObjects[indexPath.row][@"data"];
    groupDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupDetailView animated:YES];
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    if (searchText && [searchText length])
    {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"name", searchText];
        filteredDataObjects = [NSMutableArray arrayWithArray:[dataObjects filteredArrayUsingPredicate:filterPredicate]];
    }
    else
    {
        filteredDataObjects = [[NSMutableArray alloc] initWithArray:[dataObjects copy]];
    }
    
    [self.collectionView reloadData];
}

@end
