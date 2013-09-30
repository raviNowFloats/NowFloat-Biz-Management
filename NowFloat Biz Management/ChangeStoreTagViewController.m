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


@interface ChangeStoreTagViewController ()<VerifyUniqueNameDelegate>

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
    
    [storeTagTextView becomeFirstResponder];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Create NavBar here
    
    self.navigationController.navigationBarHidden=YES;
    
    [navBar setClipsToBounds:YES];
        
    //Create the custom cancel button here
    
    
    
    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [customCancelButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
    
    customCancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
    
    [customCancelButton setFrame:CGRectMake(-10,0,90,44)];
    
    [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
   
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];
    
    
    
    customNextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customNextButton setTitle:@"Done" forState:UIControlStateNormal];
    
    customNextButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
    
    [customNextButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
    
    [customNextButton setFrame:CGRectMake(240,0,90,44)];
    
    [customNextButton addTarget:self action:@selector(requestNewStoreTagButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [customNextButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customNextButton];
    
    
    
    storeTagTextView.layer.masksToBounds = YES;
    storeTagTextView.layer.cornerRadius = 6.0f;
    storeTagTextView.layer.needsDisplayOnBoundsChange=YES;
    storeTagTextView.layer.shouldRasterize=YES;
    [storeTagTextView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    storeTagTextView.layer.borderColor = [[UIColor colorWithHexString:@"dcdcda"] CGColor];
    storeTagTextView.layer.borderWidth = 1.0f;

    
    [activitySubVIew setHidden:YES];
    
    
}


-(void)back
{

    [self dismissModalViewControllerAnimated:YES];
    
}


-(void)requestNewStoreTagButtonClicked
{

    [self.view endEditing:YES];
    
    [activitySubVIew setHidden:NO];
    
    VerifyUniqueNameController *uniqueNameController=[[VerifyUniqueNameController alloc]init];
    
    uniqueNameController.delegate=self;
    
    [uniqueNameController verifyWithFpName:fpName andFpTag:storeTagTextView.text];

    

}

#pragma VerifyUniqueNameDelegate


-(void)verifyUniqueNameDidComplete:(NSString *)responseString
{
    
    [activitySubVIew setHidden:YES];
    
    if ([[responseString lowercaseString] isEqualToString:storeTagTextView.text])
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    navBar = nil;
    storeTagTextView = nil;
    activitySubVIew = nil;
    [super viewDidUnload];
}
@end
