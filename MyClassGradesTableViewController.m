//
//  MyClassGradesTableViewController.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/22/14.
//
//

#import "MyClassGradesTableViewController.h"
#import "MyClassGradesTableViewCell.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface MyClassGradesTableViewController ()

@end

@implementation MyClassGradesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyClassGradesTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyClassGradesTableCell"];
    self.tableView.backgroundColor = Rgb2UIColor(230, 255, 249);
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
    return [self.gradesInfo count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClassGradesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyClassGradesTableCell" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[MyClassGradesTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"MyClassGradesTableCell"];
    }
    cell.examTypeLabel.numberOfLines = 1;
    cell.examTypeLabel.minimumScaleFactor = 0.5;
    cell.examTypeLabel.adjustsFontSizeToFitWidth = YES;
    cell.examScoreLabel.numberOfLines = 1;
    cell.examScoreLabel.minimumScaleFactor = 0.5;
    cell.examScoreLabel.adjustsFontSizeToFitWidth = YES;
    // Configure the cell...
    if (indexPath.row == 0)
    {
        cell.examTypeLabel.text = @"Exam Type";
        cell.examScoreLabel.text = @"Score";
    }
    else
    {
        cell.examTypeLabel.text = self.gradesInfo[indexPath.row-1][@"exam type"];
        cell.examScoreLabel.text = self.gradesInfo[indexPath.row-1][@"grade"];
    }
    cell.backgroundColor = Rgb2UIColor(230, 255, 249);
    return cell;
}

@end
