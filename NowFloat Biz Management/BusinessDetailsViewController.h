//
//  BusinessDetailsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessDetailsViewController : UIViewController<UITextViewDelegate,SWRevealViewControllerDelegate>
{

    int textFieldTag;
    AppDelegate *appDelegate;
    
    NSMutableDictionary *upLoadDictionary;
    NSDictionary *textDescriptionDictionary;
    NSDictionary *textTitleDictionary;
    
    
    NSString *businessNameString;
    NSString *businessDescriptionString;
    
    BOOL isStoreTitleChanged;
    BOOL isStoreDescriptionChanged;
    
    IBOutlet UIView *activitySubView;

    IBOutlet UIScrollView *detailScrollView;
    
    UINavigationBar *navBar;
    
    UIButton *customButton;
    
    IBOutlet UILabel *businessNamePlaceHolderLabel;
    
    IBOutlet UILabel *businessDescriptionPlaceHolderLabel;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;

    IBOutlet UIView *contentSubView;

    NSString *version ;
    
}
@property (weak, nonatomic) IBOutlet UITextView *businessNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *businessDescriptionTextView;
@property (nonatomic,strong)    NSMutableArray *uploadArray;


-(IBAction)dismissKeyboardOnTap:(id)sender;

- (IBAction)revealFrontController:(id)sender;


@end
