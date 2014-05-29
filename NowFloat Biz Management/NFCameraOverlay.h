//
//  NFCameraOverlay.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/03/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NFCameraOverlayDelegate <NSObject>

-(void)NFOverlayDidFinishPickingMediaWithInfo:(NSDictionary *)info;

-(void)NFOverlayDidCancelPickingMedia;

-(void)NFOverlayDidFinishCroppingWithImage:(UIImage *)croppedImage;

@end

@interface NFCameraOverlay : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    IBOutlet UIView *bottomBarSubView;
        
    IBOutlet UIImageView *capturedImageView;
    
    IBOutlet UITabBar *tabBar;
    
    IBOutlet UIView *captureImageToolBar;
    id<NFCameraOverlayDelegate> delegate;

}
- (IBAction)captureImage:(id)sender;

- (IBAction)cameraClosed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *captureImage;

@property (strong, nonatomic) IBOutlet UIButton *takePictureBtn;

@property (nonatomic,strong) id<NFCameraOverlayDelegate> delegate;

@property (nonatomic,strong)  IBOutlet UIView *bottomBarSubView;

@property (nonatomic,strong) id pickerReference;

- (IBAction)takePictureBtnClicked:(id)sender;

- (IBAction)cameraCloseBtnClicked:(id)sender;

@end
