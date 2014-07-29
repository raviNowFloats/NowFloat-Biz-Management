//
//  LeftTableCell.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 28/07/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *headTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
