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
#import "BookDomainController.h"
#import "DBValidator.h"
#import "NFActivityView.h"
#import "Mixpanel.h"
#import "PopUpView.h"
#import "UIImage+ImageWithColor.h"
#import "FileManagerHelper.h"


@interface DomainSelectViewController ()<CheckDomainAvailablityDelegate,AddWidgetDelegate,BookDomainDelegate,PopUpDelegate>
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
    NSString *domainTypeString;
}

@end

@implementation DomainSelectViewController
@synthesize isFromOtherViews;

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

    bgArray= [[NSArray alloc]initWithObjects:@"",domainNameBg,nil];
    
    domainTypeString = @".com";
    
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
        
        
        UIImage *buttonImage = [UIImage imageNamed:@"Cross.png"];
        
        UIImageView *btnImgView=[[UIImageView alloc]initWithImage:buttonImage];
        
        [btnImgView setFrame:CGRectMake(13,13,18,18)];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        backButton.frame = CGRectMake(0,0,40,40);
        
        [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:btnImgView];
        
        [navBar addSubview:backButton];

        
        [self.view addSubview:navBar];
    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Domain Availability";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        UIImage *buttonImage = [UIImage imageNamed:@"Cross.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setImage:buttonImage forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(13,13,25,25);
        
        [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addSubview:backButton];

    }
    
    [self drawBorder];
    
    subViewArray=[[NSMutableArray alloc]initWithObjects:selectDomainSubView,nil];
    
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
    
    UIButton *selectedBtn=(UIButton *)sender;
    
    if (selectedBtn.tag==1)
    {
        
        Mixpanel *mixPanel=[Mixpanel sharedInstance];
        
        [mixPanel track:@"ttbdomaincombo_domainTypeSelected.com"];
 
        domainTypeString = @".com";
        [comBtn setBackgroundColor:[UIColor colorFromHexCode:@"ffb900"]];
        [netBtn setBackgroundColor:[UIColor colorFromHexCode:@"7f7f7f"]];
    }
    
    else
    {        
        Mixpanel *mixPanel=[Mixpanel sharedInstance];
        [mixPanel track:@"ttbdomaincombo_domainTypeSelected.net"];
 
        [comBtn setBackgroundColor:[UIColor colorFromHexCode:@"7f7f7f"]];
        domainTypeString = @".net";
        [netBtn setBackgroundColor:[UIColor colorFromHexCode:@"ffb900"]];
    }
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
    
    [self.view endEditing:YES];
    
    if (domainNameTextBox.text.length==0)
    {
        UIAlertView *domainCheckAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Domain name cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [domainCheckAlert show];
        
        domainCheckAlert=nil;
        
        [self changeBorderColorIf:NO forView:domainNameBg];
    }
    
    else
    {
        [self checkDomainAvailability];
    }
}


#pragma UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
   
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{


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
        if ([characters isEqualToString:@"\n"] )
        {
            [field resignFirstResponder];

            [self checkDomainAvailability];
        }
        
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



-(void)removeBorderFromTextFieldBeforeEditing:(UITextField *)textField forView:(UIView *)imgView
{

    [self changeBorderColorIf:YES forView:imgView];
    
}


-(void)drawBorder
{
    [successdomainButton.layer setCornerRadius:6.0];
    [successdomainButton setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateHighlighted];
    [self changeBorderColorIf:YES forView:domainNameBg];
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
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"ttbdomaincombo_backBtnClicked"];
    
    if (BOOST_PLUS && isFromOtherViews)
    {
        if (isFromOtherViews)
        {
            
            Mixpanel *mixPanel=[Mixpanel sharedInstance];
            
            [mixPanel track:@"cancel_ttbdomaincomboPurchase"];

            NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
            
            FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
            
            fHelper.userFpTag  = appDelegate.storeTag;
            
            if ([userSetting objectForKey:@"isDomainPurchaseCancelled"]==nil)
            {
                [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:NO] forKey:@"isDomainPurchaseCancelled"];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:^(void)
        {
            
        }];
    }
    
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)checkDomainAvailability
{
    domainAvailCheckAV =[[NFActivityView alloc]init];
    
    domainAvailCheckAV.activityTitle=@"Checking";
    
    [domainAvailCheckAV showCustomActivityView];
    
    [self.view endEditing:YES];
    
    CheckDomainAvailablityController *checkController=[[CheckDomainAvailablityController alloc]init];
    
    checkController.delegate=self;
    
    [checkController getDomainAvailability:domainNameTextBox.text withType:domainTypeString];
}


#pragma CheckDomainAvailablityDelegate

-(void)checkDomainDidSucceed:(NSString *)successString
{
    
    [domainAvailCheckAV hideCustomActivityView];
    
    if ([successString isEqualToString:@"true"])
    {
        
        if (version.floatValue<7.0)
        {
            [headerLabel setText:@"Domain Purchase"];
        }
        
        
        else
        {
            self.navigationItem.title=@"Domain Purchase";
        }
        
        UIAlertView *domainAvailable = [[UIAlertView alloc]initWithTitle:@"Good news !!" message:[NSString stringWithFormat:@"\"%@%@\" is available.",domainNameTextBox.text,domainTypeString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Book now", nil];
        domainAvailable.tag=1;
        
        [domainAvailable show];
        
        /*
        [domainNameTextBox setEnabled:NO];
        [successdomainButton setTitle:@"Book Now" forState:UIControlStateNormal];
        [successdomainButton addTarget:self action:@selector(bookDomain) forControlEvents:UIControlStateNormal];
        [failDomainButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [failDomainButton addTarget:self action:@selector(cancelDomainBooking) forControlEvents:UIControlStateNormal];
        */
        
    }
    
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:[NSString stringWithFormat:@"\"%@%@\" is not available.",domainNameTextBox.text,domainTypeString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
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


-(void)bookDomain
{
    buyDomainAV=[[NFActivityView alloc]init];
    
    buyDomainAV.activityTitle=@"buying";
    
    [buyDomainAV showCustomActivityView];
    
    if (BOOST_PLUS)
    {
        [self availDomain];
    }
    
    //IAP METHODS TO PURCHASE
    else
    {
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[4];
                 
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


-(void)cancelDomainBooking
{
    /*
    [domainNameTextBox setEnabled:YES];
    
    [successdomainButton setTitle:@"Next" forState:UIControlStateNormal];
    [successdomainButton addTarget:self action:@selector(selectDomainNextButtonClicked:) forControlEvents:UIControlStateNormal];
    [failDomainButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [failDomainButton addTarget:self action:@selector(skipDomainPurchase:) forControlEvents:UIControlStateNormal];
    */
    
    NSLog(@"Cancel domain booking");
    
}

#pragma IAPMethods

- (void)productPurchased:(NSNotification *)notification
{
    [self availDomain];
}


-(void)removeProgressSubview
{
    [buyDomainAV hideCustomActivityView];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"The transaction was not completed. Sorry to see you go. If this was by mistake please re-initiate transaction in store by hitting Buy" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
    
}


-(void)availDomain
{
    NSDictionary *uploadDictionary=[[NSDictionary alloc]init];
    
    @try
    {
        uploadDictionary=
        @{
          @"clientId":appDelegate.clientId,
          @"domainType":domainTypeString,
          @"domainName":domainNameTextBox.text,
          @"existingFPTag":appDelegate.storeTag
          };
        
        BookDomainController *bookController=[[BookDomainController alloc]init];
        
        bookController.delegate=self;
        
        [bookController bookDomain:uploadDictionary];
    }
    
    @catch (NSException *e)
    {
        [buyDomainAV hideCustomActivityView];
        
        UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate data. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [failedAlert show];
        
        failedAlert = nil;
    }
}


#pragma BookDomainDelegate

-(void)bookDomainDidSucceedWithObject:(id)responseObject
{
    @try
    {
        
        NSString *bundleId;
        NSNumber *amount;
        
        if (BOOST_PLUS)
        {
            bundleId = @"com.biz.boostplus";
            amount = [NSNumber numberWithDouble:0];
        }
        
        else
        {
            bundleId = @"com.biz";
            amount = [NSNumber numberWithDouble:6.99];
        }

        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
            appDelegate.clientId,@"clientId",
            [NSString stringWithFormat:@"%@.ttbdomaincombo",bundleId],@"clientProductId",
            [NSString stringWithFormat:@"Talk to business, Domain combo"],@"NameOfWidget" ,
            [userDefaults objectForKey:@"userFpId"],@"fpId",
            [NSNumber numberWithInt:12],@"totalMonthsValidity",
            amount,@"paidAmount",
            [NSString stringWithFormat:@"TOB"],@"widgetKey",nil];
        
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];
    }
    
    @catch (NSException *exception)
    {
        [buyDomainAV hideCustomActivityView];
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not purchase Talk-To-Business. Please contact our customer care at hello@nowfloats.com" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        
        [alertView show];
        
        alertView=Nil;
    }
}


-(void)bookDomainDidFail
{
    [buyDomainAV hideCustomActivityView];
    
    UIAlertView *bookDomainFailAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not book a domain with specified credentials. Please contact our customer care at hello@nowfloats.com" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
    
    [bookDomainFailAlert show];
    
    bookDomainFailAlert = nil;
}


#pragma AddWidgetDelegate

-(void)addWidgetDidSucceed
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"ttbdomaincombo_purchased"];
    
    [buyDomainAV hideCustomActivityView];

    appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@"%@%@",domainNameTextBox.text,domainTypeString];
    
    [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
    
    PopUpView *successPopUp = [[PopUpView alloc]init];
    successPopUp.delegate=self;
    successPopUp.titleText=@"Success";
    successPopUp.descriptionText=@"Domain purchased successfully.It takes 24 hours for the domain to get activated.And Talk-To-Business has been added to your widgets.";
    successPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
    successPopUp.isOnlyButton=YES;
    successPopUp.successBtnText=@"Done";
    successPopUp.tag=201;
    [successPopUp showPopUpView];
    
}


-(void)addWidgetDidFail
{
    [buyDomainAV hideCustomActivityView];

    UIAlertView *failedAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong please. Talk-To-Business was not purchased. Reach us at hello@nowfloats.com" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedAlertView show];
    
    failedAlertView=nil;
    
}


#pragma PopUpDelegate

-(void)successBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue]==201)
    {
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag = appDelegate.storeTag;

        [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"isDomainPurchaseCancelled"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)cancelBtnClicked:(id)sender
{
    
}


#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"ttbdomaincombo_bookdomainbtnclicked"];
            
            [self bookDomain];
        }
        
        
        else
        {
            Mixpanel *mixPanel=[Mixpanel sharedInstance];
            
            [mixPanel track:@"ttbdomaincombo_skipPurchasebtnclicked"];
        }
    }
}


@end
