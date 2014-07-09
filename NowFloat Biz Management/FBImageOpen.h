//
//  FBImageOpen.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/2/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBImageOpen : UIViewController
{
    NSString *ImageUrl;
}
@property (strong, nonatomic) IBOutlet UIImageView *FbImage;

@property (strong, nonatomic)NSString *ImageUrl;



@end
