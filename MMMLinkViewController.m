//
//  MMMLinkViewController.m
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/25/14.
//
//

#import "MMMLinkViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MMMLinkViewController ()

@end

@implementation MMMLinkViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];//init and create the UIWebView
        
        _webView.autoresizesSubviews = YES;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        
        [_webView setDelegate:self];
        
        [self.view addSubview:_webView];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//Post url appears
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *URL = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
