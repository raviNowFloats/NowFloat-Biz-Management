//
//  SearchQueryViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 14/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface SearchQueryViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate>
{

    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    NSMutableArray *searchQueryArray;
    NSMutableArray *searchDateArray;
    
    IBOutlet UITableView *searchQueryTableView;
    
    IBOutlet UIActivityIndicatorView *searchQueryActivityView;
    
    NSString *version ;
    
    UINavigationBar *navBar;
    
    IBOutlet UIView *contentSubView;
    
    UILabel *headerLabel;
    
    UIButton *backButton;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    NSString *frontViewPosition;
    
    UIButton *leftCustomButton;

}


- (IBAction)revealFrontController:(id)sender;

@end
