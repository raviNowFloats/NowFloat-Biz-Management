//
//  ChangeStoreTagViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 29/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "ChangeStoreTagViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"
#import "VerifyUniqueNameController.h"
#import "SignUpViewController.h"
#import "Mixpanel.h"
#import "NFActivityView.h"


@interface ChangeStoreTagViewController ()<VerifyUniqueNameDelegate>
{
    Mixpanel *mixPanel;
    NFActivityView *nfActivity;

}
@end

@implementation ChangeStoreTagViewController
@synthesize fpName,delegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.3];

}


-(void)showKeyBoard
{
    
    [storeTagTextField becomeFirstResponder];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    mixPanel=[Mixpanel sharedInstance];
    
    //Create NavBar here
    self.navigationController.navigationBarHidden=YES;
    
    textFieldBg.layer.masksToBounds = YES;
    textFieldBg.layer.cornerRadius = 6.0f;
    textFieldBg.layer.needsDisplayOnBoundsChange=YES;
    textFieldBg.layer.shouldRasterize=YES;
    [textFieldBg.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    textFieldBg.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
    textFieldBg.layer.borderWidth = 1.0f;

    nfActivity=[[NFActivityView alloc]init];
    
    nfActivity.activityTitle=@"Checking";

    
}


-(void)back
{

    [self dismissModalViewControllerAnimated:YES];
    
}


-(void)requestNewStoreTagBtnClicked
{
    
    [mixPanel track:@"requestNewStoreTag"];

    [self.view endEditing:YES];
    
    [nfActivity showCustomActivityView];
    
    VerifyUniqueNameController *uniqueNameController=[[VerifyUniqueNameController alloc]init];
    
    uniqueNameController.delegate=self;
    
    [uniqueNameController verifyWithFpName:fpName andFpTag:storeTagTextField.text];

}

#pragma VerifyUniqueNameDelegate


-(void)verifyUniqueNameDidComplete:(NSString *)responseString
{
    
    [nfActivity hideCustomActivityView];
    
    if ([[responseString lowercaseString] isEqualToString:storeTagTextField.text])
    {
        
        
        [delegate performSelector:@selector(changeStoreTagComplete:) withObject:[responseString lowercaseString]];
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
    else
    {

        UIAlertView *reWriteAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Store domain already exists with us.Please try another name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [reWriteAlertView show];
        
        reWriteAlertView=nil;
        
    }
    
    
}


-(void)verifyuniqueNameDidFail:(NSString *)responseString
{

    [nfActivity hideCustomActivityView];

    UIAlertView *failAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failAlertView show];
    
    failAlertView=nil;
    
}


#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    //Do not allow user to enter whitespaces in the begining
    if (range.location == 0 && [text isEqualToString:@" "])
    {
        return NO;
    }
    
    
    if ( [text isEqualToString:@"\n"] || [text isEqualToString:@" "])
    {
        return NO;
        
    }
   
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    
    if (![text isEqualToString:@" "])
    {
        return ([text rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
        
    }
    
    return YES;
    
}



- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger restrictedLength=45;
    
    NSString *temp=textView.text;
    
    if([[textView text] length] > restrictedLength)
    {
        textView.text=[temp substringToIndex:[temp length]-1];
    }
    
}

#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text;   // return NO to not change text
{

    //Do not allow user to enter whitespaces in the begining
    if (range.location == 0 && [text isEqualToString:@" "])
    {
        return NO;
    }
    
    
    if ( [text isEqualToString:@"\n"] || [text isEqualToString:@" "])
    {
        return NO;
        
    }
    
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    
    if (![text isEqualToString:@" "])
    {
        return ([text rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
        
    }
    
    return YES;    
}


- (IBAction)backButtonClicked:(id)sender
{
    
    [self back];
    
}

- (IBAction)checkDomainAvailabilityBtnClicked:(id)sender
{
    if (storeTagTextField.text.length<7)
    {
        UIAlertView *checkAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Tag text should be more than 6 characters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [checkAlert show];
        checkAlert=nil;
    }
    else
    {
        [self requestNewStoreTagBtnClicked];
    }
}

- (IBAction)endEditingBtnClicked:(id)sender
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    navBar = nil;
    [super viewDidUnload];
}

@end
