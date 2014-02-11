//
//  BusinessLogoUploadViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 18/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface BusinessLogoUploadViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate>

{

    AppDelegate *appDelegate;
    
    NSUserDefaults *userDetails;

    IBOutlet UILabel *imageBg;

    IBOutlet UIImageView *imgView;
    
    IBOutlet UIButton *changeBtnClicked;
    
    IBOutlet UIButton *saveButton;
    
    NSString *frontViewPosition;

    UINavigationBar *navBar;

    IBOutlet UIButton *revealFrontControllerButton;
    
    UIImagePickerController *picker;

    NSMutableData *receivedData;

    NSString *version ;
    
    IBOutlet UIView *contentSubView;
    
    NSURLConnection *theConnection;
    
    NSMutableURLRequest *request;
    
    NSString* fullPathToFile;
    
    IBOutlet UIButton *changeBtn;
    
}


@property (nonatomic,strong) NSData *dataObj;


- (IBAction)saveBtnClicked:(id)sender;

- (IBAction)revealFrontController:(id)sender;




@end
