//
//  RequestGooglePlaces.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/04/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequsestGooglePlacesDelegate <NSObject>

-(void)requestGooglePlacesDidSucceed;
-(void)requestGooglePlaceDidFail;

@end


@interface RequestGooglePlaces : NSObject


@property (nonatomic,strong) id<RequsestGooglePlacesDelegate>delegate;

-(void)requestGooglePlaces;

@end
