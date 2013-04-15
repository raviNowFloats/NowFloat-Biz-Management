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
    
    IBOutlet UIView *activitySubview;
    
    NSMutableData *receivedData;
    
    int totalImageDataChunks;
    
    int successCode;
    
}

@property (nonatomic,weak) IBOutlet UIImageView *imgView;

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSMutableArray *uniqueIdArray;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSURLConnection *theConnection;

-(void)removeActivityIndicatorSubView;

@end
