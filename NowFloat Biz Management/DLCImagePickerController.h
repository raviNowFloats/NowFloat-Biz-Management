//
//  DLCImagePickerController.h
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/14/12.
//  Copyright (c) 2012 Dmitri Cherniak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "BlurOverlayView.h"

@class DLCImagePickerController;

@protocol DLCImageSuccessDelegate <NSObject>

-(void)imageDidFinishedUpload;

@end


@protocol DLCImagePickerDelegate <NSObject>
@optional
- (void)imagePickerController1:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel1:(DLCImagePickerController *)picker;
@end

@interface DLCImagePickerController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,DLCImagePickerDelegate> {
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageOutput<GPUImageInput> *blurFilter;
    GPUImageCropFilter *cropFilter;
    GPUImagePicture *staticPicture;
    UIImageOrientation staticPictureOriginalOrientation;
    
    
    IBOutlet UIButton *rotateLeftButton;
    
    IBOutlet UIButton *rotateRightButton;
    
    IBOutlet UIButton *rotateUpButton;
    
    IBOutlet UIButton *rotateNormalButton;
    
    NSString *imageOrientationString;
    
    IBOutlet UIButton *doneButton;
    
    
}

@property (nonatomic, weak) IBOutlet GPUImageView *imageView;
@property (nonatomic, weak) id <DLCImagePickerDelegate> delegate;
@property (nonatomic,weak)  id<DLCImageSuccessDelegate>successDelegate;

@property (nonatomic, weak) IBOutlet UIButton *photoCaptureButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, weak) IBOutlet UIButton *cameraToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *blurToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *filtersToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *libraryToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *flashToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *retakeButton;

@property (nonatomic, weak) IBOutlet UIScrollView *filterScrollView;
@property (nonatomic, weak) IBOutlet UIImageView *filtersBackgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *photoBar;
@property (nonatomic, weak) IBOutlet UIView *topBar;
@property (nonatomic, strong) BlurOverlayView *blurOverlayView;
@property (nonatomic, strong) UIImageView *focusView;

@property (nonatomic, assign) CGFloat outputJPEGQuality;

@property (strong, nonatomic) IBOutlet UIButton *cropButton;

@property (nonatomic,strong) UIImage *finalImage;

-(IBAction)cropPhoto:(UIButton *)sender;
- (IBAction)rotateRight:(id)sender;
- (IBAction)rotateNormal:(id)sender;
- (IBAction)rotateUpwards:(id)sender;
- (IBAction)doneBtnClicked:(id)sender;

@end
