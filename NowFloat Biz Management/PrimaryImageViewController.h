//
//  PrimaryImageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrimaryImageViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    UIImagePickerController *picker;

    __weak IBOutlet UIImageView *imgView;
}

- (IBAction)uploadPicButtonClicked:(id)sender;


@end
