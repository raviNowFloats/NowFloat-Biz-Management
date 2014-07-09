//
//  PostFBCell.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "PostFBCell.h"

@implementation PostFBCell
@synthesize dismiss,imagePost;
@synthesize post;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    self.messgaeLabel.numberOfLines = 5;
    self.imagePost.layer.masksToBounds = YES;
    self.imagePost.contentMode = UIViewContentModeScaleAspectFill;
    [self.imagePost setClipsToBounds:YES];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
