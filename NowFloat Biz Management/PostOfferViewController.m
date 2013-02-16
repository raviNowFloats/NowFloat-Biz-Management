//
//  PostOfferViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "PostOfferViewController.h"
#import "CreateStoreDeal.h"
#import "SWRevealViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import "UIColor+HexaString.h"
#import "BizMessageViewController.h"


@interface PostOfferViewController ()

@end

@implementation PostOfferViewController

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
    
    
    [postMessageTextView.layer setCornerRadius:6];
    dealStartDateString=[[NSString alloc]init];
    dealEndDateString=[[NSString alloc]init];
    
    
    
    
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc]
                                                initWithTitle:@"Post"
                                                style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(postMessage)];
    
    
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    
    [datePickerSubView setHidden:YES];
    
    isStartDate=false;
    isEndDate=false;
    
    isStartDateFilled=false;
    isEndDateFilled=false;
    
    

    [[NSNotificationCenter defaultCenter]
                             addObserver:self
                             selector:@selector(updateView)
                             name:@"updateMessage" object:nil];


}



-(void)postMessage
{
    
    
    if (isStartDateFilled && isEndDateFilled )
    {

        
        if ([postMessageTextView.text length]==0)
        {
            
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:@"Ooops"
                                message:@"Please fill a deal title"
                                delegate:self
                                cancelButtonTitle:@"Okay"
                                otherButtonTitles:nil, nil];
            
            [alert  show];
            
            alert=nil;
            
        }
        
        
        else
        {
        CreateStoreDeal *createStrDeal=[[CreateStoreDeal alloc]init];
        
        
        NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
            @"0",@"DiscountPercent",
            postMessageTextView.text,@"Description",
            postMessageTextView.text,@"Title",
            dealEndDateString,@"EndDate",
            dealStartDateString,@"StartDate", nil];
        
            
        [createStrDeal createDeal:uploadDictionary];
            
        }
        
    }
    
    
    else
    {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"Please enter start date and end date correctly" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [alert show];
        
        alert=nil;

    }
    
    
    
}




-(void)textViewDidChange:(UITextView *)textView
{
    int len = textView.text.length;
    characterCount.text=[NSString stringWithFormat:@"%i",250-len];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL flag = NO;
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            flag = YES;
            return YES;
        }
        else {
            return NO;
        }
    }
    else if([[textView text] length] > 249)
    {
        return NO;
    }
    
    return YES;
}



-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)dealStartDateClicked:(id)sender
{
    
        [datePickerSubView setHidden:NO];
        isStartDate=true;
        isEndDate=false;
}

- (IBAction)dealEndDateClicked:(id)sender
{
    
        [datePickerSubView setHidden:NO];
        isEndDate=true;
        isStartDate=false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)displayDate:(id)sender
{
	NSDate * selected = [datePicker date];

    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString=[dateFormatter stringFromDate:selected];
    
    NSLog(@"dateFormatter:%@",dateString);


    if (isStartDate)
    {
    
        isStartDateFilled=true;
        [dealStartDateBtn setTitle:dateString forState:UIControlStateNormal];
        dealStartDateString=dateString;
        [datePickerSubView setHidden:YES];
        
        
        
        
    }
    
    
    
    if (isEndDate) {
        
        isEndDateFilled=true;
        [dealEndDateBtn setTitle:dateString forState:UIControlStateNormal ];
        dealEndDateString=dateString;
        [datePickerSubView setHidden:YES];
    }
    
    
    
    
}

- (IBAction)cancelButtonClicked:(id)sender
{
    
    [datePickerSubView setHidden:YES];
}



-(void)updateView
{

    
    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    

    [self.navigationController pushViewController:bizController animated:YES];

}


- (void)viewDidUnload {
    postMessageTextView = nil;
    datePicker = nil;
    dealStartDateBtn = nil;
    dealEndDateBtn = nil;
    datePickerSubView = nil;
    [super viewDidUnload];
}
@end
