//
//  PostUpdateViewController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/18/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateStoreDeal.h"
#import "CreatePictureDeal.h"
#import "NFCameraOverlay.h"
#import "NFCropOverlay.h"
#import "PopUpView.h"
#import "SA_OAuthTwitterController.h"
#import "DeleteFloatController.h"
@interface PostUpdateViewController : UIViewController<UIActionSheetDelegate,updateDelegate,pictureDealDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NFCameraOverlayDelegate,NFCropOverlayDelegate,UITextViewDelegate,PopUpDelegate,updateBizMessage>
{
    AppDelegate *appDelegate;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *selectedFacebookButton;
    IBOutlet UIButton *facebookPageButton;
    IBOutlet UIButton *selectedFacebookPageButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *selectedTwitterButton;
    IBOutlet UIButton *sendToSubscribersOnButton;
    IBOutlet UIButton *sendToSubscribersOffButton;
    NSUserDefaults *userDetails;
    IBOutlet UITextView *dummyTextView;
    IBOutlet UILabel *postMsgViewBgView;
    IBOutlet UILabel *addPhotoLbl;
    int totalImageDataChunks;
    NSMutableData *receivedData;
    int successCode;

}
@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) NSMutableArray *chunkArray;
@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSURLConnection *theConnection;

@property (nonatomic,strong) NSString *uploadText;


- (IBAction)createContentCloseBtnClicked:(id)sender;

- (IBAction)postUpdateBtnClicked:(id)sender;

- (IBAction)addImageBtnClicked:(id)sender;

#pragma SocialOptionsMethods

- (IBAction)facebookBtnClicked:(id)sender;

- (IBAction)selectedFaceBookClicked:(id)sender;

- (IBAction)facebookPageBtnClicked:(id)sender;

- (IBAction)selectedFbPageBtnClicked:(id)sender;

- (IBAction)fbPageSubViewCloseBtnClicked:(id)sender;

- (IBAction)twitterBtnClicked:(id)sender;

- (IBAction)selectedTwitterBtnClicked:(id)sender;

- (IBAction)sendToSubscibersOnClicked:(id)sender;

- (IBAction)sendToSubscribersOffClicked:(id)sender;



@property (strong, nonatomic) IBOutlet UIButton *addImageBtn;

@property (strong, nonatomic) IBOutlet UIImageView *uploadPictureImgView;
@property (strong, nonatomic) IBOutlet UITextView *createContentTextView;
@property (strong, nonatomic) IBOutlet UILabel *createMessageLbl;
@property (strong, nonatomic) IBOutlet UIButton *postUpdateBtn;


@property (strong, nonatomic) IBOutlet UIView *postUpdateView;

@end
