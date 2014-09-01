//
//  CustomUIButton.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/6/14.
//
//

#import <QuartzCore/QuartzCore.h>
#import "CustomUIButton.h"

static const float contentInset = 8.0f;
static const float cornerRadius = 8.0f;
static const float shadowOpacity = 0.2f;

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation CustomUIButton

-(void)setUpView
{
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = cornerRadius;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    [self setBackgroundColor:Rgb2UIColor(80, 195, 174)]; //Thai Teal
    self.contentEdgeInsets = UIEdgeInsetsMake(contentInset, contentInset, contentInset, contentInset);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
        if (self = [super initWithCoder:aDecoder])
    {
        [self setUpView];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpView];
    }
    
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted)
    {
        [self setBackgroundColor:Rgb2UIColor(131, 212, 197)]; //Cian Green
    }
    else
    {
        [self setBackgroundColor:Rgb2UIColor(80, 195, 174)]; //Thai Teal
    }
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"coral.png"] forState:UIControlStateSelected];
        
    }
    else
    {
        [self setBackgroundColor:Rgb2UIColor(80, 195, 174)]; //Thai Teal
    }
}

@end
