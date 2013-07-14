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
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"




@interface BusinessDetailsViewController ()<updateStoreDelegate>

@end

@implementation BusinessDetailsViewController
@synthesize businessDescriptionTextView,businessNameTextView;
@synthesize uploadArray;


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
            detailScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+50);
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            detailScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+20);
            
        }
    }

    
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    upLoadDictionary=[[NSMutableDictionary alloc]init];
    
    uploadArray=[[NSMutableArray alloc]init];
    
    businessNameString=[[NSString alloc]init];
    
    businessDescriptionString=[[NSString alloc]init];
    
    isStoreDescriptionChanged=NO;
    
    isStoreTitleChanged=NO;
    
    businessDescriptionString=appDelegate.businessDescription;
    
    businessNameString=appDelegate.businessName;

    [businessDescriptionTextView.layer  setCornerRadius:6.0f];
    
    [businessDescriptionTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [businessDescriptionTextView.layer setBorderWidth:1.0];
    
    [businessNameTextView.layer setCornerRadius:6.0f];
    
    [businessNameTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [businessNameTextView.layer setBorderWidth:1.0];
    
    [activitySubView setHidden:YES];
    
    
    /*Design the NavigationBar here*/

    self.navigationController.navigationBarHidden=YES;
    
    CGFloat width = self.view.frame.size.width;
    
    navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(84, 13,164, 20)];
    
    headerLabel.text=@"Business Name";
    
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


    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(textViewKeyPressed:) name: UITextViewTextDidChangeNotification object: nil];


    /*Set The TextViews Here*/

    [businessNameTextView setText:businessNameString];

    [businessDescriptionTextView setText:businessDescriptionString];
    
    
    if ([businessNameString length]==0)
    {
        [businessNamePlaceHolderLabel setHidden:NO];
    }
    
    
    if ([businessDescriptionString length]==0)
    {
        [businessDescriptionPlaceHolderLabel setHidden:NO];
        
    }
    
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView)
                                                 name:@"update" object:nil];

 
    
    customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,5, 30, 30)];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [navBar addSubview:customButton];

    [customButton setHidden:YES];
    
}


-(void)revealRearViewController
{
    
    [businessDescriptionTextView resignFirstResponder];
    [businessNameTextView resignFirstResponder];
    
    //revealToggle:
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController performSelector:@selector(revealToggle:)];
}




-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    textFieldTag=textView.tag;
    
    if (textFieldTag==2)
    {
        
        if ([businessDescriptionString length]==0) {
            
            [businessDescriptionPlaceHolderLabel setHidden:YES];
            
        }
        
        
        CGSize kbSize=CGSizeMake(320, 216);
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        
        detailScrollView.contentInset = contentInsets;
        
        detailScrollView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        
        aRect.size.height -= kbSize.height;
        
        if (!CGRectContainsPoint(aRect, textView.frame.origin) )
        {
            CGPoint scrollPoint = CGPointMake(0.0, textView.frame.origin.y-kbSize.height+120);
            
            [detailScrollView setContentOffset:scrollPoint animated:YES];
        }        
        
    }
    
    if (textFieldTag==1) {
        
        
        if ([businessNameString length]==0) {
            
            
            [businessNamePlaceHolderLabel setHidden:YES];
            
        }
        
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    
    if (textView.tag==1)
    {
        isStoreTitleChanged=YES;
        
        if ([textView.text length]==0) {
            
            [businessNamePlaceHolderLabel setHidden:NO];
            
        }
        
        
    }
    
    
    else if (textView.tag==2)
    {
        isStoreDescriptionChanged=YES;
        
        
        if ([textView.text length]==0) {
            
            [businessDescriptionPlaceHolderLabel setHidden:NO];
            
        }
    }

}


-(void) textViewKeyPressed: (NSNotification*) notification {
    
    if ([[[notification object] text] hasSuffix:@"\n"])
    {
        [[notification object] resignFirstResponder];
    }
}






- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
   
    return YES;
}



- (void)textViewDidChange:(UITextView *)textView;
{

    if (textView.tag==1 || textView.tag==2)
    {        
        [customButton setHidden:NO];
        
    }

}



-(void)updateMessage
{
    
    [businessDescriptionTextView resignFirstResponder];
    
    [businessNameTextView resignFirstResponder];
    
    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    strData.delegate=self;
    
    if (isStoreTitleChanged && isStoreDescriptionChanged)
    {
        [activitySubView setHidden:NO];
        
        [upLoadDictionary setObject:businessDescriptionTextView.text   forKey:@"DESCRIPTION"];
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
        
        [uploadArray addObject:textDescriptionDictionary];
                
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
                

        [upLoadDictionary setObject:businessNameTextView.text forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        
        
        isStoreDescriptionChanged=NO;
        isStoreTitleChanged=NO;
        
    }
    
    
    
    
    
    if (isStoreDescriptionChanged)
    {
        
        [activitySubView setHidden:NO];

        [upLoadDictionary setObject:businessDescriptionTextView.text   forKey:@"DESCRIPTION"];
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
        
        [uploadArray addObject:textDescriptionDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        
        isStoreDescriptionChanged=NO;
        
    }
    
    
    if (isStoreTitleChanged) {
        
        [activitySubView setHidden:NO];
        
        [upLoadDictionary setObject:businessNameTextView.text forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
                
        isStoreTitleChanged=NO;

    }
    
}





-(void)storeUpdateComplete
{
    
    appDelegate.businessName=[NSMutableString stringWithFormat:@"%@",businessNameTextView.text];

    appDelegate.businessDescription=[NSMutableString stringWithFormat:@"%@",businessDescriptionTextView.text ];
    
    UIAlertView *succcessAlert=[[UIAlertView alloc]initWithTitle:@"Update" message:@"Business information updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [succcessAlert show];
    
    succcessAlert=nil;

    
    [self removeSubView];
    
}

-(void)storeUpdateFailed

{

    UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Update" message:@"Business information could not be updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedAlert show];
    
    failedAlert=nil;

    
    
    [self removeSubView];

}



-(void)removeSubView
{
    [activitySubView setHidden:YES];
    
    [customButton setHidden:YES];
    
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    detailScrollView.contentInset = contentInsets;
    detailScrollView.scrollIndicatorInsets = contentInsets;
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











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setBusinessNameTextView:nil];
    [self setBusinessDescriptionTextView:nil];
    detailScrollView = nil;
    businessNamePlaceHolderLabel = nil;
    businessDescriptionPlaceHolderLabel = nil;
    [super viewDidUnload];
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}



@end
