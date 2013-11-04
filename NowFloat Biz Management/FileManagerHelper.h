//
//  FileManagerHelper.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 20/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerHelper : NSObject


-(void)createUserSettings;

-(NSMutableDictionary *)openUserSettings;

-(void)updateUserSettingWithValue:(id)value forKey:(id)key;

@end
