//
//  MMMLoginViewController.h
//  FBUProject
//
//  Created by Michelle Adjangba on 7/10/14.
//  Copyright (c) 2014 Michelle Adjangba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"

@interface MMMLoginViewController : UIViewController <CommsDelegate>

@property (nonatomic) UIViewController *signUpVC;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, retain) UINavigationController *navControllerProf;
@property (nonatomic, retain) UINavigationController *navControllerNotif;
@property (nonatomic, retain) UINavigationController *navControllerFindGroups;
@property (nonatomic, retain) UINavigationController *navControllerChat;
@property (nonatomic, retain) UINavigationController *navControllerClass;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet CustomUIButton *loginButton;
@property (weak, nonatomic) IBOutlet CustomUIButton *signUpButton;

@end