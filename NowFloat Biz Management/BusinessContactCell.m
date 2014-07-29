//
//  BusinessContactCell.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/16/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BusinessContactCell.h"

@implementation BusinessContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@synthesize contactLabel,contactText,countryCodeLabel,contactText1;
- (void)awakeFromNib
{
    // Initialization code



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
