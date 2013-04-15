//
//  PostImageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PostImageViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDetails;

    __weak IBOutlet UILabel *bgLabel;

    __weak IBOutlet UIImageView *postImageView;
    
    __weak IBOutlet UITextView *imageDescriptionTextView;
    
    UIImagePickerController *picker;

    __weak IBOutlet UILabel *saySomthingLabel;
        
    UITapGestureRecognizer *tap;
    
    NSMutableData *receivedData;
    
    int successCode;
    
    int totalImageDataChunks;

    IBOutlet UIView *activitySubView;
}

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSURLConnection *theConnection;

-(void)uploadPicture;

- (IBAction)pickButtonClicked:(id)sender;



@end
