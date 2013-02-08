//
//  MessageDetailsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "MessageDetailsViewController.h"
#import "UIColor+HexaString.h"
#import <QuartzCore/QuartzCore.h>


@interface MessageDetailsViewController ()

@end

@implementation MessageDetailsViewController
@synthesize messageDate,messageDescription,messageTextView;
@synthesize dateLabel,bgLabel;


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
    
    self.navigationController.navigationBarHidden=NO;
    
    messageTextView.text=messageDescription;
    
    [messageTextView.layer setCornerRadius:6];
    
    [dateLabel setText:messageDate];
    
    [dateLabel.layer setCornerRadius:6];

    
//    UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:CGRectMake(50,65,10,10)];
//    
//    [arrowImageView setImage:[UIImage imageNamed:@"triangle.png"]];
//    
//    [arrowImageView setBackgroundColor:[UIColor clearColor]];
//    
//    [self.view addSubview:arrowImageView];
//    
//    CGRect fra=[messageTextView frame];
//    
//    fra.size.height=messageTextView.contentSize.height;
//    
//    [messageTextView setFrame:fra];
//    
//    
//    [bgLabel.layer setCornerRadius:6];
//    
//    [bgLabel setFrame:CGRectMake(60,50,245 , messageTextView.frame.size.height+15)];
//    
    
    
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self     action:@selector(updateMessage)];
    
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
}



-(void)updateMessage
{

    NSLog(@"update message");

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setMessageTextView:nil];
    [self setMessageDate:nil];
    [self setDateLabel:nil];
    [self setBgLabel:nil];
    [super viewDidUnload];
}
@end
