//
//  BusinessHoursCell.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/18/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessHoursCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *workingDayLabel;
@property (strong, nonatomic) IBOutlet UISwitch *workingDaySwitch;

@end
