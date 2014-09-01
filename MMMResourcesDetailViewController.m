//
//  MMMResourcesDetailViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/21/14.
//
//

#import "MMMResourcesDetailViewController.h"
#import "MMMLinkViewController.h"

@interface MMMResourcesDetailViewController ()

@property (nonatomic) UIButton *button;

@end

@implementation MMMResourcesDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
        
        self.navigationItem.title = @"Full Post";
        _bookmarked = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Blue_check.png"] style:UIBarButtonItemStylePlain target:self action:@selector(unlike:)];
        
        
        self.navigationItem.rightBarButtonItem = _saveItem;
        
        _linkToSite = [[MMMLinkViewController alloc] init];

        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button addTarget:self
                   action:@selector(goToVideo:)
        forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"Open Video" forState:UIControlStateNormal];
        
        //arbitrary numbers for testing. Will change with UI change
        _button.frame = CGRectMake(80.0, 330.0, 160.0, 100.0);
        _button.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_button];
        
        
    }
    return self;
}
-(void)goToVideo: (id)sender
{
    _linkToSite.url = self.urlLabel.text;
    
    [self.navigationController pushViewController:_linkToSite animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)save: (id)sender
{
    PFUser *user = [PFUser currentUser];
    
    //save post as a relation in the user's savedPosts
    PFRelation *userToPostRelation = [user relationforKey:@"savedPosts"];
    [userToPostRelation addObject:self.classObject];
    [user saveInBackground];

    //save user as a person who liked this post
    PFRelation *postToUserRelation = [self.classObject relationforKey:@"Likes"];
    [postToUserRelation addObject:user];
    [self.classObject saveInBackground];

    [self.navigationItem setRightBarButtonItem:_bookmarked animated:YES];

}

-(void)unlike: (id)sender
{
    //unlike/remove post from save resources
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"savedPosts"];
    [relation removeObject:self.classObject];
    [user saveInBackground];
    
    [self.navigationItem setRightBarButtonItem:_saveItem animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set the text of the post
    self.postText.text = self.classObject[@"text"];
    self.urlLabel.text = self.classObject[@"PostURL"];
    self.nonurlLabel.text = self.classObject[@"nonURLSource"];
    
    //gets the users who liked this post
    PFRelation *relationLike = [self.classObject relationforKey:@"Likes"];
    PFQuery *queryLike = [relationLike query];
    NSInteger countlike = [queryLike countObjects];
    
    self.likes.text = [NSString stringWithFormat:@"%d",countlike];
    
    //finds if this post is already saved in user's savedPosts
    PFUser *user = [PFUser currentUser];
    PFRelation *relationSaved = [user relationforKey:@"savedPosts"];
    PFQuery *querySaved = [relationSaved query];
    [querySaved whereKey:@"objectId" equalTo:[self.classObject objectId]];
    NSInteger countSaved = [querySaved countObjects];
    
    //If the post is present
    if (countSaved == 1)
    {
        [self.navigationItem setRightBarButtonItem:_bookmarked animated:YES];
    }
    
    //If the post is not saved
    if (countSaved == 0)
    {
        [self.navigationItem setRightBarButtonItem:_saveItem animated:YES];
    }
    
    //tell user to open source in web Browser
    if (self.nonurlLabel.text == 0)
    {
        self.tellUser.hidden = YES;
    }
    else
    {
        self.tellUser.hidden = NO;
    }

    //Don't show button if no url
    if (self.urlLabel.text.length == 0)
    {
        self.linkButton.hidden = YES;
    }
    else
    {
        self.linkButton.hidden = NO;
    }
    
    //get the information of the user who posted the selected resource
    PFUser *puser = [self.classObject objectForKey:@"user"];
    [puser fetchIfNeeded];
    //get that user's name
    self.userName.text = [puser objectForKey:@"FullName"];
    
    
    PFFile *file = [puser objectForKey:@"profileImage"];

    // change image file into UIImageView
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            [self.userProfPic setImage:image];
        }
    }];
    
    [self.view setNeedsDisplay];
}

//open url in safari
- (IBAction)goToLink:(id)sender {
    
    NSLog(@"NS STRAANNNNGGGGG  %@", self.urlLabel.text);
    
    _linkToSite.url = self.urlLabel.text;
    
    [self.navigationController pushViewController:_linkToSite animated:YES];

}

//if there is a non https source then prompt user to look up source in Google
- (IBAction)googleIt:(id)sender {
    
    _linkToSite.url = @"http://www.google.com/";
    
    [self.navigationController pushViewController:_linkToSite animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
