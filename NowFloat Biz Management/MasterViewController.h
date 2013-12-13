//
//  MasterViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "FGalleryViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface MasterViewController : UIViewController<UIAlertViewDelegate,FGalleryViewControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{

    __weak IBOutlet UIScrollView *manageControllerScrollView;

    __weak IBOutlet UIView *manageBizSubView;

    __weak IBOutlet UIView *imageGallerySubView;

    __weak IBOutlet UIView *tertiarySubView;
    
    BOOL isManageBizSubViewSet;
    
    BOOL isImageGallerySubViewSet;
    
    BOOL isBizStoreSubViewSet;
    
    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;
    
    FGalleryViewController *networkGallery;
    
    NSMutableArray *networkImages;
    
    AppDelegate *appDelegate;
    
    NSArray *filePathsArray;
    
    NSMutableArray *fullPathImageArray;
    
    
    IBOutlet UIView *homeSubview;
    
    IBOutlet UIView *inboxSubView;
    
    IBOutlet UIView *analyticsSubView;
    
    IBOutlet UIView *settingsSubView;
    
    IBOutlet UIView *feedbackSubView;
    
    IBOutlet UIView *logoutSubView;
    
    IBOutlet UIImageView *manageArrow;
    
    IBOutlet UIImageView *galleryArrow;
    
    IBOutlet UIImageView *notificationImageView;
    
    IBOutlet UILabel *notificationLabel;
 
    IBOutlet UIImageView *inboxWidgetStateImageView;
    
    IBOutlet UIImageView *imageGalleryWidgetStateImageView;
    
    IBOutlet UIImageView *socialOptionsWidgetStateImageView;
    
    IBOutlet UIImageView *analyticsWidgetStateImageView;
    
    IBOutlet UIView *storeBusinessHoursSubView;
    
    IBOutlet UIImageView *storeBusinessHoursStateImageView;
    
    IBOutlet UIView *bizStoreSubView;
    
}

- (IBAction)homeBtnClicked:(id)sender;


- (IBAction)manageMyBizBtnClicked:(id)sender;

- (IBAction)imageGalleryBtnClicked:(id)sender;

- (IBAction)contactInformationBtnClicked:(id)sender;

- (IBAction)bizHoursBtnClicked:(id)sender;


- (IBAction)bizDetailsBtnClicked:(id)sender;

- (IBAction)bizAddressBtnClicked:(id)sender;

- (IBAction)primaryImageBtnClicked:(id)sender;

- (IBAction)secondaryImageBtnClicked:(id)sender;

- (IBAction)inboxBtnClicked:(id)sender;

- (IBAction)analyticsBtnClicked:(id)sender;

- (IBAction)logOutBtnClicked:(id)sender;

- (IBAction)settingsBtnClicked:(id)sender;

- (IBAction)feedBackBtnClicked:(id)sender;

- (IBAction)bizStoreBtnClicked:(id)sender;

- (IBAction)bizLogoBtnClicked:(id)sender;

@end
