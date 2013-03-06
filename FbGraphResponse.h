//
//  FbGraphResponse.h
//  NowFloatsv1
//
//  Created by pravasis on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface FbGraphResponse : NSObject {
    
	NSString *htmlResponse;
	UIImage *imageResponse;
	NSError *error;
	
}

@property (nonatomic, retain) NSString *htmlResponse;
@property (nonatomic, retain) UIImage *imageResponse;
@property (nonatomic, retain) NSError *error;

@end
