//
//  FbGraphFile.h
//  NowFloatsv1
//
//  Created by pravasis on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface FbGraphFile : NSObject {
    
	UIImage *uploadImage;
}
@property (nonatomic, retain) UIImage *uploadImage;

- (id)initWithImage:(UIImage *)upload_image;
- (void)appendDataToBody:(NSMutableData *)body;
@end
