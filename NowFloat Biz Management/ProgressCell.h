//
//  ProgressCell.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 26/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressCell : UITableViewCell
{

}
@property (weak, nonatomic) IBOutlet UIProgressView *myProgressView;
@property (weak, nonatomic) IBOutlet UILabel *progressText;

@end
