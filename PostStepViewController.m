//
//  PostStepViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/28/14.
//
//

#import "PostStepViewController.h"

#import "MMMAllPostsTableViewController.h"
#import "MMMCreatPostTestViewController.h"
#import "MPViewController.h"
#import "PostTextViewController.h"
#import "PostTypeViewController.h"
#import "PostLinksViewController.h"

@interface PostStepViewController ()


@property (nonatomic) PostTypeViewController *postType;
@property (nonatomic) PostTextViewController *postText;
@property (nonatomic) PostLinksViewController *postLinks;


@end

@implementation PostStepViewController


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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //Hide navigation bar
    self.navigationController.navigationBarHidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)stepViewControllers
{
    self.postType = [[PostTypeViewController alloc] init];
    self.postText = [[PostTextViewController alloc] init];
    self.postLinks = [[PostLinksViewController alloc] init];
    
    self.postType.step.title=@"Type";
    self.postText.step.title=@"Post Text";
    self.postLinks.step.title=@"Relevant Links";
    
    if ([self.type isEqualToString:@"Web"] || [self.type isEqualToString:@"Vid"] || [self.type isEqualToString:@"All"] || [self.type isEqualToString:@"Tips"])
    {
        return @[self.postLinks,self.postText];
    }
    else
    {
        return @[self.postType,self.postLinks,self.postText];

    }
}

-(void)finishedAllSteps

{
    //Save post information
    PFObject *post = [PFObject objectWithClassName:@"Posts"];
    post[@"text"]=self.results[@"text"];
    post[@"user"]=[PFUser currentUser];
    
    if (self.type == NULL)
    {
        post[@"PostType"] = self.results[@"PostType"];
    }
    else
    {
        post[@"PostType"]= self.type;
    }
    
    if (self.results[@"nonURLSource"] != nil)
    {
        post[@"nonURLSource"]= self.results[@"nonURLSource"];
    }
    
    if (self.results[@"PostURL"] != nil)
    {
        post[@"PostURL"]=self.results[@"PostURL"];
    }
    
    post[@"subject"] = self.results[@"subject"];
    post[@"PostTitle"] = self.results[@"PostTitle"];

    if (self.results[@"Picture"] != nil)
    {
        post[@"Picture"] =self.results[@"Picture"];
    }
    
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Success" message:@"Resource Posted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];

}

-(void)canceled
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
