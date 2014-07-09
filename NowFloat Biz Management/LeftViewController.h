//
//  LeftViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "FGalleryViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>



typedef NS_ENUM(int, menuItem)
{
    home=0,
    talkToBusiness=1,
    discovery=2,
    bizStore=3,
    imageGallery=4,
    socialOptions=5,
    analytics=6,
    manageWebsite=7,
    settings=8,
    contactUs=9,
    logOut=10
};


@interface LeftViewController : UIViewController<FGalleryViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;

    NSMutableIndexSet *expandedSections;

    IBOutlet UITableView *leftPanelTableView;
    
    NSArray *widgetNameArray;
    
    FGalleryViewController *networkGallery;
    
    AppDelegate *appDelegate;
    
    UIImageView *notificationBadgeImageView;
    
    UILabel *notifyLabel;
    
    UIImageView *arrowImageView;
    
}
@end
