//
//  HomeViewMsgCell.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/21/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "HomeViewMsgCell.h"

@implementation HomeViewMsgCell
@synthesize postedDateLabel,posteImageView,ImageConView,postView;
@synthesize postDateLabel1;
@synthesize postContentText,postContentText1,postView1,postContentText2,postDateLabel2;

@synthesize postContentText4,postDateLabel4,posteImageView1,ImageConView1;
@synthesize postConLabel2,postConLabel1,postConLabel3,postConLabel4;
- (void)awakeFromNib
{
   
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)prepareForReuse
{
    [super prepareForReuse];
   
}
@end
