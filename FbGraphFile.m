//
//  FbGraphFile.m
//  NowFloatsv1
//
//  Created by pravasis on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "FbGraphFile.h"


@implementation FbGraphFile

@synthesize uploadImage;

- (id)initWithImage:(UIImage *)upload_image {
	
	if (self = [super init]) {
		self.uploadImage = upload_image;
	}
	return self;
}

/**
 * this way the class is easily extensible to other file
 * types as FB allows us to upload them into the graph...
 * with little if any modification to the code 
 **/
- (void)appendDataToBody:(NSMutableData *)body {
	
	/**
	 * Facebook Graph API only support images at the moment, surely videos must occur soon.
	 **/
	
	NSData *picture_data = UIImagePNGRepresentation(uploadImage);
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\";\r\nfilename=\"media.png\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:picture_data];
	
}

-(void) dealloc {
	
	if (uploadImage != nil) {
		[uploadImage release];
	}
	
    [super dealloc];
}

@end
