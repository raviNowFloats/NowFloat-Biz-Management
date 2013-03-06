//
//  PrimaryImageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PrimaryImageViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    UIImagePickerController *picker;

    __weak IBOutlet UIImageView *imgView;
    
    AppDelegate *appDelegate;
    
    __weak IBOutlet UILabel *imageBg;

    __weak IBOutlet UIProgressView *uploadProgressView;
    
    UIImage *uploadImage;
    
    __weak IBOutlet UIButton *replaceImageButton;
    

    
    
}



- (IBAction)selectButtonClicked:(id)sender;

@end
