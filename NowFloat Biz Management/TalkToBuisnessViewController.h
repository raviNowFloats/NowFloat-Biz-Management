//
//  TalkToBuisnessViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMPullToRefreshManager.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface TalkToBuisnessViewController : UIViewController<MNMPullToRefreshManagerClient,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,SWRevealViewControllerDelegate>
{
    NSUserDefaults *userDetails;
    NSMutableArray *messageArray;
    NSMutableArray *dateArray;
    NSMutableArray *messageHeadingArray;
    AppDelegate *appDelegate;
    
    __weak IBOutlet UIActivityIndicatorView *loadingActivityView;
    NSString *contactPhoneNumber;
    NSString *contactEmail;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    
    NSString *frontViewPosition;

    NSString *version;

    UINavigationBar *navBar;
    
    IBOutlet UIView *noTTbMessageSubView;
}




@property (weak, nonatomic) IBOutlet UITableView *talkToBuisnessTableView;
@property (nonatomic, readwrite, strong) MNMPullToRefreshManager *pullToRefreshManager;
@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property(nonatomic,assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;

- (IBAction)revealFrontController:(id)sender;


@end
