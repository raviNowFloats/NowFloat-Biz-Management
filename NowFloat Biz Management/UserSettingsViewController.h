//
//  UserSettingsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/11/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "AppDelegate.h"

@interface UserSettingsViewController : UIViewController<SWRevealViewControllerDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate>
{
    NSArray *userSettingsArray;
    
    IBOutlet UITableView *userSettingsTableView;
    
    NSString *frontViewPosition;
    
    NSString *version;
    
    UINavigationBar *navBar;
    
    UILabel *headerLabel;
    
    UIButton *leftCustomButton;

    IBOutlet UIButton *revealFrontControllerButton;
    
    NSMutableIndexSet *expandedSections;
    
    SWRevealViewController *revealController;
    
    AppDelegate *appDelegate;
}



- (IBAction)revealFrontController:(id)sender;

@end
