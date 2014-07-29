//
//  BusinessProfileController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/26/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BusinessProfileController.h"
#import "UIColor+HexaString.h"
#import "SWRevealViewController.h"
#import "BusinessProfileCell.h"
#import "Mixpanel.h"
#import "BusinessContactViewController.h"
#import "BusinessHoursViewController.h"
#import "BusinessLogoUploadViewController.h"
#import "BusinessAddressViewController.h"
#import "SettingsViewController.h"
#import "BusinessDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSMutableArray *menuBusinessArray;
@interface BusinessProfileController ()

@end

@implementation BusinessProfileController
@synthesize primaryImageView,businessNameLabel,categoryLabel,businessDescText;
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
   
     self.navigationItem.title=@"Business Profile";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    businessNameLabel.text = appDelegate.businessName;
    businessDescText.text   = appDelegate.businessDescription;
    categoryLabel.text      = appDelegate.storeCategoryName;
    
    menuBusinessArray = [[NSMutableArray alloc]initWithObjects:@"Business Address",@"Contact Information",@"Business Hours",@"Business Logo",@"Social Sharing", nil];
    
    self.businessDescView.layer.borderWidth = 0.5f;
    self.businessDescView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.businessDescView.layer.masksToBounds = YES;
    
    self.businessProTable.layer.borderWidth = 0.5f;
    self.businessProTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.businessProTable.layer.masksToBounds = YES;
    
    
   
    
    if (![appDelegate.primaryImageUri isEqualToString:@""])
    {
        [primaryImageView setAlpha:1.0];
        
        NSString *imageUriSubString=[appDelegate.primaryImageUri  substringToIndex:5];
        
        if ([imageUriSubString isEqualToString:@"local"])
        {
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[appDelegate.primaryImageUri substringFromIndex:5]];
            
            [primaryImageView setImage:[UIImage imageWithContentsOfFile:imageStringUrl]];
        }
        
        else
        {
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,appDelegate.primaryImageUri];
            
            [primaryImageView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
        }
    }
    
    else
    {
        [primaryImageView   setImage:[UIImage imageNamed:@"defaultPrimaryimage.png"]];
        [primaryImageView setAlpha:0.6];
    }

    
    version = [[UIDevice currentDevice] systemVersion];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    //SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;
    
    customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,5, 30, 30)];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [customButton setHidden:YES];
    
    
    /*Design the NavigationBar here*/
    
    
    if (version.floatValue<7.0) {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
        [navBar addSubview:customButton];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(84, 13,164, 20)];
        
        headerLabel.text=@"Business Profile";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];
        
    }
    
    
    else
    {
        
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationItem.title=@"Business Profile";
        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        
        UIButton *rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(0,0,25,20)];
        
        [rightCustomButton setImage:[UIImage imageNamed:@"Share_Arrow.png"] forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightCustomButton];
        
        self.navigationItem.rightBarButtonItem = rightBtnItem;
        
    }
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];


}

-(void)share
{
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Message",@"Facebook",@"Twitter",@"Whatsapp", nil];
    selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    selectAction.tag=2;
    [selectAction showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        if(buttonIndex==0)
        {
            if(![MFMessageComposeViewController canSendText]) {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                return;
            }
            
            else
            {
                NSString *message =  [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
                MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
                messageController.messageComposeDelegate = self;
                [messageController setBody:message];
                
                // Present message view controller on screen
                [self presentViewController:messageController animated:YES completion:nil];
                
            }
            
            
        }
        
        
        if(buttonIndex == 1)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                NSString* shareText = [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
                
                [fbSheet setInitialText:shareText];
                
                [self presentViewController:fbSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't post a feed right now, make sure your device has an internet connection and you have at least one Facebook account setup."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }
    
        
        if (buttonIndex==2)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                NSString* shareText = [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
                [tweetSheet setInitialText:shareText];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }
        
        if(buttonIndex==3)
        {
            NSString * msg =  [NSString stringWithFormat:@"Take a look at my website.\n %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
            NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
            NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                [[UIApplication sharedApplication] openURL: whatsappURL];
            } else {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no whatsApp." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
        }
    
    
    
    
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identifier=@"businessProfile";
    BusinessProfileCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        NSLog(@"New Cell");
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"BusinessProfileCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
       
        
    }else{
        NSLog(@"Reuse Cell");
    }
    
    cell.menuImage.alpha = 0.70f;
    
    if(indexPath.row==0)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Address"];
    }
    if(indexPath.row==1)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Contact-Info"];
    }
    if(indexPath.row==2)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Biz-Hours"];
    }
    if(indexPath.row==3)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Logo"];
    }
    if(indexPath.row==4)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Social"];
    }

    
    cell.menuLabel.text = [menuBusinessArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue " size:15.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Business Address"];
        
        
        BusinessAddressViewController *businessAddress=[[BusinessAddressViewController alloc]initWithNibName:@"BusinessAddressViewController" bundle:Nil];
        [self setTitle:@"Profile"];
        [self.navigationController pushViewController:businessAddress animated:YES];
    }
    else if (indexPath.row==1)
    {
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Contact Information"];
        BusinessContactViewController *businessContact=[[BusinessContactViewController alloc]initWithNibName:@"BusinessContactViewController" bundle:Nil];
        
        [self setTitle:@"Profile"];
        
        [self.navigationController pushViewController:businessContact animated:YES];
    }
    else if (indexPath.row==2)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Business Hour"];
        BusinessHoursViewController *businessHour=[[BusinessHoursViewController alloc]initWithNibName:@"BusinessHoursViewController" bundle:Nil];
        [self setTitle:@"Profile"];
        [self.navigationController pushViewController:businessHour animated:YES];
        

    }
    else if (indexPath.row==3)
    {
        BusinessLogoUploadViewController *businessLogo=[[BusinessLogoUploadViewController alloc]initWithNibName:@"BusinessLogoUploadViewController" bundle:Nil];
        [self setTitle:@"Profile"];
        [self.navigationController pushViewController:businessLogo animated:YES];
    }
    else if (indexPath.row==4)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Social Options button clicked"];
        SettingsViewController *socialSharing=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:Nil];
        [self setTitle:@"Profile"];
        [self.navigationController pushViewController:socialSharing animated:YES];
        
    }
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateDescription:(id)sender {
    
    
   
    
    UIImage * btnImage1 = [UIImage imageNamed:@"Edit_On-Click.png"];
    
    [self.editButton setImage:btnImage1 forState:UIControlStateNormal];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Business Details"];
    
    
    
    
//    BusinessDetailsViewController *businessDet=[[BusinessDetailsViewController alloc]initWithNibName:@"BusinessDetailsViewController" bundle:Nil];
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//   [self.navigationController pushViewController:businessDet animated:YES];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
   
    
    BusinessDetailsViewController *businessDet=[[BusinessDetailsViewController alloc]initWithNibName:@"BusinessDetailsViewController" bundle:Nil];
    
    [self presentViewController:businessDet animated:YES completion:nil];
    
   // [[businessDet.view layer] addAnimation:animation forKey:@"SwitchToView1"];
    
    
}
@end
