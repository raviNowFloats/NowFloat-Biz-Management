//
//  NFTutorialOverlay.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 19/03/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "NFTutorialOverlay.h"

@interface NFTutorialOverlay()
{
    NSString *versionString;
    float viewHeight;
    OverlayType type;
    
}
@end

@implementation NFTutorialOverlay

-(id)initWithOverlay;
{
    NFTutorialOverlay *tutorialOverlay = [[[NSBundle mainBundle] loadNibNamed:@"NFTutorialOverlay"
                owner:self
                options:nil]
                lastObject];
    
    if ([tutorialOverlay isKindOfClass:[tutorialOverlay class]])
    {
        [tutorialOverlay layoutSubviews];
        return tutorialOverlay;
    }
    else
    {
        return nil;
    }
}



-(id)initWithOverlayType:(OverlayType)overlayType
{
    NFTutorialOverlay *tutorialOverlay = [[[NSBundle mainBundle] loadNibNamed:@"NFTutorialOverlay"
                owner:self
                options:nil]
                lastObject];
    
    if ([tutorialOverlay isKindOfClass:[tutorialOverlay class]])
    {
        [tutorialOverlay layoutSubviews];
        return tutorialOverlay;
    }
    else
    {
        return nil;
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    versionString = [[UIDevice currentDevice] systemVersion];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        
        else
        {
            viewHeight=568;
            
            overlayImageHolder.frame=CGRectMake(overlayImageHolder.frame.origin.x,0, overlayImageHolder.frame.size.width, 568);
        }
    }
}

-(void)showOverlay:(OverlayType)overLayType
{
   if (overLayType == NFHome)
    {
        if (viewHeight == 480)
        {
            [overlayImageHolder setImage:[UIImage imageNamed:@"CMHomeScreeniphone4.png"]];
        }
        
        else
        {
            [overlayImageHolder setImage:[UIImage imageNamed:@"CMHomeScreen1.png"]];
        
        }
    }
    
    else if (overLayType == NFPostUpdate)
    {
        if (viewHeight == 480)
        {
            [overlayImageHolder setImage:[UIImage imageNamed:@"CMUpdateMessageiPhone4.png"]];
        }
    
        else
        {
            [overlayImageHolder setImage:[UIImage imageNamed:@"CMUpdateMsg1.png"]];
        
        }
    }
    
    [self reorderView];
}


-(void)reorderView
{
    if (type == NFPostUpdate) {
        [[[[UIApplication sharedApplication] windows] objectAtIndex:1] addSubview:self];
    }
    
    else if (type == NFHome){
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    }
}

- (IBAction)removeOverlay:(id)sender
{
    [self removeFromSuperview];
    
}




@end
