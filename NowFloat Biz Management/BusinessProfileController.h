//
//  BusinessProfileController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/26/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SA_OAuthTwitterController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <Social/Social.h>

@interface BusinessProfileController : UIViewController<SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    UINavigationBar *navBar;
    
    UIButton *customButton;
    NSString *version ;
    
    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;
    
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *businessProTable;
- (IBAction)updateDescription:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *businessNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *primaryImageView;

@property (strong, nonatomic) IBOutlet UIView *businessDescView;
@property (strong, nonatomic) IBOutlet UITextView *businessDescText;
@property (strong, nonatomic) IBOutlet UIButton *editButton;


@end
