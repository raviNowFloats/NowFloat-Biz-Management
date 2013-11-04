//
//  MyAnnotation.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
    return nil;
}

- (NSString *)title
{
    return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
    coordinate=coord;
    return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}



@end