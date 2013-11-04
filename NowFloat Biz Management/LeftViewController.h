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


@interface LeftViewController : UIViewController<FGalleryViewControllerDelegate>
{
    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;

    NSMutableIndexSet *expandedSections;

    IBOutlet UITableView *leftPanelTableView;
    
    NSArray *widgetNameArray;
    
    FGalleryViewController *networkGallery;
    
    AppDelegate *appDelegate;
    
    UIImageView *arrowImageView;

}
@end
