//
//  CollectionViewCell.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/4/14.
//
//

#import "CollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

static const float verticalSpacing = 5.0f;
static const float labelHeight = 21.0f;
static const float cornerRadius = 10.0f;
static const float borderWidth = 0.5f;
static const float shadowRadius = 3.0;
static const float shadowOpacity = 0.1;
static const float mergeImageSpacing = 1.0f;

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //height of imageView should be 70% of the cell's height
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, verticalSpacing, self.frame.size.width, self.frame.size.height*0.7f)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.image.frame.size.height+verticalSpacing, self.frame.size.width, labelHeight)];
        self.membersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+verticalSpacing, self.frame.size.width, labelHeight)];
        self.backgroundColor = [UIColor whiteColor];
        
        //border radius
        [self.layer setCornerRadius:cornerRadius];
        
        //border
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setBorderWidth:borderWidth];
        
        //drop shadow
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:shadowOpacity];
        [self.layer setShadowRadius:shadowRadius];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        self.nameLabel.text = @"Name";
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.membersLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.image];
        [self addSubview:self.nameLabel];
        [self addSubview:self.membersLabel];
    }
    return self;
}

@end
