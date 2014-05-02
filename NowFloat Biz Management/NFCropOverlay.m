//
//  NFCropOverlay.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 28/04/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "NFCropOverlay.h"
#import "UIImage+fixOrientation.h"
#import "PECropViewController.h"


@interface NFCropOverlay ()<PECropViewControllerDelegate>
{
    float viewHeight;
}

@end

@implementation NFCropOverlay
@synthesize imageInfo=_imageInfo;
@synthesize delegate;

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
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

    
    if (viewHeight == 480)
    {
        [capturedImageView setFrame:CGRectMake(capturedImageView.frame.origin.x, capturedImageView.frame.origin.y, capturedImageView.frame.size.width, 328)];
        
        [bottomBarView setFrame:CGRectMake(bottomBarView.frame.origin.x,416, capturedImageView.frame.size.width, capturedImageView.frame.size.height)];
    }
    
    
    [bottomBarView setBackgroundColor:[UIColor colorFromHexCode:@"1B1B1B"]];

    NSData* imageData = UIImageJPEGRepresentation([_imageInfo objectForKey:UIImagePickerControllerOriginalImage], 0.7);
    
    capturedImageView.image = [[UIImage imageWithData:imageData] fixOrientation];
    
}

- (IBAction)cropBtnClicked:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = capturedImageView.image;
    
    UIImage *image = capturedImageView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:NO completion:NULL];
    
}

- (IBAction)doneBtnClicked:(id)sender
{
    [delegate performSelector:@selector(NFCropOverlayDidFinishCroppingWithImage:) withObject:capturedImageView.image];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)rotateBtnClicked:(id)sender
{
    
    
}

- (IBAction)backBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:NO completion:NULL];
    capturedImageView.image = croppedImage;
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:NO completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
