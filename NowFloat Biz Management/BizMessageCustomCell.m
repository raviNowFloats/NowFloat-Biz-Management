//
//  BizMessageCustomCell.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/02/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BizMessageCustomCell.h"

#define cornerRadius 1.0;

@implementation BizMessageCustomCell
@synthesize viewMessage;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //[self setOpaque:NO];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, .5f);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    
    CGRect rrect = rect;
    rrect.origin.y++;
    CGFloat radius = cornerRadius;
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    CGMutablePathRef outlinePath = CGPathCreateMutable();
    
        minx += 5;
        
        CGPathMoveToPoint(outlinePath, nil, midx, miny);
        CGPathAddArcToPoint(outlinePath, nil, maxx, miny, maxx, midy, radius);
        CGPathAddArcToPoint(outlinePath, nil, maxx, maxy, midx, maxy, radius);
        CGPathAddArcToPoint(outlinePath, nil, minx, maxy, minx, midy, radius);
    
    NSLog(@"minx:%f, miny:%f",minx,miny);
        CGPathAddLineToPoint(outlinePath, nil, minx, miny + 20);
        CGPathAddLineToPoint(outlinePath, nil, minx - 5, miny + 15);
        CGPathAddLineToPoint(outlinePath, nil, minx, miny + 10);
    
    
        CGPathAddArcToPoint(outlinePath, nil, minx, miny, midx, miny, radius);
        CGPathCloseSubpath(outlinePath);
        
        CGContextSetShadowWithColor(context, CGSizeMake(0,1), 1, [UIColor lightGrayColor].CGColor);
        CGContextAddPath(context, outlinePath);
        CGContextFillPath(context);
        
        CGContextAddPath(context, outlinePath);
        CGContextClip(context);
        //CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
        //CGPoint end = CGPointMake(rect.origin.x, rect.size.height);
        //CGContextDrawLinearGradient(context, [self normalGradient], start, end, 0);
}

- (CGGradientRef)normalGradient
{
    
    NSMutableArray *normalGradientLocations = [NSMutableArray arrayWithObjects:
                                               [NSNumber numberWithFloat:0.0f],
                                               [NSNumber numberWithFloat:1.0f],
                                               nil];
    
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
    
    UIColor *color = [UIColor whiteColor];
    [colors addObject:(id)[color CGColor]];

    NSMutableArray  *normalGradientColors = colors;
    
    int locCount = [normalGradientLocations count];
    CGFloat locations[locCount];
    for (int i = 0; i < [normalGradientLocations count]; i++)
    {
        NSNumber *location = [normalGradientLocations objectAtIndex:i];
        locations[i] = [location floatValue];
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef normalGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)normalGradientColors, locations);
    CGColorSpaceRelease(space);
    
    return normalGradient;
}

@end
