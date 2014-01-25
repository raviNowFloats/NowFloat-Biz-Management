//
//  PostMessageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 27/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "SA_OAuthTwitterController.h"



@class SA_OAuthTwitterEngine;



@protocol PostMessageViewControllerDelegate <NSObject>

-(void)messageUpdatedSuccessFully;

-(void)messageUpdateFailed;

@end


@interface PostMessageViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate,SA_OAuthTwitterControllerDelegate,SA_OAuthTwitterControllerDelegate>
{

    NSUserDefaults *userDefaults;
    
    AppDelegate *appDelegate;
    
    SA_OAuthTwitterEngine *_engine;
    
    __weak IBOutlet UILabel *characterCount;
    
    __weak IBOutlet UILabel *createMessageLabel;
    
    __weak IBOutlet UIButton *facebookButton;
    
    __weak IBOutlet UIButton *selectedFacebookButton;
    
    IBOutlet UIButton *facebookPageButton;
    
    IBOutlet UIButton *selectedFacebookPageButton;
    
    BOOL isFacebookSelected;
    
    BOOL isFacebookPageSelected;
    
    BOOL isTwitterSelected;
    
    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;
    
    IBOutlet UIView *fbPageSubView;
    
    IBOutlet UITableView *fbPageTableView;
    
    BOOL isForFBPageAdmin;

    IBOutlet UILabel *bgLabel;
    
    IBOutlet UIView *toolBarView;
    
    IBOutlet UIButton *twitterButton;
    
    IBOutlet UIButton *selectedTwitterButton;
    
    IBOutlet UIButton *sendToSubscribersOnButton;
    
    IBOutlet UIButton *sendToSubscribersOffButton;
    
    BOOL isSendToSubscribers;
    
    UINavigationBar *navBar;
    
    IBOutlet UIView *connectingFacebookSubView;
    
    IBOutlet UIView *tutorialOverLayView;
    
    IBOutlet UIView *tutorialOverLayiPhone4View;
    
    BOOL isFirstMessage;
    
    NSString *version;
    
    UIButton *customRightBarButton;
    
    IBOutlet UIImageView *uploadPictureImgView;
    
    IBOutlet UIButton *addImageBtn;
    
    NSMutableData *receivedData;

    int successCode;
    
    int totalImageDataChunks;
    
    BOOL isPictureMessage;
    
    BOOL isTextMessage;
    
    IBOutlet UILabel *addPhotoLbl;
    
}

@property (weak, nonatomic) IBOutlet UITextView *postMessageTextView;

-(IBAction)dismissKeyboardOnTap:(id)sender;

-(void)updateView;

- (IBAction)facebookBtnClicked:(id)sender;

- (IBAction)selectedFaceBookClicked:(id)sender;

- (IBAction)facebookPageBtnClicked:(id)sender;

- (IBAction)selectedFbPageBtnClicked:(id)sender;

- (IBAction)fbPageSubViewCloseBtnClicked:(id)sender;

- (IBAction)twitterBtnClicked:(id)sender;

- (IBAction)selectedTwitterBtnClicked:(id)sender;

- (IBAction)sendToSubscibersOnClicked:(id)sender;

- (IBAction)cancelFaceBookPages:(id)sender;

- (IBAction)sendToSubscribersOffClicked:(id)sender;

- (IBAction)dismissTutotialOverlayBtnClicked:(id)sender;


@property (nonatomic,strong) id<PostMessageViewControllerDelegate>delegate;

@property (nonatomic) BOOL isFromHomeView;

@property (strong,nonatomic) UIImage *testImage;

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSURLConnection *theConnection;


@end
