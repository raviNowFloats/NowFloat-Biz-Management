//
//  PostFBCell.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostFBCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *messgaeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imagePost;
@property (strong, nonatomic) IBOutlet UIButton *dismiss;
@property (strong, nonatomic) IBOutlet UIButton *post;

@end
