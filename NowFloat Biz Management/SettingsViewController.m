//
//  SettingsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SettingsViewController.h"
#import <Social/Social.h>
#import "Accounts/Accounts.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    if ([userDefaults objectForKey:@"NFManageFBUserId"] && [userDefaults objectForKey:@"NFManageFBAccessToken"])
    {

        [disconnectFacebookButton setHidden:NO];
        [facebookButton setHidden:YES];
        
    }
    
    
    else
    {

        [disconnectFacebookButton setHidden:YES];
        [facebookButton setHidden:NO];
    
    }
        
//    NSLog(@"UserDefaults:%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookButtonClicked:(id)sender
{
        [appDelegate openSession];
        [disconnectFacebookButton setHidden:NO];
        [facebookButton setHidden:YES];

}


- (IBAction)fbAdminButtonClicked:(id)sender
{
    [appDelegate connectAsFbPageAdmin];
}



- (IBAction)disconnectFacebookButtonClicked:(id)sender
{
    
    [disconnectFacebookButton setHidden:YES];
    [facebookButton setHidden:NO];
    [userDefaults removeObjectForKey:@"NFManageFBUserId"];
    [userDefaults removeObjectForKey:@"NFManageFBAccessToken"];
    [userDefaults synchronize];

    NSLog(@"Disconneting with facebook");
}



- (IBAction)twitterButtonClicked:(id)sender
{
    
}







- (void)viewDidUnload {
    facebookButton = nil;
    disconnectFacebookButton = nil;
    [super viewDidUnload];
}
@end
