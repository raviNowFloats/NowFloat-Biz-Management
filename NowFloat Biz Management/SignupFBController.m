//
//  SignupFBController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "SignupFBController.h"
#import "BookDomainnController.h"

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
}


-(void)viewAlign
{
    if(![city isEqualToString:@""] && ![phono isEqualToString:@""] && ![country isEqualToString:@""] && [emailID isEqualToString:@""])
    {
        emailTextfield.frame = CGRectMake(40, 124, 241,37);
        cityTextfield.hidden=YES;
        phoneNumTextfield.hidden=YES;
        countryButton.hidden = YES;
        
    }
    
    if(![city isEqualToString:@""] && ![emailID isEqualToString:@""] && ![country isEqualToString:@""] && [phono isEqualToString:@""])
    {
        phoneNumTextfield.frame = CGRectMake(40, 124, 241,37);
        cityTextfield.hidden=YES;
        emailTextfield.hidden=YES;
        countryButton.hidden = YES;
    }
    
    if(![phono isEqualToString:@""] && ![emailID isEqualToString:@""] && ![country isEqualToString:@""] && [city isEqualToString:@""])
    {
        cityTextfield.frame = CGRectMake(40, 124, 241,37);
        emailTextfield.hidden=YES;
        phoneNumTextfield.hidden=YES;
        countryButton.hidden = YES;
    }
    if(![phono isEqualToString:@""] && ![emailID isEqualToString:@""] && [country isEqualToString:@""] && ![city isEqualToString:@""])
    {
        countryButton.frame = CGRectMake(40, 124, 241,37);
        emailTextfield.hidden=YES;
        phoneNumTextfield.hidden=YES;
        cityTextfield.hidden = YES;
    }
    if(![city isEqualToString:@""] && ![country isEqualToString:@""] && [phono isEqualToString:@""] && [emailID isEqualToString:@""])
    {
        emailTextfield.frame = CGRectMake(40, 124, 241,37);
        phoneNumTextfield.frame = CGRectMake(40, 184, 241,37);
        cityTextfield.hidden=YES;
        countryButton.hidden = YES;
        
    }
    if(![phono isEqualToString:@""] && ![country isEqualToString:@""] && [emailID isEqualToString:@""] && [city isEqualToString:@""])
    {
        cityTextfield.frame = CGRectMake(40, 124, 241,37);
        emailTextfield.frame = CGRectMake(40,184, 241,37);
        phoneNumTextfield.hidden=YES;
        countryButton.hidden = YES;
    }
    
    if(![emailID isEqualToString:@""] && ![country isEqualToString:@""] && [phono isEqualToString:@""] && [city isEqualToString:@""])
    {
        cityTextfield.frame = CGRectMake(40, 124, 241,37);
        phoneNumTextfield.frame = CGRectMake(40,184, 241,37);
        emailTextfield.hidden=YES;
        countryButton.hidden = YES;
    }
    if([city isEqualToString:@""] && [country isEqualToString:@""] && ![phono isEqualToString:@""] && ![emailID isEqualToString:@""])
    {
        cityTextfield.frame = CGRectMake(40, 124, 241,37);
        countryButton.frame = CGRectMake(40, 184, 241,37);
        phoneNumTextfield.hidden=YES;
        emailTextfield.hidden = YES;
        
    }
    if(![city isEqualToString:@""] && [country isEqualToString:@""] && [phono isEqualToString:@""] && ![emailID isEqualToString:@""])
    {
        phoneNumTextfield.frame = CGRectMake(40, 124, 241,37);
        countryButton.frame = CGRectMake(40, 184, 241,37);
        emailTextfield.hidden=YES;
        cityTextfield.hidden = YES;
        
       
        
    }
    if(![city isEqualToString:@""] && [country isEqualToString:@""] && ![phono isEqualToString:@""] && [emailID isEqualToString:@""])
    {
        emailTextfield.frame = CGRectMake(40, 124, 241,37);
        countryButton.frame = CGRectMake(40, 184, 241,37);
        cityTextfield.hidden=YES;
        phoneNumTextfield.hidden = YES;
        
    }
    if([city isEqualToString:@""] && [country isEqualToString:@""] && [phono isEqualToString:@""] && ![emailID isEqualToString:@""])
    {
        cityTextfield.frame = CGRectMake(40, 124, 241,37);
        phoneNumTextfield.frame = CGRectMake(40, 184, 241,37);
        countryButton.frame = CGRectMake(40, 245, 241,37);
        emailTextfield.hidden = YES;
        
    }
    if([city isEqualToString:@""] && [country isEqualToString:@""] && ![phono isEqualToString:@""] && [emailID isEqualToString:@""])
    {
        cityTextfield.frame = CGRectMake(40, 124, 241,37);
        emailTextfield.frame = CGRectMake(40, 184, 241,37);
        countryButton.frame = CGRectMake(40, 245, 241,37);
        phoneNumTextfield.hidden = YES;
        
    }
    if(![city isEqualToString:@""] && [country isEqualToString:@""] && [phono isEqualToString:@""] && [emailID isEqualToString:@""])
    {
        phoneNumTextfield.frame = CGRectMake(40, 124, 241,37);
        emailTextfield.frame    = CGRectMake(40, 184, 241,37);
        countryButton.frame     = CGRectMake(40, 245, 241,37);
        cityTextfield.hidden    = YES;
    }
    if([city isEqualToString:@""] && ![country isEqualToString:@""] && [phono isEqualToString:@""] && [emailID isEqualToString:@""])
    {
        cityTextfield.frame = CGRectMake(40, 124, 241,37);
        phoneNumTextfield.frame    = CGRectMake(40, 184, 241,37);
        emailTextfield.frame     = CGRectMake(40, 245, 241,37);
        countryButton.hidden    = YES;
    }
    if([city isEqualToString:@""] && [country isEqualToString:@""] && [phono isEqualToString:@""] && [emailID isEqualToString:@""])
    {
        
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
    country = countryName;
    
}


- (IBAction)submitFB:(id)sender {
    
    [self.view endEditing:YES];
    
    NSDictionary *uploadDictionary = [[NSDictionary alloc]init];
    
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
    
    if(![BusinessName isEqualToString:@""] && ![userName isEqualToString:@""] && ![phono isEqualToString:@""] && ![category isEqualToString:@""] && ![emailID isEqualToString:@""] && ![city isEqualToString:@""])
    {
        uploadDictionary=@{@"name":BusinessName,@"city":city,@"country":country,@"category":category,@"clientId":appDelegate.clientId};
        SuggestBusinessDomain *suggestController=[[SuggestBusinessDomain alloc]init];
        suggestController.delegate=self;
        [suggestController suggestBusinessDomainWith:uploadDictionary];
        suggestController =nil;
        
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
        [self.navigationController pushViewController:domaincheck animated:YES];
        
    
}
@end