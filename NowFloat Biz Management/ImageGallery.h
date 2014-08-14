//
//  ImageGallery.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 11/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ImageGallery : UIViewController
{
    AppDelegate *appDelegate;
    
    IBOutlet UIView *detailImage;
   
    NSString *version;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollGallery;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollImage;

@property (strong, nonatomic) NSMutableArray *imageList;

@end
