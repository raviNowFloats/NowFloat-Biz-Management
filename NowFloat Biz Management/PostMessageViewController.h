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

@interface PostMessageViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate,SA_OAuthTwitterControllerDelegate,SA_OAuthTwitterControllerDelegate>
{

    NSUserDefaults *userDefaults;
    
    AppDelegate *appDelegate;
    
    SA_OAuthTwitterEngine *_engine;
    
    __weak IBOutlet UILabel *characterCount;

    __weak IBOutlet UIView *downloadSubview;
    
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
    
    
    
    
}

@property (weak, nonatomic) IBOutlet UITextView *postMessageTextView;

-(IBAction)dismissKeyboardOnTap:(id)sender;

-(void)updateView;

- (IBAction)facebookButtonClicked:(id)sender;

- (IBAction)selectedFaceBookClicked:(id)sender;

- (IBAction)facebookPageButtonClicked:(id)sender;

- (IBAction)selectedFbPageButtonClicked:(id)sender;

- (IBAction)fbPageSubViewCloseButtonClicked:(id)sender;

- (IBAction)twitterButtonClicked:(id)sender;

- (IBAction)selectedTwitterButtonClicked:(id)sender;

- (IBAction)sendToSubscibersOnClicked:(id)sender;



- (IBAction)sendToSubscribersOffClicked:(id)sender;






@end
