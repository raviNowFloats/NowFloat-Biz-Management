//
//  BusinessDetailsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessDetailsViewController.h"
#import "SWRevealViewController.h"
#import "UpdateStoreData.h"

@interface BusinessDetailsViewController ()

@end

@implementation BusinessDetailsViewController
@synthesize businessDescriptionTextView,businessNameTextView;



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

    
    self.title = NSLocalizedString(@"Business Details", nil);
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


    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    
    
    
    /*Set The TextViews Here*/
    
    if ([appDelegate.storeDetailDictionary  objectForKey:@"Name"]==[NSNull null])
    {
        [businessNameTextView setText:@"Business Description"];
    
    }

    else
    {
        [businessNameTextView setText:[appDelegate.storeDetailDictionary    objectForKey:@"Name"]];
    }




    if([appDelegate.storeDetailDictionary objectForKey:@"Description"]==[NSNull null])
    {
        [businessDescriptionTextView setText:@"No Description"];
        
    }



    else
    {
    
        [businessDescriptionTextView setText:[appDelegate.storeDetailDictionary objectForKey:@"Description"]];
    }
    
}



-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    textFieldTag=textView.tag;

    return YES;
}


- (void) keyboardWillShow: (NSNotification*) aNotification

{
    if (textFieldTag==1 )
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
    
    if (textFieldTag==2)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 130;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification
{
    
    if (textFieldTag==1)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
    
    if (textFieldTag==2)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 130;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
	
}






-(void)updateMessage
{
    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    NSMutableDictionary *upLoadDictionary=[[NSMutableDictionary alloc]init];
    
    [upLoadDictionary setObject:businessDescriptionTextView.text   forKey:@"DESCRIPTION"];
        
   // NSMutableArray *uploadArray=[[NSMutableArray alloc]initWithObjects:upLoadDictionary, nil];
        
    [strData updateStore:upLoadDictionary];
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBusinessNameTextView:nil];
    [self setBusinessDescriptionTextView:nil];
    [super viewDidUnload];
}
@end
