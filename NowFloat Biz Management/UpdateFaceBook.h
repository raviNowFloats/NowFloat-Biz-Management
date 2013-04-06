//
//  UpdateFaceBook.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"



@interface UpdateFaceBook : NSObject
{
    AppDelegate *appDelegate;

}


-(void)postToFaceBook:(NSString *)dealDescription;




@end
