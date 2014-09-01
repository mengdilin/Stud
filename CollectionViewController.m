//
//  CollectionViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/4/14.
//
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{
}
@end

static const float cellHeight = 188.0f;
static const float cellSpace = 10.0f;
static const float searchBarHeight = 40.0f;
static const float mergeImageSpacing = 1.0f;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.barTintColor = Rgb2UIColor(255, 232, 229);
    searchBar.tintColor = [UIColor blackColor];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:[self.view frame] collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    searchBar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, searchBarHeight);
    [self.view addSubview:self.collectionView];
    [self.view addSubview:searchBar];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y + searchBar.frame.size.height, self.collectionView.frame.size.width, self.collectionView.frame.size.height-refreshControl.frame.size.height);
    self.navigationItem.title = @"My Groups";
    self.collectionView.backgroundColor = Rgb2UIColor(230, 255, 249);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(self.collectionView.frame.size.width/2.0f-cellSpace, cellHeight);
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

//may be used later to merge four photos into one thumbnail

-(void)mergeSave:(CollectionViewCell *)cell imageArray: (NSArray *)array
{

    NSMutableArray *imagesContainer = [[NSMutableArray alloc] initWithArray:array];
    
    for (int i=0; i < [imagesContainer count]; i++)
    {
        UIImageView *image = imagesContainer[i];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [cell.image addSubview:image];
        
    }
    
    switch ([imagesContainer count]) {
        case 0:
        {
            break;
        }
        case 1:
        {
            UIImageView *image1 = imagesContainer[0];
            image1.frame = CGRectMake(mergeImageSpacing, mergeImageSpacing, -2.0*mergeImageSpacing + cell.image.frame.size.width/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            break;
        }
        case 2:
        {
            UIImageView *image1 = imagesContainer[0];
            UIImageView *image2 = imagesContainer[1];
            image1.frame = CGRectMake(mergeImageSpacing, mergeImageSpacing, -2.0*mergeImageSpacing + cell.image.frame.size.width/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            image2.frame = CGRectMake(mergeImageSpacing, mergeImageSpacing + cell.image.frame.size.height/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.width/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            break;
        }
        case 3:
        {
            UIImageView *image1 = imagesContainer[0];
            UIImageView *image2 = imagesContainer[1];
            UIImageView *image3 = imagesContainer[2];
            image1.frame = CGRectMake(mergeImageSpacing, mergeImageSpacing, -2.0*mergeImageSpacing + cell.image.frame.size.width/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            image2.frame = CGRectMake(mergeImageSpacing, mergeImageSpacing + cell.image.frame.size.height/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.width/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            image3.frame = CGRectMake(mergeImageSpacing + cell.image.frame.size.width/2.0, mergeImageSpacing, cell.image.frame.size.width/2.0 - 2.0*mergeImageSpacing, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            break;
        }
        default:
        {
            UIImageView *image1 = imagesContainer[0];
            UIImageView *image2 = imagesContainer[1];
            UIImageView *image3 = imagesContainer[2];
            UIImageView *image4 = imagesContainer[3];
            image1.frame = CGRectMake(mergeImageSpacing, mergeImageSpacing, -2.0*mergeImageSpacing + cell.image.frame.size.width/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            image2.frame = CGRectMake(mergeImageSpacing, mergeImageSpacing + cell.image.frame.size.height/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.width/2.0, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            image3.frame = CGRectMake(mergeImageSpacing + cell.image.frame.size.width/2.0, mergeImageSpacing, cell.image.frame.size.width/2.0 - 2.0*mergeImageSpacing, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            image4.frame = CGRectMake(mergeImageSpacing + cell.image.frame.size.width/2.0, mergeImageSpacing + cell.image.frame.size.height/2.0, cell.image.frame.size.width/2.0 - 2.0*mergeImageSpacing, -2.0*mergeImageSpacing + cell.image.frame.size.height/2.0);
            break;
        }
            
    }
   
    [cell.image.layer setCornerRadius:0.5*(cell.frame.size.width)];
    [cell.image.layer setMasksToBounds:YES];
}

@end
