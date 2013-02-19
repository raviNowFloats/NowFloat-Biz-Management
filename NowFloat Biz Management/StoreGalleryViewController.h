//
//  StoreGalleryViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "uploadSecondaryImage.h"


@interface StoreGalleryViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imageView;
    UIImageView *postImage;
    UIButton *button;
    NSMutableArray *imagesArray;
    UIImagePickerController *picker;
    AppDelegate *appDelegate;
    uploadSecondaryImage *uploadSecondary;

}
@property (weak, nonatomic) IBOutlet UIScrollView *storeGalleryScrollView;

- (IBAction)addPicButtonClicked:(id)sender;

@end
