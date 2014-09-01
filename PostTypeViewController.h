//
//  PostTypeViewController.h
//  ParseStarterProject
//
//  Created by Michelle Adjangba on 7/28/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"

@interface PostTypeViewController : UIViewController

@property (nonatomic, copy) NSString *type;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *prev;
@property (nonatomic, assign) CustomUIButton *video;
@property (nonatomic, assign) CustomUIButton *web;
@property (nonatomic, assign) CustomUIButton *tips;
@property (nonatomic, assign) CustomUIButton *all;

@end
