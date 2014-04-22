//
//  BusinessAddress.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 4/9/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"

@interface BusinessAddress : UIViewController<GMSMapViewDelegate>{
    AppDelegate *appDelegate;
    NSString *version;
}


@end
