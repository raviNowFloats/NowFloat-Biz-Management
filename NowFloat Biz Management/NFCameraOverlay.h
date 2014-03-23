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

@end

@interface NFCameraOverlay : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    IBOutlet UIView *bottomBarSubView;
}

@property (strong, nonatomic) IBOutlet UIButton *takePictureBtn;

@property (nonatomic,strong) id<NFCameraOverlayDelegate> delegate;

@property (nonatomic,strong) id pickerReference;

- (IBAction)takePictureBtnClicked:(id)sender;

@end
