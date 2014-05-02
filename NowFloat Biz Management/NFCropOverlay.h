//
//  NFCropOverlay.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 28/04/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NFCropOverlayDelegate <NSObject>

-(void)NFCropOverlayDidFinishCroppingWithImage:(UIImage *)croppedImage;

@end

@interface NFCropOverlay : UIViewController
{
    IBOutlet UIImageView *capturedImageView;
    
    IBOutlet UIView *bottomBarView;
}

@property (nonatomic,strong) NSDictionary *imageInfo;

@property (nonatomic,strong) id<NFCropOverlayDelegate>delegate;

- (IBAction)cropBtnClicked:(id)sender;

- (IBAction)doneBtnClicked:(id)sender;

- (IBAction)rotateBtnClicked:(id)sender;

- (IBAction)backBtnClicked:(id)sender;

@end
