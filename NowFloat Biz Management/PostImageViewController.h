//
//  PostImageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;

@protocol PostImageViewControllerDelegate <NSObject>

-(void)imageUploadDidFinishSuccessFully;

@end


@interface PostImageViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,SA_OAuthTwitterControllerDelegate,SA_OAuthTwitterControllerDelegate>
{
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDetails;
    
    SA_OAuthTwitterEngine *_engine;
    
    __weak IBOutlet UITextView *imageDescriptionTextView;
    
    UIImagePickerController *picker;

    __weak IBOutlet UILabel *saySomthingLabel;
            
    NSMutableData *receivedData;
    
    int successCode;
    
    int totalImageDataChunks;
    
    IBOutlet UITableView *fbPageTableView;

    IBOutlet UIView *activitySubView;
    
    IBOutlet UIView *toolBarView;

    IBOutlet UIButton *facebookButton;
    
    IBOutlet UIButton *selectedFacebookButton;
    
    IBOutlet UIButton *facebookPageButton;
    
    IBOutlet UIButton *selectedFacebookPageButton;
   
    BOOL  isFacebookSelected;
    
    BOOL  isFacebookPageSelected;
    
    BOOL  isFacebookAdmin;
    
    BOOL  isTwitterSelected;
    
    IBOutlet UIButton *twitterButton;
    
    IBOutlet UIButton *selectedTwitterButton;
    
    IBOutlet UIView *fbPageSubView;
    
    IBOutlet UIView *connectingToFbSubView;
    
    UINavigationBar *navBar;
    
    IBOutlet UIButton *sendToSubscribersOffButton;
    
    IBOutlet UIButton *sendToSubscribersOnButton;
    
    BOOL isSendToSubscibers;
    
    BOOL isFirstMessage;
    
    IBOutlet UIView *visitBizStoreSubView;
    
    IBOutlet UIView *visitStoreSubview;
    
    NSString *version;

    UIButton *customRightBarButton;
}

@property(nonatomic,strong) id<PostImageViewControllerDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIImageView *postImageView;

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSURLConnection *theConnection;

@property (strong, nonatomic) FBSession *fbSession;

@property (strong,nonatomic) UIImage *testImage;

@property (strong,nonatomic) NSString *imageOrinetationString;

-(void)uploadPicture;

- (IBAction)facebookBtnClicked:(id)sender;

- (IBAction)selectedFacebookBtnClicked:(id)sender;

- (IBAction)facebookPageBtn:(id)sender;

- (IBAction)selectedFacebookPageBtnClicked:(id)sender;

- (IBAction)twitterBtnClicked:(id)sender;

- (IBAction)selectedTwitterButtonCicked:(id)sender;

- (IBAction)sendToSubscribersOnClicked:(id)sender;

- (IBAction)sendToSubscribersOffBtnClicked:(id)sender;

- (IBAction)cancelFaceBookPages:(id)sender;


- (IBAction)goToBizStoreBtnClicked:(id)sender;

- (IBAction)cancelVisitStoreSubView:(id)sender;



@end
