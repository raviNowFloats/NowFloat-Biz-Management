//
//  FbGraphResponse.m
//  NowFloatsv1
//
//  Created by pravasis on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "FbGraphResponse.h"


@implementation FbGraphResponse

@synthesize htmlResponse;
@synthesize imageResponse;
@synthesize error;

-(void) dealloc {
	
	/*if (htmlResponse != nil) {
     [htmlResponse release];
     }
     
     if (imageResponse != nil) {
     [imageResponse release];
     }
     
     if (error != nil) {
     [error release];
     }
     */
    [super dealloc];
}

@end
