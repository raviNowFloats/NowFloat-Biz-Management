//
//  BizMessageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BizMessageViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UITableView+ZGParallelView.h"
#import "UIColor+HexaString.h"
#import "MessageDetailsViewController.h"
#import "NSString+CamelCase.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "KGModal.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "Mixpanel.h"
#import "BizMessage.h"
#import "SearchQueryController.h"
#import "BizWebViewController.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "WBStickyNoticeView.h"
#import "NSOperationQueue+WBNoticeExtensions.h"
#import "RightViewController.h"
#import "FileManagerHelper.h"
#import "StoreViewController.h"
#import "PopUpView.h"
#import "PrimaryImageViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Social/Social.h>

#define TIME_FOR_SHRINKING 0.61f
#define TIME_FOR_EXPANDING 0.60f
#define SCALED_DOWN_AMOUNT 0.01


@interface BizMessageViewController ()<MessageDetailsDelegate,BizMessageControllerDelegate,SearchQueryProtocol,RightViewControllerDelegate,PopUpDelegate,MFMailComposeViewControllerDelegate>
{
    float viewWidth;
    float viewHeight;
}

@end

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f



@implementation BizMessageViewController

@synthesize parallax,messageTableView,storeDetailDictionary,dealDescriptionArray,dealDateArray,dealImageArray;

@synthesize dealDateString,dealDescriptionString,dealIdString;

@synthesize isLoadedFirstTime;



typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
       
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated
{
    if (navBackgroundview.isHidden)
    {
        [navBackgroundview setHidden:NO];
    }
    
    //Set Primary Image here
    [self setStoreImage];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    if ([version intValue] >= 7)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [notificationView setFrame:CGRectMake(0, 0,notificationView.frame.size.width, notificationView.frame.size.height)];
    }
    
    
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
    
    /*FP messages initialization*/
    
    dealDescriptionArray=[[NSMutableArray alloc]init];
    dealDateArray=[[NSMutableArray   alloc]init];
    dealId=[[NSMutableArray alloc]init];
    dealImageArray=[[NSMutableArray alloc]init];
    arrayToSkipMessage=[[NSMutableArray alloc]init];
    
    dealIdString=[[NSMutableString alloc]init];
    dealDescriptionString=[[NSMutableString alloc]init];
    dealDateString=[[NSMutableString alloc]init];
    
    frontViewPosition=[[NSString alloc]init];
    
    /*Create an AppDelegate object*/
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [timeLineLabel setBackgroundColor:[UIColor colorWithHexString:@"ffb900"]];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;

    /*Create a custom Navigation Bar here*/
    
    
    if ([version floatValue]<7)
    {

        [messageTableView setFrame:CGRectMake(0, 44, messageTableView.frame.size.width, messageTableView.frame.size.height)];

        self.navigationController.navigationBarHidden=YES;

        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        UIImage *navBackgroundImage = [UIImage imageNamed:@"header-logo.png"];
        
        UIImageView *navBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(35,10,256,20)];
        
        navBgImageView.image=navBackgroundImage;
        
        navBgImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        [navBar addSubview:navBgImageView];
        
        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(0,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];

        
        
        UIButton *rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(270,0,50,44)];
        
        [rightCustomButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:rightCustomButton];

        [parallax setFrame:CGRectMake(0,0,320,230)];

    }
    
    else
    {
        [parallax setFrame:CGRectMake(0,0, 320, 230)];

        self.navigationController.navigationBarHidden=NO;

        UIImage *navBackgroundImage = [UIImage imageNamed:@"header-logo.png"];
        navBackgroundview = [[UIView alloc]initWithFrame:CGRectMake(50, 0,230, 44)];
        UIImageView *navBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(-10,10,256,20)];
        [navBackgroundview setBackgroundColor:[UIColor clearColor]];
        navBgImageView.image=navBackgroundImage;
        navBgImageView.contentMode=UIViewContentModeScaleAspectFit;
        [navBackgroundview addSubview:navBgImageView];
        [self.navigationController.navigationBar addSubview:navBackgroundview];

        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(0,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        
        
        UIButton *rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(0,0,44,44)];
        
        [rightCustomButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightCustomButton];
        
        self.navigationItem.rightBarButtonItem = rightBtnItem;

    }
    
    

    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=100.0;
    revealController.rightViewRevealOverdraw=0.0;
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    notificationBadgeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(35,3,23,23)];
    
    [notificationBadgeImageView setBackgroundColor:[UIColor clearColor]];
    
    [notificationBadgeImageView setImage:[UIImage imageNamed:@"badge.png"]];
    
    [notificationBadgeImageView setHidden:YES];
    
    notificationLabel=[[UILabel alloc]initWithFrame:CGRectMake(36,4, 20, 20)];
    
    [notificationLabel setTextAlignment:NSTextAlignmentCenter];
    
    [notificationLabel setBackgroundColor:[UIColor clearColor]];
    
    [notificationLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    
    [notificationLabel setTextColor:[UIColor whiteColor]];
    
    [notificationLabel setText:@"10"];
    
    if (version.floatValue<7.0) {

        [navBar addSubview:notificationBadgeImageView];

        [navBar addSubview:notificationLabel];

    }

    else
    {
        [self.navigationController.navigationBar addSubview:notificationBadgeImageView];
        [self.navigationController.navigationBar addSubview:notificationLabel];
    }
    
    [notificationView setBackgroundColor:[UIColor clearColor]];
    
    [notificationLabel setHidden:YES];
    
    [notificationView setHidden:YES];
    
    /*Post Message Controller*/
    
    postMessageController=[[PostMessageViewController alloc]initWithNibName:@"PostMessageViewController" bundle:nil];
    
    /*PostImageViewController*/
    
    postImageViewController=[[PostImageViewController alloc]initWithNibName:@"PostImageViewController" bundle:nil];
    

    [self.messageTableView addParallelViewWithUIView:self.parallax withDisplayRadio:0.7 cutOffAtMax:YES];
    
    [self.messageTableView setScrollsToTop:YES];
    
    fpMessageDictionary=[[NSMutableDictionary alloc]initWithDictionary:appDelegate.fpDetailDictionary];

    ismoreFloatsAvailable=[[fpMessageDictionary objectForKey:@"moreFloatsAvailable"] boolValue];
    
    /*set the array*/
    [self setUpArray];
    
    [messageTableView addInfiniteScrollingWithActionHandler:^
    {
        [self insertRowAtBottom];
        
    }];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView) name:@"updateMessages" object:nil];
    
    
    /*Set the downloadingSubview hidden*/
    
    [downloadingSubview setHidden:YES];
    
    
    /*Set the store tag*/
        
    
    [storeTagLabel setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    
    [storeTitleLabel setTextColor:[UIColor colorWithHexString:@"323232"]];
    
    [storeTitleLabel setText:[[[NSString stringWithFormat:@"%@",appDelegate.businessName] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords]];
    
    
    if (storeTitleLabel.text.length>21)
    {
        
        storeTagLabel.frame=CGRectMake(0,120, 320, 55);
        
        storeTitleLabel.frame=CGRectMake(135,120, 177, 55);
        
        storeTagButton.frame=CGRectMake(135,120, 177, 55);
        
    }
    
    [self.messageTableView setSeparatorColor:[UIColor colorWithHexString:@"ffb900"]];

    /*Search Query*/

    SearchQueryController *queryController=[[SearchQueryController alloc]init];
    queryController.delegate=self;
    [queryController getSearchQueriesWithOffset:0];
    
    
    /*Display Badge if there is searchQuery*/
    

    if (appDelegate.searchQueryArray.count>0)
    {        
        [notificationLabel setText:[NSString stringWithFormat:@"%d",appDelegate.searchQueryArray.count]];
        [notificationBadgeImageView setHidden:NO];
        [notificationLabel setHidden:NO];
        [notificationView setHidden:NO];
    }


    
    //Set parallax image here
    [self setparallaxImage];

    
    FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
    
    fHelper.userFpTag=appDelegate.storeTag;
    
    NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
    
    [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];
    
    
    //First Login
    
    if ([fHelper openUserSettings] != NULL)
    {
        if ([userSetting objectForKey:@"1st Login"]!=nil)
        {
            [self isTutorialView:[[userSetting objectForKey:@"1st Login"] boolValue]];
        }
        
        else
        {
            [self isTutorialView:NO];
        }
    }
    
    
    //If the user has no message's.Firstly we need to check if it is not his
    //first login and provide him an overlay suggesting him to update his website.
    
    if ([fHelper openUserSettings] != NULL && appDelegate.dealDescriptionArray.count==0)
    {
        if ([userSetting objectForKey:@"1st Login"]!=nil)
        {
            if ([[userSetting objectForKey:@"1st Login"] boolValue] == YES)
            {
                if(viewHeight == 480)
                {
                    [[[[UIApplication sharedApplication] delegate] window] addSubview:updateMsgOverlay];
                }
                
                else
                {
                    [[[[UIApplication sharedApplication] delegate] window]addSubview:updateMsgOverlay];
                }
            }
        }
    }
    
    
    //Second Login is only available
    //If business messages are updated regularly
    
    if ([fHelper openUserSettings] != NULL)
    {
        if ([userSetting objectForKey:@"1st Login"]!=nil)
        {
            if ([[userSetting objectForKey:@"1st Login"] boolValue] )
            {
                if ([[userSetting allKeys] containsObject:@"1stLoginCloseDate"] && appDelegate.dealDescriptionArray.count>0 )
                {
                     NSDate *appStartDate=[userSetting objectForKey:@"appStartDate"];
                    
                     NSDate *appCloseDate=[userSetting  objectForKey:@"1stLoginCloseDate"];
                    
                     NSInteger *dayDifference=[self daysBetweenDate:appCloseDate andDate:appStartDate];
                    
                     if ([NSNumber numberWithInteger:dayDifference].intValue>[NSNumber numberWithInt:0].intValue)
                     {
                        if ([userSetting objectForKey:@"2nd Login"]!=nil)
                        {
                            if ([userSetting objectForKey:@"2nd Login"])
                            {
                                [self is2ndLoginView:YES];
                            }
                            else
                            {
                                [self is2ndLoginView:NO];
                            }
                        }
                        else
                        {
                            [self is2ndLoginView:NO];
                        }
                     }
                 }
             }
         }
    }
    
    
    //Third Login is only available
    //If business messages are updated regularly
    /*
    if ([fHelper openUserSettings] != NULL)
    {
        if ([userSetting objectForKey:@"2nd Login"]!=nil)
        {
            if ([[userSetting objectForKey:@"2nd Login"] boolValue])
            {
                if ([[userSetting allKeys] containsObject:@"SecondLoginTimeStamp"])
                {
                     NSDate *appStartDate=[userSetting objectForKey:@"appStartDate"];
                    
                     NSDate *appCloseDate=[userSetting  objectForKey:@"SecondLoginTimeStamp"];

                     NSInteger *dayDifference=[self daysBetweenDate:appCloseDate andDate:appStartDate];
                     
                     if ([NSNumber numberWithInteger:dayDifference].intValue>[NSNumber numberWithInt:1].intValue)
                    {
                        if ([userSetting objectForKey:@"3rd Login"]!=nil)
                        {
                            if ([userSetting objectForKey:@"3rd Login"])
                            {
                                [self is3rdLoginView:YES];
                            }
                            else
                            {
                                [self is3rdLoginView:NO];
                            }
                        }
                        else
                        {
                            [self is3rdLoginView:NO];
                        }
                    }
                }
            }
        }
    }
     */
    
}


-(void)isTutorialView:(BOOL)available
{

    if (!available)
    {
        if(viewHeight == 480)
        {
            [[[[UIApplication sharedApplication] delegate] window] addSubview:tutorialOverlayiPhone4View];
        }
        
        else
        {
            [[[[UIApplication sharedApplication] delegate] window]addSubview:tutorialOverlayView];
        }
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];

        fHelper.userFpTag=appDelegate.storeTag;

        [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"1st Login"];
        
        NSDate *secondLoginTime = [NSDate date];
        
        [fHelper updateUserSettingWithValue:secondLoginTime forKey:@"1stLoginCloseDate"];
    }

}


-(void)is2ndLoginView:(BOOL)available
{
    if (!available)
    {
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Tell the world!";
        customPopUp.descriptionText=@"Your website is turning out well.Why don't you tell your friends about it? Share it on facebook and twitter";
        customPopUp.popUpImage=[UIImage imageNamed:@"sharewebsite.png"];
        customPopUp.successBtnText=@"Share Now";
        customPopUp.cancelBtnText=@"Later";
        customPopUp.tag=1001;
        [customPopUp showPopUpView];
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag=appDelegate.storeTag;
        
        [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"2nd Login"];
        
        NSDate *secondLoginTime = [NSDate date];
        
        [fHelper updateUserSettingWithValue:secondLoginTime forKey:@"SecondLoginTimeStamp"];
    }
}


-(void)is3rdLoginView:(BOOL)isAvailable
{
    if (!isAvailable)
    {
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Tell the world!";
        customPopUp.descriptionText=@"Your website is turning out well.Why don't you tell your friends about it? Share it on facebook and twitter";
        customPopUp.popUpImage=[UIImage imageNamed:@"sharewebsite.png"];
        customPopUp.successBtnText=@"Share Now";
        customPopUp.cancelBtnText=@"Later";
        customPopUp.tag=1002;
        [customPopUp showPopUpView];
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag=appDelegate.storeTag;

        [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"3rd Login"];
    }
}


-(void)setparallaxImage
{

    if ([appDelegate.storeCategoryName isEqualToString:@"GENERAL"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"general.jpg"]];
        
    }
    
    if ([appDelegate.storeCategoryName isEqualToString:@"FLOATINGPOINT"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"abstract.jpg"]];
        
    }
    
    if ([appDelegate.storeCategoryName isEqualToString:@"FASHION"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"fashion.jpg"]];
    }
    
    
    if ([appDelegate.storeCategoryName isEqualToString:@"HEALTH"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"health.jpg"]];
    
    }
    
    if ([appDelegate.storeCategoryName isEqualToString:@"AYURVEDA"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"ayurveda.jpg"]];
        
    }
    
    if ([appDelegate.storeCategoryName isEqualToString:@"REALESTATE"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"realestate.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"KIDS"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"kids.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"BEAUTY"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"spa.jpg"]];
        
    }


    if ([appDelegate.storeCategoryName isEqualToString:@"RESTURANT"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"Restaurant.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"RETAIL"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"retails.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"JEWELRY"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"jewellry.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"LEATHER"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"leather.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"CAFE"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"cafe.jpg"]];
        
    }


    if ([appDelegate.storeCategoryName isEqualToString:@"GYM"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"gym.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"CHEMICAL"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"chemical.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"EDUCATION"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"education.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"HOMEAPPLIANCES"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"homeappliances.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"OILGAS"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"oil&gas.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"TRAVEL"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"travel.jpg"]];
        
    }


    if ([appDelegate.storeCategoryName isEqualToString:@"ICEPARLOR"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"icecream.jpg"]];
        
    }


    if ([appDelegate.storeCategoryName isEqualToString:@"NOKIA"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"nokia.jpg"]];
        
    }



    if ([appDelegate.storeCategoryName isEqualToString:@"PRINTO"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"printo.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"HEALTHIFYME"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"healthifyme.jpg"]];
        
    }


    if ([appDelegate.storeCategoryName isEqualToString:@"WATSOL"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"watsol.jpg"]];
        
    }


    if ([appDelegate.storeCategoryName isEqualToString:@"SONUCABS"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"sonucabs.jpg"]];
        
    }

    if ([appDelegate.storeCategoryName isEqualToString:@"TINIPHARMA"])
    {
        [parallelaxImageView setImage:[UIImage imageNamed:@"tinipharma.jpg"]];
        
    }

    
}


-(void)setStoreImage
{
    
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
    
    CALayer* containerLayer = [CALayer layer];
    primaryImageView.layer.cornerRadius = roundf(primaryImageView.frame.size.width/2.0);
    primaryImageView.layer.masksToBounds = YES;
    containerLayer.borderWidth=2.0;
    containerLayer.borderColor=[UIColor whiteColor].CGColor;
    [containerLayer addSublayer:primaryImageView.layer];
    [parallax.layer addSublayer:containerLayer];
    
    
    [primaryImageView setContentMode:UIViewContentModeScaleAspectFit];
}


-(void)setUpArray
{
    [self clearObjectInArray];
        
    if ([appDelegate.deletedFloatsArray count])
    {
        for (int i=0; i<[appDelegate.deletedFloatsArray count]; i++)
        {
            for (int j=0; j<[appDelegate.dealId count]; j++)
            {
                if ([[appDelegate.dealId objectAtIndex:j] isEqual:[appDelegate.deletedFloatsArray objectAtIndex:i]])
                {
                    [appDelegate.dealId removeObjectAtIndex:j];
                    [appDelegate.dealDescriptionArray removeObjectAtIndex:j];
                    [appDelegate.dealDateArray removeObjectAtIndex:j];
                    [appDelegate.dealImageArray removeObjectAtIndex:j];
                    [appDelegate.arrayToSkipMessage removeObjectAtIndex:j];
                }
            }
        }
        
        [dealDescriptionArray addObjectsFromArray:appDelegate.dealDescriptionArray];
        [dealDateArray addObjectsFromArray:appDelegate.dealDateArray];
        [dealId addObjectsFromArray:appDelegate.dealId];
        [dealImageArray addObjectsFromArray:appDelegate.dealImageArray];
        [arrayToSkipMessage addObjectsFromArray:appDelegate.arrayToSkipMessage];
        
    }
    
    
    else
    {
        [dealDescriptionArray addObjectsFromArray:appDelegate.dealDescriptionArray];
        [dealDateArray addObjectsFromArray:appDelegate.dealDateArray];
        [dealId addObjectsFromArray:appDelegate.dealId];
        [dealImageArray addObjectsFromArray:appDelegate.dealImageArray];
        [arrayToSkipMessage addObjectsFromArray:appDelegate.arrayToSkipMessage];
    }
    
    /*Set the initial skip by value here*/
    messageSkipCount=[arrayToSkipMessage count];
}


-(void)clearObjectInArray
{

    [dealDescriptionArray removeAllObjects];
    
    [dealDateArray removeAllObjects];
    
    [dealId removeAllObjects];
    
    [dealImageArray removeAllObjects];
    
    [arrayToSkipMessage removeAllObjects];

}


- (void)updateView
{
    [downloadingSubview setHidden:YES];
    [messageTableView reloadData];
}


-(void)pushPostMessageController
{
  [self.navigationController pushViewController:postMessageController animated:YES];
}


-(void)pushPostImageViewController
{
    
    [self.navigationController pushViewController:postImageViewController animated:YES];
    
}


#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [self pushPostMessageController];
        }
        
        
        if (buttonIndex==2)
        {
            [self pushPostImageViewController];
        }
    }
}


#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [dealDescriptionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static  NSString *identifier = @"TableViewCell";
    UILabel *label = nil;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell setBackgroundColor:[UIColor clearColor]];

        
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewArrow setTag:6];
        [imageViewArrow   setBackgroundColor:[UIColor clearColor] ];
        [cell addSubview:imageViewArrow];
        
        UIImageView *dealImage=[[UIImageView alloc]initWithFrame:CGRectZero];
        [dealImage setTag:7];
        [cell addSubview:dealImage];
                
        UILabel *dealDateLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [dealDateLabel setBackgroundColor:[UIColor whiteColor]];
        [dealDateLabel setTag:4];
        [cell addSubview:dealDateLabel];
        
        UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewBg setTag:2];
        [imageViewBg   setBackgroundColor:[UIColor clearColor] ];
        [[cell contentView] addSubview:imageViewBg];
        
        UIImageView *topRoundedCorner=[[UIImageView alloc]initWithFrame:CGRectZero];
        [topRoundedCorner setTag:8];
        [topRoundedCorner setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] addSubview:topRoundedCorner];
        
        
        UIImageView *bottomRoundedCorner=[[UIImageView alloc]initWithFrame:CGRectZero];
        [bottomRoundedCorner    setTag:9];
        [bottomRoundedCorner setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] addSubview:bottomRoundedCorner];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE]];
        [label setTag:1];
        [[cell contentView] addSubview:label];
        
        
        UIImageView *dealImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [dealImageView setTag:3];
        [dealImageView setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:dealImageView];
        
    }
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    UIImageView *topImage=(UIImageView *)[cell viewWithTag:8];
    UIImageView *bottomImage=(UIImageView *)[cell viewWithTag:9];
    UIImageView *bgImage=(UIImageView *)[cell viewWithTag:2];
    UILabel *dateLabel=(UILabel *)[cell viewWithTag:4];
    UIImageView *dealImageView=(UIImageView *)[cell viewWithTag:7];
    UIImageView *bgArrowView=(UIImageView *)[cell viewWithTag:6];
    
    
    NSString *dateString=[dealDateArray objectAtIndex:[indexPath row] ];
    NSDate *date;
    
    
    if ([dateString hasPrefix:@"/Date("])
    {
        dateString=[dateString substringFromIndex:5];
        dateString=[dateString substringToIndex:[dateString length]-1];
        date=[self getDateFromJSON:dateString];
        
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    
    NSString *dealDate=[dateFormatter stringFromDate:date];
    
    NSString *text = [dealDescriptionArray objectAtIndex:[indexPath row]];
    
    NSString *stringData;
    
    if ([[dealImageArray objectAtIndex:[indexPath row]] isEqualToString:@"/Deals/Tile/deal.png"])
    {
        stringData=[NSString stringWithFormat:@"%@\n\n%@\n",text,dealDate];
    }
    
    
    else if ( [[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/BizImages/Tile/.jpg" ])
    {
        stringData=[NSString stringWithFormat:@"%@\n\n%@\n",text,dealDate];
    }
    
    else
    {
        
        version = [[UIDevice currentDevice] systemVersion];
        
        if ([version floatValue]<7.0)
        {
            stringData=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",text,dealDate];
        }

        
        else
        {
            stringData=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",text,dealDate];
        }
        
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]  constrainedToSize:constraint lineBreakMode:nil];
    
    UIImageView *storeDealImageView=(UIImageView *)[cell viewWithTag:3];
        
    NSString *_imageUriString=[dealImageArray  objectAtIndex:[indexPath row]];
    
    NSString *imageUriSubString=[_imageUriString  substringToIndex:5];
    
    if ([[dealImageArray objectAtIndex:[indexPath row]] isEqualToString:@"/Deals/Tile/deal.png"] )
    {
        [storeDealImageView setFrame:CGRectMake(50,24,254,0)];
        [storeDealImageView setBackgroundColor:[UIColor redColor]];
    }
    
    
    else if ( [[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
        
        [storeDealImageView setFrame:CGRectMake(50,24,254,0)];
        [storeDealImageView setBackgroundColor:[UIColor redColor]];
    }
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
        
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[[dealImageArray objectAtIndex:[indexPath row]] substringFromIndex:5]];
        [storeDealImageView setFrame:CGRectMake(50,28,254,250)];
        [storeDealImageView setBackgroundColor:[UIColor clearColor]];
        storeDealImageView.image=[UIImage imageWithContentsOfFile:imageStringUrl];
        storeDealImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    
    else
    {
        NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[dealImageArray objectAtIndex:[indexPath row]]];
        [storeDealImageView setFrame:CGRectMake(50,28,254,250)];
        [storeDealImageView setBackgroundColor:[UIColor clearColor]];
        [storeDealImageView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
                storeDealImageView.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    
    [label setText:stringData];
    [label setFrame:CGRectMake(52,CELL_CONTENT_MARGIN+2,254, MAX(size.height, 44.0f)+5)];
    label.textColor=[UIColor colorWithHexString:@"3c3c3c"];
    [label setBackgroundColor:[UIColor clearColor]];
    
    [dateLabel setText:dealDate];
    [dateLabel setBackgroundColor:[UIColor whiteColor]];
    [dateLabel setFrame:CGRectMake(52,label.frame.size.height,230,30)];
    dateLabel.textColor=[UIColor colorWithHexString:@"afafaf"];
    [dateLabel setTextAlignment:NSTextAlignmentLeft];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
    [dateLabel setAlpha:1];
    
    [topImage setFrame:CGRectMake(42,CELL_CONTENT_MARGIN-5, 269,5)];
    [topImage setImage:[UIImage imageNamed:@"top_cell.png"]];
    
    [bottomImage setFrame:CGRectMake(42, MAX(size.height, 44.0f)+30, 269, 5)];
    [bottomImage setImage:[UIImage imageNamed:@"bottom_cell.png"]];
    
    [bgImage setFrame:CGRectMake(42,CELL_CONTENT_MARGIN,269, MAX(size.height+5, 44.0f))];
    [bgImage setImage:[UIImage imageNamed:@"middle_cell.png"]];
    
    
    if ([[dealImageArray objectAtIndex:[indexPath row]] isEqualToString:@"/Deals/Tile/deal.png"] )
    {
        [dealImageView setImage:[UIImage imageNamed:@"qoutes.png"]];
        [dealImageView setFrame:CGRectMake(5,40,25,25)];
    }
    
    
    else if ( [[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
        [dealImageView setImage:[UIImage imageNamed:@"qoutes.png"]];
        [dealImageView setFrame:CGRectMake(5,40,25,25)];
    }
    
    
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
        [dealImageView setImage:[UIImage imageNamed:@"imagemsg.png"]];
        [dealImageView setFrame:CGRectMake(5,40,25,25)];
    }
    
    else
    {
        [dealImageView setImage:[UIImage imageNamed:@"imagemsg.png"]];
        [dealImageView setFrame:CGRectMake(5,40,25,25)];
    }
        
    bgArrowView.image=[UIImage imageNamed:@"triangle.png"];
    [bgArrowView setFrame:CGRectMake(30,50,12,12)];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}


#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Message details"];
    
    MessageDetailsViewController *messageDetailsController=[[MessageDetailsViewController alloc]initWithNibName:@"MessageDetailsViewController" bundle:nil];
    
    messageDetailsController.delegate=self;
    
    NSString *dateString=[dealDateArray objectAtIndex:[indexPath row]];
    
    NSDate *date;
    
    if ([dateString hasPrefix:@"/Date("])
    {
        dateString=[dateString substringFromIndex:5];
        
        dateString=[dateString substringToIndex:[dateString length]-1];
        
        date=[self getDateFromJSON:dateString];
        
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
    
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    
    messageDetailsController.messageDate=[dateFormatter stringFromDate:date];
    
    messageDetailsController.messageDescription=[dealDescriptionArray objectAtIndex:[indexPath row]];
    
    messageDetailsController.messageId=[dealId objectAtIndex:[indexPath row]];
    
    messageDetailsController.dealImageUri=[dealImageArray objectAtIndex:[indexPath row]];
    
    messageDetailsController.currentRow=[NSNumber numberWithInt:[indexPath row]];
    
    messageDetailsController.rawMessageDate=date;
    
    [self.navigationController pushViewController:messageDetailsController animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString *dateString=[dealDateArray objectAtIndex:[indexPath row] ];
    NSDate *date;
    
    if ([dateString hasPrefix:@"/Date("])
    {
        dateString=[dateString substringFromIndex:5];
        dateString=[dateString substringToIndex:[dateString length]-1];
        date=[self getDateFromJSON:dateString];
        
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    
    NSString *dealDate=[dateFormatter stringFromDate:date];
    
    /**
     Create a substring and check for the first 5 Chars to Local for a newly uploaded
     image to set the height for the particular cell
     **/
    NSString *_imageUriString=[dealImageArray  objectAtIndex:[indexPath row]];
    
    NSString *imageUriSubString=[_imageUriString  substringToIndex:5];
    
    
    if ([[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/Deals/Tile/deal.png" ] )
    {
        NSString *stringData=[NSString stringWithFormat:@"%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    
    else if ( [[dealImageArray objectAtIndex:[indexPath row]]isEqualToString:@"/BizImages/Tile/.jpg" ])
        
    {
        NSString *stringData=[NSString stringWithFormat:@"%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    
    
    else if ([imageUriSubString isEqualToString:@"local"])
    {
        
        NSString *stringData=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
        
    }
    
    
    else
    {
        NSString *stringData=[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",[dealDescriptionArray objectAtIndex:[indexPath row]],dealDate];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    
}


-(void)removeObjectFromTableView:(id)row
{
    [dealDescriptionArray removeObjectAtIndex:[row integerValue]];
    [dealDateArray removeObjectAtIndex:[row integerValue]];
    [dealId removeObjectAtIndex:[row integerValue]];
    [dealImageArray removeObjectAtIndex:[row integerValue]];
    [arrayToSkipMessage removeObjectAtIndex:[row integerValue]];
    messageSkipCount=arrayToSkipMessage.count+appDelegate.deletedFloatsArray.count;
    [self updateView];
}


#pragma Convert Unix Timestamp
- (NSDate*) getDateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}


#pragma Difference Between Dates

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


-(void)setFooterForTableView
{
    
    if (ismoreFloatsAvailable)
    {
        
        [loadMoreButton setHidden:NO];
        
        loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        loadMoreButton.frame = CGRectMake(80,0, 200, 50);
        
        loadMoreButton.backgroundColor=[UIColor clearColor];
        
        [loadMoreButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        [loadMoreButton setTitle:@"Tap here for older message's" forState:UIControlStateNormal];
        
        [loadMoreButton setTitleColor:[UIColor colorWithHexString:@"454545"] forState:UIControlStateNormal];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        [footerView addSubview:loadMoreButton];
        
        messageTableView.tableFooterView=footerView;
        
        [loadMoreButton addTarget:self action:@selector(fetchMoreMessages) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    else
    {
        [loadMoreButton setHidden:YES];
        
    }
    
    
    
}


-(void)fetchMoreMessages
{
    //[downloadingSubview setHidden:NO];
    
    //[self performSelector:@selector(fetchMessages) withObject:nil afterDelay:0.5];
    
}


- (void)insertRowAtBottom
{
    
    dispatch_async(dispatch_get_current_queue(), ^(void)
    
    {
        
    [messageTableView.infiniteScrollingView startAnimating];
            
    [self fetchMessages];
                
    });

     
}


-(void)fetchMessages
{
        
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/bizFloats?clientId=%@&skipBy=%d&fpId=%@",appDelegate.apiWithFloatsUri,appDelegate.clientId,messageSkipCount,[userDetails objectForKey:@"userFpId"]];
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    
    BizMessage *messageController=[[BizMessage alloc]init];
    
    messageController.delegate=self;
    
    [messageController downloadBizMessages:url];
    
    
}


-(void)updateBizMessage:(NSMutableDictionary *)responseDictionary
{
    
    if (responseDictionary!=NULL)
    {
        for (int i=0; i<[[responseDictionary objectForKey:@"floats"] count]; i++)
        {
            
            [dealDescriptionArray addObject:[[[responseDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"message" ]];
            
            [dealDateArray addObject:[[[responseDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"createdOn" ]];
            
            [dealId addObject:[[[responseDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ]];
            
            [arrayToSkipMessage addObject:[[[responseDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"_id" ]];
            
            [dealImageArray addObject:[[[responseDictionary objectForKey:@"floats"]objectAtIndex:i ]objectForKey:@"tileImageUri" ]];
            
        }
                
        messageSkipCount=arrayToSkipMessage.count+appDelegate.deletedFloatsArray.count;
        
        [messageTableView.infiniteScrollingView stopAnimating];
        
        [self updateView];
        
    }
    
    else
    {
        [messageTableView.infiniteScrollingView stopAnimating];

    }
    
}


-(UIImage*)grayishImage:(UIImage *)inputImage
{
    
    // Create a graphic context.
    UIGraphicsBeginImageContextWithOptions(inputImage.size, YES, 1.0);
    CGRect imageRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [inputImage drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
}


#pragma SWRevealViewControllerDelegate


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    else if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    else if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    else if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    
    else if ( position == FrontViewPositionLeftSide ) str = @"FrontViewPositionLeftSide";
    
    else if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    
    return str;
}


- (IBAction)revealFrontController:(id)sender
{
    
    SWRevealViewController *revealController = [self revealViewController];

    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"]) {
        
        [revealController performSelector:@selector(rightRevealToggle:)];
        
    }
    
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealController performSelector:@selector(revealToggle:)];
        
    }

}


- (IBAction)storeTagBtnClicked:(id)sender
{
    BizWebViewController *webViewController=[[BizWebViewController alloc]initWithNibName:@"BizWebViewController" bundle:nil];
    
    UINavigationController *navController=[[UINavigationController  alloc]initWithRootViewController:webViewController];
    
    [self presentModalViewController:navController animated:YES];
 
    webViewController=nil;
}


- (IBAction)dismissTutorialOverLayBtnClicked:(id)sender
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [tutorialOverlayiPhone4View removeFromSuperview];
        }
        
        else
        {
            [tutorialOverlayView removeFromSuperview];
        }
    }
}


- (IBAction)dismissUpdateMsgOverLayBtnClicked:(id)sender
{
    [updateMsgOverlay removeFromSuperview];
}


- (IBAction)primaryImageBtnClicked:(id)sender
{
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
    selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    selectAction.tag=1;
    [selectAction showInView:self.view];
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 0)
        {
            picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing=YES;
            picker.navigationBar.barStyle=UIBarStyleBlackOpaque;
            [self presentModalViewController:picker animated:NO];
            picker=nil;
            [picker setDelegate:nil];
        }
        
        
        if (buttonIndex==1)
        {
            picker=[[UIImagePickerController alloc] init];
            picker.allowsEditing=YES;
            [picker setDelegate:self];
            //          [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            picker.navigationBar.barStyle=UIBarStyleBlackOpaque;
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:picker animated:YES completion:NULL];
            picker=nil;
            [picker setDelegate:nil];
            
        }
    }
    
    if (actionSheet.tag==2)
    {
        if(buttonIndex == 0)
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
        
        
        if (buttonIndex==1)
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
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];
    
    NSData* imageData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.1);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSString *localImageUri=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];

    [picker1 dismissModalViewControllerAnimated:YES];
    
    [self performSelector:@selector(displayPrimaryImageModalView:) withObject:localImageUri afterDelay:1.0];
}


-(void)displayPrimaryImageModalView:(NSString *)path
{

    PrimaryImageViewController *primaryController=[[PrimaryImageViewController alloc]initWithNibName:@"PrimaryImageViewController" bundle:Nil];
    
    primaryController.isFromHomeVC=YES;
    
    primaryController.localImagePath=path;
    
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:primaryController];
    
    [self presentModalViewController:navController animated:YES];

}


- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;
{

    frontViewPosition=[self stringFromFrontViewPosition:position];
    

    //FrontViewPositionLeft
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    //FrontViewPositionCenter
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeft"])
    {        
        [revealFrontControllerButton setHidden:YES];
    
        [self clearObjectInArray];
        
        [self setUpArray];
        
        [messageTableView reloadData];
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {
        [revealFrontControllerButton setHidden:NO];        
    }



}



#pragma RightViewControllerDelegate
-(void)messageDidUpdate
{
    [messageTableView reloadData];
}


#pragma SearchQueryProtocol

-(void)saveSearchQuerys:(NSMutableArray *)jsonArray
{

    [appDelegate.searchQueryArray addObjectsFromArray:jsonArray];
    
    if (appDelegate.searchQueryArray.count>0)
    {
        [notificationView setHidden:NO];
        [self showNoticeView];        
    }

}


-(void)getSearchQueryDidFail
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not fetch latest search queries from the server" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
}


-(void)showNoticeView
{
     WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:notificationView title:@"Latest Search Query" message:[[[[appDelegate.searchQueryArray objectAtIndex:0] objectForKey:@"keyword"] lowercaseString] stringByConvertingCamelCaseToCapitalizedWords]];
    
    [notice setDismissalBlock:^(BOOL dismissedInteractively)
    {
        [notificationView setHidden:YES];
        [notificationBadgeImageView setHidden:NO];
        [notificationLabel setHidden:NO];
        [notificationLabel setText:[NSString stringWithFormat:@"%d",[appDelegate.searchQueryArray count]]];
    }];

     [notice setAlpha:0.7];
      notice.delay=5;
     [notice show];
}


#pragma PopUpViewDelegate

-(void)successBtnClicked:(id)sender
{
    if ([[sender objectForKey:@"tag"] intValue]==1001)
    {
        if (version.floatValue<6.0)
        {
            UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil];
            selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            selectAction.tag=2;
            [selectAction showInView:self.view];
        }
        
        else
        {
            NSString* shareText = [NSString stringWithFormat:@"Woohoo! We have a new website. Visit it at %@.nowfloats.com",[appDelegate.storeTag lowercaseString]];
            
            NSArray* dataToShare = @[shareText];
            
            UIActivityViewController* activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                              applicationActivities:nil];
            
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
    }
    
}


-(void)cancelBtnClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setParallax:nil];
    [self setMessageTableView:nil];
    downloadingSubview = nil;
    storeTagLabel = nil;
    storeTitleLabel = nil;
    timeLineLabel = nil;
    parallelaxImageView = nil;
    revealFrontControllerButton = nil;
    notificationView = nil;
    primaryImageView = nil;
    storeTagButton = nil;
    [super viewDidUnload];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [navBackgroundview setHidden:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
