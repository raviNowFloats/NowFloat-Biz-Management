//
//  PostMessageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 27/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "PostMessageViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import "UIColor+HexaString.h"
#import "CreateStoreDeal.h"
#import "BizMessageViewController.h"



@interface PostMessageViewController ()

@end

@implementation PostMessageViewController
@synthesize  postMessageTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.4];
    
    
}


-(void)showKeyBoard
{

    [postMessageTextView becomeFirstResponder];


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.view setBackgroundColor:[UIColor colorWithHexString:@"CCCCCC"]];

    [postMessageTextView.layer setCornerRadius:6];
    
    
    [[NSNotificationCenter defaultCenter]
                         addObserver:self
                         selector:@selector(updateView)
                         name:@"updateMessage" object:nil];
    
    
    [downloadSubview setHidden:YES];

}


-(void)textViewDidChange:(UITextView *)textView
{
    NSString *substring = [NSString stringWithString:textView.text];
    
    createMessageLabel.hidden=YES;
    
    substring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (substring.length > 0)
    {
        characterCount.hidden = NO;
        characterCount.text = [NSString stringWithFormat:@"%d", substring.length];
        
        UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customButton setFrame:CGRectMake(0, 0, 55, 30)];
        
        [customButton addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchUpInside];
        
        [customButton setBackgroundImage:[UIImage imageNamed:@"update.png"]  forState:UIControlStateNormal];
        
        UIBarButtonItem *postMessageButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customButton];
        
        self.navigationItem.rightBarButtonItem=postMessageButtonItem;

        
        
    }
    
    
    if (substring.length == 0)
    {
        characterCount.hidden = YES;
        createMessageLabel.hidden=NO;
        self.navigationItem.rightBarButtonItem=nil;

    }
    
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{

    NSLog(@"text view did begin editing");

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
        
        else
        {
            return NO;
        }
    }
    else if([[textView text] length] > 249)
    {
        return NO;
    }
    
    return YES;
}


-(void)postMessage
{

    if ([postMessageTextView.text length]==0)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]
                                        initWithTitle:@"Ooops"
                                        message:@"Please fill a message"
                                        delegate:self
                                        cancelButtonTitle:@"Okay"
                                        otherButtonTitles:nil, nil];
        
        [alert  show];
        
        alert=nil;
        
    }

    else
    {
    
        [downloadSubview setHidden:NO];
        [postMessageTextView resignFirstResponder];
        [self performSelector:@selector(postNewMessage) withObject:nil afterDelay:0.1];
    
    }


}


-(void)postNewMessage
{

    CreateStoreDeal *createStrDeal=[[CreateStoreDeal alloc]init];
    
    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           @"0",@"DiscountPercent",
                                           postMessageTextView.text,@"Description",
                                           postMessageTextView.text,@"Title",nil];
    
    createStrDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
    
    [createStrDeal createDeal:uploadDictionary];

}


-(void)updateView
{
    
    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    [self.navigationController pushViewController:bizController animated:YES];
    
    [downloadSubview setHidden:YES];
    
}


-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setPostMessageTextView:nil];
    characterCount = nil;
    downloadSubview = nil;
    createMessageLabel = nil;
    [super viewDidUnload];
}

@end
