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

@interface ForgotPasswordController ()
{
    float viewHeight;
    UILabel *headerLabel;
    UINavigationBar *navBar;
    int loginSuccessCode;
    NSMutableData *receivedData;
    UIButton *leftCustomButton, *rightCustomButton;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate=(AppDelegate *)[UIApplication  sharedApplication].delegate;
    
    forgotTableView.dataSource = self;
    
    forgotTableView.delegate = self;
    
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
    
    if (version.floatValue<7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 13, 200, 20)];
        
        headerLabel.text=@"Forgot Password";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"back-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
    
        
    }
    else
    {
        
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.translucent = YES;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationItem.title=@"Forgot password";
        
    }

}

#pragma UITableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            userName = [[UITextField alloc] initWithFrame:CGRectMake(10,10, 320, 40)];
            userName.tag = 101;
            userName.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
            [userName setPlaceholder:@"Username/ Business Name/ Primary number"];
            userName.delegate = self;
            userName.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:userName];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        if(viewHeight == 480)
        {
            return 80;
        }
        else
        {
            return 50;
        }
    }
    else
    {
        return 20;//35
    }
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submit:(id)sender
{
    [self.view endEditing:YES];
    
    if(userName.text.length == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ooops" message:@"Username cannot be empty" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
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
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [receivedData appendData:data1];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (loginSuccessCode==200)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Check your mail" message:@"We have sent you an email with instructions on how to reset your password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        alert.tag = 101;
        [alert show];
        
        alert=nil;
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
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

#pragma Alertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPassword:(id)sender {
    [self submit:nil];
}
@end
