//
//  RegisterBusinessDetailsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 15/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "RegisterBusinessDetailsViewController.h"
#import "RegisterBusinessAddressViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"

@interface RegisterBusinessDetailsViewController ()
{
    
    float viewHeight;
    NSCharacterSet *blockedCharacters;

}
@end



@implementation RegisterBusinessDetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            /*For iphone 3,3gS,4,42*/
            viewHeight=480;
        }
        if(result.height == 568)
        {
            /*For iphone 5*/
            viewHeight=568;
            
        }
    }

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    navBar.topItem.title=@"Business Details";

    [navBar setClipsToBounds:YES];
    
    UIImage *cancelbuttonImage = [UIImage imageNamed:@"_back.png"];
    
    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setFrame:CGRectMake(-10,0,90,44)];
    
    [customCancelButton addTarget:self action:@selector(cancelRegisterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:cancelbuttonImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];

    
    

    
    UIImage *nextbuttonImage = [UIImage imageNamed:@"nextButton.png"];
    
    
    customNextButton=[UIButton buttonWithType:UIButtonTypeCustom];

    [customNextButton setFrame:CGRectMake(240, 0, 90, 44)];

    [customNextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [customNextButton setImage:nextbuttonImage  forState:UIControlStateNormal];
    
    [customNextButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customNextButton];
    
    
    businessNameBg.layer.borderColor=[UIColor colorWithHexString:@"dcdcda"].CGColor;
    
    businessNameBg.layer.cornerRadius=6.0;
    
    businessNameBg.layer.borderWidth=1.0;
    
    businessVerticalBg.layer.borderColor=[UIColor colorWithHexString:@"dcdcda"].CGColor;

    businessVerticalBg.layer.cornerRadius=6.0;
    
    businessVerticalBg.layer.borderWidth=1.0;

    blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];

    
}



#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{

    if (field.tag==2)
    {
        //Tells the delegate to skip whitespaces
        if (![characters isEqualToString:@" "])
        {
            return ([characters rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
        }
        
    }
    
    return YES;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    
    
    if (textField.tag==1)
    {
        
        if (textField.text.length==0)
        {
        businessVerticalBg.layer.borderColor=[UIColor colorWithHexString:@"dcdcda"].CGColor;
        
        return YES;
        }
    }

    if (textField.tag==2 )
    {
        
        if (textField.text.length==0)
        {
            
            
            businessNameBg.layer.borderColor=[UIColor colorWithHexString:@"dcdcda"].CGColor;
            
            return YES;
        }
        
    }
    
    

    return YES;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{


    
    if (textField.tag==1)
    {
        if (textField.text.length==0)
        {
        businessVerticalBg.layer.borderColor=[UIColor colorWithHexString:@"ff0000"].CGColor;
        [customNextButton setHidden:YES];
        return YES;
        }
                
    }

    
    if (textField.tag==2)
    {

        if (textField.text.length==0)
        {
        
            businessNameBg.layer.borderColor=[UIColor colorWithHexString:@"ff0000"].CGColor;
            [customNextButton setHidden:YES];
            return YES;

        }


    }
    
    return YES;


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



-(void)cancelRegisterButtonClicked
{
    
    UIAlertView *cancelAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Are you sure you want to cancel the registration process ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [cancelAlertView setTag:101];
    
    [cancelAlertView show];
    
    cancelAlertView=nil;
    
}



-(void)nextButtonClicked
{

    RegisterBusinessAddressViewController *addressController=[[RegisterBusinessAddressViewController alloc]initWithNibName:@"RegisterBusinessAddressViewController" bundle:Nil];
    
    [self.navigationController pushViewController:addressController animated:YES];
    
    addressController =nil;


}


#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (alertView.tag==101)
    {
        
        if (buttonIndex==1)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
    }
    
}


- (IBAction)endEditingButtonClicked:(id)sender
{
    
    [self.view endEditing:YES];
    
}





















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    businessNameBg = nil;
    businessVerticalBg = nil;
    stepSubView = nil;
    [super viewDidUnload];
}
@end
