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


#define defaultSubViewWidth 300
#define defaultSubViewHeight 260


#define HouseNumberPlaceholder @"House number, building name, etc"
#define CityPlaceHolder @"City"
#define PincodePlaceHolder @"Pincode"
#define StatePlaceHolder @"State"



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


@interface SignUpViewController ()<VerifyUniqueNameDelegate,FpCategoryDelegate,FpAddressDelegate,SignUpControllerDelegate,updateDelegate,SuggestBusinessDomainDelegate,ChangeStoreTagDelegate>
{
    UIImage *buttonBackGroundImage;
    NSCharacterSet *blockedCharacters;
    int currentView;
    long viewHeight;
    long viewWidth;
    NSString *categoryString;
    NSString *countryCodeString;
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
    
    
    buttonBackGroundImage=[UIImage imageNamed:@"yellowcircle.png"];

    [stepTwoButton setUserInteractionEnabled:NO];
    
    [stepThreeButton setUserInteractionEnabled:NO];
    
    [stepFourButton setUserInteractionEnabled:NO];
    
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
    
    //Create NavBar here
    
    [navBar setClipsToBounds:YES];
    
    navBar.topItem.title=@"Business Details";
    
    //Create the custom cancel button here
    
    UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];

    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setFrame:CGRectMake(5,9,32,26)];
    
    [customCancelButton addTarget:self action:@selector(cancelRegisterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];
    
    
    UIImage *buttonNextImage = [UIImage imageNamed:@"next-btn.png"];

    customNextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customNextButton setFrame:CGRectMake(285,9,32,26)];
    
    [customNextButton addTarget:self action:@selector(stepOneNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [customNextButton setImage:buttonNextImage  forState:UIControlStateNormal];
    
    [customNextButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customNextButton];
        categoryTableView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    categoryTableView.layer.borderWidth=1.0;
    
    listOfStatesTableView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    listOfStatesTableView.layer.borderWidth=1.0;
    
    countryCodesTableView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    countryCodesTableView.layer.borderWidth=1.0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        viewWidth=result.width;
        if(result.height == 480)
        {
            /*For iphone 3,3gS,4,42*/            
            viewHeight=480;

        }
        if(result.height == 568)
        {
            /*For iphone 5*/
            viewHeight=568;
            
        }
    }
    
    

    
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
    
    [_container addSubview:activitySubView];[activitySubView setHidden:YES];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            /*For iphone 3,3gS,4,42*/
            
            [stepControllerSubView setFrame:CGRectMake(0, 360, 320, 100)];
                        
            [stepTwoScrollView setContentSize:CGSizeMake(_container.frame.size.width, _container.frame.size.height+160)];
                        
        }
        if(result.height == 568)
        {
            /*For iphone 5*/
            
            [stepControllerSubView setFrame:CGRectMake(0, 448, 320, 100)];
                        
            [categoryTableView setFrame:CGRectMake(categoryTableView.frame.origin.x, categoryTableView.frame.origin.y, categoryTableView.frame.size.width, categoryTableView.frame.size.height)];

            //[stepTwoScrollView setContentSize:CGSizeMake(_container.frame.size.width, _container.frame.size.height+190)];
        }
    }
    
    
    /*Give the validations to the UITextFields here*/
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
    
    
    DBValidationStringLengthRule *pincodeTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:pincodeTextField  keyPath:@"text" minStringLength:6 maxStringLength:6 failureMessage:@"Pincode should only be 6 characters"];
    
    [pincodeTextField addValidationRule:pincodeTextFieldRule];
    
    
    DBValidationStringLengthRule *nameTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:ownerNameTextField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Name should atleast contain 3 characters"];
    
    [ownerNameTextField addValidationRule:nameTextFieldRule];
    
    
    DBValidationStringLengthRule *phoneTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:businessPhoneNumberTextField keyPath:@"text" minStringLength:10 maxStringLength:10 failureMessage:@"Phone number should atleast contain 10 digits"];
    
    [businessPhoneNumberTextField addValidationRule:phoneTextFieldRule];
    
    
    DBValidationStringLengthRule *countryCodeTextFieldRule = [[DBValidationStringLengthRule alloc] initWithObject:countryCodeTextField keyPath:@"text" minStringLength:2 maxStringLength:3 failureMessage:@"Country code should be a maximum of 3 digits"];
    
    [countryCodeTextField addValidationRule:countryCodeTextFieldRule];

    DBValidationEmailRule *emailTextFieldRule=[[DBValidationEmailRule alloc]initWithObject:emailTextField keyPath:@"text" failureMessage:@"Enter Vaild Email Id"];
    [emailTextField addValidationRule:emailTextFieldRule];
    
    
}


-(void)cancelRegisterButtonClicked
{

    UIAlertView *cancelAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Are you sure you want to cancel the registration process ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
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

    if (field.tag==2 || field.tag==7 || field.tag==11 || field.tag==9)
    {
        //Tells the delegate to skip whitespaces
        if (![characters isEqualToString:@" "])
        {
            return ([characters rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
            
        }
     
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
        if (textField.tag==2)
        {
            [self animateTextField: textField up:YES movementDistance:80];
            return YES;
        }
        
        if (textField.tag==15) {
            
            [self animateTextField: textField up:YES movementDistance:160];
            return YES;

        }



    if (textField.tag==3)
    {
            
        textField.placeholder=HouseNumberPlaceholder;
        
        [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
        
    }
    


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
            textField.placeholder=PincodePlaceHolder;
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:YES movementDistance:170];
            return YES;
            
            
        }

        if (textField.tag==9)
        {
            textField.placeholder=StatePlaceHolder;
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            [self animateTextField: textField up:YES movementDistance:170];
            return YES;
            
            
        }
        
        if (textField.tag==12) {
            
            
            textField.placeholder=@"Email address";

            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];

            
        }
        
        if (textField.tag==13 ) {
            
            textField.placeholder=@"Phone number";

            //[self animateTextField: textField up:YES movementDistance:60];
            
            return YES;

        }

        if (textField.tag==14) {
            
            [self animateTextField: textField up:YES movementDistance:60];
            return YES;
            
        }

        
        
    }
    
    
    else
    {
        
        if (textField.tag==3)
        {
            
            textField.placeholder=HouseNumberPlaceholder;
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            
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

            //[self animateTextField: textField up:YES movementDistance:160];
            return YES;
            
            
        }
        
        
        if (textField.tag==8)
        {
            textField.placeholder=PincodePlaceHolder;
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
            return YES;
            
            
        }
        
        if (textField.tag==9)
        {
            textField.placeholder=StatePlaceHolder;
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepTwoSubView];
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
            
            
            textField.placeholder=@"Email address";
            
            [self removeBorderFromTextFieldBeforeEditing:textField forView:stepThreeSubView];
            
            
        }

        
        if (textField.tag==13) {
            
            
            textField.placeholder=@"Phone number";
            
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
            
            return YES;
        }
                
        if (textField.tag==3)
        {
            
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
        
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
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];

            [self animateTextField: textField up:NO movementDistance:170];
            
            return YES;
            
            
        }
        
        if (textField.tag==9)
        {
            
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];

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
            return YES;
            
            
        }
        
        
        if (textField.tag==13)
        {
            [self validateTextFieldAfterEditing:textField forView:stepThreeSubView];
            //[self animateTextField: textField up:NO movementDistance:60];

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
            
            return YES;
        }

        
        
        if (textField.tag==3)
        {
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
            
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
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];
            return YES;
            
            
        }
        
        if (textField.tag==9)
        {
            [self validateTextFieldAfterEditing:textField forView:stepTwoSubView];            
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
        
        
        [self performSelector:@selector(stepOneNextButtonClicked:) withObject:[NSNumber numberWithInt:textField.tag]];
        
    }
    
    
    if (textField.tag==9) {

        [self performSelector:@selector(stepTwoNextButtonClicked:) withObject:[NSNumber numberWithInt:textField.tag]];
        
        
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
        
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Please fill this out" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];

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
            
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Please fill this out" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:font}];
            
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
        
        
        if (textField.text.length<10 || textField.text.length>10)
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


- (IBAction)stepOneNextButtonClicked:(id)sender
{

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
                
            }
            
            if ([self textFieldHasWhiteSpaces:businessVerticalTextField.text])
            {
                
                [self changeBorderColorIf:NO forView:businessVerticalBg];

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
    
    currentView=2;
    [stepTwoButton setBackgroundImage:buttonBackGroundImage forState:UIControlStateNormal];
    [stepTwoButton  setUserInteractionEnabled:YES];
    [stepTwoButton setEnabled:YES];

    if (stepTwoSubView.frame.origin.x==-320)
    {
        [stepTwoSubView setFrame:CGRectMake(320, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    }
    
    [UIView transitionWithView:_container
                      duration:.50f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^
                    {                    
                        [stepTwoSubView setFrame:CGRectMake(0, 0, stepTwoSubView.frame.size.width,  stepTwoSubView.frame.size.height)];
                        [stepOneSubView setFrame:CGRectMake(-320,0, stepOneSubView.frame.size.width,  stepOneSubView.frame.size.height)];

                        [customCancelButton setTag:1];
                        
                        [customCancelButton removeTarget:self action:@selector(cancelRegisterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                        
                        [customCancelButton addTarget:self action:@selector(stepOneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [customNextButton removeTarget:self action:@selector(stepOneNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [customNextButton addTarget:self action:@selector(stepTwoNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                    } completion:^(BOOL finished)
     {
         
         navBar.topItem.title=@"Business Address";
         
     }];
        
    }
    
}


- (IBAction)stepTwoNextButtonClicked:(id)sender
{

    [self.view endEditing:YES];
    
     NSMutableArray *failureMessages = [NSMutableArray array];
    
     NSArray *textFields = @[houseNumberTextField,cityNameTextField,pincodeTextField,stateNameTextField];
    
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
        
    if ([streetNameTextField.text length]==0 || [landMarkTextField.text length]==0)
    {
        
        
    if ([streetNameTextField.text length]==0 && [landMarkTextField.text length]==0)
    {
        
        addressString=[NSString stringWithFormat:@"%@,%@,%@,%@,%@",houseNumberTextField.text,pincodeTextField.text,cityNameTextField.text,stateNameTextField.text,countryNameTextField.text];
        
    }
    
    else
    {

        if ([streetNameTextField.text length]==0)
        {
            
            addressString=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",houseNumberTextField.text,landMarkTextField.text,pincodeTextField.text,cityNameTextField.text,stateNameTextField.text,countryNameTextField.text];
        }
        
        if([landMarkTextField.text length]==0)

        {
            addressString=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",houseNumberTextField.text,streetNameTextField.text,pincodeTextField.text,cityNameTextField.text,stateNameTextField.text,countryNameTextField.text];

                
        }
    
    
    }
        
        
    }
    
    else
    {
   
       addressString=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",houseNumberTextField.text,streetNameTextField.text,landMarkTextField.text,pincodeTextField.text,cityNameTextField.text,stateNameTextField.text,countryNameTextField.text];
       
   }
       
         
         //[stepTwoSubView addSubview:activitySubView];
         
         [activitySubView   setHidden:NO];
         
         GetFpAddressDetails *_verifyAddress=[[GetFpAddressDetails alloc]init];
         
         _verifyAddress.delegate=self;
         
         [_verifyAddress downloadFpAddressDetails:addressString];
         
    }
}


- (IBAction)stepThreeNextButtonClicked:(id)sender
{
    
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
    
    //Sign Up With NowFloats Final Stage of the registration process
    /*
     NSMutableDictionary *regiterDetails;
     
     regiterDetails=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
     appDelegate.clientId,@"clientId",
     fpTagTextField.text,@"tag",
     ownerNameTextField.text,@"contactName",
     businessNameTextField.text,@"name",
     businessDescriptionTextField.text,@"desc",
     cityNameTextField.text,@"city",
     pincodeTextField.text,@"pincode",
     countryNameTextField.text,@"country",
     addressString,@"address",
     businessPhoneNumberTextField.text,@"primaryNumber",
     [NSString stringWithFormat:@"%@",countryCodeTextField.text],@"primaryNumberCountryCode",
     [NSString stringWithFormat:@""],@"email",
     [NSString stringWithFormat:@""],@"Uri",
     [NSString stringWithFormat:@""],@"fbPageName",
     businessVerticalTextField.text,@"primaryCategory",
     [NSString stringWithFormat:@"%f",storeLatitude],@"lat",
     [NSString stringWithFormat:@"%f",storeLongitude],@"lng",
     nil];
     
     
     [self.view addSubview:creatingWebsiteActivitySubView];
     
     
     
     SignUpController *signUpController=[[SignUpController alloc]init];
     
     signUpController.delegate=self;
     
     //[signUpController withCredentials:regiterDetails];
     */

    else
    {
        
    [self.view addSubview:suggestingActivitySubView];
        
    NSDictionary *uploadDictionary=@{@"name":businessNameTextField.text,@"city":cityNameTextField.text,@"country":countryNameTextField.text,@"category":businessVerticalTextField.text,@"clientId":appDelegate.clientId};
        
        
    SuggestBusinessDomain *suggestController=[[SuggestBusinessDomain alloc]init];

    suggestController.delegate=self;
        
    [suggestController suggestBusinessDomainWith:uploadDictionary];

    suggestController =nil;     
     
    }

}

#pragma SuggestBusinessDomainDelegate

-(void)suggestBusinessDomainDidComplete:(NSString *)suggestedDomainString
{
    
     [suggestingActivitySubView removeFromSuperview];
     [UIView transitionWithView:self.view
     duration:.50f
     options:UIViewAnimationOptionCurveEaseIn
     animations:^
     {
     
     [stepControllerSubView setFrame:CGRectMake(0,stepControllerSubView.frame.origin.y+109, stepControllerSubView.frame.size.width,stepControllerSubView.frame.size.height)];
     
     
     
     } completion:^(BOOL finished)
     {
     
     [stepControllerSubView setHidden:YES];
     
     }];
     
     
     
     currentView=4;
     
     [UIView transitionWithView:_container
     duration:.50f
     options:UIViewAnimationOptionCurveEaseIn
     animations:^
     {
     
     [stepThreeButton setBackgroundImage:buttonBackGroundImage forState:UIControlStateNormal];
     [stepThreeButton  setUserInteractionEnabled:YES];
     [stepThreeButton setEnabled:YES];
     
     
     [stepFourSubVIew setFrame:CGRectMake(0, 0, stepThreeSubView.frame.size.width,  stepThreeSubView.frame.size.height)];
     [stepThreeSubView setFrame:CGRectMake(-320,0, stepTwoSubView.frame.size.width,  stepTwoSubView.frame.size.height)];
     
     [customCancelButton setTag:3];
     
     [customCancelButton removeTarget:self action:@selector(stepTwoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     [customCancelButton addTarget:self action:@selector(stepThreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     [customNextButton removeTarget:self action:@selector(stepThreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     [customNextButton addTarget:self action:@selector(stepFourNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     }  completion:^(BOOL finished)
     {
     
             navBar.topItem.title=@"Business Domain";
             
             suggestedUriTextView.text=[suggestedDomainString lowercaseString];
         
         
         suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:16.0];

         
         
         
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
         
         if (suggestedUriTextView.text.length>36) {

             suggestedUriTextView.font=[UIFont fontWithName:@"Helvetica" size:12.0];
             
         }
     }
         
            
         
             [customNextButton setHidden:YES];
     
     }];
     
}


- (IBAction)stepFourNextButtonClicked:(id)sender
{
    
    /*
    [self.view endEditing:YES];
    
    NSMutableArray *failureMessages = [NSMutableArray array];
    
    NSArray *textFields = @[ownerNameTextField,businessPhoneNumberTextField,countryCodeTextField];
    
    for (id object in textFields)
    {
        [failureMessages addObjectsFromArray:[object validate]];
    }
    
    if (failureMessages.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[failureMessages componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    else
    {
        NSMutableDictionary *regiterDetails;
        
        regiterDetails=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                        appDelegate.clientId,@"clientId",
                        fpTagTextField.text,@"tag",
                        ownerNameTextField.text,@"contactName",
                        businessNameTextField.text,@"name",
                        businessDescriptionTextField.text,@"desc",
                        cityNameTextField.text,@"city",
                        pincodeTextField.text,@"pincode",
                        countryNameTextField.text,@"country",
                        addressString,@"address",
                        businessPhoneNumberTextField.text,@"primaryNumber",
                        [NSString stringWithFormat:@"%@",countryCodeTextField.text],@"primaryNumberCountryCode",
                        [NSString stringWithFormat:@""],@"email",
                        [NSString stringWithFormat:@""],@"Uri",
                        [NSString stringWithFormat:@""],@"fbPageName",
                        businessVerticalTextField.text,@"primaryCategory",
                        [NSString stringWithFormat:@"%f",storeLatitude],@"lat",
                        [NSString stringWithFormat:@"%f",storeLongitude],@"lng",                        
                        nil];
        
        
        [self.view addSubview:creatingWebsiteActivitySubView];
        
        
        
        SignUpController *signUpController=[[SignUpController alloc]init];
        
        signUpController.delegate=self;
        
        //[signUpController withCredentials:regiterDetails];
        
    }
     
     */
}


- (IBAction)stepOneButtonClicked:(id)sender
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


- (IBAction)stepTwoButtonClicked:(id)sender
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


- (IBAction)stepThreeButtonClicked:(id)sender
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


- (IBAction)stepFourButtonClicked:(id)sender
{
    
    if (stepFourButton.isEnabled)
    {
        [self setUpStep:[sender tag]];
    }


}



- (IBAction)stepOneDismissButtonClicked:(id)sender
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


- (IBAction)categorySubViewButtonClicked:(id)sender
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


- (IBAction)mapSaveButtonClicked:(id)sender
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


- (IBAction)mapCancelButtonClicked:(id)sender
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


- (IBAction)countryButtonClicked:(id)sender
{
    [self.view endEditing:YES];

    [self.view addSubview:countryPickerSubView];
    
    
    
}


- (IBAction)countryCodeButtonClicked:(id)sender
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
- (IBAction)createWebSiteButtonClicked:(id)sender
{
    
     [self.view endEditing:YES];
     
     if (suggestedUriTextView.text.length==0)
     {
     
         UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Store domain cannot be empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

         [alertView show];
         
         alertView=nil;
     
     }
     
     else
     {
     NSMutableDictionary *regiterDetails;
     
     regiterDetails=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
     appDelegate.clientId,@"clientId",
     suggestedUriTextView.text,@"tag",
     [NSString stringWithFormat:@""],@"contactName",
     businessNameTextField.text,@"name",
     [NSString stringWithFormat:@""],@"desc",
     cityNameTextField.text,@"city",
     pincodeTextField.text,@"pincode",
     countryNameTextField.text,@"country",
     addressString,@"address",
     businessPhoneNumberTextField.text,@"primaryNumber",
     [NSString stringWithFormat:@"%@",countryCodeTextField.text],@"primaryNumberCountryCode",
     [NSString stringWithFormat:@""],@"email",
     [NSString stringWithFormat:@""],@"Uri",
     [NSString stringWithFormat:@""],@"fbPageName",
     businessVerticalTextField.text,@"primaryCategory",
     [NSString stringWithFormat:@"%f",storeLatitude],@"lat",
     [NSString stringWithFormat:@"%f",storeLongitude],@"lng",
     nil];
     
     
     [self.view addSubview:creatingWebsiteActivitySubView];
          
     SignUpController *signUpController=[[SignUpController alloc]init];
     
     signUpController.delegate=self;
     
     [signUpController withCredentials:regiterDetails];
     
     }
     
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
    countryCodeString=[NSString stringWithFormat:@"%@",codeText];
    
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

- (IBAction)categoryDoneButtonClicked:(id)sender
{
    [pickerViewSubView removeFromSuperview];
    
    
    if (categoryString.length==0)
    {
        
        categoryString=[categoryArray objectAtIndex:0];
        
    }
    
    businessVerticalTextField.text=categoryString;
    
    [self changeBorderColorIf:YES forView:businessVerticalBg];

    categoryString=@"";
}

- (IBAction)categoryCancelButtonClicked:(id)sender
{
    [pickerViewSubView removeFromSuperview];
    
}

- (IBAction)countryDoneButtonClicked:(id)sender
{
    [countryPickerSubView removeFromSuperview];

    if (countryCodeString.length==0)
    {
        
        categoryString=[countryListArray objectAtIndex:0];
        countryCodeString=[countryCodeArray objectAtIndex:0];
    }
    
    countryNameTextField.text=categoryString;
    countryCodeTextField.text=countryCodeString;
    categoryString=@"";
    countryCodeString=@"";
}

- (IBAction)countryCancelButtonClicked:(id)sender
{
    
    [countryPickerSubView removeFromSuperview];

}

- (IBAction)endEditingButtonPressed:(id)sender
{
    
    [self.view endEditing:YES];
}

- (IBAction)countryCodeDoneButtonClicked:(id)sender
{
    
    [countryCodePickerSubView removeFromSuperview];
    
    
    if (countryCodeString.length==0)
    {
        
        countryCodeString=[countryCodeArray objectAtIndex:0];
        
    }
    
    countryCodeTextField.text=countryCodeString;
    countryCodeString=@"";

    
}


- (IBAction)countryCodeCancelButtonClicked:(id)sender
{
    
    [countryCodePickerSubView removeFromSuperview];

}


- (IBAction)changeStoreTag:(id)sender
{
    
    [self changeStoreTagButtonClicked];
    
}


-(void)changeStoreTagButtonClicked
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
    
    //[activitySubView removeFromSuperview];
    
    [activitySubView setHidden:YES];
    
    storeLatitude=[[locationArray valueForKey:@"lat"] doubleValue];
    storeLongitude=[[locationArray valueForKey:@"lng"] doubleValue];
    
    
/*
    [UIView transitionWithView:_container
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [_container addSubview:mapSubView];
                    }
                    completion:^(BOOL finished)
     {
         
         NSString *latitudeString = [locationArray valueForKey:@"lat"];
         NSString *longitudeString = [locationArray valueForKey:@"lng"];
         
         MKCoordinateRegion region;
         MKCoordinateSpan span;
         
         span.latitudeDelta = 0.005;
         span.longitudeDelta = 0.005;
         
         CLLocationCoordinate2D location ;
         
         
         location.latitude=[latitudeString doubleValue];
         location.longitude=[longitudeString doubleValue];
         
         
         region.span = span;
         region.center = location;
         
         self.addressAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
         
         [mapView addAnnotation:self.addressAnnotation];
         [mapView setRegion:region animated:YES];
         [mapView regionThatFits:region];
         
         storeLatitude=location.latitude;
         storeLongitude=location.longitude;
     }];
*/
    
     [UIView transitionWithView:_container
     duration:.50f
     options:UIViewAnimationOptionCurveEaseIn
     animations:^
     {
     
     [stepThreeButton setBackgroundImage:buttonBackGroundImage forState:UIControlStateNormal];
     [stepThreeButton  setUserInteractionEnabled:YES];
     [stepThreeButton setEnabled:YES];
     
     
     [stepThreeSubView setFrame:CGRectMake(0, 0, stepThreeSubView.frame.size.width,  stepThreeSubView.frame.size.height)];
     [stepTwoSubView setFrame:CGRectMake(-320,0, stepTwoSubView.frame.size.width,  stepTwoSubView.frame.size.height)];
     
     [customCancelButton setTag:2];
     
     [customCancelButton removeTarget:self action:@selector(stepOneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     [customCancelButton addTarget:self action:@selector(stepTwoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     [customNextButton removeTarget:self action:@selector(stepTwoNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     [customNextButton addTarget:self action:@selector(stepThreeNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     }  completion:^(BOOL finished)
     {
     
     navBar.topItem.title=@"Contact Details";
     
     }];


    
}


-(void)fpAddressDidFail
{

    [activitySubView setHidden:YES];
    UIAlertView *noLocationAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"We could not point on the map with the given address.Please enter a valid address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

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
    
    [creatingWebsiteActivitySubView setHidden:YES];
    
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

    [creatingWebsiteActivitySubView removeFromSuperview];
    
    BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    frontController.isLoadedFirstTime=YES;
    
    [self.navigationController pushViewController:frontController animated:YES];
    
    frontController=nil;

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
            
            [self changeStoreTagButtonClicked];

            
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
            
            [customCancelButton removeTarget:self action:@selector(stepOneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton addTarget:self action:@selector(cancelRegisterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton removeTarget:self action:@selector(stepTwoNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton addTarget:self action:@selector(stepOneNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case 2:
                    
            setUpSubView=stepTwoSubView;
            
            [customCancelButton setTag:1];
            
            [customCancelButton removeTarget:self action:@selector(stepTwoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton addTarget:self action:@selector(stepOneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton removeTarget:self action:@selector(stepThreeNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton addTarget:self action:@selector(stepTwoNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            

            
            break;
            
        case 3:
            
            setUpSubView=stepThreeSubView;
            
            [customCancelButton setTag:2];
            
            [customCancelButton removeTarget:self action:@selector(stepThreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton addTarget:self action:@selector(stepTwoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton removeTarget:self action:@selector(stepFourNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [customNextButton addTarget:self action:@selector(stepThreeNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
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
    activitySubView = nil;
    listOfStatesTableView = nil;
    listOfStatesSubView = nil;
    businessDescriptionTextField = nil;
    countryCodesTableView = nil;
    countryCodeSubView = nil;
    stepControllerSubView = nil;
    creatingWebsiteActivitySubView = nil;
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
    suggestingActivitySubView = nil;
    [super viewDidUnload];
}


@end
