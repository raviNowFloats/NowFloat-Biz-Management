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

#define defaultSubViewWidth 300
#define defaultSubViewHeight 260


#define HouseNumberPlaceholder @"house number, building name, etc"
#define CityPlaceHolder @"city"
#define PincodePlaceHolder @"pincode"
#define StatePlaceHolder @"state"



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


@interface SignUpViewController ()<VerifyUniqueNameDelegate,FpCategoryDelegate,FpAddressDelegate,SignUpControllerDelegate,updateDelegate,SuggestBusinessDomainDelegate,ChangeStoreTagDelegate,PopUpDelegate,RegisterChannelDelegate>
{
    UIImage *buttonBackGroundImage;
    NSCharacterSet *blockedCharacters;
    int currentView;
    long viewHeight;
    long viewWidth;
    NSString *categoryString;
    NSString *countryCodeString;
    NFActivityView *nfActivity;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [downloadingCategoriesActivityView.layer setCornerRadius:6.0];
    
    downloadingCategoriesActivityView.center=[[[UIApplication sharedApplication] delegate] window].center;

    [stepTwoButton setUserInteractionEnabled:NO];
    
    [stepThreeButton setUserInteractionEnabled:NO];
    
    [stepFourButton setUserInteractionEnabled:NO];
    
    [mainScrollView setScrollEnabled:NO];
    
    currentView=1;
    
    [checkMarkImageView setHidden:YES];
    
    isVerified=NO;
    
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
            
            if (versionString.floatValue<7.0) {

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
    
    
    DBValidationStringLengthRule *phoneTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:businessPhoneNumberTextField keyPath:@"text" minStringLength:6 maxStringLength:12 failureMessage:@"Mobile number should be between 6 to 12 digits"];
    
    [businessPhoneNumberTextField addValidationRule:phoneTextFieldRule];
    
    
    DBValidationStringLengthRule *countryCodeTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:countryCodeTextField keyPath:@"text" minStringLength:2 maxStringLength:3 failureMessage:@"Country code should be a maximum of 3 digits"];
    
    [countryCodeTextField addValidationRule:countryCodeTextFieldRule];

    DBValidationEmailRule *emailTextFieldRule=[[DBValidationEmailRule alloc]initWithObject:emailTextField keyPath:@"text" failureMessage:@"Enter Vaild Email ID"];
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
    
    if (viewHeight==480)
    {
        
        if (textField.tag==1) {

            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];
            textField.placeholder=@"business category";
        }
        
        if (textField.tag==2)
        {
            [self animateTextField: textField up:YES movementDistance:80];
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];
            textField.placeholder=@"business name";
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
            textField.placeholder=@"email address";
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:YES movementDistance:80];

        }
        
        if (textField.tag==13 )
        {
            textField.placeholder=@"mobile number";
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

        if (textField.tag==1) {

            textField.placeholder=@"business category";

            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];

        }
        
        if (textField.tag==2) {

            textField.placeholder=@"business name";

            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepOneSubView];
            
        }
        
        if (textField.tag==3)
        {
            textField.placeholder=HouseNumberPlaceholder;
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
            return YES;
        }
        
        
        if (textField.tag==8)
        {
            textField.placeholder=PincodePlaceHolder;
            return YES;
        }
        
        if (textField.tag==9)
        {
            textField.placeholder=StatePlaceHolder;
            
            //[self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:YES movementDistance:40];
            return YES;
            
            
        }
        
        if (textField.tag==11) {
            
            if ( [textField isEqual:fpTagTextField] )
            {

                textFieldBeingEdited = fpTagTextField;
            }

        }
        
        
        if (textField.tag==12) {
            
            
            textField.placeholder=@"email address";
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepThreeSubView];
            
            
        }

        
        if (textField.tag==13)
        {
            textField.placeholder=@"mobile number";
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepThreeSubView];
        }
    }
    

    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
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
            
            [self animateTextField: textField up:NO movementDistance:140];
            return YES;
            
            
        }
        if (textField.tag==7)
        {
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
            return YES;
            
            
        }
        
        
        if (textField.tag==8)
        {
            return YES;
        }
        
        if (textField.tag==9)
        {
            //[self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:NO movementDistance:40];
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
    
    
    if (textField.tag==9) {

        [self performSelector:@selector(stepTwoNextBtnClicked:) withObject:[NSNumber numberWithInt:textField.tag]];
        
    }
    
    
    
    
    
    [textField resignFirstResponder];
    return NO;
}

#pragma Validate After Editing

-(void)validateTextFieldAfterEditing:(UITextField *)textField forView:(UIView *)currentSubview
{
    
    UIImageView *imgView=(UIImageView *)[currentSubview viewWithTag:textField.tag];
    
    if (textField.tag!=8)
    {

    if ([textField.text isEqualToString:@""] || textField.text.length<3)
    {
        [self changeBorderColorIf:NO forView:imgView];
        
        UIColor *color = [UIColor redColor];
        
        UIFont *font=[UIFont fontWithName:@"Helvetica" size:14.0];

        if (textField.tag==1)
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter a category" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
        }

        
        if (textField.tag==2)
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter business name" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
        }

        
        if (textField.tag==7)
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter city name" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
        }
        
        if (textField.tag==12) {

            UIFont *font=[UIFont fontWithName:@"Helvetica" size:12.0];

            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter email address" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];

        }

        if (textField.tag==13) {

            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter mobile number" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];

        }
        
        
        
    }
    else
    {

        [self changeBorderColorIf:YES forView:imgView];
    }
    
    }
    
    
    if (textField.tag==8)
    {
        if ([textField.text isEqualToString:@""])
        {
            [self changeBorderColorIf:NO forView:imgView];
            
            UIColor *color = [UIColor redColor];
            
            UIFont *font=[UIFont fontWithName:@"Helvetica" size:14.0];
            
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"please enter this out" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
            
        }
        
        else if ([textField.text length]<6 || [textField.text length]>6)
        {
        
            [self changeBorderColorIf:NO forView:imgView];
            
            UIColor *color = [UIColor redColor];
            
            UIFont *font=[UIFont fontWithName:@"Helvetica" size:14.0];
            
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Must be equal to 6" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
        
        
        }
    
        else
        {
                
            [self changeBorderColorIf:YES forView:imgView];

        }
        

        
    }
    
    
    if (textField.tag==12)
    {
        
        
        if (![self validateEmailWithString:textField.text])
        {
            
            [self changeBorderColorIf:NO forView:imgView];
            
        }
        
            
        
    }
    
    
    if (textField.tag==13) {
        
        
        if (textField.text.length<9 || textField.text.length>15)
        {
            
            [self changeBorderColorIf:NO forView:imgView];
            
        }
        
    }
    
    
}


-(void)removeBorderFromTextFieldBeforeEditing:(UITextField *)textField forView:(UIView *)currentSubview
{


    UIImageView *imgView=(UIImageView *)[currentSubview viewWithTag:textField.tag];

    [self changeBorderColorIf:YES forView:imgView];

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
        
        if ( [self textFieldHasWhiteSpaces:businessNameTextField.text] || [self textFieldHasWhiteSpaces:businessVerticalTextField.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Fields cannot be empty." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            
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
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[failureMessages componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
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
         
         nfActivity.activityTitle=@"Loading";
         
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

        nfActivity.activityTitle=@"Suggesting";
        
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


- (IBAction)stepOneBtnClicked:(id)sender
{
    

    if (![listOfStatesSubView isHidden])
    {
        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepTwoSubView];
                        }
                        completion:^(BOOL finished)
         {
             [listOfStatesTableView setHidden:YES];
             [listOfStatesSubView setHidden:YES];
             [stepTwoSubView setHidden:NO];

         }];
    }
    
    
    if (![mapSubView isHidden])
    {
        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepTwoSubView];
                        }
                        completion:^(BOOL finished)
         {
             [mapSubView setHidden:YES];
             [mapView setHidden:YES];
             [stepTwoSubView setHidden:NO];             
         }];
        
    }
    
    
    if (![countryCodeSubView isHidden])
    {
        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepFourSubVIew];
                        }
                        completion:^(BOOL finished)
         {
             [countryCodeSubView setHidden:YES];
             [stepFourSubVIew setHidden:NO];
         }];

                
    }
    
    if (stepOneButton.userInteractionEnabled)
    {
        [self setUpStep:[sender tag]];
    }
    
        
    
}


- (IBAction)stepTwoBtnClicked:(id)sender
{
    if (![countryCodeSubView isHidden])
    {
        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepFourSubVIew];
                        }
                        completion:^(BOOL finished)
         {
             [countryCodeSubView setHidden:YES];
             [stepFourSubVIew setHidden:NO];
         }];
        
        
    }

    if (stepTwoButton.isEnabled)
    {
        [self setUpStep:[sender tag]];
    }
    
}


- (IBAction)stepThreeBtnClicked:(id)sender
{
    if (![countryCodeSubView isHidden])
    {
        [UIView transitionWithView:_container
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [_container addSubview:stepFourSubVIew];
                        }
                        completion:^(BOOL finished)
         {
             [countryCodeSubView setHidden:YES];
             [stepFourSubVIew setHidden:NO];
         }];
    }

    if (stepThreeButton.isEnabled)
    {    
        [self setUpStep:[sender tag]];
    }
}


- (IBAction)stepFourBtnClicked:(id)sender
{
    
    if (stepFourButton.isEnabled)
    {
        [self setUpStep:[sender tag]];
    }


}


- (IBAction)stepOneDismissBtnClicked:(id)sender
{
    
    [self.view endEditing:YES];
}


- (IBAction)stepTwoKeyBoardShouldReturn:(id)sender
{
    [[self view] endEditing:YES];
}


- (IBAction)stepThreeKeyBoardShouldReturn:(id)sender
{
    [[self view] endEditing:YES];

}


- (IBAction)categorySubViewBtnClicked:(id)sender
{

    [categoryArray removeAllObjects];
    
    [self.view endEditing:YES];
    
    [self.view addSubview:pickerViewSubView];
    
    [downloadingCategoriesActivityView setHidden:NO];
    
    [pickerView setHidden:YES];    
    
    FpCategoryController *categoryController=[[FpCategoryController alloc]init];
    
    categoryController.delegate=self;
    
    [categoryController downloadFpCategoryList];

    
    
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

#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    CGFloat pageWidth = mainScrollView.frame.size.width;
    
    int page = floor((mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    scrollPageControl.currentPage = page;
    
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
        [pickerView setHidden:NO];
        
        [downloadingCategoriesActivityView setHidden:YES];
        [categoryPickerView reloadAllComponents];
        
        
        
    }
    
    
    else
    {
        [pickerView setHidden:YES];
        [pickerViewSubView removeFromSuperview];
        
    
    }
    
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
    [self presentModalViewController:navigationController animated:YES];

}

-(void)fpCategoryDidFailWithError
{

    [pickerViewSubView removeFromSuperview];

}


#pragma VerifyUniqueNameDelegate


-(void)verifyUniqueNameDidComplete:(NSString *)responseString
{

    if ([[responseString lowercaseString] isEqualToString:fpTagTextField.text])
    {
        [checkMarkImageView setHidden:NO];
        
        isVerified=YES;
        
        [stepThreeNextButton setEnabled:YES]; 
        
        [verifyValidFpActivityIndicator stopAnimating];
        
        [checkMarkImageView setImage:[UIImage imageNamed:@"valid.png"]];        
    }
    
    
    else
    {
        [checkMarkImageView setHidden:NO];
        
        isVerified=NO;
        
        [verifyValidFpActivityIndicator stopAnimating];
        
        [checkMarkImageView setImage:[UIImage imageNamed:@"invalid.png"]];
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

    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    UIAlertView *noLocationAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"We could not point on the map with the given address. Please enter a valid address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [noLocationAlertView show];
    noLocationAlertView=nil;
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

    NSUserDefaults  *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:responseString  forKey:@"userFpId"];
    
    [userDefaults synchronize];

    
    /*Get all the messages and store details*/
    
    GetFpDetails *getDetails=[[GetFpDetails alloc]init];
    
    getDetails.delegate=self;
    
    [getDetails fetchFpDetail];

}


-(void)signUpDidFailWithError
{
    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    UIAlertView *fpCreationFailError=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Sorry something went wrong while creating your website" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [fpCreationFailError show];
    
    fpCreationFailError=nil;

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



#pragma updateDelegate

-(void)downloadFinished
{

    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
    
    @try
    {
        [self setRegisterChannel];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel identify:appDelegate.storeTag]; //username
        
        NSDictionary *specialProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                           appDelegate.storeEmail, @"$email",
                                           appDelegate.businessName, @"$name",
                                           nil];
        
        [mixpanel.people set:specialProperties];
        [mixpanel.people addPushDeviceToken:appDelegate.deviceTokenData];
    }
    @catch (NSException *e){}
    

    
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    fHelper.userFpTag=appDelegate.storeTag;
    
    [fHelper createUserSettings];
    
    BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    frontController.isLoadedFirstTime=YES;
    
    [self.navigationController pushViewController:frontController animated:YES];
    
    frontController=nil;

}


-(void)downloadFailedWithError
{

    [nfActivity hideCustomActivityView];
    
    nfActivity=nil;
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

#pragma SetUpStep

-(void)setUpStep:(int)stepNumber
{

    [self.view endEditing:YES];
    UIView *setUpSubView;
    UIView *subViewToRemove;
    int currentPosition=currentView;
    
    
    if ([customNextButton isHidden]) {
        
        [customNextButton setHidden:NO];
        
    }
    
    
    if ([stepControllerSubView isHidden]) {

        
        [UIView transitionWithView:self.view
                          duration:.50f
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^
         {
             
             
             [stepControllerSubView setHidden:NO];
             [stepControllerSubView setFrame:CGRectMake(0,stepControllerSubView.frame.origin.y-109, stepControllerSubView.frame.size.width,stepControllerSubView.frame.size.height)];
             
             
             
         } completion:^(BOOL finished)
         {
             

             
         }];

        
    }
    
    
    
    if (stepNumber!=currentView)
    {

    switch (stepNumber)
    {
        case 1:
            
            setUpSubView=stepOneSubView;
            
            [customCancelButton removeTarget:self action:@selector(stepOneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton addTarget:self action:@selector(cancelRegisterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton removeTarget:self action:@selector(stepTwoNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton addTarget:self action:@selector(stepOneNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case 2:
                    
            setUpSubView=stepTwoSubView;
            
            [customCancelButton setTag:1];
            
            [customCancelButton removeTarget:self action:@selector(stepTwoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton addTarget:self action:@selector(stepOneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton removeTarget:self action:@selector(stepThreeNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton addTarget:self action:@selector(stepTwoNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            

            
            break;
            
        case 3:
            
            setUpSubView=stepThreeSubView;
            
            [customCancelButton setTag:2];
            
            [customCancelButton removeTarget:self action:@selector(stepThreeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton addTarget:self action:@selector(stepTwoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton removeTarget:self action:@selector(stepFourNextBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton addTarget:self action:@selector(stepThreeNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case 4:
            setUpSubView=stepFourSubVIew;
            break;
            
        default:
            break;
    }
    
    switch (currentView)
    {   
        case 1:
            subViewToRemove=stepOneSubView;            
            currentView=stepNumber;
            break;
            
        case 2:
            subViewToRemove=stepTwoSubView;
            [stepTwoButton setUserInteractionEnabled:YES];
            [stepTwoButton setEnabled:NO];
            currentView=stepNumber;
            break;
            
        case 3:
            subViewToRemove=stepThreeSubView;
            [stepThreeButton setUserInteractionEnabled:YES];
            [stepThreeButton setEnabled:NO];
            currentView=stepNumber;
            break;
            
        case 4:
            subViewToRemove=stepFourSubVIew;
            [stepFourButton setUserInteractionEnabled:YES];
            [stepFourButton setEnabled:NO];
            currentView=stepNumber;
            break;
            
        default:
            break;
    }

    
        
    [UIView transitionWithView:_container
                      duration:.50f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^
     {                

         [setUpSubView setFrame:CGRectMake(0, 0, _container.frame.size.width,_container.frame.size.height)];
         
         [subViewToRemove setFrame:CGRectMake(320,0, _container.frame.size.width,_container.frame.size.height)];

         
     } completion:^(BOOL finished)
     {



         switch (currentPosition)
         {
             case 3:
                 if (stepNumber==1)
                 {

                     if (stepFourButton.isEnabled || stepTwoButton.isEnabled || stepThreeButton.isEnabled)
                     {                         
                         [stepFourButton setEnabled:NO];
                         [stepThreeButton setEnabled:NO];
                         [stepTwoButton setEnabled:NO];
                     }                 
                 }
                 
                break;

             case 4:

                 if (stepNumber==1)
                 {
                     
                     if (stepFourButton.isEnabled || stepTwoButton.isEnabled || stepThreeButton.isEnabled)
                     {
                         [stepFourButton setEnabled:NO];
                         [stepThreeButton setEnabled:NO];
                         [stepTwoButton setEnabled:NO];                         
                     }
                     
                 }
                 
                 if (stepNumber==2)
                 {
                     if (stepFourButton.isEnabled || stepThreeButton.isEnabled)
                     {
                         [stepFourButton setEnabled:NO];
                         [stepThreeButton setEnabled:NO];
                     }
                     
                 }
                 break;
             default:
                 break;
         }

         switch (currentView)
         {
             case 1:
                 
                 navBar.topItem.title=@"Business Details";

                 break;

             case 2:
                 
                 navBar.topItem.title=@"Business Address";
                 
                 break;

             case 3:
                 
                 navBar.topItem.title=@"Contact Details";
                 
                 break;

             default:
                 break;
         }
         
         
     }
     ];

        
        
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



#pragma PopUpDelegate
-(void)successBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue]==101)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Cancel SignUp"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


-(void)cancelBtnClicked:(id)sender
{
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
    //    NSLog(@"channelDidRegisterSuccessfully");
}

-(void)channelFailedToRegister
{
    //    NSLog(@"channelFailedToRegister");
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
