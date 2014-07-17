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
@interface BusinessContactViewController ()<updateStoreDelegate>
{
    NFActivityView *nfActivity;
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

    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
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


    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;

        if (version.floatValue<7.0) {
            
            self.navigationController.navigationBarHidden=YES;
            
            CGFloat width = self.view.frame.size.width;
            
            navBar = [[UINavigationBar alloc] initWithFrame:
                      CGRectMake(0,0,width,44)];
            
            [self.view addSubview:navBar];
            
            UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
            
            [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            [navBar addSubview:leftCustomButton];
            
            UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 13,160, 20)];
            
            headerLabel.text=@"Contact Info";
            
            headerLabel.backgroundColor=[UIColor clearColor];
            
            headerLabel.textAlignment=NSTextAlignmentCenter;
            
            headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
            
            headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
            
            [navBar addSubview:headerLabel];
            
            
            [contentSubView setFrame:CGRectMake(0,20, contentSubView.frame.size.width, contentSubView.frame.size.height)];
            
        }
        
        else
        {
            self.navigationController.navigationBarHidden=NO;
            
            self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
            
            self.navigationController.navigationBar.translucent = NO;
            
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            
            
            self.navigationItem.title=@"Contact Info";
            
            //[contentSubView setFrame:CGRectMake(0,-44, contentSubView.frame.size.width, contentSubView.frame.size.height)];
            
            UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
            
            [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;
            
        }
    

    
    /*Design the NavigationBar here*/
    
   

    
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

    


    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;
    
    
    
    /*Store Contact Array*/
    
    [storeContactArray addObjectsFromArray:appDelegate.storeContactArray ];
    
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
        
        [facebookTextField setPlaceholder:@"Facebook.com/username"];
        
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    if(indexPath.row==0)
    {
         cell.contactLabel.text =@"Primary Number  ";
        
        if ([storeContactArray count]==1)
        {
            
            contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
            
            if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
            {
                
                [cell.contactText setPlaceholder:@"Primary Phone Number"];
                
                contactNumberOne=@"No Description";
                
                
            }
            
            else
            {
                [cell.contactText setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
                
                contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
                
            }

        }
    }
    if(indexPath.row==1)
    {
         cell.contactLabel.text =@"Alternate Number";
    }
    if(indexPath.row==2)
    {
         cell.contactLabel.text =@"Alternate Number";
    }
    
   
    
    
    return cell;
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
    

    
    if (textField.tag==1 || textField.tag==2 || textField.tag==3 || textField.tag==4 ||textField.tag==5 || textField.tag==6)
    {
        
        [self unHideRightBarBtn];
        
    }

    return YES;

}


- (void)textFieldDidChange: (NSNotification*)aNotification
{

    if ([storeContactArray count]==1)
    {
        if ([contactNumberOne isEqualToString:mobileNumTextField.text] && [secondaryPhoneTextField.text length]==0 &&
            [landlineNumTextField.text length]==0 )
        {
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    
    
    
    if ([storeContactArray count]==2)
    {
        if ([contactNumberOne isEqualToString:mobileNumTextField.text] && [contactNumberTwo isEqualToString:landlineNumTextField.text] && [secondaryPhoneTextField.text length]==0 )
        {
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    
    
    if ([storeContactArray count]==3)
    {
        if ([contactNumberOne isEqualToString:mobileNumTextField.text] && [contactNumberTwo isEqualToString:landlineNumTextField.text] && [secondaryPhoneTextField.text isEqualToString:contactNumberThree])
        {
            self.navigationItem.rightBarButtonItem=nil;
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
    customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [navBar addSubview:customButton];

    if (version.floatValue<7.0)
    {
        [customButton setFrame:CGRectMake(280,5,30,30)];

        [customButton setHidden:YES];
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
    
    [customButton setFrame:CGRectMake(275,5, 30, 30)];
    
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
    
    if (textField.tag==1)
    {
       
        isContact1Changed=YES;
    }
    
    if (textField.tag==2)
    {
        isContact2Changed=YES;
    }

    if (textField.tag==3)
    {
        isContact3Changed=YES;
        
    }

    
    
    if (textField.tag==4) {
        
        isWebSiteChanged=YES;
        
    }
    
    
    if (textField.tag==5) {
        
        isEmailChanged=YES;
    }
    
    
    if (textField.tag==6) {
        
        isFBChanged=YES;
    }


}

/*
 Adjust the ScrollView to make the textfields appear if hidden behind the keyboard
*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    CGSize kbSize=CGSizeMake(320, 216);

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    contactScrollView.contentInset = contentInsets;
    
    contactScrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, textField.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y-kbSize.height+60);
        
        [contactScrollView setContentOffset:scrollPoint animated:YES];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Primary number cannot be empty" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
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
                NSArray *textFields = @[landlineNumTextField];
                
                for (id object in textFields)
                {
                    [failureMessages addObjectsFromArray:[object validate]];
                }
                
                
                if (!failureMessages.count>0)
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
            
            
            isContact2Changed=NO;
            
        }
        
        
        if (isContact3Changed)
        {
            NSString *uploadString=[NSString stringWithFormat:@"%@#%@#%@",mobileNumTextField.text,landlineNumTextField.text,secondaryPhoneTextField.text];
            
            NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
            
            
            if (secondaryPhoneTextField.text.length!=0)
            {
                
                NSArray *textFields = @[secondaryPhoneTextField];
                
                for (id object in textFields)
                {
                    [failureMessages addObjectsFromArray:[object validate]];
                }
                
                
                if (!failureMessages.count>0)
                {
                    secondaryPhoneTextField.text=contactNumberThree;
                    
                    upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
                    
                    [uploadArray  addObject:upLoadDictionary];
                    
                    isContact3Changed=NO;
                }
                
            }
            else
            {
                upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
                
                [uploadArray  addObject:upLoadDictionary];
                
                isContact3Changed=NO;
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
                NSArray *textFields = @[emailTextField];
                
                for (id object in textFields)
                {
                    [failureMessages addObjectsFromArray:[object validate]];
                }
                
                
                if (!failureMessages.count>0)
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
            [nfActivity showCustomActivityView];
            
            [strData updateStore:uploadArray];
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


-(void)updateView
{
    [self removeSubView];
}


-(void)updateFailView
{
    [nfActivity hideCustomActivityView];
    
    UIAlertView *succcessAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please try again to make your update" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [succcessAlert show];
    
    succcessAlert=nil;

}


#pragma storeUpdateDelegate
-(void)storeUpdateComplete
{
    isContact1Changed=NO;
    isContact2Changed=NO;
    isContact3Changed=NO;
    isWebSiteChanged=NO;
    isEmailChanged=NO;
    isFBChanged=NO;
    
    [self removeRightBarBtn];
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"update_Business Contact"];
    
    [self updateView];
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
}




@end
