//
//  ReferFriendViewController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/4/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "ReferFriendViewController.h"
#import "UIColor+HexaString.h"
#import "EmailShareController.h"
#import <Social/Social.h>
#import "MobileShareController.h"
#import "Mixpanel.h"


@interface ReferFriendViewController ()
{
    float viewHeight;
    UILabel *headerLabel;
    UIButton *leftCustomButton;
    UINavigationBar *navBar;
}

@end

@implementation ReferFriendViewController

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
    if(version.floatValue < 7.0)
    {
        
    }
    else
    {
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 13, 200, 20)];
        
        headerLabel.text=@"Tell a friend";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [self.navigationController.navigationBar addSubview:headerLabel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate=(AppDelegate *)[UIApplication  sharedApplication].delegate;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
            [referTableView setFrame:CGRectMake(0, 0,result.width, result.height)];
        }
        else
        {
            viewHeight=568;
            [referTableView setFrame:CGRectMake(0, 0,result.width, result.height)];
        }
    }
    
    if(version.floatValue < 7.0)
    {
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 13, 200, 20)];
        
        headerLabel.text=@"Tell a friend";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,9,50,26)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"back-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        

    }
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        
        
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 4;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"String Identifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Email";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Message";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"Facebook";
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"Twitter";
        }
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            if(version.floatValue < 7.0)
            {
                
            }
            else
            {
                [headerLabel removeFromSuperview];
            }
            
            Mixpanel *mixPanel = [Mixpanel sharedInstance];
            
            [mixPanel track:@"Tell a friend via email"];
            
            EmailShareController *emailReferral = [[EmailShareController alloc] initWithNibName:@"EmailShareController" bundle:nil];
            
            [self.navigationController pushViewController:emailReferral animated:YES];

        }
        else if (indexPath.row == 1)
        {
            
            if(version.floatValue < 7.0)
            {
                
            }
            else
            {
                [headerLabel removeFromSuperview];
            }
            Mixpanel *mixPanel = [Mixpanel sharedInstance];
            
            [mixPanel track:@"Tell a friend via sms"];
            
            MobileShareController *mobileReferral = [[MobileShareController alloc] initWithNibName:@"MobileShareController" bundle:nil];
            
            [self.navigationController pushViewController:mobileReferral animated:YES];
            
        }
        else if (indexPath.row == 2)
        {
            Mixpanel *mixPanel = [Mixpanel sharedInstance];
            
            [mixPanel track:@"Tell a friend via Facebook"];
            
            [self shareOnFacebook];
        }
        else if (indexPath.row == 3)
        {
            Mixpanel *mixPanel = [Mixpanel sharedInstance];
            
            [mixPanel track:@"Tell a friend via Twitter"];
            
            [self shareOnTwitter];
        }
    }
}

-(void)shareOnFacebook
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Get a website in minutes using the NowFloats Boost App on iOS & Android. Download it today <referral link> "];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {

        
        [FBRequestConnection startForPostStatusUpdate:@"Get a website in minutes using the NowFloats Boost App on iOS & Android. Download it today <referral link> "
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        if (!error) {
                                            // Status update posted successfully to Facebook
                                            NSLog(@"result: %@", result);
                                        } else {
                                            // An error occurred, we need to handle the error
                                            // See: https://developers.facebook.com/docs/ios/errors
                                            NSLog(@"%@", error.description);
                                        }
                                    }];
        
//        
//        [FBDialogs presentShareDialogWithLink:nil
//                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                          if(error) {
//                                              NSLog(@"Error: %@", error.description);
//                                          } else {
//                                              NSLog(@"Success!");
//                                          }
//                                      }];
        
    }

}

-(void)shareOnTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Get a website in minutes using the @nowfloatsboost App on iOS & Android . Download it today  <referral link>"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(version.floatValue < 7.0)
    {
        
    }
    else
    {
        [headerLabel removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
