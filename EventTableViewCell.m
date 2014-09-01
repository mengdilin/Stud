//
//  EventTableViewCell.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 8/8/14.
//
//

#import "EventTableViewCell.h"

static const float imageXOffSet = 10.0f;
static const float imageYOffSet = 5.0f;
static const float imageWidth = 50.0f;
static const float imageHeight = 50.0f;
static const float labelXOffSet = 70;
static const float horizontalSpace = 5.0f;
static const float labelWidth = 200.0f;
static const float nameLabelHeight = 25.0f;
static const float descriptionLabelHeight = 15.0f;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation EventTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageview = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont systemFontOfSize:20];
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.font = [UIFont systemFontOfSize:10];
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:self.imageview];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.descriptionLabel];
        [self setBackgroundColor:Rgb2UIColor(230, 255, 249)];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGFloat boundsY = contentRect.origin.y;
    CGRect frame;
    
    frame = CGRectMake(boundsX+imageXOffSet, boundsY+imageYOffSet, imageWidth, imageHeight);
    self.imageview.frame = frame;
    
    frame = CGRectMake(boundsX+labelXOffSet, horizontalSpace, labelWidth, nameLabelHeight);
    self.nameLabel.frame = frame;
    
    frame = CGRectMake(boundsX+labelXOffSet, horizontalSpace + self.nameLabel.frame.size.height, labelWidth, descriptionLabelHeight);
    self.descriptionLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
