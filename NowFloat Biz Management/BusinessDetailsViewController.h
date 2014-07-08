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
    
    IBOutlet UIScrollView *detailScrollView;
    
    UINavigationBar *navBar;
    
    UIButton *customButton;
    
    IBOutlet UILabel *businessNamePlaceHolderLabel;
    
    IBOutlet UILabel *businessDescriptionPlaceHolderLabel;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;

    IBOutlet UIView *contentSubView;

    __weak IBOutlet UIPickerView *catPicker;
    
    __weak IBOutlet UIToolbar *pickerToolBar;
    
    __weak IBOutlet UITextField *categoryText;
    NSString *version ;
    
}
@property (weak, nonatomic) IBOutlet UITextView *businessNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *businessDescriptionTextView;
@property (nonatomic,strong)    NSMutableArray *uploadArray;

- (IBAction)cancelPicker:(id)sender;
- (IBAction)donePicker:(id)sender;

- (IBAction)businessCategories:(id)sender;

-(IBAction)dismissKeyboardOnTap:(id)sender;

- (IBAction)revealFrontController:(id)sender;


@end
