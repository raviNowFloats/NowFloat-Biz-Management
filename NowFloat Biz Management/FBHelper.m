//
//  FBHelper.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "FBHelper.h"
#import <Social/Social.h>
#import "Accounts/Accounts.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FBHelper
{

    RequestLoginCompletionHandler _completionHandler;
    
}


- (id)init
{
    if ((self = [super init]))
    {
        
        
    }
    return self;
}


-(void)requestLoginAsAdmin:(BOOL)isFBPageAdmin WithCompletionHandler:(RequestLoginCompletionHandler)completionHandler;
{
    _completionHandler = [completionHandler copy];
    [self openSession:isFBPageAdmin];
}


- (void)openSession:(BOOL)isAdmin
{
    isPageAdmin=isAdmin;
    
    NSArray *permission = [NSArray arrayWithObjects:
                           @"publish_stream",
                           @"manage_pages",
                           @"publish_actions",
                           @"user_photos",
                           @"photo_upload"
                           ,nil];
    
    [FBSession setActiveSession: [[FBSession alloc] initWithPermissions:permission] ];
    
    [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        switch (status)
        {
            case FBSessionStateOpen:
                if (isAdmin)
                {
                    [self connectAsFbPageAdmin];
                }
                else
                {
                    [self populateUserDetails];
                }
                break;
                
            case FBSessionStateClosedLoginFailed:
            {

                NSString *errorCode = [[error userInfo] objectForKey:FBErrorLoginFailedOriginalErrorCode];
                NSString *errorReason = [[error userInfo] objectForKey:FBErrorLoginFailedReason];
                BOOL userDidCancel = !errorCode && (!errorReason || [errorReason isEqualToString:FBErrorLoginFailedReasonInlineCancelledValue]);
                
                if(error && userDidCancel)
                {
                    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Oops"
                               message:errorReason
                              delegate:nil
                     cancelButtonTitle:@"Ok"
                     otherButtonTitles:nil];
                    [errorMessage show];
                    errorMessage = nil;
                }

                _completionHandler(NO, Nil);
                
                _completionHandler=nil;
            }
                break;
            default:
                break;
        }
    }];
    permission = nil;
    
    
}


//- (void)sessionStateChanged:(FBSession *)session
//                      state:(FBSessionState)state
//                      error:(NSError *)error
//{    switch (state)
//    {
//        case FBSessionStateOpen:
//        {
//            
//            if ([FBSession.activeSession.permissions
//                 indexOfObject:@"publish_actions"] == NSNotFound)
//            {
//                
//                dispatch_async(dispatch_get_main_queue(),
//                               ^{
//                                    [self openSessionForPublishPermissions];
//                                });
//            }
//            
//            else
//            {
//                if (isPageAdmin)
//                {
//                    [self connectAsFbPageAdmin];
//                    
//                }
//                
//                
//                else
//                {
//                    [self populateUserDetails];
//                }
//                
//            }
//            
//        }
//            
//        break;
//            
//        case FBSessionStateClosed:
//        case FBSessionStateClosedLoginFailed:
//        {
//            if (error)
//            {
//                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops"
//                                                                 message:error.localizedDescription
//                                                                delegate:self
//                                                       cancelButtonTitle:@"Done"
//                                                       otherButtonTitles:nil, nil];
//                
//                [alertView show];
//                
//                alertView=nil;
//                
//                _completionHandler(NO,nil);
//                
//                [FBSession.activeSession closeAndClearTokenInformation];
//            }
//            
//            [FBSession.activeSession closeAndClearTokenInformation];
//        }
//            
//        break;
//            
//        default:
//            break;
//            
//    }
//    
//}



-(void)populateUserDetails
{
    
    NSString * accessToken =  [[FBSession activeSession] accessTokenData].accessToken;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:accessToken forKey:@"NFManageFBAccessToken"];
    
    [userDefaults synchronize];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (!error)
         {
             _completionHandler(YES, user);
             
             _completionHandler = nil;
             
             [FBSession.activeSession closeAndClearTokenInformation];
         }
         
         else
         {
             _completionHandler(NO,nil);
             
             _completionHandler = nil;
             
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [alertView show];
             
             alertView=nil;
             
             [FBSession.activeSession closeAndClearTokenInformation];
             
         }
     }];
    
    
}


-(void)connectAsFbPageAdmin
{
    NSString * accessToken =  [[FBSession activeSession] accessTokenData].accessToken;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:accessToken forKey:@"NFManageFBAccessToken"];
    
    [userDefaults synchronize];
    
    [[FBRequest requestForGraphPath:@"me/accounts"]
     startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         
         if (!error)
         {
             
             _completionHandler(YES, user);
             
             _completionHandler=nil;
             
             [FBSession.activeSession closeAndClearTokenInformation];

         }
         
         else
         {
             _completionHandler(NO, user);
             
             _completionHandler=nil;
             
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [alertView show];
             
             alertView=nil;
             
             [FBSession.activeSession closeAndClearTokenInformation];
         }
         
     }];


}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


-(void)openSessionForPublishPermissions
{
    
    NSArray *permissions =  [NSArray arrayWithObjects:
                             @"publish_stream",
                             @"manage_pages",
                             @"publish_actions"
                             ,nil];

    [[FBSession activeSession] requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:
     
     ^(FBSession *session, NSError *error)
     {
         
         if (error)
         {
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil
                      message:error.localizedDescription delegate:nil
            cancelButtonTitle:@"Ok"
            otherButtonTitles:nil, nil];
             
             [alertView show];
             alertView=nil;
             [FBSession.activeSession closeAndClearTokenInformation];
         }
         
         else
         {
             if (isPageAdmin)
             {
                 [self connectAsFbPageAdmin];
             }
             else
             {
                 [self populateUserDetails];
             }
         }
     }];

}

@end
