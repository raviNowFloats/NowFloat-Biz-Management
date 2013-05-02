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

@interface PostMessageViewController : UIViewController<UITextViewDelegate>
{

    NSUserDefaults *userDefaults;
    
    AppDelegate *appDelegate;
    
    __weak IBOutlet UILabel *characterCount;

    __weak IBOutlet UIView *downloadSubview;
    
    __weak IBOutlet UILabel *createMessageLabel;
    
    __weak IBOutlet UIButton *facebookButton;
    
    __weak IBOutlet UIButton *selectedFacebookButton;
    
    IBOutlet UIButton *facebookPageButton;
    
    IBOutlet UIButton *selectedFacebookPageButton;
    
    BOOL isFacebookSelected;
    
    BOOL isFacebookPageSelected;
    
    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;
    
    IBOutlet UIView *fbPageSubView;
    
    IBOutlet UITableView *fbPageTableView;
    
    IBOutlet UILabel *selectPageBgLabel;
    
    BOOL isForFBPageAdmin;

}

@property (weak, nonatomic) IBOutlet UITextView *postMessageTextView;

-(IBAction)dismissKeyboardOnTap:(id)sender;

-(void)updateView;

- (IBAction)facebookButtonClicked:(id)sender;

- (IBAction)selectedFaceBookClicked:(id)sender;

- (IBAction)facebookPageButtonClicked:(id)sender;

- (IBAction)selectedFbPageButtonClicked:(id)sender;

- (IBAction)fbPageSubViewCloseButtonClicked:(id)sender;

@end
