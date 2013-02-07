//
//  BusinessDetailsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessDetailsViewController : UIViewController<UITextViewDelegate>
{

    int textFieldTag;
    AppDelegate *appDelegate;

}
@property (weak, nonatomic) IBOutlet UITextView *businessNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *businessDescriptionTextView;

-(IBAction)dismissKeyboardOnTap:(id)sender;

@end
