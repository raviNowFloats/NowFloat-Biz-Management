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
#import "PopUpView.h"
#import "NFInstaPurchase.h"
#import "AlertViewController.h"

#define BusinessTimingsTag 1006
NSIndexPath *tableIndexpath;
NSMutableArray *menuBusinessArray;
BOOL isDesc;
BOOL isTimingEnabled;
@interface BusinessProfileController ()
{
    NFInstaPurchase *popUpView;
    
}
@end

@implementation BusinessProfileController
@synthesize primaryImageView,businessNameLabel,categoryLabel,businessDescText,editImage;
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
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    
    if(isDesc)
    {
        BusinessProfileCell *cell = (BusinessProfileCell*)[self.businessProTable cellForRowAtIndexPath:tableIndexpath];
        
        cell.menuLabel.alpha = 1.0f;
        cell.menuImage.alpha = 1.0f;
    }
    
    
    NSMutableArray *timings = [[NSMutableArray alloc]init];
    
    timings = [appDelegate.storeDetailDictionary objectForKey:@"FPWebWidgets"];
    
    for(int i= 0; i<[timings count];i++)
    {
        if([[timings objectAtIndex:i]isEqualToString:@"TIMINGS"])
        {
            isTimingEnabled = YES;
        }
    }
    
    UIImage * btnImage1 = [UIImage imageNamed:@"Edit_Normal.png"];
    
    editImage.image = btnImage1;
    isTimingEnabled = NO;
    
    businessNameLabel.text  = [appDelegate.businessName  capitalizedString];
    businessDescText.text   = appDelegate.businessDescription;
    categoryLabel.text      = [[appDelegate.storeDetailDictionary objectForKey:@"Categories" ]capitalizedString];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    businessNameLabel.text  = [[appDelegate.storeDetailDictionary  objectForKey:@"Name"] capitalizedString];
    businessDescText.text   = appDelegate.businessDescription;
    categoryLabel.text      = [appDelegate.storeCategoryName capitalizedString];
    
    menuBusinessArray = [[NSMutableArray alloc]initWithObjects:@"Business Address",@"Contact Information",@"Business Hours",@"Business Logo",@"Social Sharing", nil];
    
    
    tableIndexpath = [[NSIndexPath alloc]init];
    
    self.businessProTable.bounces= NO;
    
    
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            if(version.floatValue >=7.0)
            {
                self.businessDescView.frame = CGRectMake(-5, 11, self.businessDescView.frame.size.width, self.businessDescView.frame.size.height+100);
                
                self.businessProTable.frame = CGRectMake(0, 190, self.businessProTable.frame.size.width, self.businessProTable.frame.size.height+100);
                
                self.businessDescText.frame = CGRectMake(15, self.businessDescText.frame.origin.y+7, self.businessDescText.frame.size.width, self.businessDescText.frame.size.height);
                primaryImageView.frame = CGRectMake(self.primaryImageView.frame.origin.x, self.primaryImageView.frame.origin.y+10, 86, 170);
                
            }
            else
            {
                
                self.businessDescView.frame = CGRectMake(-5, 60, self.businessDescView.frame.size.width, self.businessDescView.frame.size.height+50);
                
                self.businessProTable.frame = CGRectMake(0, 240, self.businessProTable.frame.size.width, self.businessProTable.frame.size.height+100);
                
                self.businessDescText.frame = CGRectMake(15, self.businessDescText.frame.origin.y+5, self.businessDescText.frame.size.width, self.businessDescText.frame.size.height);
                primaryImageView.frame = CGRectMake(self.primaryImageView.frame.origin.x, self.primaryImageView.frame.origin.y+7, 86, 130);
            }
            
        }
        else
        {
            self.businessDescView.frame = CGRectMake(-5, 15, self.businessDescView.frame.size.width, self.businessDescView.frame.size.height+20);
            
            self.businessProTable.frame = CGRectMake(0, 205, self.businessProTable.frame.size.width, self.businessProTable.frame.size.height);
            
            self.businessDescText.frame = CGRectMake(15, self.businessDescText.frame.origin.y+10, self.businessDescText.frame.size.width, self.businessDescText.frame.size.height);
            primaryImageView.frame = CGRectMake(self.primaryImageView.frame.origin.x, self.primaryImageView.frame.origin.y+7, 86, 86);
        }
    }
    
    primaryImageView.layer.cornerRadius = 5.0f;
    primaryImageView.layer.masksToBounds = YES;
    
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"dedede"]];
    
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
        
        [leftCustomButton setFrame:CGRectMake(25,0,35,15)];
        [leftCustomButton setImage:[UIImage imageNamed:@"Menu-Burger.png"] forState:UIControlStateNormal];
        
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
        
        [leftCustomButton setFrame:CGRectMake(25,0,35,15)];
        [leftCustomButton setImage:[UIImage imageNamed:@"Menu-Burger.png"] forState:UIControlStateNormal];
        
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
            
            
            [AlertViewController CurrentView:self.view errorString:@"Your device doesn't support SMS!" size:0 success:NO];
            
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
           
            
             [AlertViewController CurrentView:self.view errorString:@"You can't post a feed right now, make sure your device has an internet connection and you have at least one Facebook account setup." size:0 success:NO];
            
            
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
        
            
            [AlertViewController CurrentView:self.view errorString:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup." size:0 success:NO];
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
            
            [AlertViewController CurrentView:self.view errorString:@"Your device has no whatsApp." size:0 success:NO];
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
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"BusinessProfileCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        
    }else{
    }
    
    cell.menuImage.alpha = 0.70f;
    
    if(indexPath.row==0)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Address"];
        cell.lockImage.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row==1)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Contact-Info"];
        cell.lockImage.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if(indexPath.row==2)
    {
        
        if ([appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.lockImage.hidden = YES;
            cell.menuImage.image = [UIImage imageNamed:@"Biz-Hours"];
            
            
        }
        else
        {
            cell.menuImage.image = [UIImage imageNamed:@"Biz-Hours"];
            cell.lockImage.hidden = NO;
            cell.menuLabel.alpha = 0.4f;
            cell.menuImage.alpha = 0.4f;
            cell.lockImage.alpha = 0.4f;
        }
        
    }
    if(indexPath.row==3)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Logo"];
        cell.lockImage.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if(indexPath.row==4)
    {
        cell.menuImage.image = [UIImage imageNamed:@"Social"];
        cell.lockImage.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    cell.menuLabel.text = [menuBusinessArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue " size:15.0f];
    
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isDesc = YES;
    BusinessProfileCell *cell = (BusinessProfileCell*)[self.businessProTable cellForRowAtIndexPath:indexPath];
    
    cell.menuLabel.alpha = 0.4f;
    cell.menuImage.alpha = 0.4f;
    
    tableIndexpath = indexPath;
    
    if(indexPath.row==0)
    {
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Business Address"];
        
        
        BusinessAddressViewController *businessAddress=[[BusinessAddressViewController alloc]initWithNibName:@"BusinessAddressViewController" bundle:Nil];
        
        [self.navigationController pushViewController:businessAddress animated:YES];
    }
    else if (indexPath.row==1)
    {
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Contact Information"];
        BusinessContactViewController *businessContact=[[BusinessContactViewController alloc]initWithNibName:@"BusinessContactViewController" bundle:Nil];
        
        [self.navigationController pushViewController:businessContact animated:YES];
    }
    else if (indexPath.row==2)
    {
        
        if ([appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        {
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Business Hour"];
            BusinessHoursViewController *businessHour=[[BusinessHoursViewController alloc]initWithNibName:@"BusinessHoursViewController" bundle:Nil];
            
            [self.navigationController pushViewController:businessHour animated:YES];
        }
        else
        {
            popUpView=[[NFInstaPurchase alloc]init];
            
            popUpView.delegate=self;
            
            popUpView.selectedWidget=BusinessTimingsTag;
            
            [popUpView showInstantBuyPopUpView];
        }
        
        
        
    }
    else if (indexPath.row==3)
    {
        BusinessLogoUploadViewController *businessLogo=[[BusinessLogoUploadViewController alloc]initWithNibName:@"BusinessLogoUploadViewController" bundle:Nil];
        
        [self.navigationController pushViewController:businessLogo animated:YES];
    }
    else if (indexPath.row==4)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Social Options button clicked"];
        SettingsViewController *socialSharing=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:Nil];
        
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
    
    editImage.image = btnImage1;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Business Details"];
    
    
    BusinessDetailsViewController *businessDet=[[BusinessDetailsViewController alloc]initWithNibName:@"BusinessDetailsViewController" bundle:Nil];
    [self presentViewController:businessDet animated:YES completion:nil];
    
    
}

-(void)instaPurchaseViewDidClose
{
    [popUpView removeFromSuperview];
    [self.businessProTable reloadData];
}
@end
