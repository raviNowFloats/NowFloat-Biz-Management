//
//  BusinessAddressViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessAddressViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"


@interface BusinessAddressViewController ()

@end

@implementation BusinessAddressViewController


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
    
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    [addressTextView.layer setCornerRadius:6.0f];
    
    [addressTextView.layer setBorderWidth:1.0];
    
    [addressTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    addressTextView.textColor=[UIColor colorWithHexString:@"9c9b9b"];
    
    noteTextView.textColor=[UIColor colorWithHexString:@"464646"];
    
    /*Design the NavigationBar here*/
    
    self.navigationController.navigationBarHidden=YES;
    
    CGFloat width = self.view.frame.size.width;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,44)];
    
    [self.view addSubview:navBar];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 13,160, 20)];
    
    headerLabel.text=@"Business Address";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textAlignment=NSTextAlignmentCenter;
    
    headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
    
    [navBar addSubview:headerLabel];    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
    
    [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
    
    [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:leftCustomButton];
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;

    
    
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,9, 25 , 25)];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"editicon.png"]  forState:UIControlStateNormal];
    
    [navBar addSubview:customButton];
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"Address"]!=[NSNull null])
    {
    
    addressTextView.text=[appDelegate.storeDetailDictionary objectForKey:@"Address"];
        
        NSString *spList=addressTextView.text;
        NSArray *list = [spList componentsSeparatedByString:@","];
        
        addressTextView.text=[NSString stringWithFormat:@"%@",list];
        
        addressTextView.text=[addressTextView.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        addressTextView.text=[addressTextView.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
        addressTextView.text=[addressTextView.text stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        addressTextView.text=[addressTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        noteTextView.text=[NSString stringWithFormat:@"Note: The address cannot be changed through the app.You can contact our customer care to make any changes." ];
        
        CGRect frame = addressTextView.frame;
        frame.size.height = addressTextView.contentSize.height;
        addressTextView.frame = frame;
        
        CGRect noteFrame=CGRectMake(21, addressTextView.frame.size.height+110, noteTextView.frame.size.width, noteTextView.frame.size.height);
        noteFrame.size.height=noteTextView.contentSize.height;
        noteTextView.frame=noteFrame;
        
        UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [callButton setFrame:CGRectMake(21, noteTextView.frame.size.height+310, noteTextView.frame.size.width,48)];
        [callButton setBackgroundImage:[UIImage imageNamed:@"menu-bg-hover.png"] forState:UIControlStateNormal];
        [callButton setTitle:@"Call" forState:UIControlStateNormal];
        callButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        [callButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
        
        [callButton addTarget:self
                       action:@selector(callCustomerSupport)
             forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:callButton];
        
        

        
        
    }
    
    else
    {
    
    addressTextView.text=@"No Description";
    
    }

    
    
}


-(void)updateMessage
{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"Please call our customer care to change your address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setTag:1];
    [alert show];
    alert=nil;

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
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {
        [revealFrontControllerButton setHidden:NO];        
    }
    
}


-(void)callCustomerSupport
{
    
    UIAlertView *callAlertView=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to call the customer care?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    callAlertView.tag=1;
    [callAlertView show];
    callAlertView=nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{

    if (alertView.tag==1)
    {
        
        if (buttonIndex==1) {
            
            
            NSString* phoneNumber=@"919160004303";
            
            NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",phoneNumber]];
            
            if([[UIApplication sharedApplication] canOpenURL:callUrl])
            {
                [[UIApplication sharedApplication] openURL:callUrl];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            

        }
        
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    addressTextView = nil;
    noteTextView = nil;
    [super viewDidUnload];
}




@end
