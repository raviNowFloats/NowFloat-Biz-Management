//
//  AddWidgetController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol AddWidgetDelegate <NSObject>

-(void)addWidgetDidSucceed;

-(void)addWidgetDidFail;

@end



@interface AddWidgetController : NSObject
{

    AppDelegate *appDelegate;
    NSMutableData *msgData;
    
}


@property(nonatomic,strong) id<AddWidgetDelegate>delegate;

@property(nonatomic) int buttonTag;

-(void)addWidgetsForFp:(NSDictionary *)detailsDictionary;


@end
