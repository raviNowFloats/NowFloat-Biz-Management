//
//  FbGraph.m
//  NowFloatsv1
//
//  Created by pravasis on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//





#import "FbGraph.h"
#import "FbGraphFile.h"

@implementation FbGraph

@synthesize facebookClientID;
@synthesize redirectUri;
@synthesize accessToken;
@synthesize webView;

@synthesize callbackObject;
@synthesize callbackSelector;

- (id)initWithFbClientID:fbcid {
	if (self = [super init]) {
		self.facebookClientID = fbcid;
		self.redirectUri = @"http://www.facebook.com/connect/login_success.html";
		activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		
	}
	return self;
}

- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions andSuperView:(UIView *)super_view {
	
	self.callbackObject = anObject;
	self.callbackSelector = selector;
	
	NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch", facebookClientID, redirectUri, extended_permissions];
	NSURL *url = [NSURL URLWithString:url_string];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	CGRect webFrame = [super_view frame];
	closeButton=[UIButton  buttonWithType:UIButtonTypeCustom];
	[closeButton setFrame:CGRectMake(265, 0, 25, 25)];
	[closeButton setBackgroundColor:[UIColor clearColor]];
	[closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	
	webFrame.origin.y = 0;
	UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 10, 290, 345)];
	[aWebView setDelegate:self];	
	self.webView = aWebView;
	[webView addSubview:closeButton];
	
	[webView loadRequest:request];	
	[webView setDelegate:self];
	[super_view addSubview:webView];
	
}
-(void)closeView{
    
	[webView removeFromSuperview];
}
-(void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions {
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	
	[self authenticateUserWithCallbackObject:anObject andSelector:selector andExtendedPermissions:extended_permissions andSuperView:window];
}

- (FbGraphResponse *)doGraphGet:(NSString *)action withGetVars:(NSDictionary *)get_vars {
    
	NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/%@?", action];
    
	//tack on any get vars we have...
	if ( (get_vars != nil) && ([get_vars count] > 0) ) {
		
		NSEnumerator *enumerator = [get_vars keyEnumerator];
		NSString *key;
		NSString *value;
		while ((key = (NSString *)[enumerator nextObject])) {
			
			value = (NSString *)[get_vars objectForKey:key];
			url_string = [NSString stringWithFormat:@"%@%@=%@&", url_string, key, value];
			
		}//end while	
	}//end if
	
	if (accessToken != nil) {
		//now that any variables have been appended, let's attach the access token....
		url_string = [NSString stringWithFormat:@"%@access_token=%@", url_string, self.accessToken];
	}
	
	//encode the string
	url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	return [self doGraphGetWithUrlString:url_string];
}

- (FbGraphResponse *)doGraphGetWithUrlString:(NSString *)url_string {
	
	FbGraphResponse *return_value = [[FbGraphResponse alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
	
	NSError *err;
	NSURLResponse *resp;
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
	
	if (resp != nil) {
		
		/**
		 * In the case we request a picture (avatar) the Graph API will return to us the actual image
		 * bits versus a url to the image.....
		 **/
		if ([resp.MIMEType isEqualToString:@"image/jpeg"]) {
			
			UIImage *image = [UIImage imageWithData:response];
			return_value.imageResponse = image;
			
		} else if ([resp.MIMEType isEqualToString:@"text/javascript"]) {
			
			return_value.htmlResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		} else {
			
			return_value.htmlResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		}
		
	} else if (err != nil) {
		return_value.error = err;
	}
	
	return return_value;
	
}

- (FbGraphResponse *)doGraphPost:(NSString *)action withPostVars:(NSDictionary *)post_vars {
	
	
	FbGraphResponse *return_value = [[FbGraphResponse alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@", action];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSString *boundary = @"----1010101010";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSEnumerator *enumerator = [post_vars keyEnumerator];
	NSString *key;
	NSString *value;
	NSString *content_disposition;
	
	//loop through all our parameters 
	while ((key = (NSString *)[enumerator nextObject])) {
		
		//if it's a picture (file)...we have to append the binary data
		if ([key isEqualToString:@"file"]) {
			
			/*
			 * the FbGraphFile object is smart enough to append it's data to 
			 * the request automagically, regardless of the type of file being
			 * attached
			 */
			FbGraphFile *upload_file = (FbGraphFile *)[post_vars objectForKey:key];
			[upload_file appendDataToBody:body];
			
            //key/value nsstring/nsstring
		} else {
			value = (NSString *)[post_vars objectForKey:key];
			
			content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
			
		}//end else
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}//end while
	
	//add our access token
	[body appendData:[@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[accessToken dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//button up the request body
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	[request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField: @"Content-Length"];
	
	//quite a few lines of code to simply do the business of the HTTP connection....
    NSURLResponse *response;
    NSData *data_reply;
	NSError *err;
    
    data_reply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    return_value.htmlResponse = (NSString *)[[NSString alloc] initWithData:data_reply encoding:NSUTF8StringEncoding];
	
	
	
	return return_value;
}

#pragma mark -
#pragma mark UIWebViewDelegate Function
- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	[activityIndicator stopAnimating];
	[activityIndicator setHidesWhenStopped:YES];
	
	/**
	 * Since there's some server side redirecting involved, this method/function will be called several times
	 * we're only interested when we see a url like:  http://www.facebook.com/connect/login_success.html#access_token=..........
	 */
	
	//get the url string
	NSString *url_string = [((_webView.request).URL) absoluteString];
    
	//looking for "access_token="
	NSRange access_token_range = [url_string rangeOfString:@"access_token="];
	
	//it exists?  coolio, we have a token, now let's parse it out....
	if (access_token_range.length > 0) {
        
		//we want everything after the 'access_token=' thus the position where it starts + it's length
		int from_index = access_token_range.location + access_token_range.length;
		NSString *access_token = [url_string substringFromIndex:from_index];
		
		//finally we have to url decode the access token
		access_token = [access_token stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		//remove everything '&' (inclusive) onward...
		NSRange period_range = [access_token rangeOfString:@"&"];
		
		//move beyond the .
		access_token = [access_token substringToIndex:period_range.location];
		
		//store our request token....
		
		self.accessToken = access_token;
		
		//remove our window
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		if (!window) {
			window = [[UIApplication sharedApplication].windows objectAtIndex:0];
		}
		[webView removeFromSuperview];
		[webView release];
		self.webView = nil;
		
		//tell our callback function that we're done logging in :)
		if ( (callbackObject != nil) && (callbackSelector != nil) ) {
			[callbackObject performSelector:callbackSelector];
		}
	}//end if length > 0
}

#pragma mark -webView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)_webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityIndicator setFrame:CGRectMake(140, 170, 40, 40)];
	[webView addSubview:activityIndicator];
	[activityIndicator startAnimating];
}


-(void) dealloc {
	
	if (facebookClientID != nil) {
		[facebookClientID release];
	}
    
	if (redirectUri != nil) {
		[redirectUri release];
	}
	
	if (accessToken != nil) {
		[accessToken release];
	}
	
	if (webView != nil) {
		[webView release];
	}
    [super dealloc];
}

@end
