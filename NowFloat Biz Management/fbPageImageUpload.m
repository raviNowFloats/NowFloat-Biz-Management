//
//  fbPageImageUpload.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 01/07/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "fbPageImageUpload.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation fbPageImageUpload

-(void)postToPage:(NSString *)dealTitle withImage:(UIImage *)dealImage
{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication ]delegate];
    
    NSArray *permissionsNeeded = @[@"basic_info", @"manage_pages",@"publish_actions",@"user_photos"];

    for (int i=0;i<appDelegate.socialNetworkNameArray.count; i++)
    {
        
        NSString *accessTokenString=[NSString stringWithFormat:@"%@",[appDelegate.socialNetworkAccessTokenArray objectAtIndex:i]];
        
        NSString *accessIdString=[NSString stringWithFormat:@"%@",[appDelegate.socialNetworkIdArray objectAtIndex:i]];
        
        // Request the permissions the user currently has
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/permissions",accessIdString]
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error){
                                      // These are the current permissions the user has:
                                      NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                      
                                      // We will store here the missing permissions that we will have to request
                                      NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                      
                                      // Check if all the permissions we need are present in the user's current permissions
                                      // If they are not present add them to the permissions to be requested
                                      for (NSString *permission in permissionsNeeded){
                                          if (![currentPermissions objectForKey:permission]){
                                              [requestPermissions addObject:permission];
                                          }
                                      }
                                      
                                      // If we have permissions to request
                                      if ([requestPermissions count] > 0){
                                          // Ask for the missing permissions
                                          [FBSession.activeSession
                                           
                                           requestNewPublishPermissions:requestPermissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                                               if (!error) {
                                                   // Permission granted
                                                   NSLog(@"new permissions %@", [FBSession.activeSession permissions]);
                                                   // We can request the user information
                                                   
                                               } else {
                                                   
                                                   NSLog(@" permissions %@", [FBSession.activeSession permissions]);
                                                   // An error occurred, we need to handle the error
                                                   // See: https://developers.facebook.com/docs/ios/errors
                                               }
                                           }];
                                          
                                          
                                      }
                                      
                                  } else {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                  }
                              }];
        
        
        UIImage *imgSource = dealImage;
        NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             imgSource,@"source",
                                             dealTitle,@"message",
                                             accessTokenString,@"access_token",
                                             nil];
        
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/photos",accessIdString]
                                     parameters:photosParams
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  
                                  
                              }];
        
      
    }
    
   
    
    
   
    
    
    
    
    

}

@end
