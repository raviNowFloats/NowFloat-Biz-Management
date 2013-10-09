//
//  StoreDetailViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StoreDetailViewController : UIViewController
{
    
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDefaults;
    
    IBOutlet UIImageView *topBackgroundImageView;
    
    IBOutlet UIImageView *bottomBackgroundIMageView;
    
    IBOutlet UILabel *lineLabel;

    IBOutlet UIView *navBar;
    
    UIButton *customCancelButton;

    IBOutlet UIImageView *detailImageView;
    
    IBOutlet UIButton *buyButton;
    
    IBOutlet UITextView *productDescriptionTextView;
    
    IBOutlet UIScrollView *textViewBgScrollView;
    
    IBOutlet UILabel *productName;
    
    IBOutlet UILabel *productPrice;
    
    int purchaseButtonTag;
    
    int clickedTag;
    
    IBOutlet UIView *activitySubView;
    
    IBOutlet UIImageView *descriptionImageView;
    
    
}


@property(nonatomic) int buttonTag;

- (IBAction)buyButtonClicked:(id)sender;


@end
