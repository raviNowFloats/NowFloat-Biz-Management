//
//  DomainSelectViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "DomainSelectViewController.h"
#import "UIColor+HexaString.h"
#import "CheckDomainAvailablityController.h"
#import "AddWidgetController.h"
#import "BizStoreIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "BuyDomainController.h"
#import "DBValidator.h"
#import "NFActivityView.h"
#import "Mixpanel.h"

@interface DomainSelectViewController ()<CheckDomainAvailablityDelegate,BuyDomainDelegate,AddWidgetDelegate>
{
    float viewHeight;
    NSArray *_products;
    NSString *version;
    UINavigationBar *navBar;
    NSArray *subViewArray;
    NSArray *bgArray;
    NFActivityView *domainAvailCheckAV;
    NFActivityView *buyDomainAV;
    UILabel *headerLabel;
}

@end

@implementation DomainSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //[self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.4];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];
    
    

}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        
        else
        {
            viewHeight=568;
        }
    }

    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    version = [[UIDevice currentDevice] systemVersion];

    bgArray= [[NSArray alloc]initWithObjects:@"",domainNameBg,domainTypeBg,contactNameImgView,phoneNumberImgView,emailImgView,addressImgView,cityImgView,stateImgView,countryImgView,zipCodeImgView,nil];
    
    //Create NavBar here
    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                                   CGRectMake(0,0,width,44)];
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(90,13,160,20)];
        
        headerLabel.text=@"Domain Availability";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        [navBar addSubview:headerLabel];
        
        [self.view addSubview:navBar];
    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Domain Availability";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    [self drawBorder];
    
    subViewArray=[[NSMutableArray alloc]initWithObjects:selectDomainSubView,contactInformationSubView,nil];
    
    
    for (int i = 0; i < subViewArray.count; i++)
    {
        CGRect frame;
        
        frame.origin.x = contentScrollView.frame.size.width * i;
        
        frame.origin.y = 0;
        
        if(viewHeight==568)
        {
            frame.size.height = 568;
        }
        else
        {
            frame.size.height = 460;
        }
        
        frame.size.width= 320;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        
        [subview addSubview:[subViewArray objectAtIndex:i]];
        
        [contentScrollView addSubview:subview];
    }
    
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width * subViewArray.count,568);
    
    if (viewHeight==480)
    {
        buyDomainScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width, 700);
    }
    
    else
    {
        buyDomainScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width,620);
    }
    
    [self setUpDisplayData];
    
    [self setUpValidationRules];
    
    [self setUpNextView];
}


-(void)setUpNextView
{
    if (version.floatValue<7.0)
    {
        if (viewHeight==480)
        {
            [nextViewOne setFrame:CGRectMake(nextViewOne.frame.origin.x, 356, nextViewOne.frame.size.width, nextViewOne.frame.size.width)];
        }
    }
    
    else
    {
        if (viewHeight==480)
        {
            [nextViewOne setFrame:CGRectMake(nextViewOne.frame.origin.x, 346, nextViewOne.frame.size.width, nextViewOne.frame.size.width)];
        }
    }
}

-(void)setUpDisplayData
{
    if (![[appDelegate.storeDetailDictionary objectForKey:@"PrimaryNumber"] isEqualToString:@""] && [appDelegate.storeDetailDictionary   objectForKey:@"PrimaryNumber"]!=[NSNull null])
    {
        [mobileNumberTxtField setText:[appDelegate.storeDetailDictionary objectForKey:@"PrimaryNumber"]];
    }
}


-(void)setUpValidationRules
{
    DBValidationEmailRule *emailTextFieldRule=[[DBValidationEmailRule alloc]initWithObject:emailTxtField keyPath:@"text" failureMessage:@"Enter Vaild Email ID"];
    
    [emailTxtField addValidationRule:emailTextFieldRule];

    
    DBValidationStringLengthRule *contactNameRule=[[DBValidationStringLengthRule alloc]initWithObject:contactNameTxtField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Enter valid name"];
    
    [contactNameTxtField addValidationRule:contactNameRule];
    
    
    DBValidationStringLengthRule *addressRule=[[DBValidationStringLengthRule alloc]initWithObject:addressTxtField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Enter valid address"];
    
    [addressTxtField addValidationRule:addressRule];
    
    
    DBValidationStringLengthRule *cityRule=[[DBValidationStringLengthRule alloc]initWithObject:cityTxtField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Enter valid city"];
    
    [cityTxtField addValidationRule:cityRule];
    
    
    DBValidationStringLengthRule *stateRule=[[DBValidationStringLengthRule alloc]initWithObject:stateTxtField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Enter valid state"];
    
    [stateTxtField addValidationRule:stateRule];
    
    
    DBValidationStringLengthRule *countryRule=[[DBValidationStringLengthRule alloc]initWithObject:countryTxtField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Enter valid country"];
    
    [countryTxtField addValidationRule:countryRule];

    
    DBValidationStringLengthRule *zipCodeRule=[[DBValidationStringLengthRule alloc]initWithObject:zipCodeTxtField keyPath:@"text" minStringLength:3 maxStringLength:60 failureMessage:@"Enter valid zip code"];
    
    [zipCodeTxtField addValidationRule:zipCodeRule];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showKeyBoard
{
    
    [domainNameTextBox becomeFirstResponder];
    
    
}


- (IBAction)skipDomainPurchase:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"ttbdomaincombo_skipPurchase"];
    
    [self backBtnClicked];
}


- (IBAction)selectDomainTypeBtnClicked:(id)sender
{
    
    [self.view endEditing:YES];
    
    if (domainTypeBg.layer.borderColor==[UIColor redColor].CGColor)
    {
        [self changeBorderColorIf:YES forView:domainTypeBg];
    }

    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Choose a domain type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@".com",@".net", nil];
    selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    selectAction.tag=1;
    [selectAction showInView:self.view];

}


- (IBAction)dismissKeyboardBtnClicked:(id)sender
{
    
    [self.view endEditing:YES];
    
}

//First Next Button
- (IBAction)selectDomainNextButtonClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"ttbdomaincombo_selectDomainBtnClicked"];
    
    if (domainNameTextBox.text.length==0 || domainTypeTextBox.text.length==0)
    {
        if(domainNameTextBox.text.length==0 && domainTypeTextBox.text.length==0)
        {
            UIAlertView *domainCheckAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Domain name & type cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [domainCheckAlert show];
            
            domainCheckAlert=nil;
            
            [self changeBorderColorIf:NO forView:domainNameBg];
            [self changeBorderColorIf:NO forView:domainTypeBg];
        }
        
        else
        {
            if (domainTypeTextBox.text.length==0)
            {
                UIAlertView *domainCheckAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Domain type cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [domainCheckAlert show];
                
                domainCheckAlert=nil;
                
                [self changeBorderColorIf:NO forView:domainTypeBg];
            }
            
            
            if (domainNameTextBox.text.length==0)
            {
                UIAlertView *domainCheckAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Domain name cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [domainCheckAlert show];
                
                domainCheckAlert=nil;
                
                [self changeBorderColorIf:NO forView:domainNameBg];
            }
            
        }
    }
    
    else
    {
        [self checkDomainAvailability];
    }
}

//Second Next Button
- (IBAction)buyDomainBtnClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"ttbdomaincombo_buyBtnClicked"];
    
    [self.view endEditing:YES];
    
    NSMutableArray *failureMessages = [NSMutableArray array];
    
    NSArray *textFields = @[contactNameTxtField,emailTxtField,addressTxtField,cityTxtField,stateTxtField,countryTxtField,zipCodeTxtField];
    

    for (id object in textFields)
    {
        [failureMessages addObjectsFromArray:[object validate]];
    }

    for (int i=0; i<textFields.count; i++)
    {
        UITextField *tf=(UITextField *)[textFields objectAtIndex:i];
        
        [self validateTextFieldAfterEditing:tf forView:buyingDomainSubView];
    }

    
    if (failureMessages.count > 0)
    {
        UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[failureMessages componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [failureAlert show];
    }
    
    
    else
    {
        
        /*
        appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@"sumanta.com"];
        
        [self dismissModalViewControllerAnimated:YES];
         */
        
        //IAP METHODS TO PURCHASE
        
        buyDomainAV=[[NFActivityView alloc]init];
        
        buyDomainAV.activityTitle=@"buying";
        
        [buyDomainAV showCustomActivityView];
        
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[3];
                 
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             else
             {
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Failed to populate list of products." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 
                 [alertView show];
                 
                 alertView=nil;
                 
                 [buyDomainAV hideCustomActivityView];
             }
         }];
    }
}


- (IBAction)buyDomainBackBtnClicked:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"ttbdomaincombo_goToDomainSelectionBackBtnClicked"];

    if (version.floatValue<7.0)
    {
        [headerLabel setText:@"Domain Availability"];
    }
    
    else
    {
        self.navigationItem.title=@"Domain Availability";
    }
    
    CGRect frame = CGRectMake(0,contentScrollView.frame.origin.y, contentScrollView.frame.size.width, contentScrollView.frame.size.height);
    
    [contentScrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)selectCountryBtnClicked:(id)sender
{
    
}


#pragma UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 0)
        {
            domainTypeTextBox.text=@".com";
        }
        
        
        if (buttonIndex==1)
        {
            domainTypeTextBox.text=@".net";
        }
        
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{

    if (domainTypeTextBox.text.length==0) {

        
        [self changeBorderColorIf:NO forView:domainTypeBg];
        
        
    }

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
    
    if (field.tag==1)
    {
            return ([characters rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
    }

    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self rearrangeUpWithTextField:textField];
    
    if (textField.tag==1 || textField.tag==2 || textField.tag==3 || textField.tag==4 || textField.tag==5 || textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9 || textField.tag==10)
    {
        
        [self removeBorderFromTextFieldBeforeEditing:textField forView:[bgArray objectAtIndex:textField.tag]];
        return YES;
    }
    
    
    /*
    else if (textField.tag==2)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:domainTypeBg];
        return YES;
    }

    else if (textField.tag==3)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:contactNameImgView];
        return YES;
    }

    else if (textField.tag==4)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:phoneNumberImgView];
        return YES;
    }

    else if (textField.tag==5)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:emailImgView];
        return YES;
    }

    else if (textField.tag==6)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:addressImgView];
        return YES;
    }

    else if (textField.tag==7)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:cityImgView];
        return YES;
    }

    else if (textField.tag==8)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:stateImgView];
        return YES;
    }
    
    else if (textField.tag==9)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:countryImgView];
        return YES;
    }

    else
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:zipCodeImgView];
        return YES;
    }
     */
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [self rearrangeDownWithTextField:textField];
    
    if (textField.tag==1)
    {
        if ([textField.text isEqualToString:@""] || textField.text.length<3 ||[self textFieldHasWhiteSpaces:textField.text])
        {
            [self changeBorderColorIf:NO forView:domainNameBg];
        }
        
        else
        {
            [self changeBorderColorIf:YES forView:domainNameBg];
        }
        
        return YES;
    }
    
    else if (textField.tag==2)
    {
        
        if ([textField.text isEqualToString:@""] ||[self textFieldHasWhiteSpaces:textField.text])
        {
            [self changeBorderColorIf:NO forView:domainTypeBg];
        }
        
        else
        {
            [self changeBorderColorIf:YES forView:domainTypeBg];
        }
        
        return YES;
    }
    
    else if (textField.tag==3 || textField.tag==4 ||textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 9 || textField.tag == 10)
    {
        
        if ([textField.text isEqualToString:@""] ||[self textFieldHasWhiteSpaces:textField.text])
        {
            [self changeBorderColorIf:NO forView:[bgArray objectAtIndex:textField.tag]];
        }
        
        else
        {
            [self changeBorderColorIf:YES forView:[bgArray objectAtIndex:textField.tag]];
        }
        
        return YES;
    }
    
    else//Email Validation
    {
        if (![self validateEmailWithString:textField.text])
        {
            [self changeBorderColorIf:NO forView:emailImgView];
        }
    }
    
    return YES;
}


-(void)changeBorderColorIf:(BOOL)isCorrect forView:(UIView *)imgView
{
    imgView.layer.masksToBounds = NO;
    imgView.backgroundColor=[UIColor whiteColor];
    imgView.layer.opaque=YES;
    
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


-(void)rearrangeDownWithTextField:(UITextField *)textField
{
    if (viewHeight==480)
    {
        if (textField.tag==6)
        {
            [self animateTextField:textField up:NO movementDistance:80];
        }
        
        else if (textField.tag==7)
        {
            [self animateTextField:textField up:NO movementDistance:100];
        }
        
        else if (textField.tag==8)
        {
            [self animateTextField:textField up:NO movementDistance:120];
        }
        
        else if (textField.tag==9)
        {
            [self animateTextField:textField up:NO movementDistance:150];
        }
        
        else if (textField.tag==10)
        {
            [self animateTextField:textField up:NO movementDistance:170];
        }
    }
    
    else
    {
        if (textField.tag==8)
        {
            [self animateTextField:textField up:NO movementDistance:80];
        }
        
        else if (textField.tag==9)
        {
            [self animateTextField:textField up:NO movementDistance:120];
        }
        
        else if (textField.tag==10)
        {
            [self animateTextField:textField up:NO movementDistance:180];
        }
    }
}


-(void)rearrangeUpWithTextField:(UITextField *)textField
{
    if (viewHeight==480)
    {
        if (textField.tag==6)
        {
            [self animateTextField:textField up:YES movementDistance:80];
        }
        
        else if (textField.tag==7)
        {
            [self animateTextField:textField up:YES movementDistance:100];
        }

        else if (textField.tag==8)
        {
            [self animateTextField:textField up:YES movementDistance:120];
        }

        else if (textField.tag==9)
        {
            [self animateTextField:textField up:YES movementDistance:150];
        }
        
        else if (textField.tag==10)
        {
            [self animateTextField:textField up:YES movementDistance:170];
        }
    }
    
    else
    {
        if (textField.tag==8)
        {
            [self animateTextField:textField up:YES movementDistance:80];
        }
        
        else if (textField.tag==9)
        {
            [self animateTextField:textField up:YES movementDistance:120];
        }
        
        else if (textField.tag==10)
        {
            [self animateTextField:textField up:YES movementDistance:180];
        }
    }
}


#pragma Validate After Editing

-(void)validateTextFieldAfterEditing:(UITextField *)textField forView:(UIView *)currentSubview
{
    if (textField.text.length==0 || textField.text.length<4)
    {
        if (textField.tag==3)
        {
            [self changeBorderColorIf:NO forView:contactNameImgView];
        }
        
        if (textField.tag==4)
        {
            [self changeBorderColorIf:NO forView:phoneNumberImgView];
        }
        
        if (textField.tag==6)
        {
            [self changeBorderColorIf:NO forView:addressImgView];
        }
        
        if (textField.tag==7)
        {
            [self changeBorderColorIf:NO forView:cityImgView];
        }
        
        if(textField.tag==8)
        {
            [self changeBorderColorIf:NO forView:stateImgView];
        }
        
        if (textField.tag == 9)
        {
            [self changeBorderColorIf:NO forView:countryImgView];
        }
        
        if (textField.tag == 10)
        {
            [self changeBorderColorIf:NO forView:zipCodeImgView];
        }
    }
    
    if (textField.tag==5)
    {
        if (![self validateEmailWithString:textField.text])
        {
            [self changeBorderColorIf:NO forView:emailImgView];
        }
    }
}

-(void)removeBorderFromTextFieldBeforeEditing:(UITextField *)textField forView:(UIView *)imgView
{

    [self changeBorderColorIf:YES forView:imgView];
    
}


-(void)drawBorder
{
    [self changeBorderColorIf:YES forView:domainNameBg];
    [self changeBorderColorIf:YES forView:domainTypeBg];
    [self changeBorderColorIf:YES forView:contactNameImgView];
    [self changeBorderColorIf:YES forView:phoneNumberImgView];
    [self changeBorderColorIf:YES forView:emailImgView];
    [self changeBorderColorIf:YES forView:addressImgView];
    [self changeBorderColorIf:YES forView:cityImgView];
    [self changeBorderColorIf:YES forView:stateImgView];
    [self changeBorderColorIf:YES forView:countryImgView];
    [self changeBorderColorIf:YES forView:zipCodeImgView];
}


#pragma EmailValidation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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


-(void)backBtnClicked
{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)checkDomainAvailability
{
    domainAvailCheckAV =[[NFActivityView alloc]init];
    
    domainAvailCheckAV.activityTitle=@"Checking";
    
    [domainAvailCheckAV showCustomActivityView];
    
    [self.view endEditing:YES];
    
    
    CheckDomainAvailablityController *checkController=[[CheckDomainAvailablityController alloc]init];
    
    checkController.delegate=self;
    
    [checkController getDomainAvailability:domainNameTextBox.text withType:domainTypeTextBox.text];
    
    checkController=nil;
    
    
    
}


#pragma CheckDomainAvailablityDelegate

-(void)checkDomainDidSucceed:(NSString *)successString
{
    
    [domainAvailCheckAV hideCustomActivityView];
    
    if ([successString isEqualToString:@"true"])
    {
        
        if (version.floatValue<7.0) {
            [headerLabel setText:@"Domain Purchase"];
        }
        
        
        else
        {
            self.navigationItem.title=@"Domain Purchase";
        }
        
        CGRect frame = CGRectMake(320,contentScrollView.frame.origin.y, contentScrollView.frame.size.width, contentScrollView.frame.size.height);
        
        [contentScrollView scrollRectToVisible:frame animated:YES];
    }
    
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Domain already exists" message:@"Domain specified already exists,please try with another domain name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        alertView=nil;
    }
    
}


-(void)checkDomaindidFail
{
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Something went wrong.Could not check for the availablity of domain." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;

    [domainAvailCheckAV hideCustomActivityView];
}

#pragma IAPMethods

- (void)productPurchased:(NSNotification *)notification
{
    //Do not pass country code
    
    //NSLog(@"productPurchased");
    
    NSDictionary *uploadDictionary;
    @try
    {
        uploadDictionary=
        @{
          @"clientId":appDelegate.clientId,
          @"domainName":domainNameTextBox.text,
          @"domainType":[domainTypeTextBox.text uppercaseString],
          @"contactName":contactNameTxtField.text,
          @"companyName":[appDelegate.storeDetailDictionary objectForKey:@"Name"],
          @"addressLine1":addressTxtField.text,
          @"city":cityTxtField.text,
          @"state":stateTxtField.text,
          @"country":countryTxtField.text,
          @"zip":zipCodeTxtField.text,
          @"countryCode":@"",
          @"phoneISDCode":[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"],
          @"primaryNumber":mobileNumberTxtField.text,
          @"email":emailTxtField.text,
          @"primaryCategory":[[appDelegate.storeDetailDictionary objectForKey:@"Category"] objectAtIndex:0],
          @"lat":[appDelegate.storeDetailDictionary objectForKey:@"lat"],
          @"lng":[appDelegate.storeDetailDictionary objectForKey:@"lng"],
          @"existingFPTag":[appDelegate.storeDetailDictionary objectForKey:@"Tag"]
          };
    }
    
    @catch (NSException *e)
    {
        UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong please call our customer care at +91 9160004303" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [failedAlert show];
        
        failedAlert = nil;
    }

    BuyDomainController *buyController=[[BuyDomainController alloc]init];
    
    buyController.delegate=self;
    
    [buyController buyDomain:uploadDictionary];
    
}


-(void)removeProgressSubview
{
    [buyDomainAV hideCustomActivityView];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"The transaction was not completed. Sorry to see you go. If this was by mistake please re-initiate transaction in store by hitting Buy" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
    
}

#pragma BuyDomainDelegate

-(void)buyDomainDidSucceed
{
    @try
    {
        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
            appDelegate.clientId,@"clientId",
            [NSString stringWithFormat:@"com.biz.ttbdomaincombo"],@"clientProductId",
            [NSString stringWithFormat:@"Talk to business, Domain combo"],@"NameOfWidget" ,
            [userDefaults objectForKey:@"userFpId"],@"fpId",
            [NSNumber numberWithInt:12],@"totalMonthsValidity",
            [NSNumber numberWithDouble:4.99],@"paidAmount",
            [NSString stringWithFormat:@"TOB"],@"widgetKey",nil];
        
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];
    }

    @catch (NSException *exception)
    {
        [buyDomainAV hideCustomActivityView];
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not purchase Talk-To-Business. Please contact our customer care at +91-9160004303" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        
        [alertView show];
        
        alertView=Nil;
    }
}

-(void)buyDomainDidFail
{
    [buyDomainAV hideCustomActivityView];
    
    UIAlertView *failedPurchase=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not purchase the domain for your website.Please call our customer care at +91 9160004303 for assistance." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedPurchase show];
    
    failedPurchase=nil;
}

#pragma AddWidgetDelegate

-(void)addWidgetDidSucceed;
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"ttbdomaincombo_purchased"];
    
    [buyDomainAV hideCustomActivityView];

    appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@"%@%@",domainNameTextBox.text,domainTypeTextBox.text];
    
    [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
    
    UIAlertView *successAlertView=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Personalised domain purchased successfully.It takes 24 hrs for the domain to get activated.Talk-To-Business has been added to your widgets." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [successAlertView show];
    
    successAlertView=nil;
}

-(void)addWidgetDidFail;
{
    [buyDomainAV hideCustomActivityView];

    UIAlertView *failedAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong please. Talk-To-Business was not purchased. Please call our customer support at +91-9160004303 for assistance." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedAlertView show];
    
    failedAlertView=nil;
    
}




@end
