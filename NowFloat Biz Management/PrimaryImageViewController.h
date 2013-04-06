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
    
    NSUserDefaults *userDetails;
    
    __weak IBOutlet UILabel *imageBg;

    __weak IBOutlet UIProgressView *uploadProgressView;
    
    UIImage *uploadImage;
    
    __weak IBOutlet UIButton *replaceImageButton;
    
    __weak IBOutlet UIView *activityIndicatorSubView;

    
}

@property (nonatomic,weak) IBOutlet UIImageView *imgView;

@property (nonatomic,strong) UIImage *pickedImage;

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSMutableArray *uniqueIdArray;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSMutableArray *requestArray;

@property (nonatomic,strong)     NSMutableURLRequest *request;

- (IBAction)selectButtonClicked:(id)sender;


-(void)removeActivityIndicatorSubView;

@end
