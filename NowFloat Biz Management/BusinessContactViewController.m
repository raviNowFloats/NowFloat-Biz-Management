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


@interface BusinessContactViewController ()

@end

@implementation BusinessContactViewController
@synthesize storeContactArray   ;



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

    
    self.title = NSLocalizedString(@"Contact Information", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(updateMessage)];
    
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

    
    /*Text Field Notification*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    
    
    
    /*Store Contact Array*/
    
    [storeContactArray addObjectsFromArray:appDelegate.storeContactArray ];
    
    NSLog(@"storeContactArray:%@",storeContactArray);
    
    if ([storeContactArray count]==1)
    {
    contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
        
        if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [mobileNumTextField setText:@"No Description"];
            
        }
        
        else
        {
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
        
        }
        
            [landlineNumTextField setText:@"No Description"];
        
            [secondaryPhoneTextField setText:@"No Description"];
        
        
    contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
    
    }
    
    
    
    
    if ([storeContactArray count]==2)
    {

        contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName" ];
        contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];

        if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [mobileNumTextField setText:@"No Description"];
            
        }
        
        else
        {
            
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
            
        }

        
        if ([[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [landlineNumTextField setText:@"No Description"];
            
        }
        
        else
        {
            
            [landlineNumTextField setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
            
        }
        

            [secondaryPhoneTextField setText:@"No Description"];
       

    }
    
    
    if ([storeContactArray count]==3)
    {
        
        
    contactNameString1=[[storeContactArray objectAtIndex:0]objectForKey:@"ContactName"];
    contactNameString2=[[storeContactArray objectAtIndex:1]objectForKey:@"ContactName"];
    contactNameString3=[[storeContactArray objectAtIndex:2]objectForKey:@"ContactName"];

        
        
        
        if ([[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ] length]==0)
        {
            
            [mobileNumTextField setText:@"No Description"];
            
        }
        
        else
        {
            [mobileNumTextField setText:[[storeContactArray objectAtIndex:0]objectForKey:@"ContactNumber" ]];
        }
        
        
        if ([[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ] length]==0)
        {
            [landlineNumTextField setText:@"No Description"];
        }
        else
        {
            [landlineNumTextField setText:[[storeContactArray objectAtIndex:1]objectForKey:@"ContactNumber" ]];
        }
        
        
              
        
        
        if ([[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]==[NSNull null] || [[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ] length]==0)
        {
            [secondaryPhoneTextField setText:@"No Description"];
            
        }
        else
        {
            [secondaryPhoneTextField setText:[[storeContactArray objectAtIndex:2]objectForKey:@"ContactNumber" ]];
        }

    }

        /*Set the TextFields for Email,website and facebook here*/
    
        [websiteTextField setText:appDelegate.storeWebsite];
        [emailTextField setText:appDelegate.storeEmail];
        [facebookTextField setText:appDelegate.storeFacebook];


    
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


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
        
    return YES;
}


- (void) keyboardWillShow: (NSNotification*) aNotification

{
    
    if (textFieldTag==1 || textFieldTag==2 || textFieldTag==3)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];

    }
    
    
    
    
    if (textFieldTag==4 || textFieldTag==5 || textFieldTag==6)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 190;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];

    }
    
}




- (void) keyboardWillHide: (NSNotification*) aNotification
{
    
    
    if (textFieldTag==1 || textFieldTag==2 || textFieldTag==3)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
    
    if (textFieldTag==4 || textFieldTag==5 || textFieldTag==6)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 190;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }

    
	
}


-(void)updateMessage
{
    
    UpdateStoreData  *strData=[[UpdateStoreData  alloc]init];
    NSMutableArray *uploadArray=[[NSMutableArray alloc]init];
    

    
    if (isContact1Changed )
    {
                
        NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
        
        upLoadDictionary=@{@"value":mobileNumTextField.text,@"key":@"CONTACTS"};

        [uploadArray  addObject:upLoadDictionary];
        
        [strData updateStore:uploadArray];
        
        isContact1Changed=NO;
        
        
        
        
    }

    
    if (isContact2Changed)
    {
        
        NSString *uploadString=[NSString stringWithFormat:@"%@#%@",mobileNumTextField.text,landlineNumTextField.text];
    
        NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
        
        upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
        
        [uploadArray  addObject:upLoadDictionary];
        
        [strData updateStore:uploadArray];
        
        isContact2Changed=NO;
        
    }
        
    
    if (isContact3Changed)
    {

        NSString *uploadString=[NSString stringWithFormat:@"%@#%@#%@",mobileNumTextField.text,landlineNumTextField.text,secondaryPhoneTextField.text];
        
        NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
        
        upLoadDictionary=@{@"value":uploadString,@"key":@"CONTACTS"};
        
        [uploadArray  addObject:upLoadDictionary];
        
        [strData updateStore:uploadArray];
        
        isContact3Changed=NO;
        
        
    }
    

    if (isWebSiteChanged)
    {

        NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
        
        upLoadDictionary=@{@"value":websiteTextField.text,@"key":@"URL"};
        
        [uploadArray  addObject:upLoadDictionary];
        
        [strData updateStore:uploadArray];
        
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
        
        [uploadArray  addObject:upLoadDictionary];
        
        [strData updateStore:uploadArray];
        
        isEmailChanged=NO;

        
        if ([emailTextField.text isEqualToString:@""]) {
            
            appDelegate.storeEmail=@"No Description";
            
        }
        
        else
        {
            appDelegate.storeEmail=emailTextField.text;
            
        }
        
    }
    
    
    if (isFBChanged)
    {
        
        NSDictionary *upLoadDictionary=[[NSDictionary alloc]init];
        
        upLoadDictionary=@{@"value":facebookTextField.text,@"key":@"FB"};
        
        [uploadArray  addObject:upLoadDictionary];
        
        [strData updateStore:uploadArray];
        
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
    
    NSLog(@"appdelegate Store contact array:%@",appDelegate.storeContactArray);
    
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
    [super viewDidUnload];
}

- (IBAction)dismissKeyBoard:(id)sender
{
    [[self view] endEditing:YES];
}

@end
