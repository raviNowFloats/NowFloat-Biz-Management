//
//  StoreGalleryViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FGalleryViewController.h"


@interface StoreGalleryViewController : UIViewController<FGalleryViewControllerDelegate,UIAlertViewDelegate>
{
    UIImageView *imageView;
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *bgImageView;
    
    IBOutlet UIView *activityIndicatorSubview;
    
    NSMutableData *receivedData;
    
    int totalImageDataChunks;
    
    int successCode;

    NSUserDefaults *userDetails;

}

@property (strong, nonatomic) IBOutlet UIImageView *secondaryImageView;

@property (strong , nonatomic) UIImage *secondaryImage;

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSURLConnection *theConnection;


@end
