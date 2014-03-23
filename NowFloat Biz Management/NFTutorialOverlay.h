//
//  NFTutorialOverlay.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 19/03/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NFPostUpdate,
    NFHome
} OverlayType;

@interface NFTutorialOverlay : UIView
{
    
    
    IBOutlet UIImageView *overlayImageHolder;
    
    IBOutlet UIButton *removeOverlayBtn;
}


-(id)initWithOverlay;

-(id)initWithOverlayType:(OverlayType)overlayType;

-(void)showOverlay:(OverlayType)overLayType;

- (IBAction)removeOverlay:(id)sender;

@end
