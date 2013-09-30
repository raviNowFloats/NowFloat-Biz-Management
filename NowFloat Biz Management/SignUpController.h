//
//  SignUpController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol SignUpControllerDelegate <NSObject>

-(void)signUpDidSucceedWithFpId:(NSString *)responseString;

-(void)signUpDidFailWithError;

@end


@interface SignUpController : NSObject
{
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    NSMutableData *receivedData;
    
    int successCode;

}



@property(nonatomic,strong) id<SignUpControllerDelegate>delegate;

-(void)withCredentials:(NSMutableDictionary *)signUpDetails;



@end
