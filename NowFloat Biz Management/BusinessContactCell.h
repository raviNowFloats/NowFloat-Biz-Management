//
//  BusinessContactCell.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/16/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessContactCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;
@property (strong, nonatomic) IBOutlet UITextField *contactText;
@property (strong, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (strong, nonatomic) IBOutlet UITextField *contactText1;

@end
