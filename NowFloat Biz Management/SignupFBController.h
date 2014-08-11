//
//  SignupFBController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestBusinessDomain.h"
@interface SignupFBController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,SuggestBusinessDomainDelegate>
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

@end
