//
//  MyAnnotation.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MyAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end