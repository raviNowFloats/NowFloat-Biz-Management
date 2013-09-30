//
//  VerifyUniqueNameController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol VerifyUniqueNameDelegate <NSObject>

-(void)verifyUniqueNameDidComplete:(NSString *)responseString;

-(void)verifyuniqueNameDidFail:(NSString *)responseString;

@end

@interface VerifyUniqueNameController : NSObject
{

    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableData *receivedData;
    BOOL isSuccess;

}

@property(nonatomic,strong)id<VerifyUniqueNameDelegate>delegate;



-(void)verifyWithFpName:(NSString *)fpName andFpTag:(NSString *)fpTag;



@end
