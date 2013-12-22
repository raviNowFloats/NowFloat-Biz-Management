//
//  BizMessageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostMessageViewController.h"
#import "PostImageViewController.h"
#import "AppDelegate.h"



@interface BizMessageViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate>
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
    
    PostImageViewController    *postImageViewController;
    
    IBOutlet UIView *downloadingSubview;
    
    __weak IBOutlet UILabel *storeTagLabel;
    
    __weak IBOutlet UILabel *storeTitleLabel;
    
    UIImagePickerController *picker;
    
    IBOutlet UILabel *timeLineLabel;
    
    IBOutlet UIImageView *parallelaxImageView;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    UINavigationBar *navBar;
    
    UIImageView *notificationBadgeImageView;
    
    UILabel *notificationLabel;

    IBOutlet UIView *notificationView;
    
    IBOutlet UIImageView *primaryImageView;
    
    IBOutlet UIButton *storeTagButton;
    
    IBOutlet UIView *tutorialOverlayView;
    
    IBOutlet UIView *tutorialOverlayiPhone4View;
    
    IBOutlet UIView *shareWebSiteOverlayiPhone4;
    
    IBOutlet UIView *shareWebSiteOverlay;
    
    IBOutlet UIView *updateMsgOverlay;
    
    NSString *version ;
    
    UIView *navBackgroundview;
        
}

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

- (IBAction)revealFrontController:(id)sender;

- (IBAction)storeTagBtnClicked:(id)sender;

- (IBAction)dismissTutorialOverLayBtnClicked:(id)sender;

- (IBAction)dismissUpdateMsgOverLayBtnClicked:(id)sender;

- (IBAction)primaryImageBtnClicked:(id)sender;


- (void)updateView;

@end
