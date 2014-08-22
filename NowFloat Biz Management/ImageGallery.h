//
//  ImageGallery.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 11/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ImageGallery : UIViewController
{
    AppDelegate *appDelegate;
    
    IBOutlet UIView *detailImage;
   
    NSString *version;
    
    int successCode;
    
    NSUserDefaults *userDetails;
    
    NSMutableData *receivedData;
    
    int totalImageDataChunks;
    
    SWRevealViewController *revealController;
    
    UIImagePickerController *picker;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollGallery;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollImage;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (strong, nonatomic) NSMutableArray *imageList;

@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSURLConnection *theConnection;

@end
