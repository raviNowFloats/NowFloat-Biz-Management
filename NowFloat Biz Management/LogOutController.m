//
//  LogOutController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/12/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "LogOutController.h"

@implementation LogOutController

-(void)clearFloatingPointDetails
{
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:@"userFpId"];
    
    [userDefaults removeObjectForKey:@"NFManageFBAccessToken"];
    
    [userDefaults removeObjectForKey:@"NFManageFBUserId"];
    
    [userDefaults removeObjectForKey:@"NFFacebookName"];
    
    [userDefaults removeObjectForKey:@"NFManageUserFBAdminDetails"];
    
    [userDefaults synchronize];
    
    [appDelegate.storeDetailDictionary removeAllObjects];
    [appDelegate.msgArray removeAllObjects];
    [appDelegate.fpDetailDictionary removeAllObjects];
    [appDelegate.dealDateArray removeAllObjects];
    [appDelegate.dealDescriptionArray removeAllObjects];
    [appDelegate.dealId removeAllObjects];
    [appDelegate.arrayToSkipMessage removeAllObjects];
    [appDelegate.inboxArray removeAllObjects];
    [appDelegate.userMessagesArray removeAllObjects];
    [appDelegate.userMessageDateArray removeAllObjects];
    [appDelegate.userMessageContactArray removeAllObjects];
    [appDelegate.storeTimingsArray removeAllObjects];
    [appDelegate.storeContactArray removeAllObjects];
    [appDelegate.storeAnalyticsArray removeAllObjects];
    [appDelegate.storeVisitorGraphArray removeAllObjects];
    [appDelegate.secondaryImageArray removeAllObjects];
    [appDelegate.dealImageArray removeAllObjects];
    [appDelegate.fbUserAdminArray removeAllObjects];
    [appDelegate.fbUserAdminIdArray removeAllObjects];
    [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
    [appDelegate.socialNetworkNameArray removeAllObjects];
    [appDelegate.socialNetworkIdArray removeAllObjects];
    [appDelegate.socialNetworkAccessTokenArray removeAllObjects];
    [appDelegate.multiStoreArray removeAllObjects];
    [appDelegate.searchQueryArray removeAllObjects];
    appDelegate.storeEmail=@"No Description";
    [appDelegate.storeWidgetArray removeAllObjects];
    appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@""];
    appDelegate.storeCategoryName=[NSMutableString stringWithFormat:@""];
    [appDelegate.deletedFloatsArray removeAllObjects];
    appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@""];
    appDelegate.storeLogoURI=[NSMutableString stringWithFormat:@""];
    appDelegate.storeTag=[NSMutableString stringWithFormat:@""];
}

@end
