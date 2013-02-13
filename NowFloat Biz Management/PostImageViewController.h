//
//  PostImageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostImageViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    __weak IBOutlet UILabel *bgLabel;

    __weak IBOutlet UIImageView *postImageView;
    
    __weak IBOutlet UITextView *imageDescriptionTextView;
    
    UIImagePickerController *picker;

    __weak IBOutlet UILabel *saySomthingLabel;
}

- (IBAction)cameraButtonClicked:(id)sender;

- (IBAction)galleryButtonClicked:(id)sender;

- (IBAction)downArrowButtonClicked:(id)sender;


@end
