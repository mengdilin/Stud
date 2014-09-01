//
//  MMMChatViewCell.m
//  ParseStarterProject
//
//  Created by Milica Kolundzija on 7/28/14.
//
//

#import "MMMChatViewCell.h"

// Constants for creating frames
static const CGFloat kLabelsLeftMargin = 30.0;
static const CGFloat kNameTopMargin = 5.0;
static const CGFloat kClassesTopMargin = 25.0;
static const CGFloat kLabelsHeight = 20.0;


@implementation MMMChatViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:self.nameLabel];
        
        self.classesLabel = [[UILabel alloc] init];
        self.classesLabel.font = [UIFont fontWithName:@"Arial"
                                                 size:12.0f];
        [self addSubview:self.classesLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    self.nameLabel.frame = CGRectMake(kLabelsLeftMargin, kNameTopMargin, width - kLabelsLeftMargin, kLabelsHeight);
    self.classesLabel.frame = CGRectMake(kLabelsLeftMargin, kClassesTopMargin, width - kLabelsLeftMargin, kLabelsHeight);
}

@end
