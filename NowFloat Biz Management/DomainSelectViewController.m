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

@interface DomainSelectViewController ()<CheckDomainAvailablityDelegate,BuyDomainDelegate>
{

    NSArray *_products;

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


- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.4];
 
    
    
    
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
    
    self.navigationController.navigationBarHidden=YES;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
    
    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setFrame:CGRectMake(5,9,32,26)];
    
    [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];
    
    customRighNavButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customRighNavButton setFrame:CGRectMake(275,0,40,40)];
    
    [customRighNavButton addTarget:self action:@selector(checkDomainAvailability) forControlEvents:UIControlEventTouchUpInside];
    
    [customRighNavButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [navBar addSubview:customRighNavButton];
    
    [activitySubView setHidden:YES];
    
    [buyingDomainSubView setHidden:YES];
    
    [self drawBorder];
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


- (IBAction)selectDomainTypeButtonClicked:(id)sender
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


- (IBAction)dismissKeyboardButtonClicked:(id)sender
{
    
    [self.view endEditing:YES];
    
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
    if (textField.tag==1)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:domainNameBg];
        return YES;
    }
    
    if (textField.tag==2)
    {
        [self removeBorderFromTextFieldBeforeEditing:textField forView:domainTypeBg];
        return YES;
    }
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    
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
    

    
    if (textField.tag==2)
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


-(void)removeBorderFromTextFieldBeforeEditing:(UITextField *)textField forView:(UIView *)imgView
{

    [self changeBorderColorIf:YES forView:imgView];
    
}


-(void)drawBorder
{
    [self changeBorderColorIf:YES forView:domainNameBg];
    [self changeBorderColorIf:YES forView:domainTypeBg];
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


-(void)back
{

    [self.navigationController  popViewControllerAnimated:YES];
    
}


-(void)checkDomainAvailability
{
    [activitySubView setHidden:NO];
    [customCancelButton setEnabled:NO];
    [customRighNavButton setEnabled:NO];

    
    [self.view endEditing:YES];
    

    if (domainNameTextBox.text.length>0 && domainTypeTextBox.text.length>0)
    {
        
        if ([appDelegate.storeEmail isEqualToString:@"No Description"] || [appDelegate.businessName isEqualToString:@"No Description"] || [appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]==NULL || appDelegate.storeEmail.length==0 || appDelegate.businessName==0)
        {
            
            [activitySubView setHidden:YES];
            [customCancelButton setEnabled:YES];
            [customRighNavButton setEnabled:YES];
            
            
            if ([appDelegate.storeEmail isEqualToString:@"No Description"] && [appDelegate.businessName isEqualToString:@"No Description"] && [appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]==NULL &&  appDelegate.storeEmail.length==0 && appDelegate.businessName==0)
            {
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Email,BusinessName,Country PhoneCode cannot be empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                alertView=nil;
                
            }
            
            else
            {
                NSMutableArray *alertMessageArray=[[NSMutableArray alloc]init];
                
                if ([appDelegate.storeEmail isEqualToString:@"No Description"] || [appDelegate.storeEmail   length]==0)
                {
                    [alertMessageArray insertObject:@"Store Email cannot be empty" atIndex:0];
                }
                
                
                if ([appDelegate.businessName length]==0 || [appDelegate.businessName isEqualToString:@"No Description"])
                {
                    [alertMessageArray insertObject:@"Store Name cannot be empty" atIndex:0];
                }
                
                
                
                if ([appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]==NULL)
                {
                    [alertMessageArray insertObject:@"Country phone code cannot be empty.Call our customer care at +91 9160004303" atIndex:0];
                }
                
                
                NSString *str=[alertMessageArray componentsJoinedByString:@","];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:str delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                alertView=nil;
                
                
            }
            
            
            
            
        }
        else
        {
//Case for address
/*
            NSArray *addressArray=[[appDelegate.storeDetailDictionary objectForKey:@"Address"] componentsSeparatedByString:@","];
            
            NSLog(@"Array:%@",addressArray);
            
            NSString *city=[[NSString alloc]init];
            
            NSString *state=[[NSString alloc]init];
            
            NSString *country=[[NSString alloc]init];
            
            if ([addressArray count]<=4 && [addressArray count]<7)
            {
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Your contact address is too short.Please call our customer care at +91 9160004303 to change your address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                alertView=nil;
                
            }
            
            if ([addressArray count]>4 && [addressArray count]<12)
            {
                
                for (int i=1; i<addressArray.count; i++)
                {
                    
                    if (i==addressArray.count-2)
                    {
                        country=[addressArray objectAtIndex:i];
                    }
                    
                    
                    if (i==addressArray.count-3)
                    {
                        state=[addressArray objectAtIndex:i];
                    }
                    
                    
                    if (i==addressArray.count-4)
                    {
                        city=[addressArray objectAtIndex:i];
                    }
                    
                }
 
                 //Write the code for check availability here
                 //
                 //
                 //
                 //
                 //
            }
            
            
*/
            
                 CheckDomainAvailablityController *checkController=[[CheckDomainAvailablityController alloc]init];
                 
                 checkController.delegate=self;
                 
                 [checkController getDomainAvailability:domainNameTextBox.text withType:domainTypeTextBox.text];
            
                 checkController=nil;
            
            

        }
        

        
        
        
        
    }
    
    
    else
    {
        
        [activitySubView setHidden:YES];
        [customRighNavButton setEnabled:YES];
        [customCancelButton setEnabled:YES];
        
        
        if(domainNameTextBox.text.length==0 && domainTypeTextBox.text.length==0)
        {
            UIAlertView *domainCheckAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Domain name & type cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [domainCheckAlert show];
            
            domainCheckAlert=nil;
            
            [self changeBorderColorIf:NO forView:domainNameBg];
            [self changeBorderColorIf:NO forView:domainTypeBg];
        }
        
        
        else{
        
        if (domainTypeTextBox.text.length==0) {

            UIAlertView *domainCheckAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Domain type cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [domainCheckAlert show];
            
            domainCheckAlert=nil;

            [self changeBorderColorIf:NO forView:domainTypeBg];
        }
    
        
        else
        {
            UIAlertView *domainCheckAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Domain name cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [domainCheckAlert show];
            
            domainCheckAlert=nil;
            
            [self changeBorderColorIf:NO forView:domainNameBg];

        }
        
        }
        
    
    }
}


#pragma CheckDomainAvailablityDelegate

-(void)checkDomainDidSucceed:(NSString *)successString
{

    if ([successString isEqualToString:@"true"])
    {

    [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
    {
        _products = nil;
        
        if (success)
        {
                _products = products;

                SKProduct *product = _products[1];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                
                [[BizStoreIAPHelper sharedInstance] buyProduct:product];
                
                [activitySubView setHidden:YES];
                
                [buyingDomainSubView setHidden:NO];
                
        }
        
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Failed to populate list of products." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertView show];
            
            alertView=nil;
        
            [activitySubView setHidden:YES];
            
            [buyingDomainSubView setHidden:YES];

            [customCancelButton setEnabled:YES];
            
            [customRighNavButton setEnabled:YES];

        }
        
    }];

    }

    if ([successString isEqualToString:@"false"])
    {
        
        [activitySubView setHidden:YES];
        
        [customCancelButton setEnabled:YES];
        
        [customRighNavButton setEnabled:YES];

        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Domain specified already exists,please try with another domain name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        alertView=nil;
    }

    
    
}


-(void)checkDomaindidFail
{
    [activitySubView setHidden:YES];
    
    [customCancelButton setEnabled:YES];
    
    [customRighNavButton setEnabled:YES];

    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Something went wrong.Could not check for the availablity of domain." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;

}

#pragma IAPMethods

- (void)productPurchased:(NSNotification *)notification
{
    //Do not pass country code
     NSDictionary *uploadDictionary=
     @{
     @"clientId":appDelegate.clientId,
     @"domainName":domainNameTextBox.text,
     @"domainType":[domainTypeTextBox.text uppercaseString],
     @"contactName":@"NowFloat's Customer",
     @"companyName":[appDelegate.storeDetailDictionary objectForKey:@"Name"],
     @"addressLine1":@"1st Floor,8-2-467/4/A/A,Road No. 1",
     @"city":@"Hyderabad",
     @"state":@"Andhra Pradesh",
     @"country":@"India",
     @"zip":@"500034",
     @"countryCode":@"",
     @"phoneISDCode":[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"],
     @"primaryNumber":[appDelegate.storeDetailDictionary objectForKey:@"PrimaryNumber"],
     @"email":[appDelegate.storeDetailDictionary objectForKey:@"Email"],
     @"primaryCategory":[[appDelegate.storeDetailDictionary objectForKey:@"Category"] objectAtIndex:0],
     @"lat":[appDelegate.storeDetailDictionary objectForKey:@"lat"],
     @"lng":[appDelegate.storeDetailDictionary objectForKey:@"lng"],
     @"existingFPTag":[appDelegate.storeDetailDictionary objectForKey:@"Tag"]
     };
     NSLog(@"uploadDictionary:%@",uploadDictionary);

    

    BuyDomainController *buyController=[[BuyDomainController alloc]init];
    
    buyController.delegate=self;
    
    [buyController buyDomain:uploadDictionary];
    
    
    
    

}


-(void)removeProgressSubview
{
    
    [customCancelButton setEnabled:YES];
    
    [customRighNavButton setEnabled:YES];
    
    [activitySubView setHidden:YES];
    
    [buyingDomainSubView setHidden:YES];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"The transaction was not completed. Sorry to see you go. If this was by mistake please re-initiate transaction in store by hitting Buy" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
    
}


#pragma BuyDomainDelegate

-(void)buyDomainDidSucceed
{

    [activitySubView setHidden:YES];
    
    [buyingDomainSubView setHidden:YES];
    
    [customRighNavButton setEnabled:NO];
    
    [customCancelButton setEnabled:YES];
    
    appDelegate.storeRootAliasUri=[NSMutableString stringWithFormat:@"%@%@",domainNameTextBox.text,domainTypeTextBox.text];
    
    UIAlertView *successAlertView=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Personalised domain purchased successfully.It takes 24 hrs for the domain to get activated." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [successAlertView show];
    
    successAlertView=nil;
    
    

}


-(void)buyDomainDidFail
{
    
    [activitySubView setHidden:YES];
    
    [buyingDomainSubView setHidden:YES];
    
    [customRighNavButton setEnabled:NO];
    
    [customCancelButton setEnabled:YES];
    
    
    UIAlertView *failedPurchase=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not integrate domain with website.Please call our customer care at +91 9160004303 for assistance" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedPurchase show];
    
    failedPurchase=nil;
    
    
}



@end
