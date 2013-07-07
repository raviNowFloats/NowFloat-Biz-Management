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


@protocol MessageDetailsDelegate <NSObject>

-(void)removeObjectFromTableView :(id)row;

@end


@interface MessageDetailsViewController : UIViewController<UITextViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UIView *postToSocialSiteSubview;
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    NSMutableData *recievedData;

    __weak IBOutlet UITextView *fbTextMessage;
    
    __weak IBOutlet UIView *activityIndicatorSubView;
    
    __weak IBOutlet UIButton *postToFBTimelineButton;
    
    IBOutlet UIScrollView *messageDescriptionScrollView;
    
    IBOutlet UILabel *messageTitleLabel;
    
    UITextView *tagTextView;
    
    UIActivityIndicatorView  *av;
    
    id<MessageDetailsDelegate>delegate;
    
}

@property (strong, nonatomic) SelectItemCallback selectItemCallback;
@property (nonatomic,strong)     id<MessageDetailsDelegate>delegate;
@property(nonatomic,strong) NSString *messageDescription;
@property(nonatomic,strong) NSString *messageDate;
@property(nonatomic,strong) NSString *messageId;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (nonatomic,strong)NSString *dealImageUri;
@property (nonatomic) NSNumber  *currentRow;
- (IBAction)returnKeyBoard:(id)sender;

- (IBAction)postToFacebook:(id)sender;

- (IBAction)postToFBTimeLine:(id)sender;

- (IBAction)postToTwitter:(id)sender;

- (IBAction)smsButtonClicked:(id)sender;

- (IBAction)mailButtonClicked:(id)sender;


@end
