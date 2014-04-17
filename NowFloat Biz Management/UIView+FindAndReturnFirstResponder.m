//
//  UIView+FindAndReturnFirstResponder.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/04/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "UIView+FindAndReturnFirstResponder.h"

@implementation UIView (FindAndReturnFirstResponder)

- (UITextField *)findFirstResponderAndReturn
{
    for (UITextField *subView in self.subviews)
    {
        if (subView.isFirstResponder)
        {            
            NSLog(@"subView.tag:%d",subView.tag);
            return subView;
        }
    }
    return nil;
}
@end