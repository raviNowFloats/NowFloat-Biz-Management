//
//  BusinessContactViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessContactViewController.h"
#import "SWRevealViewController.h"
#import "UpdateStoreData.h"
#import "UIColor+HexaString.h"
#import "QuartzCore/QuartzCore.h"
#import "DBValidator.h"
#import "Mixpanel.h"
#import "NFActivityView.h"
#import "BusinessContactCell.h"
#import "AlertViewController.h"
#import "UIColor+HexaString.h"
#define EMAIL_REGEX @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define	PASSWORD_LENGTH 100

@interface BusinessContactViewController ()<updateStoreDelegate>
{
    NFActivityView *nfActivity;
    NSString *countryCodeVal;
}
@end

@implementation BusinessContactViewController
@synthesize storeContactArray ,successCode,isFromOtherViews;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ContactInfoTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.ContactInfoTable.bounces=NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            contactScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+146);
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            contactScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+58);
            
        }
    }
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    [self.view setBackgroundColor:[UIColor colorFromHexCode:@"dedede"]];
    
    UITapGestureRecognizer *removeKey = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyboard)];
    
    removeKey.numberOfTapsRequired = 1;
    removeKey.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:removeKey];
    
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    nfActivity=[[NFActivityView alloc]init];
    
    nfActivity.activityTitle=@"Updating";
    
    
    isContact1Changed=NO;
    isContact2Changed=NO;
    isContact3Changed=NO;
    isEmailChanged=NO;
    isWebSiteChanged=NO;
    isFBChanged=NO;
    
    storeContactArray=[[NSMutableArray alloc]init];
    _contactsArray=[[NSMutableArray alloc]init];
    contactNameString1=[[NSString alloc]init];
    contactNameString2=[[NSString alloc]init];
    contactNameString3=[[NSString alloc]init];
    keyboardInfo=[[NSMutableDictionary alloc]init];
    
    
    
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
    
    for (NSString *countryCode in countryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country];
    }
    
    NSDictionary *codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    
    NSString *countryCode = [codeForCountryDictionary objectForKey:[appDelegate.storeDetailDictionary objectForKey:@"Country"]];
    
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
    
    countryCodeVal = [NSString stringWithFormat:@"+%@",[dictDialingCodes objectForKey:countryCode]];
    
    
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    if (version.floatValue<7.0) {
        
        self.navigationController.navigationBarHidden=NO;
       
        self.navigationItem.title=@"Contact Information";
        
    }
    
    else
    {
        self.navigationItem.title=@"Contact Information";
    }
    
    
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;
    
    
    
    /*Store Contact Array*/
    
    [storeContactArray addObjectsFromArray:appDelegate.storeContactArray];
    
    if ([storeContactArray count]==1)
    {
        
        contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
        
        if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [mobileNumTextField setPlaceholder:@"Primary Phone Number"];
            
            contactNumberOne=@"No Description";
            
            
        }
        
        else
        {
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
            
            contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
            
        }
        
        [landlineNumTextField setPlaceholder:@"Alternate Phone Number 1"];
        
        [secondaryPhoneTextField setPlaceholder:@"Alternate Phone Number 2"];
        
        
        contactNumberTwo=@"No Description";
        contactNumberThree=@"No Description";
        
        
        contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
        
    }
    
    
    
    
    if ([storeContactArray count]==2)
    {
        
        contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
        contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
        
        if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [mobileNumTextField setPlaceholder:@"Primary Phone Number"];
            
            contactNumberOne=@"No Description";
            
            
        }
        
        else
        {
            
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
            
            contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
            
            
        }
        
        
        if ([[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [landlineNumTextField setPlaceholder:@"Alternate Phone Number 1"];
            
            contactNumberTwo=@"No Description";
            
        }
        
        else
        {
            
            [landlineNumTextField setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
            
            contactNumberTwo=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ];
            
            
        }
        
        
        [secondaryPhoneTextField setPlaceholder:@"Alternate Phone Number 2"];
        contactNumberThree=@"No Description";
        
    }
    
    
    if ([storeContactArray count]==3)
    {
        
        
        contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName"];
        contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
        contactNameString3=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactName"];
        
        
        
        
        if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [mobileNumTextField setPlaceholder:@"Primary Phone Number"];
            
            contactNumberOne=@"No Description";
            
            
        }
        
        else
        {
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
            
            contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
            
        }
        
        
        if ([[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ] length]==0)
        {
            [landlineNumTextField setPlaceholder:@"Alternate Phone Number 1"];
            contactNumberTwo=@"No Description";
            
        }
        else
        {
            [landlineNumTextField setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
            
            
            contactNumberTwo=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ];
            
        }
        
        
        
        
        
        if ([[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ] length]==0)
        {
            [secondaryPhoneTextField setPlaceholder:@"Alternate Phone Number 2"];
            contactNumberThree=@"No Description";
            
            
        }
        else
        {
            [secondaryPhoneTextField setText:[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]];
            
            contactNumberThree=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ];
            
        }
        
    }
    
    /*Set the TextFields for Email,website and facebook here*/
    
    
    if ([appDelegate.storeWebsite isEqualToString:@"No Description"])
    {
        [websiteTextField setPlaceholder:@"Website URL"];
    }
    
    
    else
    {
        [websiteTextField setText:appDelegate.storeWebsite];
    }
    
    
    if ([appDelegate.storeEmail isEqualToString:@""])
    {
        [emailTextField setPlaceholder:@"Email"];
    }
    
    
    else
    {
        [emailTextField setText:appDelegate.storeEmail];
    }
    
    if ([appDelegate.storeFacebook isEqualToString:@"No Description"])
    {
        
        
        
    }
    
    else
    {
        [facebookTextField setText:appDelegate.storeFacebook];
        
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView)
                                                 name:@"update" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFailView)
                                                 name:@"updateFail" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)                                            name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unPlaceRightBarButton) name:@"RemoveRightBarButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeRightBarButton) name:@"UnHideRightBarButton" object:nil];
    
    
    DBValidationEmailRule *emailTextFieldRule=[[DBValidationEmailRule alloc]initWithObject:emailTextField
                                                                                   keyPath:@"text"
                                                                            failureMessage:@"Enter Vaild Email Id"];
    
    [emailTextField addValidationRule:emailTextFieldRule];
    
    DBValidationStringLengthRule *phoneTextFieldRule1 = [[DBValidationStringLengthRule alloc] initWithObject:landlineNumTextField keyPath:@"text" minStringLength:0 maxStringLength:12 failureMessage:@"Mobile number should be between 0 to 12 digits"];
    
    
    DBValidationStringLengthRule *phoneTextFieldRule2 = [[DBValidationStringLengthRule alloc] initWithObject:secondaryPhoneTextField keyPath:@"text" minStringLength:0 maxStringLength:12 failureMessage:@"Mobile number should be between 0 to 12 digits"];
    
    [landlineNumTextField addValidationRule:phoneTextFieldRule1];
    
    [secondaryPhoneTextField addValidationRule:phoneTextFieldRule2];
    
    [self setUpButton];
}

-(void)removeKeyboard
{
    [self.view endEditing:YES];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BusinessContactCell *cell = [self.ContactInfoTable dequeueReusableCellWithIdentifier:@""];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"BusinessContactCell" bundle:nil] forCellReuseIdentifier:@"businessContact"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"businessContact"];
    }
    
    cell.contactText.delegate = self;
    cell.contactText1.delegate = self;
    
    
    if(indexPath.section==0)
    {
        
        cell.countryCodeLabel.text = countryCodeVal;
        if(indexPath.row==0)
            cell.countryCodeLabel.hidden = NO;
        cell.contactText1.hidden = YES;
        {
            
            
            cell.contactLabel.text =@"Primary Number  ";
            cell.contactText.tag = 200;
            
            if ([storeContactArray count]==1)
            {
                
                contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
                
                if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
                {
                    
                    
                    contactNumberOne=@"No Description";
                    
                    
                }
                
                else
                {
                    [cell.contactText setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
                    
                    contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
                    
                    if(indexPath.row==1)
                    {
                        [cell.contactText setText:@""];
                    }
                    if(indexPath.row==2)
                    {
                        [cell.contactText setText:@""];
                    }
                }
                
                
            }
            if ([storeContactArray count]==2)
            {
                
                contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
                contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
                
                if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
                {
                    
                    contactNumberOne=@"No Description";
                }
                
                else
                {
                    
                    [cell.contactText setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
                    
                    contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
                    
                    if(indexPath.row==1)
                    {
                        [cell.contactText setText:@""];
                    }
                    if(indexPath.row==2)
                    {
                        [cell.contactText setText:@""];
                    }
                }
                
            }
            if ([storeContactArray count]==3)
            {
                
                
                contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName"];
                contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
                contactNameString3=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactName"];
                
                if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
                {
                    contactNumberOne=@"No Description";
                }
                
                else
                {
                    [cell.contactText setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
                    
                    contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
                    
                    if(indexPath.row==1)
                    {
                        [cell.contactText setText:@""];
                    }
                    if(indexPath.row==2)
                    {
                        [cell.contactText setText:@""];
                    }
                    
                }
            }
        }
        if(indexPath.row==1)
        {
            cell.countryCodeLabel.hidden = NO;
            cell.contactText1.hidden = YES;
            cell.contactLabel.text =@"Alternate Number";
            
            cell.contactText.tag = 201;
            if ([storeContactArray count]==2)
            {
                
                contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
                contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
                
                
                if ([[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ] length]==0)
                {
                    contactNumberTwo=@"No Description";
                }
                
                else
                {
                    
                    [cell.contactText setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
                    
                    contactNumberTwo=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ];
                    
                    if(indexPath.row==2)
                    {
                        [cell.contactText setText:@""];
                    }
                    
                    
                }
                contactNumberThree=@"No Description";
                
            }
            else
            {
                [cell.contactText setPlaceholder:@""];
                
                contactNumberTwo=@"No Description";
            }
            if ([storeContactArray count]==3)
            {
                
                
                contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName"];
                contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
                contactNameString3=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactName"];
                
                if ([[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ] length]==0)
                {
                    
                    contactNumberThree=@"No Description";
                    
                    
                }
                else
                {
                    [cell.contactText setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
                    
                    contactNumberTwo=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ];
                    if(indexPath.row==2)
                    {
                        [cell.contactText setText:@""];
                    }
                }
                
            }
            
            
        }
        if(indexPath.row==2)
        {
            cell.contactText.tag = 202;
            cell.contactText1.hidden = YES;
            cell.countryCodeLabel.hidden = NO;
            cell.contactLabel.text =@"Alternate Number  ";
            
            
            if ([storeContactArray count]==3)
            {
                
                
                contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName"];
                contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
                contactNameString3=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactName"];
                
                if ([[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ] length]==0)
                {
                    [cell.contactText setPlaceholder:@""];
                    contactNumberThree=@"No Description";
                    
                    
                }
                else
                {
                    [cell.contactText setText:[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]];
                    
                    contactNumberThree=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ];
                    
                }
                
            }
            else
            {
                [cell.contactText setPlaceholder:@""];
                contactNumberThree=@"No Description";
            }
        }
        
        
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            cell.contactText1.tag=203;
            cell.countryCodeLabel.hidden = YES;
            cell.contactLabel.text = @"Website";
            if ([appDelegate.storeWebsite isEqualToString:@"No Description"])
            {
                
                [cell.contactText1 setPlaceholder:@""];
            }
            
            
            else
            {
                
                [cell.contactText1 setText:appDelegate.storeWebsite];
            }
            
            
            
        }
        
        if(indexPath.row==1)
        {
            cell.countryCodeLabel.hidden = YES;
            cell.contactText1.tag=204;
            cell.contactLabel.text = @"Email";
            if ([appDelegate.storeEmail isEqualToString:@""])
            {
                
                [cell.contactText1 setPlaceholder:@""];
            }
            
            
            else
            {
                
                
                [cell.contactText1 setText:appDelegate.storeEmail];
            }
            
            
        }
        if(indexPath.row==2)
        {
            cell.countryCodeLabel.hidden = YES;
            cell.contactText1.tag=205;
            cell.contactLabel.text = @"Facebook Page";
            if ([appDelegate.storeFacebook isEqualToString:@"No Description"])
            {
                
                
                
            }
            
            else
            {
                
                [cell.contactText1 setText:appDelegate.storeFacebook];
                
                
            }
        }
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 22, tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:@"Helvetica Neue-Regular" size:13.0]];
    [label setFont:[UIFont systemFontOfSize:13.0]];
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    
    if(section==0)
    {
        label.text = @"PHONE NUMBERS";
    }
    if(section==1)
    {
        label.text = @"OTHER DETAILS";
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
    
}

-(void)revealRearViewController
{
    
    [self.view endEditing:YES];
    //revealToggle:
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController performSelector:@selector(revealToggle:)];
    
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    [self placeRightBarButton];
    
    if (textField.tag==200 || textField.tag==201 || textField.tag==202 || textField.tag==4 ||textField.tag==5 || textField.tag==6)
    {
        
        // [self placeRightBarButton];
        
    }
    
    
    
    
    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0)
    {
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else
    {
        self.view.frame = CGRectMake(0, 63, 320, self.view.frame.size.height+20);
    }
    
    
    //    if (textField.tag==200)
    //    {
    //        mobileNumTextField.text = textField.text;
    //        NSLog(@"Text : %@",mobileNumTextField.text);
    //    }
    //
    //    if (textField.tag==201)
    //    {
    //        landlineNumTextField.text = textField.text;
    //        NSLog(@"Text : %@",landlineNumTextField.text);
    //    }
    //
    //    if (textField.tag==202)
    //    {
    //        secondaryPhoneTextField.text = textField.text;
    //        NSLog(@"Text : %@",secondaryPhoneTextField.text);
    //    }
    //    if (textField.tag==203)
    //    {
    //        websiteTextField.text = textField.text;
    //        NSLog(@"Text : %@",websiteTextField.text);
    //    }
    //    if (textField.tag==204)
    //    {
    //        emailTextField.text = textField.text;
    //        NSLog(@"Text : %@",emailTextField.text);
    //    }
    //    if (textField.tag==205)
    //    {
    //        facebookTextField.text = textField.text;
    //        NSLog(@"Text : %@",facebookTextField.text);
    //    }
    
    return YES;
}


- (void)textFieldDidChange: (NSNotification*)aNotification
{
    
    if ([storeContactArray count]==1)
    {
        if ([contactNumberOne isEqualToString:mobileNumTextField.text] && [secondaryPhoneTextField.text length]==0 &&
            [landlineNumTextField.text length]==0 )
        {
            // self.navigationItem.rightBarButtonItem=nil;
        }
    }
    
    
    
    if ([storeContactArray count]==2)
    {
        if ([contactNumberOne isEqualToString:mobileNumTextField.text] && [contactNumberTwo isEqualToString:landlineNumTextField.text] && [secondaryPhoneTextField.text length]==0 )
        {
            // self.navigationItem.rightBarButtonItem=nil;
        }
    }
    
    
    if ([storeContactArray count]==3)
    {
        if ([contactNumberOne isEqualToString:mobileNumTextField.text] && [contactNumberTwo isEqualToString:landlineNumTextField.text] && [secondaryPhoneTextField.text isEqualToString:contactNumberThree])
        {
            // self.navigationItem.rightBarButtonItem=nil;
        }
    }
    
    
    
    
    else
    {
        
        //WebSite
        if (isWebSiteChanged)
        {
            @try
            {
                if ([appDelegate.storeDetailDictionary objectForKey:@"Uri"]==[NSNull null])
                {
                    isWebSiteChanged=NO;
                }
                
                else
                {
                    [self unHideRightBarBtn];
                }
            }
            @catch (NSException *e) {}
        }
        
        //Email
        if (isEmailChanged)
        {
            @try
            {
                if ([appDelegate.storeDetailDictionary objectForKey:@"Email"]!=[NSNull null])
                {
                    [self unHideRightBarBtn];
                }
            }
            @catch (NSException *e) {}
        }
        
        //FaceBook
        if (isFBChanged )
        {
            @try
            {
                if ( [appDelegate.storeDetailDictionary objectForKey:@"FBPageName"]!=[NSNull null])
                {
                    [self unHideRightBarBtn];
                }
            }
            @catch (NSException *exception) {}
        }
    }
}


-(void)setUpButton
{
    customButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setTitle:@"Save" forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue-Regular" size:17.0f];
    
    [navBar addSubview:customButton];
    
    if (version.floatValue<7.0)
    {
        [customButton setFrame:CGRectMake(280,21,30,30)];
        
        [customButton setHidden:YES];
    }
    else
    {
        [customButton setFrame:CGRectMake(260,21, 60, 30)];
    }
}


-(void)removeRightBarBtn
{
    if (version.floatValue<7.0)
    {
        [customButton setHidden:YES];
    }
    
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveRightBarButton" object:nil];
    }
}


-(void)unHideRightBarBtn
{
    if (version.floatValue<7.0)
    {
        if (customButton.isHidden)
        {
            [customButton setHidden:NO];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnHideRightBarButton" object:nil];
    }
}


-(void)placeRightBarButton
{
    self.navigationItem.rightBarButtonItem=nil;
    
    [customButton setFrame:CGRectMake(260,21, 60, 30)];
    
    [customButton setHidden:NO];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
    
    self.navigationItem.rightBarButtonItem=rightBarBtn;
}


-(void)unPlaceRightBarButton
{
    [customButton setFrame:CGRectMake(275,5,0,0)];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
    
    self.navigationItem.rightBarButtonItem=rightBarBtn;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    textFieldTag=[textField tag];
    
    if (textField.tag==200)
    {
        
        isContact1Changed=YES;
        isContact1Changed1=YES;
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    
    if (textField.tag==201)
    {
        isContact2Changed=YES;
        isContact2Changed1=YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (textField.tag==202)
    {
        isContact3Changed=YES;
        isContact3Changed1=YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    
    
    
    if (textField.tag==203) {
        
        isWebSiteChanged=YES;
        isWebSiteChanged1=YES;
        
    }
    
    
    if (textField.tag==204) {
        
        isEmailChanged=YES;
        isEmailChanged1=YES;
    }
    
    
    if (textField.tag==205) {
        
        isFBChanged=YES;
        isFBChanged1=YES;
    }
    
    
}

/*
 Adjust the ScrollView to make the textfields appear if hidden behind the keyboard
 */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //    CGSize kbSize=CGSizeMake(320, 216);
    //
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    //
    //    contactScrollView.contentInset = contentInsets;
    //
    //    contactScrollView.scrollIndicatorInsets = contentInsets;
    //
    //    CGRect aRect = self.view.frame;
    //
    //    aRect.size.height -= kbSize.height;
    //
    //    if (!CGRectContainsPoint(aRect, textField.frame.origin) )
    //    {
    //        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y-kbSize.height+60);
    //
    //        [contactScrollView setContentOffset:scrollPoint animated:YES];
    //    }
    
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            if([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0)
            {
                if(textField.tag==205)
                {
                    self.view.frame = CGRectMake(0, -180, 320, self.view.frame.size.height+200);
                }
                else if(textField.tag==204 || textField.tag==203)
                {
                    self.view.frame = CGRectMake(0, -140, 320, self.view.frame.size.height+200);
                }
                else
                {
                    //                        self.view.frame = CGRectMake(0, -20, 320, self.view.frame.size.height+200);
                }
            }
            else
            {
                if(textField.tag==205)
                {
                    self.view.frame = CGRectMake(0, -123, 320, self.view.frame.size.height+200);
                }
                else if(textField.tag==204 || textField.tag==203)
                {
                    self.view.frame = CGRectMake(0, -80, 320, self.view.frame.size.height+200);
                }
                else
                {
                    //                        self.view.frame = CGRectMake(0, -20, 320, self.view.frame.size.height+200);
                }
            }
            
            
            
            
        }
        if(result.height == 568)
        {
            if(textField.tag==205 || textField.tag==204 || textField.tag==203)
            {
                self.view.frame = CGRectMake(0, -40, 320, self.view.frame.size.height+200);
            }
            else
            {
                //                     self.view.frame = CGRectMake(0, -20, 320, self.view.frame.size.height+200);
            }
            
            
        }
    }
    
    
    return YES;
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    contactScrollView.contentInset = contentInsets;
    contactScrollView.scrollIndicatorInsets = contentInsets;
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    
    return YES;
}


-(void)updateMessage
{
    
  
    
    [self.view endEditing:YES];
    
    for (int i=0; i <3; i++){
        
        BusinessContactCell *theCell;
        theCell = (id)[self.ContactInfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        
        [theCell.contactText resignFirstResponder];
        
        
        UITextField *cellTextField = [theCell contactText1];
        
        NSString *changedText = [cellTextField text];
        
        if (i==0)
        {
            websiteTextField.text = changedText;
            
        }
        if (i==1)
        {
            emailTextField.text = changedText;
            
        }
        if (i==2)
        {
            facebookTextField.text = changedText;
            
        }
        
    }
    
    for (int i=0; i <3; i++){
        
        BusinessContactCell *theCell;
        theCell = (id)[self.ContactInfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [theCell.contactText1 resignFirstResponder];
        
        
        UITextField *cellTextField = [theCell contactText];
        
        NSString *changedText = [cellTextField text];
        
        if (i==0)
        {
            mobileNumTextField.text = changedText;
            
        }
        if (i==1)
        {
            landlineNumTextField.text = changedText;
            
        }
        if (i==2)
        {
            secondaryPhoneTextField.text = changedText;
            
        }
        
    }
    
    BOOL isComplete = NO;
    
    NSMutableArray *failureMessages;
    
    failureMessages = [NSMutableArray array];
    
    UpdateStoreData  *strData=[[UpdateStoreData  alloc]init];
    strData.delegate=self;
    
    NSMutableArray *uploadArray=[[NSMutableArray alloc]init];
    
    [mobileNumTextField resignFirstResponder];
    [landlineNumTextField resignFirstResponder];
    [secondaryPhoneTextField resignFirstResponder];
    [facebookTextField resignFirstResponder];
    [websiteTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    
    
    if(mobileNumTextField.text.length == 0)
    {
        
        
        [AlertViewController CurrentView:self.view errorString:@"Primary Number is mandatory" size:0 success:NO];
        isComplete = YES;
    }
    else
    {
        if (isContact1Changed )
        {
            
            
            NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
            
            upLoadDictionary=@{@"value":mobileNumTextField.text,@"key":@"CONTACTS"};
            
            [uploadArray  addObject:upLoadDictionary];
            
            isContact1Changed=NO;
            
        }
        
        if (isContact2Changed)
        {
            
            NSString *uploadString=[NSString stringWithFormat:@"%@#%@",mobileNumTextField.text,landlineNumTextField.text];
            
            NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
            
            if (landlineNumTextField.text.length!=0)
            {
                
                if(landlineNumTextField.text.length >12 || landlineNumTextField.text.length <6)
                {
                    [AlertViewController CurrentView:self.view errorString:@"Phone Number should be between 6 to 12 characters" size:0 success:NO];
                    isComplete = YES;
                }
                else
                {
                    upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
                    
                    [uploadArray  addObject:upLoadDictionary];
                }
                
                
                if (!failureMessages.count>0)
                {
                    
                }
            }
            
            
            else
            {
                upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
                
                [uploadArray  addObject:upLoadDictionary];
            }
            
            }
        
        
        if (isContact3Changed)
        {
            NSString *uploadString=[NSString stringWithFormat:@"%@#%@#%@",mobileNumTextField.text,landlineNumTextField.text,secondaryPhoneTextField.text];
            
            NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
            
            
            
            if (secondaryPhoneTextField.text.length!=0)
            {
                
                if(secondaryPhoneTextField.text.length >12 || secondaryPhoneTextField.text.length <6)
                {
                    [AlertViewController CurrentView:self.view errorString:@"Phone Number should be between 6 to 12 characters" size:0 success:NO];
                    
                    isComplete = YES;
                }
                else
                {
                    upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
                    
                    [uploadArray  addObject:upLoadDictionary];
                    
                }
                
            }
            else
            {
                upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
                
                [uploadArray  addObject:upLoadDictionary];
                
            }
        }
        
        
        if (isWebSiteChanged)
        {
            NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
            
            upLoadDictionary=@{@"value":websiteTextField.text,@"key":@"URL"};
            
            [uploadArray  addObject:upLoadDictionary];
            
            isWebSiteChanged=NO;
            
            if ([websiteTextField.text isEqualToString:@""])
            {
                appDelegate.storeWebsite=@"No Description";
            }
            
            else
            {
                appDelegate.storeWebsite=websiteTextField.text;
            }
        }
        
        
        if (isEmailChanged)
        {
            NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
            
            if (emailTextField.text.length!=0)
            {
                
                if([self checkForEmail:emailTextField.text]==NO)
                {
                    [AlertViewController CurrentView:self.view errorString:@"Enter valid Email" size:0 success:NO];
                    isComplete = YES;
                }
                else
                {
                    appDelegate.storeEmail=emailTextField.text;
                    
                    upLoadDictionary=@{@"value":emailTextField.text,@"key":@"EMAIL"};
                    
                    [uploadArray  addObject:upLoadDictionary];
                    
                }
            
            }
            
            else
            {
                appDelegate.storeEmail=emailTextField.text;
                
                upLoadDictionary=@{@"value":emailTextField.text,@"key":@"EMAIL"};
                
                [uploadArray  addObject:upLoadDictionary];
            }
        }
        
        
        if (isFBChanged)
        {
            NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
            
            upLoadDictionary=@{@"value":facebookTextField.text,@"key":@"FB"};
            
            [uploadArray  addObject:upLoadDictionary];
            
            NSMutableArray *widgetArray
            =[[NSMutableArray alloc]initWithArray:
              [appDelegate.storeDetailDictionary objectForKey:@"FPWebWidgets"]];
            
            NSString *widgetString;
            for(int i =0;i<widgetArray.count;i++)
            {
                
                NSString *fbLike = [NSString stringWithFormat:@"#%@",[widgetArray objectAtIndex:i]];
                if(i==0)
                {
                    widgetString = fbLike;
                }
                else
                {
                    widgetString = [widgetString stringByAppendingString:fbLike];
                    
                }
                
            }
            
            widgetString = [widgetString stringByAppendingString:@"#FBLIKEBOX"];
            NSDictionary *upLoadDictionary1=[[NSDictionary alloc]init];
            
            
            upLoadDictionary1=@{@"value":widgetString,@"key":@"WEBWIDGETS"};
            
            [uploadArray  addObject:upLoadDictionary1];
            
            
            isFBChanged=NO;
            
            if ([facebookTextField.text isEqualToString:@""])
            {
                appDelegate.storeFacebook=@"No Description";
            }
            else
            {
                appDelegate.storeFacebook=facebookTextField.text;
            }
        }
        
        
        if (failureMessages.count > 0)
        {
            [self removeRightBarBtn];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[failureMessages componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            
            [alert show];
        }
        
        
        
        
        
        else
        {
            
            
            if([uploadArray count]==0)
            {
                
            }
            else
            {
                if(!isComplete)
                {
                    
                    
                    
                    [nfActivity showCustomActivityView];
                    [strData updateStore:uploadArray];
                }
            }
            
            
        }
        
        
        
        if ([mobileNumTextField.text isEqualToString:@"No Description"] || [mobileNumTextField.text isEqualToString:@"No Description"])
        {
            _contactDictionary1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:contactNameString1,@"ContactName",[NSNull null],@"ContactNumber", nil];
        }
        
        else
        {
            _contactDictionary1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:contactNameString1,@"ContactName",mobileNumTextField.text,@"ContactNumber", nil];
            
            [_contactsArray addObject:_contactDictionary1];
        }
        
        
        
        if ([landlineNumTextField.text isEqualToString:@"No Description"] || [landlineNumTextField.text isEqualToString:@""])
        {
            _contactDictionary2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:contactNameString2,@"ContactName",[NSNull null],@"ContactNumber", nil];
            
        }
        
        
        else
        {
            _contactDictionary2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:contactNameString2,@"ContactName",landlineNumTextField.text,@"ContactNumber", nil];
            
            [_contactsArray addObject:_contactDictionary2];
        }
        
        
        
        if ([secondaryPhoneTextField.text isEqualToString:@"No Description"] || [secondaryPhoneTextField.text isEqualToString:@""] )
        {
            _contactDictionary3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:contactNameString3,@"ContactName",[NSNull null],@"ContactNumber", nil];
            
        }
        
        
        else
        {
            _contactDictionary3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:contactNameString3,@"ContactName",secondaryPhoneTextField.text,@"ContactNumber", nil];
            
            [_contactsArray addObject:_contactDictionary3];
            
        }
        
        [appDelegate.storeContactArray removeAllObjects];
        
        [appDelegate.storeContactArray addObjectsFromArray:_contactsArray];
        
        [_contactsArray removeAllObjects];
        
        
    }
    
    
    
    
    
}

-(BOOL) checkForEmail:(NSString *) emailId
{
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX];
	return [emailTest evaluateWithObject:emailId]?([emailId length] <= PASSWORD_LENGTH):NO;
}


-(void)updateView
{
    [self removeSubView];
}


-(void)updateFailView
{
    [nfActivity hideCustomActivityView];
    
    [AlertViewController CurrentView:self.view errorString:@"Uh oh. Please try updating again." size:0 success:NO];
    
}


#pragma storeUpdateDelegate
-(void)storeUpdateComplete
{
    
    
    [self removeRightBarBtn];
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"update_Business Contact"];
    
    [self updateView];
    
    if(isContact1Changed1)
    {
        [AlertViewController CurrentView:self.view errorString:@"Primary Number updated" size:0 success:YES];
    }
    else if (isContact2Changed1)
    {
        [AlertViewController CurrentView:self.view errorString:@"Alternate Number updated" size:0 success:YES];
    }
    else if (isContact3Changed1)
    {
        [AlertViewController CurrentView:self.view errorString:@"Alternate Number updated" size:0 success:YES];
    }
    else if (isWebSiteChanged1)
    {
        [AlertViewController CurrentView:self.view errorString:@"Website updated" size:0 success:YES];
    }
    else if (isEmailChanged1)
    {
        [AlertViewController CurrentView:self.view errorString:@"Email updated" size:0 success:YES];
    }
    else if (isFBChanged1)
    {
        [AlertViewController CurrentView:self.view errorString:@"Facebook Page updated" size:0 success:YES];
    }
    
    isContact1Changed1=NO;
    isContact2Changed1=NO;
    isContact3Changed1=NO;
    isWebSiteChanged1=NO;
    isEmailChanged1=NO;
    isFBChanged1=NO;
    
   
}


-(void)storeUpdateFailed
{
    
    [self removeRightBarBtn];
    
    isContact1Changed=NO;
    isContact2Changed=NO;
    isContact3Changed=NO;
    isWebSiteChanged=NO;
    isEmailChanged=NO;
    isFBChanged=NO;
    
    [self updateFailView];
    
}


-(void)removeSubView
{
    [nfActivity hideCustomActivityView];
    
    [customButton setHidden:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    mobileNumTextField = nil;
    landlineNumTextField = nil;
    websiteTextField = nil;
    emailTextField = nil;
    secondaryPhoneTextField = nil;
    facebookTextField = nil;
    contactScrollView = nil;
    [super viewDidUnload];
}


- (IBAction)dismissKeyBoard:(id)sender
{
    [[self view] endEditing:YES];
}


- (IBAction)registeredPhoneNumberBtnClicked:(id)sender
{
    UIAlertView *registeredPhoneNumberAlerView=[[UIAlertView alloc]initWithTitle:@"Facebook Fan Page" message:@"If your Facebook page URL is facebook.com/nowfloats; then your username is nowfloats" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [registeredPhoneNumberAlerView show];
    
    
    registeredPhoneNumberAlerView=nil;
    
}

#pragma SWRevealViewControllerDelegate


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    else if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    else if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    else if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    
    else if ( position == FrontViewPositionLeftSide ) str = @"FrontViewPositionLeftSide";
    
    else if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    
    return str;
}


- (IBAction)revealFrontController:(id)sender
{
    
    SWRevealViewController *revealController = [self revealViewController];
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"]) {
        
        [revealController performSelector:@selector(rightRevealToggle:)];
        
    }
    
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealController performSelector:@selector(revealToggle:)];
        
    }
    
}


- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;
{
    
    frontViewPosition=[self stringFromFrontViewPosition:position];
    
    //FrontViewPositionLeft
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    //FrontViewPositionCenter
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeft"]) {
        
        [revealFrontControllerButton setHidden:YES];
        
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealFrontControllerButton setHidden:NO];
        
        [mobileNumTextField resignFirstResponder];
        [landlineNumTextField resignFirstResponder];
        [secondaryPhoneTextField resignFirstResponder];
        [websiteTextField resignFirstResponder];
        [emailTextField resignFirstResponder];
        [facebookTextField resignFirstResponder];
        
        
    }
    
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;   
    }
    
}




@end
