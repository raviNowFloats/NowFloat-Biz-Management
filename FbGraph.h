//
//  FbGraph.h
//  NowFloatsv1
//
//  Created by pravasis on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "FbGraphResponse.h"

@interface FbGraph : NSObject <UIWebViewDelegate> {
    
	NSString *facebookClientID;
	NSString *redirectUri;
	NSString *accessToken;
	
	UIWebView *webView;
	
	id callbackObject;
	SEL callbackSelector;
	UIButton *closeButton;
	UIActivityIndicatorView *activityIndicator;
	
}

@property (nonatomic, retain) NSString *facebookClientID;
@property (nonatomic, retain) NSString *redirectUri;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) UIWebView *webView;

@property (assign) id callbackObject;
@property (assign) SEL callbackSelector;

- (id)initWithFbClientID:fbcid;
- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions andSuperView:(UIView *)super_view;
- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions;
- (FbGraphResponse *)doGraphGet:(NSString *)action withGetVars:(NSDictionary *)get_vars;
- (FbGraphResponse *)doGraphGetWithUrlString:(NSString *)url_string;
- (FbGraphResponse *)doGraphPost:(NSString *)action withPostVars:(NSDictionary *)post_vars;
-(void)closeView;
@end
