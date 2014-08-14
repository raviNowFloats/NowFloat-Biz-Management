//
//  SignupFBController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "SignupFBController.h"
#import "BookDomainnController.h"
#import "AlertViewController.h"
#import "TutorialViewController.h"

NSMutableArray *countryListArray;
NSMutableArray *countryCodeArray;
NSString *countryName;
NSString *countryCode;
NSString *suggestedURL;



@interface SignupFBController ()

@end

@implementation SignupFBController
@synthesize BusinessName,city,countryPickerView,category,country,cityTextfield,countryButton,countryPicker,userName,phono,phoneNumTextfield;
@synthesize emailID,emailTextfield;
@synthesize textfd;
@synthesize pageDescription,primaryImageURL;
@synthesize countryView,phoneView,cityView;
@synthesize fbPagename;
@synthesize errorView;
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
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    textfd.frame = CGRectMake(0, 0, 320, 60);
    // Do any additional setup after loading the view from its nib.
    
    
    countryView.layer.borderWidth = 0.5f;
    countryView.layer.borderColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    
    cityView.layer.borderWidth = 0.5f;
    cityView.layer.borderColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    
    phoneView.layer.borderWidth = 0.5f;
    phoneView.layer.borderColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    countryName = [locale displayNameForKey: NSLocaleCountryCode
                                      value: countryCode];
    
    self.countryLabel.textColor = [UIColor colorWithRed:88.0f/255.0f green:88.0f/255.0f blue:88.0f/255.0f alpha:1.0f];
    
   
    self.countryLabel.text = countryName;
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
    
    self.countryCodeLabel.text = [NSString stringWithFormat:@"+%@",[dictDialingCodes objectForKey:countryCode]];
    

    
    
    if([city isEqualToString:@""] || city == nil)
    {
        city=@"";
    }
    if([phono isEqualToString:@""] || phono == nil)
    {
        phono = @"";
    }
    if([emailID isEqualToString:@""] || emailID == nil)
    {
        emailID =@"";
    }
    if([country isEqualToString:@""] || country == nil)
    {
        country = @"";
    }
    
    NSError *error;
    
     countryListArray=[[NSMutableArray alloc]init];
     countryCodeArray=[[NSMutableArray alloc]init];
    
    NSString *filePathForCountries = [[NSBundle mainBundle] pathForResource:@"listofcountries" ofType:@"json"];
    
    NSString *myJSONString = [[NSString alloc] initWithContentsOfFile:filePathForCountries encoding:NSUTF8StringEncoding error:&error];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[myJSONString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSMutableArray *countryJsonArray=[[NSMutableArray  alloc]initWithArray:[[json objectForKey:@"countries"]objectForKey:@"country"]];
    
    for (int i=0; i<[countryJsonArray count]; i++)
    {
        [countryListArray insertObject:[[countryJsonArray objectAtIndex:i]objectForKey:@"-name"] atIndex:i];
        
        [countryCodeArray insertObject:[[countryJsonArray objectAtIndex:i]objectForKey:@"-phoneCode"] atIndex:i];
        
    }
    
    [self viewAlign];
    
    UITapGestureRecognizer *removeKey = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyboard)];
    
    removeKey.numberOfTapsRequired = 1;
    removeKey.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:removeKey];
    self.view.userInteractionEnabled=YES;
}


-(void)removeKeyboard
{
    [self.view endEditing:YES];
}

-(void)viewAlign
{
   
    
    if(![city isEqualToString:@""] &&  ![country isEqualToString:@""] && [phono isEqualToString:@""])
    {
        phoneView.frame = CGRectMake(-4, 162, 330,40);
        cityView.hidden=YES;
        countryView.hidden = YES;
    }
    if(![city isEqualToString:@""] &&  [country isEqualToString:@""] && ![phono isEqualToString:@""])
    {
        countryView.frame = CGRectMake(-4, 162, 330,40);
        cityView.hidden=YES;
        phoneView.hidden = YES;
    }
    
    if(![phono isEqualToString:@""] && ![country isEqualToString:@""] && [city isEqualToString:@""])
    {
        cityView.frame = CGRectMake(-4, 162, 330,40);
        phoneView.hidden=YES;
        countryView.hidden = YES;
    }
      if(![country isEqualToString:@""] && [phono isEqualToString:@""] && [city isEqualToString:@""])
    {
        cityView.frame  =  CGRectMake(-4, 162, 330,41);
        phoneView.frame =  CGRectMake(-4, 202, 330,41);
        countryView.hidden = YES;
    }
    if([city isEqualToString:@""] && [country isEqualToString:@""] && ![phono isEqualToString:@""])
    {
        countryView.frame = CGRectMake(-4, 162, 330,41);
        cityView.frame    = CGRectMake(-4, 202, 330,41);
        phoneView.hidden=YES;
        
        
    }
    if(![city isEqualToString:@""] && [country isEqualToString:@""] && [phono isEqualToString:@""])
    {
        countryView.frame = CGRectMake(-4, 162, 330,41);
        phoneView.frame    = CGRectMake(-4, 202, 330,41);
        cityView.hidden=YES;
        
    }
   
    if([city isEqualToString:@""] && [country isEqualToString:@""] && [phono isEqualToString:@""])
    {
        countryView.frame = CGRectMake(-4, 162, 330,41);
        cityView.frame = CGRectMake(-4, 202, 330,41);
        phoneView.frame = CGRectMake(-4, 242, 330,41);
        
    }
        
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)_pickerView;
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)_pickerView numberOfRowsInComponent:(NSInteger)component;
{
   
        
        return countryListArray.count;
    
}


- (NSString *)pickerView:(UIPickerView *)_pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *text;
    text=[countryListArray objectAtIndex: row];
    return text;
    
}


- (void)pickerView:(UIPickerView *)_pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
    countryName =[countryListArray objectAtIndex: row];
    countryCode=[countryCodeArray objectAtIndex: row];
    
    countryName=[NSString stringWithFormat:@"%@",countryName];
    countryCode=[NSString stringWithFormat:@"+%@",countryCode];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (IBAction)selectCountry:(id)sender {
    
    countryPickerView.frame = CGRectMake(0, 370, 320, 200);
    [self.view addSubview:countryPickerView];
    [self.view endEditing:YES];

}

- (IBAction)pickerCancel:(id)sender {
    countryPickerView.frame = CGRectMake(0, 800, 320, 200);
}

- (IBAction)donePicker:(id)sender {
    
    countryPickerView.frame = CGRectMake(0, 800, 320, 200);
    [countryButton setTitle:countryName forState:UIControlStateNormal];
    self.countryLabel.text = countryName;
    self.countryLabel.textColor = [UIColor colorWithRed:88.0f/255.0f green:88.0f/255.0f blue:88.0f/255.0f alpha:1.0f];
    country = countryName;
    self.countryCodeLabel.text = countryCode;
    
}


- (IBAction)submitFB:(id)sender {
    
    [self.view endEditing:YES];
    
    NSDictionary *uploadDictionary = [[NSDictionary alloc]init];
    
    if([cityTextfield.text isEqualToString:@""])
    {
        [self word:@"Please enter city name" isSuccess:NO ];
    }
    else if ([phoneNumTextfield.text isEqualToString:@""])
    {
        [self word:@"Please enter phone number" isSuccess:NO ];

    }
    else if(phoneNumTextfield.text.length >12 || phoneNumTextfield.text.length <6)
    {
         [self word:@"Please enter phone number between 6 to 12 characters" isSuccess:NO ];
    }
    else
    {
    
    if([phono isEqualToString:@""])
    {
        phono=phoneNumTextfield.text;
    }
    if([city isEqualToString:@""])
    {
        city = cityTextfield.text;
    }
    if([emailID isEqualToString:@""])
    {
        emailID=emailTextfield.text;
    }
    
    if(![BusinessName isEqualToString:@""] && ![userName isEqualToString:@""] && ![phono isEqualToString:@""] && ![category isEqualToString:@""] && ![city isEqualToString:@""])
    {
        uploadDictionary=@{@"name":BusinessName,@"city":city,@"country":country,@"category":category,@"clientId":appDelegate.clientId};
        SuggestBusinessDomain *suggestController=[[SuggestBusinessDomain alloc]init];
        suggestController.delegate=self;
        [suggestController suggestBusinessDomainWith:uploadDictionary];
        suggestController =nil;
        
    }
    
    }
}

#pragma SuggestBusinessDomainDelegate

-(void)suggestBusinessDomainDidComplete:(NSString *)suggestedDomainString
{
    
    
    suggestedURL=[suggestedDomainString lowercaseString];
    
    if (suggestedDomainString.length==0)
    {
        UIAlertView *emptyAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"We could not suggest a domain for you.Why dont you give it a try ?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        emptyAlertView.tag=102;
        
        [emptyAlertView show];
    }
        country = countryName;
        countryCode = self.countryCodeLabel.text;
        BookDomainnController *domaincheck = [[BookDomainnController alloc]initWithNibName:@"BookDomainnController" bundle:nil];
        domaincheck.city = city;
        domaincheck.emailID =emailID;
        domaincheck.phono = phono;
        domaincheck.country = country;
        domaincheck.BusinessName=BusinessName;
        domaincheck.userName=userName;
        domaincheck.suggestedURL = suggestedDomainString;
        domaincheck.category = category;
        domaincheck.countryCode = countryCode;
        domaincheck.primaryImageURL = primaryImageURL;
        domaincheck.pageDescription = pageDescription;
        domaincheck.fbpageName      = fbPagename;
        domaincheck.viewName = @"rem";
        [self.navigationController pushViewController:domaincheck animated:YES];
}

- (void)word:(NSString*)string isSuccess:(BOOL)success
{
    errorView.alpha = 1.0;
    if(success)
    {
        errorView.backgroundColor = [UIColor colorWithRed:93.0f/255.0f green:172.0f/255.0f blue:1.0f/255.0f alpha:1.0];
        
        
    }
    else
    {
        errorView.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:34.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    }
    
    UILabel  *errorLabel = [[UILabel alloc]init];
    errorLabel.frame=CGRectMake(20, 0, 280, 40);
    errorLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    errorLabel.textAlignment =NSTextAlignmentCenter;
    errorLabel.text =@"";
    errorLabel.text = string;
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.backgroundColor =[UIColor clearColor];
    [errorLabel setNumberOfLines:0];
    

    
    
    errorView.tag = 55;
    errorView.frame=CGRectMake(0, -200, 320, 40);
    [UIView animateWithDuration:0.8f
                          delay:0.03f
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         
                         errorView.frame=CGRectMake(0, 57, 320, 40);
                         
                             [errorView addSubview:errorLabel];

                      
                         
                     }completion:^(BOOL finished){
                         
                         double delayInSeconds = 1.5;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                             
                             
                             
                             [UIView animateWithDuration:0.8f
                                                   delay:0.10f
                                                 options:UIViewAnimationOptionTransitionFlipFromBottom
                                              animations:^{
                                                  
                                                      errorView.alpha = 0.0;
                                                      errorView.frame = CGRectMake(0, -55, 320, 50);
                                                 
                                                  
                                              }completion:^(BOOL finished){
                                                  
                                                  for (UIView *errorRemoveView in [self.view subviews]) {
                                                      if (errorRemoveView.tag == 55) {
                                                                                                                    errorLabel.frame=CGRectMake(-200, 0, -50, 40);
                                                      }
                                                      
                                                  }
                                                  
                                                  
                                              }];
                             
                         });
                         
                     }];
    
}

- (IBAction)goBack:(id)sender {
    
    TutorialViewController *tutroial = [[TutorialViewController alloc]initWithNibName:@"TutorialViewController" bundle:Nil];
  
    
    [self.navigationController pushViewController: tutroial animated:YES];
}
@end