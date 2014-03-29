//
//  NFCameraOverlay.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/03/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "NFCameraOverlay.h"

@interface NFCameraOverlay ()
{
    float viewHeight;
    NSString *version;
}
@end

@implementation NFCameraOverlay
@synthesize pickerReference = _pickerReference;
@synthesize delegate;
@synthesize takePictureBtn;
@synthesize bottomBarSubView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    version = [[UIDevice currentDevice] systemVersion];
        
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
        }
    }
    
    if (viewHeight == 480) {
        
        [bottomBarSubView setFrame:CGRectMake(bottomBarSubView.frame.origin.x, 400, bottomBarSubView.frame.size.width, bottomBarSubView.frame.size.height)];
    }
    
 

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [delegate performSelector:@selector(NFOverlayDidFinishPickingMediaWithInfo:) withObject:info];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
}


- (IBAction)takePictureBtnClicked:(id)sender
{
    [_pickerReference takePicture];
}


- (IBAction)cameraCloseBtnClicked:(id)sender
{
    [delegate performSelector:@selector(NFOverlayDidCancelPickingMedia)];    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
@end
