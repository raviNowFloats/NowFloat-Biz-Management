//
//  FBHelper.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^RequestLoginCompletionHandler)(BOOL Success,NSDictionary *userDetails);

@interface FBHelper : NSObject
{
    BOOL isPageAdmin;
}


-(void)requestLoginAsAdmin:(BOOL)isFBPageAdmin WithCompletionHandler:(RequestLoginCompletionHandler)completionHandler;

@end
