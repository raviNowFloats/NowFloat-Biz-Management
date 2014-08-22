//
//  ForgotPasswordController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/7/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "ForgotPasswordController.h"
#import "Mixpanel.h"
#import "UIColor+HexaString.h"
#import "SBJsonWriter.h"
#import "DBValidator.h"
#import "SBJson.h"
#import "Helpshift.h"

@interface ForgotPasswordController ()<UIAlertViewDelegate>
{
    float viewHeight;
    UILabel *headerLabel;
    UINavigationBar *navBar;
    int loginSuccessCode;
    NSMutableData *receivedData;
    UIButton *leftCustomButton, *submitButton;
    UITextField *userName;
}

@end

@implementation ForgotPasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 102 && buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate=(AppDelegate *)[UIApplication  sharedApplication].delegate;
    
    forgotTableView.dataSource = self;
    
    forgotTableView.delegate = self;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"forgotPassword_clicked"];

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        
        else
        {
            viewHeight=568;
        }
    }
    
    
    leftCustomButton = [[UIButton alloc] init];
    
    [leftCustomButton setFrame:CGRectMake(10,34,15,15)];
    
    [leftCustomButton setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
    
    [leftCustomButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationBarView addSubview:leftCustomButton];
    
        forgotTableView.backgroundColor = [UIColor clearColor];
        
        forgotTableView.backgroundView = nil;
    
        forgotTableView.scrollEnabled = NO;
    
    forgotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.navigationController.navigationBarHidden=YES;
    
    headLabel.text = @"Forgot Password!";
    headLabel.textColor = [UIColor colorFromHexCode:@"#969696"];
    headLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    
    submitButton = [[UIButton alloc] init];
    
    if(viewHeight == 480)
    {
        submitButton.frame = CGRectMake(10, 170, 300, 45);
    }
    else
    {
         submitButton.frame = CGRectMake(10, 200, 300, 45);
    }
    
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitPassword:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
    
    submitButton.layer.cornerRadius = 5.0;
    submitButton.layer.masksToBounds = YES;
    
    [self.view addSubview:submitButton];
  
    
    
        
  
    
    


}

#pragma UITableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (!cell)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    

        if(indexPath.row == 0)
        {
            if(viewHeight == 480)
            {
                userName = [[UITextField alloc] initWithFrame:CGRectMake(10,10, 320, 40)];
            }
            else
            {
                userName = [[UITextField alloc] initWithFrame:CGRectMake(10,3, 320, 40)];
            }
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            lineView.backgroundColor = [UIColor colorFromHexCode:@"#d4d4d4"];
            
            [cell.contentView addSubview:lineView];
            
            UIView *MiddleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
            MiddleLineView.backgroundColor = [UIColor colorFromHexCode:@"#d4d4d4"];
            
            [cell.contentView addSubview:MiddleLineView];
            userName.tag = 101;
            userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
            userName.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
            [userName setPlaceholder:@"Username"];
            userName.delegate = self;
            userName.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:userName];
        }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




#pragma TextField methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)back:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submit:(id)sender
{
    [self.view endEditing:YES];
    
    
    if(userName.text.length == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Username cannot be empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        alert=nil;
    }
    else
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:appDelegate.clientId,@"clientId",userName.text,@"fpKey", nil];
        
        SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
        
        NSString *uploadString=[jsonWriter stringWithObject:dic];
        
        NSData *postData = [uploadString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSString *urlString=[NSString stringWithFormat:
                             @"%@/forgotPassword",appDelegate.apiWithFloatsUri];
        
        NSURL *loginUrl=[NSURL URLWithString:urlString];
        
        NSMutableURLRequest *changePasswordRequest = [NSMutableURLRequest requestWithURL:loginUrl];
        
        [changePasswordRequest setHTTPMethod:@"POST"];
        
        [changePasswordRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [changePasswordRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [changePasswordRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [changePasswordRequest setHTTPBody:postData];
        
        NSURLConnection *theConnection;
        
        theConnection =[[NSURLConnection alloc] initWithRequest:changePasswordRequest delegate:self];
    }
    
    submitButton.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [receivedData appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (loginSuccessCode==200)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"forgotPassword_retrieved"];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Check your email!" message:@"We have sent you an email with password details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        alert.tag = 102;
        
        [alert show];
        
        alert=nil;
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
        alert=nil;
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code==200)
    {
        loginSuccessCode=200;
    }
    else
    {
        loginSuccessCode=code;
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [errorAlert show];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPassword:(id)sender
{
     submitButton.backgroundColor = [UIColor colorFromHexCode:@"#ebaa00"];
    [self submit:nil];
}


- (IBAction)submitClicked:(id)sender
{
    [self submit:nil];
}

@end
