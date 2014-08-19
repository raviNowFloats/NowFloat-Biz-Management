//
//  BookDomainnController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/31/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyUniqueNameController.h"
#import "SignUpController.h"
#import "AppDelegate.h"
#import "GetFpDetails.h"
#import "GetFpAddressDetails.h"

@interface BookDomainnController : UIViewController<UITextViewDelegate,VerifyUniqueNameDelegate,SignUpControllerDelegate,updateDelegate,FpAddressDelegate>
{
    AppDelegate *appDelegate;
    
    double storeLatitude,storeLongitude;
}
@property (strong, nonatomic) IBOutlet UITextView *suggestedUrltextView;
@property (strong, nonatomic) IBOutlet UILabel *domianChkLabel;
@property (strong, nonatomic) IBOutlet UIImageView *domianChkImage;
@property (strong, nonatomic) IBOutlet UILabel *privacyLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;

@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *BusinessName;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *phono;
@property(nonatomic,strong) NSString *emailID;
@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *pincode;
@property(nonatomic,strong) NSString *suggestedURL;
@property(nonatomic,strong) NSString *countryCode;
@property(nonatomic,strong) NSString *primaryImageURL;
@property(nonatomic,strong) NSString *pageDescription;
@property(nonatomic,strong) NSString *addressValue;
@property(nonatomic,strong) NSString *fbpageName;
@property(nonatomic,strong) NSString *longt,*latt;
@property(nonatomic,strong) NSString *viewName;


- (IBAction)createMysite:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *suggestDomainView;

- (IBAction)goBack:(id)sender;

@end
