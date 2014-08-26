//
//  SignupFBController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestBusinessDomain.h"
@interface SignupFBController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,SuggestBusinessDomainDelegate,UITextFieldDelegate>
{
     AppDelegate *appDelegate;
}
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *BusinessName;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *phono;
@property(nonatomic,strong) NSString *emailID;
@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *primaryImageURL;
@property(nonatomic,strong) NSString *pageDescription;
@property(nonatomic,strong) NSString *fbPagename;

@property (strong,nonatomic)  UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UITextField *cityTextfield;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextfield;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;

@property (strong, nonatomic) IBOutlet UIButton *countryButton;
- (IBAction)selectCountry:(id)sender;

- (IBAction)pickerCancel:(id)sender;
- (IBAction)donePicker:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *countryPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (strong, nonatomic) IBOutlet UITextField *cityText;

@property (strong, nonatomic) IBOutlet UITextField *textfd;
- (IBAction)submitFB:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *countryView;
@property (strong, nonatomic) IBOutlet UIView *cityView;
@property (strong, nonatomic) IBOutlet UIView *phoneView;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryCodeLabel;

@property (strong, nonatomic) IBOutlet UIView *errorView;
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *backLabel;

@property (strong, nonatomic) IBOutlet UILabel *nextlabel;
@property (strong, nonatomic) IBOutlet UIImageView *NextImage;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end
