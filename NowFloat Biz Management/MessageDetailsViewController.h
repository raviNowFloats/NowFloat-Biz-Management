//
//  MessageDetailsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

typedef void(^SelectItemCallback)(id sender, id selectedItem);


@class FBSession;


@interface MessageDetailsViewController : UIViewController<UITextViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UIView *postToSocialSiteSubview;
    
    AppDelegate *appDelegate;
    
    __weak IBOutlet UITextView *fbTextMessage;
    
    __weak IBOutlet UIView *activityIndicatorSubView;
    
    __weak IBOutlet UIButton *postToFBTimelineButton;
    
    NSMutableData *recievedData;
    
    
}

@property (strong, nonatomic) SelectItemCallback selectItemCallback;

@property(nonatomic,strong) NSString *messageDescription;
@property(nonatomic,strong) NSString *messageDate;
@property(nonatomic,strong) NSString *messageId;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

- (IBAction)returnKeyBoard:(id)sender;

- (IBAction)postToFacebook:(id)sender;

- (IBAction)postToFBTimeLine:(id)sender;

- (IBAction)postToTwitter:(id)sender;

- (IBAction)smsButtonClicked:(id)sender;

- (IBAction)mailButtonClicked:(id)sender;


@end
