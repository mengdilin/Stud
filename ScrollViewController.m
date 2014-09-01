//
//  ScrollViewController.m
//  Scroller
//
//  Created by reefaq on 25/04/12.
//  Copyright (c) 2012 raw engineering. All rights reserved.
//

#import "ScrollViewController.h"
#import "UserBoxView.h"

@implementation ScrollViewController

@synthesize scrollView;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
    
    self.title = @"Scroller";
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIBarButtonItem* addContactBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewContact:)];
    self.navigationItem.rightBarButtonItem = addContactBarButton;
		
	scrollView  = [[ScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	scrollView.scrollViewDelegate = self;
	scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:scrollView];
	
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray* peopleArray = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (id per in peopleArray) {
        ABRecordRef person = (__bridge ABRecordRef)per;
        
        NSString* firstName = (__bridge_transfer NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString* lastName = (__bridge_transfer NSString*) ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFDataRef image = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        NSData* imageData = (__bridge_transfer NSData*)image;

        UIImage* imageObj = nil;
        
        if (imageData) {
            imageObj = [UIImage imageWithData:imageData];
        }
        
        UserBoxView* boxView = [[UserBoxView alloc] init];
        [boxView.userImageView setImage:[UIImage imageNamed:@"defaultPersonImage.png"]];
        
        [boxView.displayTextLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,(lastName.length>0 ? lastName : @"")]];
        if (imageObj != nil) {
            [boxView.userImageView setImage:imageObj];
        }else {
            [boxView.userImageView setImage:[UIImage imageNamed:@"userdefault.jpg"]];
        }
        
        //[boxView.badgeLabel setText:[NSString stringWithFormat:@" %d ",1]];

        [scrollView addUserView:boxView];
    }
    CFRelease(addressBook);
    
	[scrollView bringViewAtIndexToFront:0 animated:YES];
    
    if ([peopleArray count] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Opps !!" message:@"No Contacts!  So Sad :( " delegate:nil cancelButtonTitle:@"I Got it!" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


-(void)addNewContact:(id)sender {

    ABNewPersonViewController* picker = [[ABNewPersonViewController alloc] init];
	picker.newPersonViewDelegate = self;
	
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
	[self presentModalViewController:navigation animated:YES];
	

    
}
#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller. 
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	[self dismissModalViewControllerAnimated:YES];

    if (person) {
        NSString* firstName = (__bridge_transfer NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString* lastName = (__bridge_transfer NSString*) ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFDataRef image = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        NSData* imageData = (__bridge_transfer NSData*)image;
        
        UIImage* imageObj = nil;
        
        if (imageData) {
            imageObj = [UIImage imageWithData:imageData];
        }
        
        UserBoxView* boxView = [[UserBoxView alloc] init];
        [boxView.userImageView setImage:[UIImage imageNamed:@"defaultPersonImage.png"]];
        
        [boxView.displayTextLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,(lastName.length>0 ? lastName : @"")]];
        if (imageObj != nil) {
            [boxView.userImageView setImage:imageObj];
        }else {
            [boxView.userImageView setImage:[UIImage imageNamed:@"userdefault.jpg"]];
        }
        
        [boxView.badgeLabel setText:[NSString stringWithFormat:@" %d ",1]];
        
        [scrollView addUserView:boxView];

        [scrollView jumpToLast:YES];
    }
    
}

//Select row and takes you to person's contact information. Still looking into why the numbers are not showing up. Will do in next diff.
- (void) selectedView:(UserBoxView*)selectedview {
    
    ABPersonViewController* ctrl = [[ABPersonViewController alloc]init];
    ctrl.allowsEditing = YES;
    [self.navigationController pushViewController:ctrl animated:
     YES];
}

-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
