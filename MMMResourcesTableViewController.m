//
//  MMMResourcesTableViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/14/14.
//
//

#import "MMMResourcesTableViewController.h"
#import "MMMResourcesFinalDetailViewController.h"

@interface MMMResourcesTableViewController ()

@end

@implementation MMMResourcesTableViewController


-(instancetype)init
{
    self = [super initWithCellNibName:@"EventTableViewCell"];
    
    if (self)
    {
        self.navigationItem.title = @"Saved Resources";
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.relationKey = @"savedPosts";
        self.keyInRelation = @"text";
    }
    
    return self;
}

// Makes changes while switching into/out of editing mode
- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated {
    [super setEditing:editing
             animated:animated];
    
    // Show/hide labels, buttons and text fields
    [self updateView:editing];
}

- (void)updateView:(BOOL)isEditing {
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

// Delete unwanted saved posts
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        PFObject *post = self.allObjects[indexPath.row];
        PFUser *user = [PFUser currentUser];
        PFRelation *relation = [user relationforKey:self.relationKey];
        
        //remove relation then remove the object in the array
        [relation removeObject:post];

        [self.allObjects removeObjectAtIndex:indexPath.row];
        [user saveInBackground];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];

        
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
    // Navigation logic may go here, for example:
    // Create the next view controller.
    MMMResourcesFinalDetailViewController *detailViewController = [[MMMResourcesFinalDetailViewController alloc] initWithNibName:@"MMMResourcesFinalDetailViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    detailViewController.classObject = self.allObjects[indexPath.row];
    detailViewController.hidesBottomBarWhenPushed = YES;

    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
