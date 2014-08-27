//
//  SiteMeterHomeView.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 27/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiteMeterHomeView : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UIProgressView *myProgress;

@property (weak, nonatomic) IBOutlet UILabel *progressText;

@property (weak, nonatomic) IBOutlet UILabel *headLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end
