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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.view setBackgroundColor:[UIColor colorWithHexString:@"CCCCCC"]];

    [postMessageTextView.layer setCornerRadius:6];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self     action:@selector(postMessage)];
    
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
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


-(void)postMessage
{
    
    NSLog(@"update message");
    
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

- (void)viewDidUnload {
    [self setPostMessageTextView:nil];
    characterCount = nil;
    [super viewDidUnload];
}
@end
