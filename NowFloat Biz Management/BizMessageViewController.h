//
//  BizMessageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostMessageViewController.h"
#import "AppDelegate.h"
#import "SA_OAuthTwitterController.h"
@class SA_OAuthTwitterEngine;



@interface BizMessageViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate,SA_OAuthTwitterControllerDelegate,SA_OAuthTwitterControllerDelegate>
{
    NSUserDefaults *userDetails; 
    
    PostMessageViewController *postMessageController;
    NSMutableArray *dealsArray;
    AppDelegate *appDelegate;
    NSMutableData *data;
    

    NSMutableArray *dealId;
    NSMutableDictionary *fpMessageDictionary;
    int messageSkipCount;
    
    UIButton *loadMoreButton;
    bool ismoreFloatsAvailable;
    NSMutableArray *arrayToSkipMessage;
    
    __weak IBOutlet UILabel *storeTagLabel;
    
    __weak IBOutlet UILabel *storeTitleLabel;
    
    IBOutlet UIImageView *parallelaxImageView;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    UINavigationBar *navBar;
    
    UIImageView *notificationBadgeImageView;
    
    UILabel *notificationLabel;

    IBOutlet UIView *notificationView;
    
    IBOutlet UIImageView *primaryImageView;
    
    IBOutlet UIView *tutorialOverlayView;
    
    IBOutlet UIView *tutorialOverlayiPhone4View;
    
    IBOutlet UIView *shareWebSiteOverlayiPhone4;
    
    IBOutlet UIView *shareWebSiteOverlay;
    
    IBOutlet UIView *updateMsgOverlay;
    
    NSString *version ;
    
    UIView *navBackgroundview;
    
    IBOutlet UIView *noUpdateSubView;
    
    IBOutlet UIView *createContentSubView;
    
    IBOutlet UILabel *createContentSubViewLbl;
    
    IBOutlet UIView *postMessageSubView;
    
    IBOutlet UITextView *createContentTextView;
    
    IBOutlet UILabel *createMessageLbl;
    
    IBOutlet UITextView *dummyTextView;
    
    IBOutlet UILabel *postMsgViewBgView;
    
    IBOutlet UIView *postMessageContentCreateSubview;
    
    IBOutlet UIView *postMessageSubviewHeaderView;
    
    IBOutlet UIButton *postUpdateBtn;
    
    IBOutlet UILabel *characterCount;
    
    IBOutlet UIImageView *uploadPictureImgView;
    
    IBOutlet UIButton *addImageBtn;
    
    IBOutlet UILabel *addPhotoLbl;

    int totalImageDataChunks;

    NSMutableData *receivedData;
    
    int successCode;
    
    IBOutlet UIButton *facebookButton;
    
    IBOutlet UIButton *selectedFacebookButton;
    
    IBOutlet UIButton *facebookPageButton;
    
    IBOutlet UIButton *selectedFacebookPageButton;
    
    IBOutlet UIButton *twitterButton;
    
    IBOutlet UIButton *selectedTwitterButton;
    
    IBOutlet UIButton *sendToSubscribersOnButton;
    
    IBOutlet UIButton *sendToSubscribersOffButton;

    IBOutlet UIView *fbPageSubView;
    
    IBOutlet UITableView *fbPageTableView;
    
    IBOutlet UIView *fbPageTableViewSubView;
    
    IBOutlet UIView *noAdsSubView; 
    
    IBOutlet UIButton *noAdsBtn;
        
    IBOutlet UIButton *primaryImageBtn;
    
    IBOutlet UIButton *editDescription;
    
    IBOutlet UIView *noAdsChildSubView;
    
    IBOutlet UIButton *storeTagButton;
    
    IBOutlet UIImageView *primaryBackImage;
    
     NSUserDefaults *userDefaults;
}



- (IBAction)updateDescription:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *coverPanel2;

@property (strong, nonatomic) IBOutlet UIView *coverPanel1;

@property (nonatomic,strong) UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIView *parallax;

@property(nonatomic,strong) NSMutableDictionary *storeDetailDictionary;

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (nonatomic,strong) NSMutableArray *dealDescriptionArray;

@property (nonatomic,strong) NSMutableArray *dealDateArray;

@property (nonatomic,strong) NSMutableString *dealIdString;

@property (nonatomic,strong) NSMutableString *dealDateString;

@property (nonatomic,strong) NSMutableString *dealDescriptionString;

@property (nonatomic,strong) NSMutableArray *dealImageArray;

@property (nonatomic) BOOL isLoadedFirstTime;

@property (strong, nonatomic) IBOutlet UIView *detailViewController;

@property (nonatomic,strong) NSMutableArray *chunkArray;

@property (nonatomic,strong) NSMutableURLRequest *request;

@property (nonatomic,strong) NSData *dataObj;

@property (nonatomic,strong) NSString *uniqueIdString;

@property (nonatomic,strong) NSURLConnection *theConnection;



- (IBAction)revealFrontController:(id)sender;

- (IBAction)storeTagBtnClicked:(id)sender;

- (IBAction)dismissTutorialOverLayBtnClicked:(id)sender;

- (IBAction)dismissUpdateMsgOverLayBtnClicked:(id)sender;

- (IBAction)primaryImageBtnClicked:(id)sender;

- (void)updateView;

-(void)showLatestVisitor;

-(void)openContentCreateSubview;

-(void)inAppNotificationDeepLink:(NSURL *) url;

-(void)showReferScreen;


- (IBAction)cameraButtonClicked:(id)sender;

- (IBAction)noUpdateBtnClicked:(id)sender;

- (IBAction)createContentBtnClicked:(id)sender;

- (IBAction)createContentCloseBtnClicked:(id)sender;

-(void)talkToSupport;
-(UIImage*)rotate:(UIImageOrientation)orient;





#pragma PostMessageMethods

- (IBAction)dismissKeyboardBtnClicked:(id)sender;

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

- (IBAction)cancelFaceBookPages:(id)sender;

- (IBAction)noAdsBtnClicked:(id)sender;



@end
