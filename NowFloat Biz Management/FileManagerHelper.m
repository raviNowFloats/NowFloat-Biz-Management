//
//  FileManagerHelper.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 20/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "FileManagerHelper.h"

@implementation FileManagerHelper
@synthesize userFpTag=_userFpTag;

-(void)createUserSettings
{
    NSString *tag=_userFpTag;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",tag]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",_userFpTag]];
    }
}

-(NSMutableDictionary *)openUserSettings
{

    NSString *tag=_userFpTag;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",tag]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",_userFpTag]];
    }

    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }

    return data;
}


-(void)updateUserSettingWithValue:(id)value forKey:(id)key
{
    
    NSString *tag=_userFpTag;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",tag]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",_userFpTag]];
    }
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    [data setObject:value forKey:key];
    
    [data writeToFile: path atomically:YES];

}


-(void)removeUserSettingforKey:(id)key
{
    
    NSString *tag=_userFpTag;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",tag]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NFB%@Settings.plist",_userFpTag]];
    }
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    [data removeObjectForKey:key];
    
    [data writeToFile: path atomically:YES];
    
}



@end
