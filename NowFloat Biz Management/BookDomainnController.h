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

@interface BookDomainnController : UIViewController<UITextViewDelegate,VerifyUniqueNameDelegate,SignUpControllerDelegate,updateDelegate>
{
    AppDelegate *appDelegate;
    
    double storeLatitude,storeLongitude;
}
@property (strong, nonatomic) IBOutlet UITextView *suggestedUrltextView;
@property (strong, nonatomic) IBOutlet UILabel *domianChkLabel;
@property (strong, nonatomic) IBOutlet UIImageView *domianChkImage;
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


- (IBAction)createMysite:(id)sender;



@end
