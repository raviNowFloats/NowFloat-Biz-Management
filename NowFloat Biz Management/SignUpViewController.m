//
//  SignUpViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIColor+HexaString.h"
#import <QuartzCore/QuartzCore.h>
#import "DBValidator.h"
#import "VerifyUniqueNameController.h"
#import "FpCategoryController.h"
#import "UIColor+HexaString.h"  
#import "NSString+CamelCase.h"
#import "GetFpAddressDetails.h"
#import "SignUpController.h"
#import "LoginViewController.h"
#import "GetFpDetails.h"
#import "BizMessageViewController.h"
#import "ChangeStoreTagViewController.h"
#import "SuggestBusinessDomain.h"
#import "FileManagerHelper.h"
#import "PopUpView.h"
#import "Mixpanel.h"
#import "RegisterChannel.h"
#import "NFActivityView.h"
#import "EmailShareController.h"
#import "DomainSelectViewController.h"  
#import "UIView+FindAndReturnFirstResponder.h"
#import "LocateBusinessAddress.h"
#import "UserSettingsWebViewController.h"
#import "AarkiContact.h"
#import "RIATipsController.h"


#define defaultSubViewWidth 300
#define defaultSubViewHeight 260


#define HouseNumberPlaceholder @"Building Name"
#define CityPlaceHolder @"City"
#define PincodePlaceHolder @"Pincode/Zipcode"
#define StatePlaceHolder @"State"


NSString *countryName;





@implementation AddressAnnotation

@synthesize coordinate;


- (NSString *)subtitle
{
    return nil;
}

- (NSString *)title
{
    
    NSString *string=@"Hello";
    return string;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c
{
    coordinate = c;
    return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}


@end


@interface SignUpViewController ()<VerifyUniqueNameDelegate,FpCategoryDelegate,FpAddressDelegate,SignUpControllerDelegate,updateDelegate,SuggestBusinessDomainDelegate,ChangeStoreTagDelegate,PopUpDelegate,RegisterChannelDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,UITextViewDelegate>
{
    UIImage *buttonBackGroundImage;
    NSCharacterSet *blockedCharacters;
    int currentView;
    long viewHeight;
    long viewWidth;
    NSString *categoryString;
    NSString *countryCodeString;
    NFActivityView *nfActivity;
    NFActivityView *locatingAV;
    NSString *createdFpName;
    BOOL isFromDomainSelect;
    BOOL isEditingAddress;
    NSInteger *tfTag;
    UITextField *newText;
    BOOL isAddressFetched;
}

@end



@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    if (isFromDomainSelect)
    {
        [self navigateBizMessageView];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
   countryName = [locale displayNameForKey: NSLocaleCountryCode
                                                value: countryCode];
    
    countryNameTextField.text = countryName;

    
    NSDictionary *dictDialingCodes = [[NSDictionary alloc]initWithObjectsAndKeys:
                                      @"972", @"IL",
                                      @"93", @"AF",
                                      @"355", @"AL",
                                      @"213", @"DZ",
                                      @"1", @"AS",
                                      @"376", @"AD",
                                      @"244", @"AO",
                                      @"1", @"AI",
                                      @"1", @"AG",
                                      @"54", @"AR",
                                      @"374", @"AM",
                                      @"297", @"AW",
                                      @"61", @"AU",
                                      @"43", @"AT",
                                      @"994", @"AZ",
                                      @"1", @"BS",
                                      @"973", @"BH",
                                      @"880", @"BD",
                                      @"1", @"BB",
                                      @"375", @"BY",
                                      @"32", @"BE",
                                      @"501", @"BZ",
                                      @"229", @"BJ",
                                      @"1", @"BM", @"975", @"BT",
                                      @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                                      @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                                      @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                                      @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                                      @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                                      @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                                      @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                                      @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                                      @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                                      @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                                      @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                                      @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                                      @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                                      @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                                      @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                                      @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                                      @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                                      @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                                      @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                                      @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                                      @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                                      @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                                      @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                                      @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                                      @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                                      @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                                      @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                                      @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                                      @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                                      @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                                      @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                                      @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                                      @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                                      @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                                      @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                                      @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                                      @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                                      @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                                      @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                                      @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                                      @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                                      @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                                      @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                                      @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                                      @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                                      @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                                      @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                                      @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                                      @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                                      @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                                      @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                                      @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963",
                                      @"SY",@"886",
                                      @"TW", @"255",
                                      @"TZ", @"670",
                                      @"TL",@"58",
                                      @"VE",@"84",
                                      @"VN",
                                      @"284", @"VG",
                                      @"340", @"VI",
                                      @"678",@"VU",
                                      @"681",@"WF",
                                      @"685",@"WS",
                                      @"967",@"YE",
                                      @"262",@"YT",
                                      @"27",@"ZA",
                                      @"260",@"ZM",
                                      @"263",@"ZW",
                                      nil];
    
    countryCodeTextField.text = [NSString stringWithFormat:@"+%@",[dictDialingCodes objectForKey:countryCode]];
    
    
    
    self.privacyLabel.userInteractionEnabled = YES;
    self.termsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *privacy = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPrivacy)];
    privacy.numberOfTapsRequired = 1;
    privacy.numberOfTouchesRequired = 1;
    [self.privacyLabel addGestureRecognizer:privacy];
    
    
    UITapGestureRecognizer *terms = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(terms)];
    privacy.numberOfTapsRequired = 1;
    privacy.numberOfTouchesRequired = 1;
    [self.termsLabel addGestureRecognizer:terms];
    
    
    FpCategoryController *categoryController=[[FpCategoryController alloc]init];
    
    categoryController.delegate=self;
    
    [categoryController downloadFpCategoryList];
    
    
    
    // Do any additional setup after loading the view from its nib.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    
    [downloadingCategoriesActivityView.layer setCornerRadius:6.0];
    
    downloadingCategoriesActivityView.center=[[[UIApplication sharedApplication] delegate] window].center;

    [stepTwoButton setUserInteractionEnabled:NO];
    
    [stepThreeButton setUserInteractionEnabled:NO];
    
    [stepFourButton setUserInteractionEnabled:NO];
    
    [mainScrollView setScrollEnabled:NO];
    
    currentView=1;
    
    [checkMarkImageView setHidden:YES];
    
    isVerified=NO;
    
    viewMovedUp = NO;
    
    isFromDomainSelect=NO;
    
    isAddressFetched = NO;
    
    blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];

    [categoryTableView setSeparatorColor:[UIColor whiteColor]];
    
    [listOfStatesTableView setSeparatorColor:[UIColor whiteColor]];
    
    [countryCodesTableView setSeparatorColor:[UIColor whiteColor]];
    
    categoryArray=[[NSMutableArray alloc]init];
    
    listOfStatesArray=[[NSMutableArray alloc]init];
    
    countryListArray=[[NSMutableArray alloc]init];
    
    countryCodeArray=[[NSMutableArray alloc]init];
    
    storeLatitude=0;
    
    storeLongitude=0;
    
    countryCodeBg.layer.borderColor=[UIColor colorWithHexString:@"dcdcda"].CGColor;
    
    countryCodeBg.layer.borderWidth=1.0;
    
    countryCodeBg.layer.cornerRadius=6.0;
    
    subViewArray=[[NSMutableArray alloc]init];
    
    cancelRegistrationSubview.center=self.view.center;
    
    cancelSIgnUpAlertVIew.center=self.view.center;

    
    [subViewArray addObject:stepOneSubView];
    [subViewArray addObject:stepTwoSubView];
    [subViewArray addObject:stepThreeSubView];
    [subViewArray addObject:stepFourSubVIew];

    NSString *versionString = [[UIDevice currentDevice] systemVersion];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        viewWidth=result.width;
        if(result.height == 480)
        {
            //For iphone 3,3gS,4,42
            viewHeight=480;
            
            [stepOneIconView setFrame:CGRectMake(stepOneIconView.frame.origin.x, 13, stepOneIconView.frame.size.width, stepOneIconView.frame.size.height)];
            [stepTwoIconView setFrame:CGRectMake(stepTwoIconView.frame.origin.x, 13, stepTwoIconView.frame.size.width, stepTwoIconView.frame.size.height)];
            [stepThreeIconView setFrame:CGRectMake(stepThreeIconView.frame.origin.x, 13, stepThreeIconView.frame.size.width, stepThreeIconView.frame.size.height)];
            [stepFourIconView setFrame:CGRectMake(stepFourIconView.frame.origin.x, 13, stepFourIconView.frame.size.width, stepFourIconView.frame.size.height)];
            
            
            [stepOneBtnView setFrame:CGRectMake(stepOneBtnView.frame.origin.x, 405, stepOneBtnView.frame.size.width, stepOneBtnView.frame.size.height)];
            
            [stepTwoBrnView setFrame:CGRectMake(stepTwoBrnView.frame.origin.x, 405, stepTwoBrnView.frame.size.width, stepTwoBrnView.frame.size.height)];
            
            [stepThreeBtnView setFrame:CGRectMake(stepThreeBtnView.frame.origin.x, 405, stepThreeBtnView.frame.size.width, stepThreeBtnView.frame.size.height)];
            
            [stepFourBtnView setFrame:CGRectMake(stepFourBtnView.frame.origin.x, 405, stepFourBtnView.frame.size.width, stepFourBtnView.frame.size.height)];
            
            [stepOneContentView setFrame:CGRectMake(stepOneContentView.frame.origin.x, stepOneContentView.frame.origin.y-30, stepOneContentView.frame.size.width, stepOneContentView.frame.size.height)];
            
            [stepTwoContentView setFrame:CGRectMake(stepTwoContentView.frame.origin.x, stepTwoContentView.frame.origin.y-30, stepTwoContentView.frame.size.width, stepTwoContentView.frame.size.height)];
            
            [pickerView setFrame:CGRectMake(0, 220, viewWidth, 260)];
            
            [countryPickerViewContainer setFrame:CGRectMake(0, 220, viewWidth, 260)];
            
            if (versionString.floatValue<7.0)
            {
                [pageControlSubView setFrame:CGRectMake(0, 430, 320,10)];
                [changeTagBtn setFrame:CGRectMake(214, 273, changeTagBtn.frame.size.width, changeTagBtn.frame.size.height)];
            }
            
            else
            {
                [pageControlSubView setFrame:CGRectMake(0, 450, 320,30)];
            }
            [pageControlSubView setHidden:YES];
        }
        
        
        if(result.height == 568)
        {
            //For iphone 5
            viewHeight=568;
            
            if (versionString.floatValue<7.0)
            {
                [pageControlSubView setFrame:CGRectMake(0, 514, 320,30)];
                [changeTagBtn setFrame:CGRectMake(180, 273, changeTagBtn.frame.size.width, changeTagBtn.frame.size.height)];
            }
        }
    }
    
    /*
    //Create NavBar here
    
    [navBar setClipsToBounds:YES];
    
    navBar.topItem.title=@"Business Details";
    
    //Create the custom cancel button here
    
    UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];

    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setFrame:CGRectMake(5,9,32,26)];
    
    [customCancelButton addTarget:self action:@selector(cancelRegisterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];
    
    
    UIImage *buttonNextImage = [UIImage imageNamed:@"next-btn.png"];

    customNextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customNextButton setFrame:CGRectMake(285,9,32,26)];
    
    [customNextButton addTarget:self action:@selector(stepOneNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [customNextButton setImage:buttonNextImage  forState:UIControlStateNormal];
    
    [customNextButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customNextButton];
        categoryTableView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    categoryTableView.layer.borderWidth=1.0;
    
    listOfStatesTableView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    listOfStatesTableView.layer.borderWidth=1.0;
    
    countryCodesTableView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    countryCodesTableView.layer.borderWidth=1.0;
    
    CGRect frame ;
    
    if (viewHeight==568)
    {

           frame = CGRectMake(10,80,self.view.frame.size.width-20, self.view.frame.size.height-158);

    }

    else
    {
            [pickerView setFrame:CGRectMake(0, 220, viewWidth, 260)];

            [countryPickerViewContainer setFrame:CGRectMake(0, 220, viewWidth, 260)];
        
            frame = CGRectMake(10,60,self.view.frame.size.width-20, self.view.frame.size.height-250);
        
    }
    
    
    _container = [[UIView alloc] initWithFrame:frame];
    
    [self.view addSubview:_container];
    
    [stepOneSubView setFrame:CGRectMake(0,0,_container.frame.size.width, _container.frame.size.height)];
    
    [categorySubView setFrame:CGRectMake(0,0,_container.frame.size.width, _container.frame.size.height)];
    
    [stepTwoSubView setFrame:CGRectMake(320,0,_container.frame.size.width,_container.frame.size.height)];
    
    [mapSubView  setFrame:CGRectMake(0,0,_container.frame.size.width, _container.frame.size.height)];
    
    [stepThreeSubView setFrame:CGRectMake(320,0,_container.frame.size.width,_container.frame.size.height)];
    
    [stepFourSubVIew setFrame:CGRectMake(320,0,_container.frame.size.width,_container.frame.size.height)];
    
    [_container addSubview:stepOneSubView];[stepOneSubView setBackgroundColor:[UIColor clearColor]];
    
    [_container addSubview:categorySubView];[categorySubView setHidden:YES];

    [_container addSubview:stepTwoSubView];[stepTwoSubView setBackgroundColor:[UIColor clearColor]];
    
    [_container addSubview:listOfStatesSubView];[listOfStatesSubView setHidden:YES];
    
    [_container addSubview:mapSubView];[mapSubView setHidden:YES];
    
    [_container addSubview:stepThreeSubView];
    
    [_container addSubview:stepFourSubVIew];
    
    [_container addSubview:countryCodeSubView];[countryCodeSubView setHidden:YES];
        
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
     
            [stepControllerSubView setFrame:CGRectMake(0, 360, 320, 100)];
                        
            [stepTwoScrollView setContentSize:CGSizeMake(_container.frame.size.width, _container.frame.size.height+160)];
                        
        }
        if(result.height == 568)
        {
            
            
            [stepControllerSubView setFrame:CGRectMake(0, 448, 320, 100)];
                        
            [categoryTableView setFrame:CGRectMake(categoryTableView.frame.origin.x, categoryTableView.frame.origin.y, categoryTableView.frame.size.width, categoryTableView.frame.size.height)];

            //[stepTwoScrollView setContentSize:CGSizeMake(_container.frame.size.width, _container.frame.size.height+190)];
        }
    }
    */

    scrollPageControl.numberOfPages = subViewArray.count;
    [scrollPageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
    [scrollPageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];

    
    
    for (int i = 0; i < subViewArray.count; i++)
    {
        CGRect frame;
        frame.origin.x = mainScrollView.frame.size.width * i;
        frame.origin.y = 0;
        
        if(viewHeight==568)
        {
            frame.size.height = 548;
        }
        else
        {
            frame.size.height = 460;//460
        }
        frame.size.width= 320;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        [subview addSubview:[subViewArray objectAtIndex:i]];
        [mainScrollView addSubview:subview];
    }
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width * subViewArray.count,548);

    
    //Give the validations to the UITextFields here
    
    [self setUpValidations];


    [[NSNotificationCenter defaultCenter]
                             addObserver:self
                             selector:@selector(changeBothFieldsText:)
                             name:UITextFieldTextDidChangeNotification
                             object:nil ];
    
    
    NSString *filePathForIndianStates = [[NSBundle mainBundle] pathForResource:@"listofstates" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePathForIndianStates];
    
    NSArray *array = [NSArray arrayWithArray:[dict objectForKey:@"statesArray"]];
    
    [listOfStatesArray  addObjectsFromArray:array];
    
    
    NSError *error;

    
    NSString *filePathForCountries = [[NSBundle mainBundle] pathForResource:@"listofcountries" ofType:@"json"];
    
    NSString *myJSONString = [[NSString alloc] initWithContentsOfFile:filePathForCountries encoding:NSUTF8StringEncoding error:&error];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[myJSONString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];

    NSMutableArray *countryJsonArray=[[NSMutableArray  alloc]initWithArray:[[json objectForKey:@"countries"]objectForKey:@"country"]];
    
    for (int i=0; i<[countryJsonArray count]; i++)
    {
        [countryListArray insertObject:[[countryJsonArray objectAtIndex:i]objectForKey:@"-name"] atIndex:i];
        
        [countryCodeArray insertObject:[[countryJsonArray objectAtIndex:i]objectForKey:@"-phoneCode"] atIndex:i];
        
    }
    
    
    [self drawBorder];

}


-(void)openPrivacy
{
    UserSettingsWebViewController *webViewController=[[UserSettingsWebViewController alloc]initWithNibName:@"UserSettingsWebViewController" bundle:nil];
    
    UINavigationController *navController=[[UINavigationController   alloc]initWithRootViewController:webViewController];
    
    webViewController.displayParameter=@"Privacy Policy";
    
    [self presentViewController:navController animated:YES completion:nil];
    
    webViewController=nil;

}

-(void)terms
{
    UserSettingsWebViewController *webViewController=[[UserSettingsWebViewController alloc]initWithNibName:@"UserSettingsWebViewController" bundle:nil];
    
    UINavigationController *navController=[[UINavigationController   alloc]initWithRootViewController:webViewController];
    
    webViewController.displayParameter=@"Terms & Conditions";
    
    [self presentViewController:navController animated:YES completion:nil];
    
    webViewController=nil;

}

-(void)drawBorder
{
    [self changeBorderColorIf:YES forView:businessNameBg];
    [self changeBorderColorIf:YES forView:businessVerticalBg];
    [self changeBorderColorIf:YES forView:houseNumberImageViewBg];
    [self changeBorderColorIf:YES forView:streetNameImageViewBg];
    [self changeBorderColorIf:YES forView:cityImageViewBg];
    [self changeBorderColorIf:YES forView:pinCodeImageViewBg];
    [self changeBorderColorIf:YES forView:stateImageViewBg];
    [self changeBorderColorIf:YES forView:countryImageViewBg];
    [self changeBorderColorIf:YES forView:emailAddressImageViewBg];
    [self changeBorderColorIf:YES forView:mobileNumberImageViewBg];
    [self changeBorderColorIf:YES forView:suggestedUriImageViewBg];
    [self changeBorderColorIf:YES forView:suggestedUriTextView];
    
}


-(void)setUpValidations
{

    DBValidationStringLengthRule *businessVerticalTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:businessVerticalTextField keyPath:@"text" minStringLength:2 maxStringLength:60 failureMessage:@"Business vertical cannot be empty"];
    [businessVerticalTextField addValidationRule:businessVerticalTextFieldRule];
    
    
    
    DBValidationStringLengthRule *businessNameTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:businessNameTextField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Business name should atleast contain 3 characters"];
    [businessNameTextField addValidationRule:businessNameTextFieldRule];
    
        
    DBValidationStringLengthRule *houseNumberTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:houseNumberTextField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"House number should atleast contain 3 characters"];
    
    [houseNumberTextField addValidationRule:houseNumberTextFieldRule];
    
    
    DBValidationStringLengthRule *cityNameTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:cityNameTextField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"City name should atleast contain 3 characters"];
    
    [cityNameTextField addValidationRule:cityNameTextFieldRule];
    
    DBValidationStringLengthRule *stateNameTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:stateNameTextField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"State name cannot be empty"];
    
    [stateNameTextField addValidationRule:stateNameTextFieldRule];
    
    
    DBValidationStringLengthRule *pincodeTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:pincodeTextField  keyPath:@"text" minStringLength:5 maxStringLength:6 failureMessage:@"Pincode should atleast contain 5 digits"];
    
    [pincodeTextField addValidationRule:pincodeTextFieldRule];
    
    
    DBValidationStringLengthRule *nameTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:ownerNameTextField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Name should atleast contain 3 characters"];
    
    [ownerNameTextField addValidationRule:nameTextFieldRule];
    
    
    DBValidationStringLengthRule *phoneTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:businessPhoneNumberTextField keyPath:@"text" minStringLength:6 maxStringLength:12 failureMessage:@"Phone number should be between 6 to 12 digits"];
    
    [businessPhoneNumberTextField addValidationRule:phoneTextFieldRule];
    
    
    DBValidationStringLengthRule *countryCodeTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:countryCodeTextField keyPath:@"text" minStringLength:2 maxStringLength:3 failureMessage:@"Country code should be a maximum of 3 digits"];
    
    [countryCodeTextField addValidationRule:countryCodeTextFieldRule];

    DBValidationEmailRule *emailTextFieldRule=[[DBValidationEmailRule alloc]initWithObject:emailTextField keyPath:@"text" failureMessage:@"Enter Valid Email Address"];
    [emailTextField addValidationRule:emailTextFieldRule];
    
    
}


-(void)cancelRegisterBtnClicked
{

    UIAlertView *cancelAlertView=[[UIAlertView alloc]initWithTitle:Nil message:@"Are you sure to cancel the registration process ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [cancelAlertView setTag:101];
    
    [cancelAlertView show];
    
    cancelAlertView=nil;

}


#pragma UITextFieldDelegate





- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{

    //Do not allow user to enter whitespaces in the begining
    
    if (range.location == 0 && [characters isEqualToString:@" "])
    {
        return NO;
    }
    
    //Block special characters for the particular field

    if (field.tag==2 || field.tag==7 || field.tag==11 || field.tag==9 )
    {
        //Tells the delegate to skip whitespaces
        if (![characters isEqualToString:@" "])
        {
            return ([characters rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
        }
    }
    
    
    if (field.tag==13)
    {
        return ([characters rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
    }
    
    
    if (field.tag==14)
    {
        
        NSUInteger newLength = [field.text length] + [characters length] - range.length;
        return (newLength > 2) ? NO : YES;
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    tfTag = textField.tag;
    newText = textField;
    
    if (textField.tag==3 || textField.tag ==4 || textField.tag== 7 || textField.tag==8 || textField.tag == 9 || textField.tag ==10 )
    {
        isEditingAddress = YES;
        
        
        
        [stepTwoScrollView setContentSize:CGSizeMake(self.view.frame.size.width,700)];
        
        textField.inputAccessoryView = toolBarView;
        
        if (textField.tag==3)
        {
            [goToPrevTextFieldBtn setEnabled:NO];
        }
        
        else{
            [goToPrevTextFieldBtn setEnabled:YES];
        }
        
        
        
        if (textField.tag==10)
        {
            [goToNextTextFieldBtn setEnabled:NO];
        }
        
        else
        {
            [goToNextTextFieldBtn setEnabled:YES];
        }

    }
    
    else
    {
        [stepTwoScrollView setContentSize:CGSizeMake(self.view.frame.size.width,548)];

        isEditingAddress = NO;
    }
    
    
    
    if (viewHeight==480)
    {
        
        if (textField.tag==1) {

            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];
            textField.placeholder=@"Business Category";
        }
        
        if (textField.tag==2)
        {
            [self animateTextField: textField up:YES movementDistance:80];
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];
            textField.placeholder=@"Business Name";
            return YES;
        }
        
        if (textField.tag==15)
        {
            [self animateTextField: textField up:YES movementDistance:160];
            return YES;
        }


/*
    if (textField.tag==3)
    {
            
        textField.placeholder=HouseNumberPlaceholder;
        
        [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
        
    }
*/


    if (textField.tag==4)
    {
        [self animateTextField: textField up:YES movementDistance:100];
        return YES;
    }

    if (textField.tag==5)
    {
        [self animateTextField: textField up:YES movementDistance:120];
        return YES;
    }

        if (textField.tag==6)
        {
            [self animateTextField: textField up:YES movementDistance:140];
            return YES;
        }
        
        if (textField.tag==7)
        {
            textField.placeholder=CityPlaceHolder;
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:YES movementDistance:160];

            return YES;
        }

        if (textField.tag==8)
        {
            [self animateTextField: textField up:YES movementDistance:170];
            return YES;
        }
        

        if (textField.tag==9)
        {
            textField.placeholder=StatePlaceHolder;
            
            //[self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:YES movementDistance:170];
            return YES;
        }
        
        if (textField.tag==12)
        {
            textField.placeholder=@"Email Address";
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:YES movementDistance:80];

        }
        
        if (textField.tag==13 )
        {
            textField.placeholder=@"Phone Number";
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            return YES;
        }

        if (textField.tag==14)
        {
            [self animateTextField: textField up:YES movementDistance:60];
            return YES;
        }

        
        
    }
    
    else
    {
        
        if(textField.tag == 10)
        {
            [stepTwoScrollView setContentSize:CGSizeMake(self.view.frame.size.width,548)];
        }

        if (textField.tag==1) {

            textField.placeholder=@"Business Category";

            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];

        }
        
        if (textField.tag==2) {

            textField.placeholder=@"Business Name";

            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];
            
        }
        
        if(textField.tag == 4)
        {
            [self animateTextField: textField up:YES movementDistance:20];
            
        }
        
        if (textField.tag==3)
        {
            textField.placeholder=HouseNumberPlaceholder;
        }


        if (textField.tag==6)
        {
             [self animateTextField: textField up:YES movementDistance:40];
            //[self animateTextField: textField up:YES movementDistance:140];
            return YES;
        }
        
        if (textField.tag==7)
        {
             [self animateTextField: textField up:YES movementDistance:60];
            textField.placeholder=CityPlaceHolder;
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            return YES;
        }
        
        
        if (textField.tag==8)
        {
             [self animateTextField: textField up:YES movementDistance:60];
            textField.placeholder=PincodePlaceHolder;
            return YES;
        }
        
        if (textField.tag==9)
        {
             [self animateTextField: textField up:YES movementDistance:80];
            textField.placeholder=StatePlaceHolder;
            
            //[self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            //[self animateTextField: textField up:YES movementDistance:40];
            return YES;
            
            
        }
        
        if (textField.tag==11) {
            
            if ( [textField isEqual:fpTagTextField] )
            {

                textFieldBeingEdited = fpTagTextField;
            }

        }
        
        
        if (textField.tag==12) {
            
            
            textField.placeholder=@"Email Address";
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepThreeSubView];
            
            
        }

        
        if (textField.tag==13)
        {
            textField.placeholder=@"Phone Number";
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepThreeSubView];
        }
    }

    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField.tag==3 || textField.tag ==4 || textField.tag== 7 || textField.tag==8 || textField.tag == 9 || textField.tag ==10 )
    {
        isEditingAddress=NO;
        [stepTwoScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        //[stepTwoScrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)];
    }
    
    else{
    
    }
    
    if (viewHeight==480)
    {
        if (textField.tag==2)
        {
            [self animateTextField: textField up:NO movementDistance:80];
            
            if ([textField.text isEqualToString:@""] || textField.text.length<3 ||[self textFieldHasWhiteSpaces:textField.text])
                {
                    [self changeBorderColorIf:NO forView:businessNameBg];
                }
            
                else
                {
                    [self changeBorderColorIf:YES forView:businessNameBg];
                }
            
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];
            
            return YES;
        }
                
        if (textField.tag==3)
        {
            
            //[self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
        
            return YES;
        }
        


        if (textField.tag==4)
        {
            [self animateTextField: textField up:NO movementDistance:100];
            return YES;
        }
        
        if (textField.tag==5)
        {
            
            [self animateTextField: textField up:NO movementDistance:120];
            return YES;
            
            
        }
        
        if (textField.tag==6)
        {
            
            [self animateTextField: textField up:NO movementDistance:140];
            
            return YES;
            
            
        }
        if (textField.tag==7)
        {
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];

            [self animateTextField: textField up:NO movementDistance:160];
            
            return YES;
            
            
        }
        
        
        if (textField.tag==8)
        {
            //[self validateTextFieldAfterEditing:textField forView:stepTwoSubView];

            [self animateTextField: textField up:NO movementDistance:170];
            
            return YES;
            
            
        }
        
        if (textField.tag==9)
        {

            //[self validateTextFieldAfterEditing:textField forView:stepTwoSubView];

            [self animateTextField: textField up:NO movementDistance:170];
            
            return YES;
        }
        
        
        if (textField.tag==11)
        {
            if (textField.text.length>2)
            {
                            
            [checkMarkImageView setHidden:YES];
            
            [verifyValidFpActivityIndicator setHidden:NO];
            
            [verifyValidFpActivityIndicator startAnimating];
            
            VerifyUniqueNameController *uniqueNameController=[[VerifyUniqueNameController alloc]init];

            uniqueNameController.delegate=self;
            
            [uniqueNameController verifyWithFpName:businessNameTextField.text andFpTag:fpTagTextField.text];
                
            return YES;
                
            }
            
            else if (textField.text.length<3 && textField.text.length>=1)
            {
                [checkMarkImageView setHidden:NO];
                
                [checkMarkImageView setImage:[UIImage imageNamed:@"invalid.png"]];
                
                isVerified=NO;
                
                return YES;
            }
            
            else
            {
                isVerified=NO;
                return YES;

            }
            
            
        }
        
        
        if (textField.tag==12)
        {
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];
            [self animateTextField: textField up:NO movementDistance:80];
            [textField resignFirstResponder];

            return YES;
            
            
        }
        
        
        if (textField.tag==13)
        {
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];

            return YES;
            
            
        }

        
        
        if (textField.tag==14)
        {            
            [self animateTextField: textField up:NO movementDistance:60];
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];

            return YES;
            
        }

        
        
        
        

    }
    
    if (viewHeight==568)
    {
        if(newText.tag == 4)
        {
            [self animateTextField:newText up:NO movementDistance:0];
        }
        if(newText.tag == 6)
        {
            [self animateTextField:newText up:NO movementDistance:0];
        }
        if(newText.tag == 7 || newText.tag == 8)
        {
            [self animateTextField:newText up:NO movementDistance:0];
        }
        
        if(newText.tag == 9)
        {
            [self animateTextField:newText up:NO movementDistance:0];
        }
        if(newText.tag == 10)
        {
            [self animateTextField:newText up:NO movementDistance:0];
        }
        
        
        if (textField.tag==2)
        {
            
            
            if ([textField.text isEqualToString:@""] || textField.text.length<3 ||[self textFieldHasWhiteSpaces:textField.text])
            {
                businessNameBg.layer.cornerRadius = 6.0f;
                businessNameBg.layer.masksToBounds = YES;
                businessNameBg.layer.borderColor = [[UIColor redColor] CGColor];
                businessNameBg.layer.borderWidth = 1.0f;
            }
            
            else
            {
                businessNameBg.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
                businessNameBg.layer.borderWidth = 1.0f;
            }
            
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];

            return YES;
        }

        
        
        if (textField.tag==3)
        {
            //[self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
            
            return YES;
        }
        

        
        
        if (textField.tag==6)
        {
            
            //[self animateTextField: textField up:NO movementDistance:140];
            return YES;
            
            
        }
        if (textField.tag==7)
        {
            //[self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
            return YES;
            
            
        }
        
        
        if (textField.tag==8)
        {
            return YES;
        }
        
        if (textField.tag==9)
        {
            //[self animateTextField: textField up:NO movementDistance:40];
            return YES;
        }
        
        if (textField.tag==11)
        {
            if (textField.text.length>2)
            {

                [checkMarkImageView setHidden:YES];
                
                [verifyValidFpActivityIndicator setHidden:NO];
                
                [verifyValidFpActivityIndicator startAnimating];
                
                VerifyUniqueNameController *uniqueNameController=[[VerifyUniqueNameController alloc]init];
                
                uniqueNameController.delegate=self;
                
                [uniqueNameController verifyWithFpName:businessNameTextField.text andFpTag:fpTagTextField.text];
                
                return YES;
            }
            
            
            else if (textField.text.length<3 && textField.text.length>=1)
            {

                [checkMarkImageView setHidden:NO];
                
                [checkMarkImageView setImage:[UIImage imageNamed:@"invalid.png"]];
                
                isVerified=NO;
                
                return YES;

            }

            
            else
            {
            
                isVerified=NO;
                return YES;

            
            }
            
        }

        if (textField.tag==12)
        {
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];
            return YES;
            
            
        }
        
        
        if (textField.tag==13)
        {
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];
            return YES;
        }
    }
    
    
    
    
    
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==2)
    {
        
        
        [self performSelector:@selector(stepOneNextBtnClicked:) withObject:[NSNumber numberWithInt:textField.tag]];
        
    }
    
    else if (textField.tag==9)
    {
        
        [self performSelector:@selector(stepTwoNextBtnClicked:) withObject:[NSNumber numberWithInt:textField.tag]];
        
    }
    
    else if (textField.tag == 12)
    {
        [self performSelector:@selector(stepThreeNextBtnClicked:) withObject:[NSNumber numberWithInt:textField.tag]];
    }
    
    return NO;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
    self.domianChkImage.image = [UIImage imageNamed:@"domain_not_available.png"];
        self.domainChkLabel.text = @"Please enter a valid Sub-Domain";
    }
    else
    {
    
    if(textView==suggestedUriTextView)
    {
        VerifyUniqueNameController *uniqueNameController=[[VerifyUniqueNameController alloc]init];
        
        uniqueNameController.delegate=self;
        
        [uniqueNameController verifyWithFpName:businessNameTextField.text andFpTag:suggestedUriTextView.text];
    }
    }
    
    
}

#pragma Validate After Editing

-(void)validateTextFieldAfterEditing:(UITextField *)textField forView:(UIView *)currentSubview
{
    
    UIImageView *imgView=(UIImageView *)[currentSubview viewWithTag:textField.tag];
    
    if (textField.tag!=8 && textField.tag!=7)
    {

        if ([textField.text isEqualToString:@""] || textField.text.length<3)
        {
            [self changeBorderColorIf:NO forView:imgView];
            
            //        UIColor *color = [UIColor redColor];
            //
            //        UIFont *font=[UIFont fontWithName:@"Helvetica" size:14.0];
            
            if (textField.tag==1)
            {
                //textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter a category" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
            }
            
            
            if (textField.tag==2)
            {
                //textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter business name" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
            }
            
            
            //        if (textField.tag==7)
            //        {
            //            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter city name" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
            //        }
            
            if (textField.tag==12) {
                
                //            UIFont *font=[UIFont fontWithName:@"Helvetica" size:12.0];
                
                //            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter email address" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
                
            }
            
            if (textField.tag==13)
            {
                //            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter mobile number" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
            }
            
            
            
        }
        
        else
        {
            [self changeBorderColorIf:YES forView:imgView];
        }
    
    }
    
    
    else if (textField.tag==7)
    {
        if ([textField.text isEqualToString:@""] || textField.text.length<3)
        {
            [self changeBorderColorIf:NO forView:cityImageViewBg];
        }
    }
    
    else if (textField.tag==8)
    {
        if ([textField.text isEqualToString:@""])
        {
            [self changeBorderColorIf:NO forView:imgView];
            
            UIColor *color = [UIColor redColor];
            
            UIFont *font=[UIFont fontWithName:@"Helvetica" size:14.0];
            
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter this out" attributes:@{UITextAttributeTextColor: color,NSFontAttributeName:font}];
            
        }
        
        else if ([textField.text length]<6 || [textField.text length]>6)
        {
        
            [self changeBorderColorIf:NO forView:imgView];
            
            UIColor *color = [UIColor redColor];
            
            UIFont *font=[UIFont fontWithName:@"Helvetica" size:14.0];
            
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Must be equal to 6" attributes:@{UITextAttributeTextColor: color,NSFontAttributeName:font}];
        }
    
        else
        {
                
            [self changeBorderColorIf:YES forView:imgView];

        }
        

        
    }
    
    
    else if (textField.tag==12)
    {
        if (![self validateEmailWithString:textField.text])
        {
            [self changeBorderColorIf:NO forView:imgView];
        }
    }
    
    
    else if (textField.tag==13)
    {
        if (textField.text.length<9 || textField.text.length>15)
        {
            [self changeBorderColorIf:NO forView:imgView];
        }
    }
}


-(void)removeBorderFromTextFieldBeforeEditing:(UITextField *)textField forView:(UIView *)currentSubview
{
    if (textField.tag==7)
    {
        [self changeBorderColorIf:YES forView:cityImageViewBg];
    }
    
    else
    {
        UIImageView *imgView=(UIImageView *)[currentSubview viewWithTag:textField.tag];

        [self changeBorderColorIf:YES forView:imgView];
    }
}

#pragma Check WhiteSpaces Method

-(BOOL)textFieldHasWhiteSpaces:(NSString *)text
{
    NSString *rawString = text;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0)
    {
        return YES;
    }
    return NO;
}


#pragma Change BorderColor Method

-(void)changeBorderColorIf:(BOOL)isCorrect forView:(UIView *)imgView
{

    
    if ([imgView isKindOfClass:[UIImageView class]])
    {        
        imgView.layer.masksToBounds = NO;
        imgView.backgroundColor=[UIColor clearColor];
        imgView.layer.opaque=YES;

    }
    
    else
    {
        imgView.layer.masksToBounds = YES;
    }
    
    
    if (!isCorrect)
    {
        imgView.layer.cornerRadius = 6.0f;
        imgView.layer.needsDisplayOnBoundsChange=YES;
        imgView.layer.shouldRasterize=YES;
        [imgView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        imgView.layer.borderColor = [[UIColor redColor] CGColor];
        imgView.layer.borderWidth = 1.0f;
        
    }
    
    else
    {
        imgView.layer.cornerRadius = 6.0f;
        imgView.layer.needsDisplayOnBoundsChange=YES;
        imgView.layer.shouldRasterize=YES;
        [imgView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        imgView.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
        imgView.layer.borderWidth = 1.0f;
    }

}


-(void)changeBothFieldsText:(NSNotification*)notification
{
    
    if (fpTagTextField.text.length!=0)
    {
        annotationTextField.text=[NSString stringWithFormat:@"%@.nowfloats.com",fpTagTextField.text];
        [checkMarkImageView setHidden:YES];

    }
    
    else
    {
        annotationTextField.text=@"";
        [checkMarkImageView setHidden:YES];

    }
    
}


- (IBAction)stepOneNextBtnClicked:(id)sender
{

    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    [mixPanel track:@"register_stepOneButtonClicked"];
    
    [self.view endEditing:YES];
    
    NSMutableArray *failureMessages = [NSMutableArray array];
    
    NSArray *textFields = @[businessVerticalTextField,businessNameTextField];
    
    for (id object in textFields)
    {
        [failureMessages addObjectsFromArray:[object validate]];
    }
    
    if (failureMessages.count > 0 || [self textFieldHasWhiteSpaces:businessNameTextField.text] || [self textFieldHasWhiteSpaces:businessVerticalTextField.text])
    {
        
        if ( [self textFieldHasWhiteSpaces:businessNameTextField.text] || [self textFieldHasWhiteSpaces:businessVerticalTextField.text])
        {
            
            if ([self textFieldHasWhiteSpaces:businessNameTextField.text])
            {
                
                [self changeBorderColorIf:NO forView:businessNameBg];
                [self validateTextFieldAfterEditing:businessNameTextField forView:stepThreeSubView];
                
            }
            
            if ([self textFieldHasWhiteSpaces:businessVerticalTextField.text])
            {
                [self changeBorderColorIf:NO forView:businessVerticalBg];
                [self validateTextFieldAfterEditing:businessVerticalTextField forView:stepThreeSubView];
            }
            
            
            
        }
        
        else
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[failureMessages componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        }
    }

    else
    {
        CGRect frame = CGRectMake(320,mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
        
        [mainScrollView scrollRectToVisible:frame animated:YES];
        
    }
}


- (IBAction)stepTwoNextBtnClicked:(id)sender
{
    
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    [mixPanel track:@"register_stepTwoButtonClicked"];


    [self.view endEditing:YES];
    

     NSMutableArray *failureMessages = [NSMutableArray array];

     NSArray *textFields = @[cityNameTextField];
    
     for (id object in textFields)
     {
      [failureMessages addObjectsFromArray:[object validate]];
         
     }
    
    
    for (int i=0; i<textFields.count; i++)
    {
        
        UITextField *tf=(UITextField *)[textFields objectAtIndex:i];
        
        
        [self validateTextFieldAfterEditing:tf forView:stepTwoSubView];
        
        
        if (tf.text.length<3)
        {
        
            [self validateTextFieldAfterEditing:tf forView:stepTwoSubView];
            
        }
                
    }
    
    
    
     if (failureMessages.count > 0)
     {
         [self validateTextFieldAfterEditing:cityNameTextField forView:stepTwoSubView];
     }
    
     else
     {
         currentView=3;
        
        [self.view endEditing:YES];
         
         if (houseNumberTextField.text.length==0) {

             houseNumberTextField.text=@"";
             
         }
         
         if (streetNameTextField.text.length==0) {
             
             streetNameTextField.text=@"";
             
         }


         if (cityNameTextField.text.length==0) {
             
             cityNameTextField.text=@"";
             
         }

         
         if (stateNameTextField.text.length==0) {
             
             stateNameTextField.text=@"";
             
         }

         if (pincodeTextField.text.length==0) {
             
             pincodeTextField.text=@"";
             
         }

         if (countryNameTextField.text.length==0) {
             
             countryNameTextField.text=@"";
             
         }

         
         
         NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:houseNumberTextField.text,
              streetNameTextField.text,
              cityNameTextField.text,
              stateNameTextField.text,
              pincodeTextField.text,
              countryNameTextField.text, nil];
         
         NSArray *noEmptyStrings = [arr filteredArrayUsingPredicate:
                                    [NSPredicate predicateWithFormat:@"length > 0"]];
         
         addressString=[noEmptyStrings componentsJoinedByString:@","];

         /*
         if (noEmptyStrings.count>0)
         {
              addressString=[noEmptyStrings componentsJoinedByString:@","];
         }
         
         else
         {
             addressString=[noEmptyStrings objectAtIndex:0];
         }
         */
         
         
         
         nfActivity=[[NFActivityView alloc]init];
         
         nfActivity.activityTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
         
         nfActivity.activityTitle=@"Locating your Business";
         
         [nfActivity showCustomActivityView];
         
         GetFpAddressDetails *_verifyAddress=[[GetFpAddressDetails alloc]init];
         
         _verifyAddress.delegate=self;
         
         [_verifyAddress downloadFpAddressDetails:addressString];
    }
}


- (IBAction)stepThreeNextBtnClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"register_stepThreeButtonClicked"];

    [self.view endEditing:YES];
        
    NSMutableArray *failureMessages = [NSMutableArray array];
    
    NSArray *textFields = @[emailTextField,businessPhoneNumberTextField];
    
    for (id object in textFields)
    {
        [failureMessages addObjectsFromArray:[object validate]];
    }
    
    
    for (int i=0; i<textFields.count; i++)
    {
        
        UITextField *tf=(UITextField *)[textFields objectAtIndex:i];
        
        
        [self validateTextFieldAfterEditing:tf forView:stepThreeSubView];
        
        
        if ([tf validate])
        {
            
            [self validateTextFieldAfterEditing:tf forView:stepThreeSubView];
            
        }
        
    }
    

    
    if (failureMessages.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[failureMessages componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    else
    {
        nfActivity=[[NFActivityView alloc]init];

        nfActivity.activityTitleLabel.font =[UIFont fontWithName:@"Helvetica" size:10.0];
        
        nfActivity.activityTitle=@"Suggesting website domain";
        
        [nfActivity showCustomActivityView];
        
        NSDictionary *uploadDictionary;
        
        NSString *stateString;
        
        if (stateNameTextField.text.length==0)
        {
            stateString=countryNameTextField.text;
        }
        
        else
        {
            stateString=stateNameTextField.text;
        }
        
        if (cityNameTextField.text.length==0)
        {
            uploadDictionary=@{@"name":businessNameTextField.text,@"city":stateString,@"country":countryNameTextField.text,@"category":businessVerticalTextField.text,@"clientId":appDelegate.clientId};
        }
        
        else
        {
            uploadDictionary=@{@"name":businessNameTextField.text,@"city":cityNameTextField.text,@"country":countryNameTextField.text,@"category":businessVerticalTextField.text,@"clientId":appDelegate.clientId};
        }
        
    SuggestBusinessDomain *suggestController=[[SuggestBusinessDomain alloc]init];

    suggestController.delegate=self;
        
    [suggestController suggestBusinessDomainWith:uploadDictionary];

    suggestController =nil;     
     
    }

}

#pragma SuggestBusinessDomainDelegate

-(void)suggestBusinessDomainDidComplete:(NSString *)suggestedDomainString
{
    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    suggestedUriTextView.text=[suggestedDomainString lowercaseString];
    
    suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    
    CGRect frame = CGRectMake(960,mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    
    [mainScrollView scrollRectToVisible:frame animated:YES];
    
    
    if (suggestedDomainString.length==0)
    {
        UIAlertView *emptyAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"We could not suggest a domain for you.Why dont you give it a try ?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        emptyAlertView.tag=102;
        
        [emptyAlertView show];
    }
    
    
    else
    {
        if (suggestedUriTextView.text.length>30 && suggestedUriTextView.text.length<36)
        {
            suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:13.0];
        }
        
        if (suggestedUriTextView.text.length>36)
        {
            suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        }
    }

    
    
    
}


- (IBAction)stepFourNextBtnClicked:(id)sender
{
    
}

- (IBAction)stepOneDismissBtnClicked:(id)sender
{
    
    [self.view endEditing:YES];
}


- (IBAction)stepTwoKeyBoardShouldReturn:(id)sender
{
    self.view.frame = CGRectMake(0, 0, 320, viewHeight);
    [[self view] endEditing:YES];
}


- (IBAction)stepThreeKeyBoardShouldReturn:(id)sender
{
    [[self view] endEditing:YES];

}


- (IBAction)categorySubViewBtnClicked:(id)sender
{

    
    [self showPickerCategory];
    
}


- (IBAction)mapSaveBtnClicked:(id)sender
{
    
    [mapView removeAnnotations:mapView.annotations];

    [mapSubView setHidden:YES];
    [mapView setHidden:YES];
    [stepTwoSubView setHidden:NO];
    
    [UIView transitionWithView:_container
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [_container addSubview:stepTwoSubView];
                    }
                    completion:^(BOOL finished)
     {
         
          [mapSubView setHidden:YES];
          [stepThreeButton setBackgroundImage:buttonBackGroundImage forState:UIControlStateNormal];
          [stepThreeButton  setUserInteractionEnabled:YES];
          [stepThreeButton setEnabled:YES];
          
          if (stepThreeSubView.frame.origin.x==-320)
          {
          [stepThreeSubView setFrame:CGRectMake(320, 0,stepThreeSubView.frame.size.width,stepThreeSubView.frame.size.height)];
          }
          
          
          
          [UIView transitionWithView:_container
          duration:.50f
          options:UIViewAnimationOptionCurveEaseIn
          animations:^
          {
          [stepThreeSubView setFrame:CGRectMake(0, 0, stepThreeSubView.frame.size.width,  stepThreeSubView.frame.size.height)];
          [stepTwoSubView setFrame:CGRectMake(-320,0, stepTwoSubView.frame.size.width,  stepTwoSubView.frame.size.height)];
          
          
          } completion:nil];


     }];
}


- (IBAction)mapCancelBtnClicked:(id)sender
{

    
    [mapView removeAnnotations:mapView.annotations];

    [mapSubView setHidden:YES];
    [stepTwoSubView setHidden:NO];
    
    [UIView transitionWithView:_container
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [_container addSubview:stepTwoSubView];
                    }
                    completion:^(BOOL finished)
     {
         
         storeLatitude=0;
         storeLongitude=0;
     }];

}


- (IBAction)stepFourKeyBoardShouldReturn:(id)sender
{
    
    
    [self.view endEditing:YES];
}


- (IBAction)countryBtnClicked:(id)sender
{
    self.view.frame = CGRectMake(0, 0, 320, viewHeight);
    // [stepTwoScrollView setContentSize:CGSizeMake(self.view.frame.size.width,548)];
    
    [self.view endEditing:YES];

   [self.view addSubview:countryPickerSubView];
    
    
    
}


- (IBAction)countryCodeBtnClicked:(id)sender
{
    
    
    [self.view addSubview:countryCodePickerSubView];
    
    /*
     [self.view endEditing:YES];
     [stepFourSubVIew setHidden:YES];
     [countryCodeSubView setHidden:NO];

    [UIView transitionWithView:_container
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [_container addSubview:countryCodeSubView];
                    }
                    completion:^(BOOL finished)
     {
         
     }];
*/
}


#pragma Create Website

- (IBAction)createWebSiteBtnClicked:(id)sender
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Create Website"];

     [self.view endEditing:YES];
     
     if (suggestedUriTextView.text.length==0)
     {
     
         UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Store domain cannot be empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

         [alertView show];
         
         alertView=nil;
     
     }
     
     else
     {
         
         if (pincodeTextField.text.length==0)
         {
             pincodeTextField.text=@"";
         }
         
         if (cityNameTextField.text.length==0)
         {
             cityNameTextField.text=@"";
         }
         
         if (stateNameTextField.text.length==0 )
         {
             stateNameTextField.text=@"";
         }
         
                  
         
         
     NSMutableDictionary *regiterDetails;
     
     regiterDetails=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
     appDelegate.clientId,@"clientId",
     suggestedUriTextView.text,@"tag",
     [NSString stringWithFormat:@""],@"contactName",
     businessNameTextField.text,@"name",
     [NSString stringWithFormat:@""],@"desc",
    [NSString stringWithFormat:@"%@",cityNameTextField.text],@"city",
    [NSString stringWithFormat:@"%@",pincodeTextField.text],@"pincode",
     countryNameTextField.text,@"country",
     addressString,@"address",
     businessPhoneNumberTextField.text,@"primaryNumber",
     [NSString stringWithFormat:@"%@",countryCodeTextField.text],@"primaryNumberCountryCode",
     [NSString stringWithFormat:@"%@",emailTextField.text],@"email",
     [NSString stringWithFormat:@""],@"Uri",
     [NSString stringWithFormat:@""],@"fbPageName",
     businessVerticalTextField.text,@"primaryCategory",
     [NSString stringWithFormat:@"%f",storeLatitude],@"lat",
     [NSString stringWithFormat:@"%f",storeLongitude],@"lng",
     nil];
              
     nfActivity=[[NFActivityView alloc]init];

     nfActivity.activityTitle=@"Creating";
     
     [nfActivity showCustomActivityView];
         
     SignUpController *signUpController=[[SignUpController alloc]init];
     
     signUpController.delegate=self;
         
     [signUpController withCredentials:regiterDetails];
     
     }
     
}

- (IBAction)stepOneBackBtnClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];

    [mixPanel track:@"dropAt_FirstRegistrationScreen"];
    
    //dropAt_SecondRegistrationScreen
    PopUpView *visitorsPopUp=[[PopUpView alloc]init];
    visitorsPopUp.delegate=self;
    visitorsPopUp.descriptionText=@"We hate to see you go. You are missing out on something special for your business. Give it another shot?";
    visitorsPopUp.titleText=@"Are you sure?";
    visitorsPopUp.tag=101;
    visitorsPopUp.popUpImage=[UIImage imageNamed:@"cancelregister.png"];
    visitorsPopUp.successBtnText=@"GOT TO GO";
    visitorsPopUp.cancelBtnText=@"Cancel";
    [visitorsPopUp showPopUpView];
}

- (IBAction)stepTwoBackBtnClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"dropAt_SecondRegistrationScreen"];
    
    CGRect frame = CGRectMake(0,mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    
    [mainScrollView scrollRectToVisible:frame animated:YES];

}

- (IBAction)stepThreeBackBtnClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"dropAt_ThirdRegistrationScreen"];

    CGRect frame = CGRectMake(320,mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    
    [mainScrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)stepFourBackBtnClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"dropAt_FourthRegistrationScreen"];

    CGRect frame = CGRectMake(640,mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    
    [mainScrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)signUpOkBtnClicked:(id)sender
{
    [cancelRegistrationSubview removeFromSuperview];
}

- (IBAction)signUpCancelBtnClicked:(id)sender
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Cancel SignUp"];

    [cancelRegistrationSubview removeFromSuperview];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goToPrevTextFieldBtnClicked:(id)sender
{
    int tag = tfTag;
    
    int prevTag;
    
    switch (tag)
    {
        case 4:
            prevTag= 3;
            break;
        case 7:
            prevTag= 4;
            break;
        case 8:
            prevTag= 7;
            break;
        case 9:
            prevTag= 8;
            break;
    }
    
    UITextField *currentTextField=(UITextField*)[self.view viewWithTag:tfTag];
    UITextField *prevTextField = (UITextField *)[self.view viewWithTag:prevTag];
    
    [currentTextField resignFirstResponder];
    [prevTextField becomeFirstResponder];
    
    if (viewHeight==480)
    {
        
    }
    else
    {
        if (prevTag == 7)
        {
            [self animateScrollView: prevTextField up:NO movementDistance:-30];
        }
        
        else if (prevTag == 8)
        {
            [self animateScrollView: prevTextField up:NO movementDistance:-35];
        }
        
        else if (prevTag == 9)
        {
            [self animateScrollView: prevTextField up:NO movementDistance:50];
        }
    }

    
    tfTag = prevTag;

}

- (IBAction)goToNextTextField:(id)sender
{
    int tag = tfTag;
    
    int nextTag;

    switch (tag)
    {
        case 3:
            nextTag= 4;
            break;
        case 4:
            nextTag= 7;
            break;
        case 7:
            nextTag= 8;
            break;
        case 8:
            nextTag= 9;
            break;
        case 9:
            nextTag= 10;
            break;
    }
    
    
    
    UITextField *currentTextField=(UITextField*)[self.view viewWithTag:tfTag];
    UITextField *nextTextField = (UITextField *)[self.view viewWithTag:nextTag];
    
    [currentTextField resignFirstResponder];
    [nextTextField becomeFirstResponder];
    
    
    if (viewHeight==480)
    {
        
    }
    else
    {
        if (nextTag == 7)
        {
            [self animateScrollView: nextTextField up:YES movementDistance:50];
        }
        
        else if (nextTag == 8)
        {
            [self animateScrollView: nextTextField up:YES movementDistance:100];
        }
        
        else if (nextTag == 9)
        {
            [self animateScrollView: nextTextField up:YES movementDistance:100];
            
        }
        else if(nextTag == 10)
        {
            self.view.frame = CGRectMake(0, 0, 320, viewHeight);
        }
    }
    
    

    
    
    
    
    tfTag = nextTag;
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            if([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0)
            {
               [stepTwoScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else
            {
               [stepTwoScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            
            
            
            
        }
        if(result.height == 568)
        {
            
            
            self.view.frame = CGRectMake(0, 0, 320, viewHeight);
            
            
        }
    }
    

    
    [self.view endEditing:YES];
}




#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    CGFloat pageWidth = mainScrollView.frame.size.width;
    
    int page = floor((mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    scrollPageControl.currentPage = page;
    
}

/*
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1001 && scrollView.contentOffset.x == 320.0 && !isAddressFetched)
    {
        locatingAV = [[NFActivityView alloc]init];
        locatingAV.activityTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        locatingAV.activityTitle = @"Locating your \n business address";
        [locatingAV showCustomActivityView];
        
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
        [locationManager stopUpdatingLocation];
        CLLocation *location = [locationManager location];
        
        float longitude=location.coordinate.longitude;
        float latitude=location.coordinate.latitude;
        
        NSLog(@"dLongitude : %f", longitude);
        NSLog(@"dLatitude : %f", latitude);
        
        LocateBusinessAddress *locateAddress = [[LocateBusinessAddress alloc] init];
        
        [locateAddress findAddressWithLatitude:longitude andLongitude:latitude];
        
        
        
    }
}
*/

#pragma CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    [locatingAV hideCustomActivityView];
}


#pragma UIPickerView


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)_pickerView;
{

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)_pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (_pickerView.tag==1)
    {
        
        return categoryArray.count;
        
    }
    
    if (_pickerView.tag==2)
    {
        
        return countryListArray.count;
    }
    
    else
    {
        return countryCodeArray.count;
        
    }
    
}


- (NSString *)pickerView:(UIPickerView *)_pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    NSString *text;
    
    if (_pickerView.tag==1)
    {
    text=[[[categoryArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    }
    
    if (_pickerView.tag==2)
    {
    text=[[[countryListArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    }
    
    
    if (_pickerView.tag==3) {
        
    text=[[[countryListArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
        
    }
    
    return text;

}


- (void)pickerView:(UIPickerView *)_pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{

    NSString *text;
    
    NSString *codeText;
    
    if (_pickerView.tag==1)
    {
        text=[[[categoryArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    }
    
    if (_pickerView.tag==2)
    {
        text=[[[countryListArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
        codeText=[[[countryCodeArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    }
    
    
    if (_pickerView.tag==3) {
        
        text=[[[countryCodeArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
        codeText=[[[countryCodeArray objectAtIndex: row] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];

    }
    

    categoryString=[NSString stringWithFormat:@"%@",text];
    countryCodeString=[NSString stringWithFormat:@"+%@",codeText];
    
}


#pragma EmailValidation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma FpCategoryDelegate

-(void)fpCategoryDidFinishDownload:(NSArray *)downloadedArray
{

    
    if (downloadedArray!=NULL)
    {
        [categoryArray addObjectsFromArray:downloadedArray];
        
    }
    
    
    else
    {
        [pickerView setHidden:YES];
        [pickerViewSubView removeFromSuperview];
        
    }
    
}

-(void)showPickerCategory
{
   // [categoryArray removeAllObjects];
    
    [self.view endEditing:YES];
    
    [self.view addSubview:pickerViewSubView];
    
    //[downloadingCategoriesActivityView setHidden:NO];
    
   // [pickerView setHidden:YES];

    
    
    [pickerView setHidden:NO];
    [downloadingCategoriesActivityView setHidden:YES];
    [categoryPickerView reloadAllComponents];
    
}

- (IBAction)categoryDoneBtnClicked:(id)sender
{
    [pickerViewSubView removeFromSuperview];
    
    
    if (categoryString.length==0)
    {
        
        categoryString=[categoryArray objectAtIndex:0];
        
    }
    
    businessVerticalTextField.text=[[categoryString lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    
    [self changeBorderColorIf:YES forView:businessVerticalBg];

    categoryString=@"";
}

- (IBAction)categoryCancelBtnClicked:(id)sender
{
    [pickerViewSubView removeFromSuperview];
    
}

- (IBAction)countryDoneBtnClicked:(id)sender
{
    [countryPickerSubView removeFromSuperview];

    if (countryCodeString.length==0)
    {
        
        categoryString=[countryListArray objectAtIndex:0];
        countryCodeString=[countryCodeArray objectAtIndex:0];
    }
    
    countryNameTextField.text=[[categoryString lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    countryCodeTextField.text=[[countryCodeString lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    categoryString=@"";
    countryCodeString=@"";
}

- (IBAction)countryCancelBtnClicked:(id)sender
{
    
    [countryPickerSubView removeFromSuperview];

}

- (IBAction)endEditingButtonPressed:(id)sender
{
    
    [self.view endEditing:YES];
}

- (IBAction)countryCodeDoneBtnClicked:(id)sender
{
    
    [countryCodePickerSubView removeFromSuperview];
    
    
    if (countryCodeString.length==0)
    {
        
        countryCodeString=[countryCodeArray objectAtIndex:0];
        
    }
    
    countryCodeTextField.text=countryCodeString;
    countryCodeString=@"";

    
}


- (IBAction)countryCodeCancelBtnClicked:(id)sender
{
    
    [countryCodePickerSubView removeFromSuperview];

}


- (IBAction)changeStoreTag:(id)sender
{
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"btnclicked_changeStoreTag"];
    
    [self changeStoreTagBtnClicked];
    
}


-(void)changeStoreTagBtnClicked
{

    ChangeStoreTagViewController *storeTagController=[[ChangeStoreTagViewController alloc]initWithNibName:@"ChangeStoreTagViewController" bundle:nil ];
    
    storeTagController.delegate=self;
    
    storeTagController.fpName=businessNameTextField.text;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeTagController];
    
    // You can even set the style of stuff before you show it
    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // And now you want to present the view in a modal fashion
    [self presentViewController:navigationController animated:YES completion:nil];

}

-(void)fpCategoryDidFailWithError
{

    [pickerViewSubView removeFromSuperview];

}


#pragma VerifyUniqueNameDelegate


-(void)verifyUniqueNameDidComplete:(NSString *)responseString
{

   
    
    if ([[responseString lowercaseString] isEqualToString:suggestedUriTextView.text])
    {
//        [checkMarkImageView setHidden:NO];
//        
//        isVerified=YES;
//        
//        [stepThreeNextButton setEnabled:YES]; 
//        
//        [verifyValidFpActivityIndicator stopAnimating];
//        
//        [checkMarkImageView setImage:[UIImage imageNamed:@"valid.png"]];
        
        
        
        self.domianChkImage.image = [UIImage imageNamed:@"domain_available.png"];
        self.domainChkLabel.text = @"Chosen Sub-Domain is Available";
        
    }
    
    
    else
    {
//        [checkMarkImageView setHidden:NO];
//        
//        isVerified=NO;
//        
//        [verifyValidFpActivityIndicator stopAnimating];
//        
//        [checkMarkImageView setImage:[UIImage imageNamed:@"invalid.png"]];

        self.domianChkImage.image = [UIImage imageNamed:@"domain_not_available.png"];
        self.domainChkLabel.text = @"Chosen Sub-Domain is not Available";
    
    }
    

}


-(void)verifyuniqueNameDidFail:(NSString *)responseString
{
    isVerified=NO;
    
    [verifyValidFpActivityIndicator setHidden:YES];

    [checkMarkImageView setHidden:YES];

}


#pragma FpAddressDelegate

-(void)fpAddressDidFetchLocationWithLocationArray:(NSArray *)locationArray
{
    
    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    storeLatitude=[[locationArray valueForKey:@"lat"] doubleValue];
    storeLongitude=[[locationArray valueForKey:@"lng"] doubleValue];

    CGRect frame = CGRectMake(640,mainScrollView.frame.origin.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
    
    [mainScrollView scrollRectToVisible:frame animated:YES];
    
}


-(void)fpAddressDidFail
{
/*
    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    UIAlertView *noLocationAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"We could not point on the map with the given address. Please enter a valid address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [noLocationAlertView show];
    
    noLocationAlertView=nil;
*/
    
    GetFpAddressDetails *_verifyAddress=[[GetFpAddressDetails alloc]init];
    
    _verifyAddress.delegate=self;
    
    houseNumberTextField.text=@"";
    streetNameTextField.text=@"";
    cityNameTextField.text=@"";
    stateNameTextField.text=@"";
    pincodeTextField.text=@"";
    
    addressString = countryNameTextField.text;
    
    [_verifyAddress downloadFpAddressDetails:addressString];    
}



#pragma MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView1 viewForAnnotation: (id<MKAnnotation>) annotation
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mappin.png"]];

    MKAnnotationView *pin = (MKAnnotationView *) [mapView1 dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    
    
    if (pin == nil)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"];
    }
    
    else
    {
        pin.annotation = annotation;
    }
    
    pin.draggable = YES;
    pin.clipsToBounds=YES;
    pin.contentMode=UIViewContentModeScaleAspectFit;
    pin.image=imageView.image;
    
    return pin;
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        
        storeLatitude=droppedAt.latitude;
        storeLongitude=droppedAt.longitude;
        
    }
}


#pragma UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView.tag==1)
    {
        
    return categoryArray.count;
        
    }
    
    if (tableView.tag==2)
    {
    
        return countryListArray.count;
    }
    
    else
    {
        return countryCodeArray.count;

    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    NSString *identifier=@"stringIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
        
    if (tableView.tag==1)
    {        
    cell.textLabel.text=[[[categoryArray objectAtIndex:[indexPath row]] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    }
    
    if (tableView.tag==2)
    {
        cell.textLabel.text=[[[countryListArray objectAtIndex:[indexPath row]] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
    }
    
    
    if (tableView.tag==3) {
    
        cell.textLabel.text=[[[countryListArray objectAtIndex:[indexPath row]] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
        
    }
    
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    cell.textLabel.textColor=[UIColor colorWithHexString:@"464646"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    if (tableView.tag==1)
    {
        [categorySubView setHidden:YES];
        [stepOneSubView setHidden:NO];
        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepOneSubView];
                        }
                        completion:^(BOOL finished)
         {
             businessVerticalTextField.text=[[[categoryArray objectAtIndex:[indexPath row]] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];

         }];
        
    }    
    
    if (tableView.tag==2)
    {
    
        [listOfStatesSubView setHidden:YES];
        [stepTwoSubView setHidden:NO];

        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepTwoSubView];
                        }
                        completion:^(BOOL finished)
         {
             countryNameTextField.text=[[[countryListArray objectAtIndex:[indexPath row]] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
             
         }];

    
    }
    
    
    if (tableView.tag==3)
    {
    
        [stepFourSubVIew setHidden:NO];
        [countryCodeSubView setHidden:YES];
        
        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepFourSubVIew];
                        }
                        completion:^(BOOL finished)
         {
             countryCodeTextField.text=[[[countryCodeArray objectAtIndex:[indexPath row]] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords];
             
         }];

    }
    
    
}


-(void)reloadTableView
{
    [categoryTableView reloadData];
}



#pragma SignUpControllerDelegate

-(void)signUpDidSucceedWithFpId:(NSString *)responseString
{
    [self showBizMessageView:responseString];
}


-(void)signUpDidFailWithError
{
    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    UIAlertView *fpCreationFailError=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Sorry something went wrong while creating your website" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [fpCreationFailError show];
    
    fpCreationFailError=nil;

}


-(void)showBizMessageView:(NSString *)responseString
{
    
    createdFpName = responseString;
    
    NSUserDefaults  *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:responseString  forKey:@"userFpId"];
    
    [userDefaults synchronize];
    
    /*Get all the messages and store details*/
    
    GetFpDetails *getDetails=[[GetFpDetails alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails fetchFpDetail];
}


#pragma updateDelegate

-(void)downloadFinished
{
    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    if (BOOST_PLUS)
    {
        PopUpView *buyDomainPopUp = [[PopUpView alloc]init];
        buyDomainPopUp.delegate=self;
        buyDomainPopUp.tag=102;
        buyDomainPopUp.successBtnText=@"Book Now";
        buyDomainPopUp.cancelBtnText=@"May be Later";
        buyDomainPopUp.titleText = @"Book your Domain";
        buyDomainPopUp.descriptionText = @"Your NowFloats website is now ready.You can now dress it up with your own domain name reflecting your business identity. Choose your free .com or .net now.";
        buyDomainPopUp.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        buyDomainPopUp.popUpImage=[UIImage imageNamed:@"storeDomain2.png"];
        [buyDomainPopUp showPopUpView];
    }
    
    else
    {
        [self navigateBizMessageView];
    }
}


-(void)downloadFailedWithError
{

    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    UIAlertView *downloadAlertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong during download. Please kill the application and click Login In" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
    
    [downloadAlertView show];

    downloadAlertView = nil;
    
}



#pragma ChangeStoreTagDelegate

-(void)changeStoreTagComplete:(NSString *)strTag
{
    
    [suggestedUriTextView setText:[strTag lowercaseString]];
    
    
    suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    
    
    if (suggestedUriTextView.text.length>30 && suggestedUriTextView.text.length<36)
    {
        
        suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:13.0];
        
    }
    
    if (suggestedUriTextView.text.length>36) {
        
        suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        
    }
    
    
}





#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (alertView.tag==101)
    {
        
        if (buttonIndex==1)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    
    }
    
    
    if (alertView.tag==102) {

        
        if (buttonIndex==0)
        {
            
            [self changeStoreTagBtnClicked];

            
        }
        
        
    }
    
    
}


- (BOOL)isEmptyOrNull:(NSString*)string
{
    if (string)
    {
        if ([string isEqualToString:@""])
        {
            return YES;
        }
        return NO;
    }
    return YES;
}


-(BOOL)isLessThan:(int)length forString:(NSString *)string
{
    
    if (string)
    {
        if (string.length<length && string.length!=0)
        {
            return YES;
        }
        return NO;
    }
    
    return YES;
}


- (void)animateTextField:(UITextField*)textField up:(BOOL)up movementDistance:(int)dist
{
    const int movementDistance = dist; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)animateScrollView:(UITextField*)textField up:(BOOL)up movementDistance:(int)dist
{
    const int movementDistance = dist;
    
    int movement = (up ? movementDistance : -movementDistance);

    [stepTwoScrollView setContentOffset:CGPointMake(0,movement) animated:YES];

}


#pragma PopUpDelegate

-(void)successBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue]==101)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Cancel SignUp"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    else if ([[sender objectForKey:@"tag"] intValue]==102)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"goto_domainPurchasefromSignUp"];
        
        DomainSelectViewController *selectController=[[DomainSelectViewController alloc]initWithNibName:@"DomainSelectViewController" bundle:Nil];
        
        selectController.isFromOtherViews = YES;
        
        isFromDomainSelect = YES;
        
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:selectController];
        
        [self presentViewController:navController animated:YES completion:nil];
    }
}


-(void)cancelBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue]==102)
    {        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"cancel_domainPurchasefromSignUp"];

        NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag = appDelegate.storeTag;
        
        if ([userSetting objectForKey:@"isDomainPurchaseCancelled"]==nil)
        {
            [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:NO] forKey:@"isDomainPurchaseCancelled"];
        }
        
        [self navigateBizMessageView];
    }
}


#pragma RegisterChannel

-(void)setRegisterChannel
{
    RegisterChannel *regChannel=[[RegisterChannel alloc]init];
    
    regChannel.delegate=self;
    
    [regChannel registerNotificationChannel];
}

#pragma RegisterChannelDelegate

-(void)channelDidRegisterSuccessfully
{
}

-(void)channelFailedToRegister
{
}

-(void)navigateBizMessageView
{    
    @try
    {
        [self setRegisterChannel];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel identify:appDelegate.storeTag]; //username
        
        NSDate *createdDate = [NSDate date];
        
        NSDictionary *specialProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                           appDelegate.storeEmail, @"$email",
                                           appDelegate.businessName, @"$name",
                                           createdDate,@"$Created On",
                                           nil];
        
        [mixpanel.people set:specialProperties];
        [mixpanel.people addPushDeviceToken:appDelegate.deviceTokenData];
        
    
        
    }
    
    @catch (NSException *e){}

    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    fHelper.userFpTag=appDelegate.storeTag;
    
    [fHelper createUserSettings];
    
    [fHelper updateUserSettingWithValue:[NSDate date] forKey:@"1stSignUpDate"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *startTime = [NSDate date];
    
    [userDefaults setObject:startTime forKey:@"appStartDate"];
    
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"showTutorialView"];
    
    [AarkiContact registerEvent:@"26D69ACEA3F720D5OU"];

    
//    BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
//    
//    frontController.isLoadedFirstTime=YES;
//    
//    [self.navigationController pushViewController:frontController animated:YES];

    
    RIATipsController *ria = [[RIATipsController alloc]initWithNibName:@"RIATipsController" bundle:nil];
    [self presentViewController:ria animated:YES completion:nil];
    
    
   // frontController=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)viewDidUnload
{
    stepOneSubView = nil;
    stepTwoSubView = nil;
    stepTwoScrollView = nil;
    stepOneNextButton = nil;
    stepThreeNextButton = nil;
    stepFourSubVIew = nil;
    stepFourNextButton = nil;
    stepOneButton = nil;
    stepTwoButton = nil;
    stepThreeButton = nil;
    stepFourButton = nil;
    businessVerticalTextField = nil;
    businessNameTextField = nil;
    houseNumberTextField = nil;
    streetNameTextField = nil;
    localityTextField = nil;
    landMarkTextField = nil;
    cityNameTextField = nil;
    pincodeTextField = nil;
    fpTagTextField = nil;
    annotationTextField = nil;
    checkMarkImageView = nil;
    verifyValidFpActivityIndicator = nil;
    categorySubView = nil;
    categoryTableView = nil;
    categoryActivityIndicator = nil;
    countryNameTextField = nil;
    stateNameTextField = nil;
    mapView = nil;
    mapSubView = nil;
    businessPhoneNumberTextField = nil;
    ownerNameTextField = nil;
    countryCodeTextField = nil;
    countryCodeBg = nil;
    listOfStatesTableView = nil;
    listOfStatesSubView = nil;
    businessDescriptionTextField = nil;
    countryCodesTableView = nil;
    countryCodeSubView = nil;
    stepControllerSubView = nil;
    navBar = nil;
    businessNameBg = nil;
    businessVerticalBg = nil;
    emailTextField = nil;
    pickerViewSubView = nil;
    pickerView = nil;
    categoryPickerView = nil;
    downloadingCategoriesActivityView = nil;
    houseNumberImageViewBg = nil;
    streetNameImageViewBg = nil;
    cityImageViewBg = nil;
    pinCodeImageViewBg = nil;
    stateImageViewBg = nil;
    countryImageViewBg = nil;
    countryPickerSubView = nil;
    countryPickerViewContainer = nil;
    countryPickerView = nil;
    emailAddressImageViewBg = nil;
    mobileNumberImageViewBg = nil;
    countryCodeImageViewBg = nil;
    countryCodePickerSubView = nil;
    countryCodePickerContainer = nil;
    suggestedUriImageViewBg = nil;
    suggestedUriTextView = nil;
    [super viewDidUnload];
}


@end
