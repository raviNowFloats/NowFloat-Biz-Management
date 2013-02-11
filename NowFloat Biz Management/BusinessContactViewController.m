//
//  BusinessContactViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessContactViewController.h"
#import "SWRevealViewController.h"


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
    
    
    self.title = NSLocalizedString(@"Contact Information", nil);
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self     action:@selector(updateMessage)];
    
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

    
    /*Text Field Notification*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    
    
    
    /*Store Contact Array*/
    
    
    storeContactArray=[appDelegate.storeDetailDictionary objectForKey:@"Contacts"];
    
    NSLog(@"storeContactArray:%@",storeContactArray);
    

    if ([storeContactArray count]==1)
    {
        
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

        
    }
    
    
    
    
    if ([storeContactArray count]==2)
    {
        
        
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

    
    
    
    
    
        
    
    
       
    
    
    
    
    
    
    
    
    
    if ([appDelegate.storeDetailDictionary   objectForKey:@"Uri"]==[NSNull null] || [[appDelegate.storeDetailDictionary   objectForKey:@"Uri"]length]==0)
    {
        
        [websiteTextField setText:@"No Description"];
        
    }
    
    else
    {
        
    [websiteTextField setText:[appDelegate.storeDetailDictionary   objectForKey:@"Uri"]];
    }
    
    
    if ([appDelegate.storeDetailDictionary  objectForKey:@"Email"]==[NSNull null] ||
        [[appDelegate.storeDetailDictionary  objectForKey:@"Email"] length]==0)
    
    {
        [emailTextField setText:@"No Description"];
    }
    
    else
    {
    [emailTextField setText:[appDelegate.storeDetailDictionary  objectForKey:@"Email"]];
    }
    
    
    
    
}




- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    textFieldTag=[textField tag];
    NSLog(@"textFieldTag:%d",textFieldTag);
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
        
    return YES;
}

- (void) keyboardWillShow: (NSNotification*) aNotification

{
    
    if (textFieldTag==1 || textFieldTag==2 )
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];

    }
    
    
    
    
    if (textFieldTag==4 || textFieldTag==3)
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
    
    
    if (textFieldTag==1 || textFieldTag==2 ) 
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
    
    if (textFieldTag==4 || textFieldTag==3)
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
    
    NSLog(@"update message");
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    mobileNumTextField = nil;
    landlineNumTextField = nil;
    websiteTextField = nil;
    emailTextField = nil;
    secondaryPhoneTextField = nil;
    [super viewDidUnload];
}
@end
