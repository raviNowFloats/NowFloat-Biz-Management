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

@interface BusinessContactViewController ()<updateStoreDelegate>

@end

@implementation BusinessContactViewController
@synthesize storeContactArray ,successCode  ;



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
    
    

    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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


    

    
    /*Design the NavigationBar here*/
    
    self.navigationController.navigationBarHidden=YES;
    
    CGFloat width = self.view.frame.size.width;
    
    navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 13,160, 20)];
    
    headerLabel.text=@"Contact Number";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textAlignment=NSTextAlignmentCenter;
    
    headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
    
    [navBar addSubview:headerLabel];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
    
    [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
    
    [leftCustomButton addTarget:self action:@selector(revealRearViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:leftCustomButton];
    
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
            
            [mobileNumTextField setPlaceholder:@"Enter contact number here"];
            
            contactNumberOne=@"No Description";
            
            
        }
        
        else
        {
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
            
            contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
        
        }
        
            [landlineNumTextField setPlaceholder:@"Enter contact number here"];
        
            [secondaryPhoneTextField setPlaceholder:@"Enter contact number here"];
        
        
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
            
            [mobileNumTextField setPlaceholder:@"Enter contact number here"];
            
            contactNumberOne=@"No Description";

            
        }
        
        else
        {
            
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
            
            contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];

            
        }

        
        if ([[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [landlineNumTextField setPlaceholder:@"Enter contact number here"];
            
            contactNumberTwo=@"No Description";
            
        }
        
        else
        {
            
            [landlineNumTextField setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
            
            contactNumberTwo=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ];
            
            
        }
        

            [secondaryPhoneTextField setPlaceholder:@"Enter contact number here"];
            contactNumberThree=@"No Description";

    }
    
    
    if ([storeContactArray count]==3)
    {
        
        
    contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName"];
    contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
    contactNameString3=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactName"];

        
        
        
        if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [mobileNumTextField setPlaceholder:@"Enter contact number here"];
            
            contactNumberOne=@"No Description";
            
            
        }
        
        else
        {
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
            
            contactNumberOne=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ];
            
        }
        
        
        if ([[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ] length]==0)
        {
            [landlineNumTextField setPlaceholder:@"Enter contact number here"];
            contactNumberTwo=@"No Description";
            
        }
        else
        {
            [landlineNumTextField setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
            
            
            contactNumberTwo=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ];
            
        }
        
        
              
        
        
        if ([[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ] length]==0)
        {
            [secondaryPhoneTextField setPlaceholder:@"No Description"];
            contactNumberThree=@"No Description";
            
            
        }
        else
        {
            [secondaryPhoneTextField setText:[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]];
            
            contactNumberThree=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ];
            
        }

    }

        /*Set the TextFields for Email,website and facebook here*/
    
    
    if ([appDelegate.storeWebsite isEqualToString:@"No Description"]) {
        
        
        [websiteTextField setPlaceholder:@"www.websitename.com"];
    }
    
    
    else
    {
        [websiteTextField setText:appDelegate.storeWebsite];
        
    }
    
    
    if ([appDelegate.storeEmail isEqualToString:@""]) {
        
        [emailTextField setPlaceholder:@"foo@gmail.com"];
    }
    
    
    else
    {
    
        [emailTextField setText:appDelegate.storeEmail];


    }
    
    if ([appDelegate.storeFacebook isEqualToString:@"No Description"])
    {
        
        [facebookTextField setPlaceholder:@"Enter store facebook page name here"];
        
    }
    
    else
    {
        [facebookTextField setText:appDelegate.storeFacebook];
        

    }

    
    
    [activitySubView setHidden:YES];

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
    
    
        DBValidationEmailRule *emailTextFieldRule=[[DBValidationEmailRule alloc]initWithObject:emailTextField keyPath:@"text" failureMessage:@"Enter Vaild Email Id"];
        
        [emailTextField addValidationRule:emailTextFieldRule];
    
}




-(void)revealRearViewController
{

    [mobileNumTextField resignFirstResponder];
    [landlineNumTextField resignFirstResponder];
    [secondaryPhoneTextField resignFirstResponder];
    [websiteTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [facebookTextField resignFirstResponder];
    //revealToggle:
    
    SWRevealViewController *revealController = [self revealViewController];

    [revealController performSelector:@selector(revealToggle:)];
}


#pragma storeUpdateDelegate
-(void)storeUpdateComplete
{

    [self updateView];
    
}


-(void)storeUpdateFailed
{

    [self updateFailView];

}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    

    
    if (textField.tag==1 || textField.tag==2 || textField.tag==3 || textField.tag==4 ||textField.tag==5 || textField.tag==6)
    {
        
        [self setUpButton];
        
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
            
            if ([appDelegate.storeDetailDictionary objectForKey:@"Uri"]==[NSNull null])
            {
                
                self.navigationItem.rightBarButtonItem=nil;
                isWebSiteChanged=NO;
            }
            
            else{
            
            
                [self setUpButton];

            }
            
            
            
        }

        //Email
        if (isEmailChanged)
        {
            
            
            
            if ([appDelegate.storeDetailDictionary objectForKey:@"Email"]==[NSNull null])
            {
                
                self.navigationItem.rightBarButtonItem=nil;

            }
            
            
            else
            {
            
                [self setUpButton];
            }
            
            
        
        }
        
        //FaceBook
        if (isFBChanged )
        {
            
            if ( [appDelegate.storeDetailDictionary objectForKey:@"FBPageName"]==[NSNull null])
            {
                self.navigationItem.rightBarButtonItem=nil;
                
            }
                
            else
                
            {
            
                [self setUpButton];

            }
            
        }
    
    }
    
}


-(void)setUpButton
{

    customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,5,30,30)];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [navBar addSubview:customButton];

    [customButton setHidden:NO];
    
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
    
    UpdateStoreData  *strData=[[UpdateStoreData  alloc]init];
    strData.delegate=self;
    
    NSMutableArray *uploadArray=[[NSMutableArray alloc]init];
    
    [mobileNumTextField resignFirstResponder];
    [landlineNumTextField resignFirstResponder];
    [secondaryPhoneTextField resignFirstResponder];
    [facebookTextField resignFirstResponder];
    [websiteTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    
    [activitySubView setHidden:NO];
    
    
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
        
        upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
        
        [uploadArray  addObject:upLoadDictionary];
                
        isContact2Changed=NO;
        
    }
        
    
    if (isContact3Changed)
    {

        NSString *uploadString=[NSString stringWithFormat:@"%@#%@#%@",mobileNumTextField.text,landlineNumTextField.text,secondaryPhoneTextField.text];
        
        NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
        
        upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
        
        [uploadArray  addObject:upLoadDictionary];
        
        isContact3Changed=NO;
    
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
        
        upLoadDictionary=@{@"value":emailTextField.text,@"key":@"EMAIL"};
        
        isEmailChanged=NO;

        if (emailTextField.text.length!=0)
        {
            
            NSMutableArray *failureMessages = [NSMutableArray array];
            
            NSArray *textFields = @[emailTextField];
            
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
        
                appDelegate.storeEmail=emailTextField.text;
                
                [uploadArray  addObject:upLoadDictionary];
            }
            

            
        }
        
        
        else
        {
        
            appDelegate.storeEmail=emailTextField.text;
            
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
    
    
    [strData updateStore:uploadArray];

    
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


-(void)updateView
{
    [self removeSubView];
}


-(void)updateFailView
{
    [activitySubView setHidden:YES];
    
    [customButton setHidden:YES];
    
    UIAlertView *succcessAlert=[[UIAlertView alloc]initWithTitle:@"Update Fail" message:@"Please try again to make your update" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    [succcessAlert show];
    
    succcessAlert=nil;

}



-(void)removeSubView
{
    [activitySubView setHidden:YES];
    
    [customButton setHidden:YES];
    
    UIAlertView *succcessAlert=[[UIAlertView alloc]initWithTitle:@"Update" message:@"Contact information updated" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    [succcessAlert show];
    
    succcessAlert=nil;
    
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
    activitySubView = nil;
    contactScrollView = nil;
    [super viewDidUnload];
}


- (IBAction)dismissKeyBoard:(id)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)registeredPhoneNumberBtnClicked:(id)sender
{

    UIAlertView *registeredPhoneNumberAlerView=[[UIAlertView alloc]initWithTitle:@"Facebook fan page" message:@"Enter store facebook fan page name here" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
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
        
    }
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}




@end
