//
//  GetFpAddressDetails.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>




@protocol FpAddressDelegate <NSObject>


-(void)fpAddressDidFetchLocationWithLocationArray:(NSArray *)locationArray;
-(void)fpAddressDidFail;


@end


@interface GetFpAddressDetails : NSObject
{

    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    NSMutableData *receivedData;

}

@property (nonatomic,strong) id<FpAddressDelegate>delegate;

-(void)downloadFpAddressDetails :(NSString *)addressString;

@end
