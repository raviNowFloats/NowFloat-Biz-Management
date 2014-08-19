//
//  BizStoreViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BizStoreViewController.h"
#import "BizStoreIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "SWRevealViewController.h"
#import "UIColor+HexaString.h"
#import "BizStoreDetailViewController.h"
#import "UIImage+ImageWithColor.h"
#import "AddWidgetController.h"
#import "BizStoreIAPHelper.h"
#import "BuyStoreWidget.h"
#import "Mixpanel.h"
#import "NFActivityView.h"
#import "OwnedWidgetsViewController.h"
#import "CMPopTipView.h"
#import "PopUpView.h"
#import "BizWebViewController.h"
#import "FileManagerHelper.h"
#import "RequestGooglePlaces.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import <CoreText/CTStringAttributes.h>
#import "ProPackController.h"
#import <StoreKit/StoreKit.h>

BOOL isNoanimation;
#define TtbDomainCombo 1100
#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002
#define GooglePlacesTag 1010
#define InTouchTag 1011
#define BannerScrollViewTag 1
#define NoAds 11000
#define ProPack 1017



#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface BizStoreViewController ()<SWRevealViewControllerDelegate,BuyStoreWidgetDelegate,CMPopTipViewDelegate,PopUpDelegate,RequsestGooglePlacesDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSTimer *scrollTimer;
    
    NSArray *_products;
    
    NSNumberFormatter * _priceFormatter;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    double viewHeight;
    
    NSMutableArray *dataArray;
    
    double clickedTag;
    
    Mixpanel *mixPanel;
    
    NFActivityView *buyingActivity;
    
    UIButton *topPaidBtn;
    
    UIButton *topFreeBtn;
    
    UIButton *contactUsBtn;
    
    NSMutableArray *secondSectionMutableArray;
    
    NSMutableArray *secondSectionPriceArray;
    
    NSMutableArray *secondSectionTagArray;
    
    NSMutableArray *secondSectionDescriptionArray;
    
    NSMutableArray *secondSectionImageArray;
    
    NSMutableArray *thirdSectionMutableArray;
    
    NSMutableArray *thirdSectionPriceArray;
    
    NSMutableArray *thirdSectionTagArray;
    
    NSMutableArray *thirdSectionDescriptionArray;
    
    NSMutableArray *thirdSectionImageArray;
    
    UIButton *rightCustomButton,*leftBtn,*rightBtn;
    
    BOOL is3rdSectionRemoved,is2ndSectionRemoved,is1stSectionRemoved;
    
    NSString *contentMessage;
    
    BOOL isBannerAvailable;
    
    NSMutableArray *bannerArray;
    
    NSMutableArray *bannerTagArray;
    
    UIPageControl *pageControl;
    
    UIScrollView *bannerScrollView;
    
    int bannerNumber;
    
    UIView *leftToolBarBtn,*rightToolBarBtn;
    
    
}

@end

@implementation BizStoreViewController
@synthesize pageViews;
@synthesize isFromOtherViews;

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
    if([self.title isEqualToString:@"Store"])
    {
        self.title =@"NowFloats Store";
    }
    
    if([[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]  isEqual: @"91"])
    {
        [self setUpStoreIndia];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];
        
        [rightCustomButton setHidden:NO];
        [self setUpDisplayData];
        //[bizStoreTableView reloadData];
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [scrollTimer invalidate];
    
    [rightCustomButton setHidden:YES];
    
    [secondSectionMutableArray removeAllObjects];
    
    [secondSectionPriceArray removeAllObjects];
    
    [secondSectionTagArray  removeAllObjects];
    
    [secondSectionDescriptionArray removeAllObjects];
    
    [secondSectionImageArray removeAllObjects];
    
    [thirdSectionMutableArray removeAllObjects];
    
    [thirdSectionPriceArray removeAllObjects];
    
    [thirdSectionTagArray removeAllObjects];
    
    [thirdSectionDescriptionArray removeAllObjects];
    
    [thirdSectionImageArray removeAllObjects];
    
    [dataArray removeAllObjects];
    
    [bannerTagArray removeAllObjects];
    
    [bannerArray removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    isNoanimation = YES;
    
    bannerNumber = 1;
    
    mach1TableView.bounces=NO;
    mach3TableView.scrollEnabled = NO;
    
    //    scrollTimer= [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(imageSlider) userInfo:nil repeats:YES];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
    
    is1stSectionRemoved=NO;
    
    is2ndSectionRemoved=NO;
    
    is3rdSectionRemoved=NO;
    
    [noWidgetView setHidden:YES];
    
    [revealFrontControllerButton setHidden:YES];
    
    noWidgetView.center=self.view.center;
    
    version=[UIDevice currentDevice].systemVersion;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    topPaidAppArray=[[NSMutableArray alloc]init];
    
    topFreeAppArray=[[NSMutableArray  alloc]init];
    
    secondSectionMutableArray=[[NSMutableArray alloc]init];
    
    secondSectionPriceArray=[[NSMutableArray alloc]init];
    
    secondSectionTagArray=[[NSMutableArray alloc] init];
    
    secondSectionDescriptionArray =[[NSMutableArray alloc]init];
    
    secondSectionImageArray=[[NSMutableArray alloc]init];
    
    thirdSectionMutableArray=[[NSMutableArray alloc]init];
    
    thirdSectionPriceArray=[[NSMutableArray alloc]init];
    
    thirdSectionTagArray=[[NSMutableArray alloc]init];
    
    thirdSectionDescriptionArray=[[NSMutableArray alloc]init];
    
    thirdSectionImageArray=[[NSMutableArray alloc]init];
    
    self.visiblePopTipViews = [NSMutableArray array];
    
    productSubViewsArray=[[NSMutableArray alloc]init];
    
    bannerArray = [[NSMutableArray alloc]init];
    
    bannerTagArray = [[NSMutableArray alloc]init];
    
    
    self.popUpContentDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Image Gallery added to owned widgets",@"IG",@"Business Hours added to owned widgets",@"BT",@"Auto-SEO added to owned widgets",@"AS",@"Talk-To-Business added to owned widgets",@"TTB",nil];
    
    mixPanel=[Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    buyingActivity=[[NFActivityView alloc]init];
    
    buyingActivity.activityTitle=@"Buying";
    
    if (isFromOtherViews)
    {
        if (version.floatValue<7.0)
        {
            self.navigationController.navigationBarHidden=YES;
            
            CGFloat width = self.view.frame.size.width;
            
            navBar = [[UINavigationBar alloc] initWithFrame:
                      CGRectMake(0,0,width,44)];
            
            [self.view addSubview:navBar];
            
            headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 13, 140, 20)];
            
            headerLabel.text=@"NowFloats Store";
            
            headerLabel.backgroundColor=[UIColor clearColor];
            
            headerLabel.textAlignment=NSTextAlignmentCenter;
            
            headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
            
            headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
            
            [navBar addSubview:headerLabel];
            
            leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
            
            [leftCustomButton setTitle:@"Cancel" forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            
            [navBar addSubview:leftCustomButton];
            
            
            rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [rightCustomButton setFrame:CGRectMake(276,7,28,28)];
            
            [rightCustomButton setImage:[UIImage imageNamed:@"userwidgeticon.png"] forState:UIControlStateNormal];
            
            [rightCustomButton addTarget:self action:@selector(showOwnedWidgetController) forControlEvents:UIControlEventTouchUpInside];
            
            [navBar addSubview:rightCustomButton];
        }
        
        else
        {
            self.navigationController.navigationBarHidden=NO;
            
            self.navigationItem.title=@"NowFloats Store";
            
            self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
            
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            
            leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
            
            [leftCustomButton setTitle:@"Cancel" forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;
            
            rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [rightCustomButton setFrame:CGRectMake(280,7,26,26)];
            
            [rightCustomButton setImage:[UIImage imageNamed:@"userwidgeticon.png"] forState:UIControlStateNormal];
            
            [rightCustomButton addTarget:self action:@selector(showOwnedWidgetController) forControlEvents:UIControlEventTouchUpInside];
            
            
            [self.navigationController.navigationBar addSubview:rightCustomButton];
            
            [bizStoreTableView setSeparatorInset:UIEdgeInsetsZero];
            
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        [revealFrontControllerButton setHidden:YES];
    }
    
    else{
        
        SWRevealViewController *revealController = [self revealViewController];
        
        revealController.delegate=self;
        
        
        if (version.floatValue<7.0)
        {
            self.navigationController.navigationBarHidden=NO;
            
            self.navigationItem.title=@"NowFloats Store";
            
            leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(25,0,35,15)];
            [leftCustomButton setImage:[UIImage imageNamed:@"Menu-Burger.png"] forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;
            
            //NFStore for rest of world
            
            if(![[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]  isEqual: @"91"])
            {
                rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
                
                [rightCustomButton setFrame:CGRectMake(280,7,26,26)];
                
                [rightCustomButton setImage:[UIImage imageNamed:@"userwidgeticon.png"] forState:UIControlStateNormal];
                
                [rightCustomButton addTarget:self action:@selector(showOwnedWidgetController) forControlEvents:UIControlEventTouchUpInside];
                
                [self.navigationController.navigationBar addSubview:rightCustomButton];
            }
            
        }
        
        else
        {
            self.navigationController.navigationBarHidden=NO;
            
            self.navigationItem.title=@"NowFloats Store";
            
            self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
            
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            
            self.navigationController.navigationBar.translucent = NO;
            
            leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [leftCustomButton setFrame:CGRectMake(25,0,35,15)];
            [leftCustomButton setImage:[UIImage imageNamed:@"Menu-Burger.png"] forState:UIControlStateNormal];
            
            [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;
            
            // NFStore for Rest of world
            
            if(![[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]  isEqual: @"91"])
            {
                rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
                
                [rightCustomButton setFrame:CGRectMake(280,7,26,26)];
                
                [rightCustomButton setImage:[UIImage imageNamed:@"userwidgeticon.png"] forState:UIControlStateNormal];
                
                [rightCustomButton addTarget:self action:@selector(showOwnedWidgetController) forControlEvents:UIControlEventTouchUpInside];
                
                [self.navigationController.navigationBar addSubview:rightCustomButton];
                
                [bizStoreTableView setSeparatorInset:UIEdgeInsetsZero];
                
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            
            
            
        }
        
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        
        //Set the RightRevealWidth 0
        revealController.rightViewRevealWidth=100.0;
        revealController.rightViewRevealOverdraw=0.0;
        
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    }
    
    [bizStoreTableView setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
    
    [bizStoreTableView setBackgroundView:Nil];
    
    [bizStoreTableView setScrollsToTop:YES];
    
    [recommendedAppScrollView setScrollsToTop:NO];
    
    for (UIButton *recommendedbuyBtn in recommendedBuyBtnCollection)
    {
        [recommendedbuyBtn.layer setCornerRadius:3.0];
        
        [recommendedbuyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb900"]] forState:UIControlStateHighlighted];
        
    }
    
    if(![[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]  isEqual: @"91"])
    {
        if ([appDelegate.storeRootAliasUri isEqualToString:@""])
        {
            [self setUpTableViewWithBanner];
        }
        else
        {
            [self setUpTableViewWithOutBanner];
        }
        
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                                       target: self
                                                     selector: @selector(imageSlider)
                                                     userInfo: nil
                                                      repeats: YES];
    }
    
    contactUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactUsBtn.frame = CGRectMake(20, 358, 280, 45);
    contactUsBtn.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
    contactUsBtn.tintColor = [UIColor blueColor];
    contactUsBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    [contactUsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactUsBtn setTitle:@"CONTACT US" forState:UIControlStateNormal];
    [contactUsBtn setShowsTouchWhenHighlighted:YES];
    
    contactUsBtn.layer.masksToBounds = YES;
    contactUsBtn.layer.cornerRadius = 5;
    contactUsBtn.tag = 17;
    
    [contactUsBtn addTarget:self action:@selector(contactUsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)setUpDisplayData
{
    if (BOOST_PLUS)
    {
        NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag = appDelegate.storeTag;
        
        if ([appDelegate.storeRootAliasUri isEqualToString:@""] && [userSetting objectForKey:@"isDomainPurchaseCancelled"]==nil)
        {
            isBannerAvailable = YES;
            [self setUpDisplayDataWithBanner];
        }
        
        else if ([appDelegate.storeRootAliasUri isEqualToString:@""] && [userSetting objectForKey:@"isDomainPurchaseCancelled"]!=nil)
        {
            if (![userSetting objectForKey:@"isDomainPurchaseCancelled"])
            {
                isBannerAvailable = YES;
                [self setUpDisplayDataWithBanner];
            }
            
            else{
                isBannerAvailable = NO;
                [self setUpDisplayDataWithOutBanner];
            }
        }
        
        else
        {
            isBannerAvailable = NO;
            [self setUpDisplayDataWithOutBanner];
        }
    }
    
    else
    {/*
      if ([appDelegate.storeRootAliasUri isEqualToString:@""])
      {
      isBannerAvailable = YES;
      [self setUpDisplayDataWithBanner];
      }
      
      else
      {
      isBannerAvailable = NO;
      [self setUpDisplayDataWithOutBanner];
      }
      */
        
        isBannerAvailable = YES;
        [self setUpDisplayDataWithBanner];
        
    }
}

-(void)setUpDisplayDataWithBanner
{
    @try
    {
        if(!is1stSectionRemoved)
        {
            is1stSectionRemoved=NO;
        }
        
        if( !is2ndSectionRemoved)
        {
            is2ndSectionRemoved=NO;
        }
        
        if(!is3rdSectionRemoved)
        {
            is3rdSectionRemoved = NO;
        }
        
        
        [bannerArray addObject:ttbdomainComboBannerSubView];
        [bannerArray addObject:googlePlacesBannerSubView];
        [bannerArray addObject:internationalPack];

        [bannerTagArray addObject:[NSNumber numberWithInteger:TtbDomainCombo]];
        [bannerTagArray addObject:[NSNumber numberWithInteger:GooglePlacesTag]];
        [bannerTagArray addObject:[NSNumber numberWithInteger:ProPack]];
        
        
        
        for (UIButton *recommendedbuyBtn in recommendedBuyBtnCollection)
        {
            [recommendedbuyBtn.layer setCornerRadius:3.0];
            
            if (recommendedbuyBtn.tag==1008)
            {
                if ([appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
                {
                    [recommendedbuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:NO];
                }
                else
                {
                    [recommendedbuyBtn setTitle:@"FREE" forState:UIControlStateNormal];
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:YES];
                }
            }
            
            else if (recommendedbuyBtn.tag == 1006)
            {
                if ([appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
                {
                    [recommendedbuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                    
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:NO];
                    
                }
                else
                {
                    NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.businesstimings"];
                    [recommendedbuyBtn setTitle:titlePrice forState:UIControlStateNormal];
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:YES];
                }
                
            }
            
            else if (recommendedbuyBtn.tag == 1004)
            {
                if ([appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
                {
                    [recommendedbuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                    
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:NO];
                }
                else
                {
                    NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.imagegallery"];
                    [recommendedbuyBtn setTitle:titlePrice forState:UIControlStateNormal];
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:YES];
                }
            }
            
            else if (recommendedbuyBtn.tag==1002)
            {
                if ([appDelegate.storeWidgetArray containsObject:@"TOB"]){
                    {
                        [recommendedbuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                        
                        [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                        
                        [recommendedbuyBtn setEnabled:NO];
                    }
                }
                else
                {
                    NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.tob"];
                    [recommendedbuyBtn setTitle:titlePrice forState:UIControlStateNormal];
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:YES];
                }
            }
            
            else if (recommendedbuyBtn.tag == 11000)
            {//NOADS
                if ([appDelegate.storeWidgetArray containsObject:@"NOADS"])
                {
                    [recommendedbuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                    
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:NO];
                }
                else
                {
                    NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.noads"];
                    [recommendedbuyBtn setTitle:titlePrice forState:UIControlStateNormal];
                    [recommendedbuyBtn setFrame:CGRectMake(recommendedbuyBtn.frame.origin.x, recommendedbuyBtn.frame.origin.y, 80, recommendedbuyBtn.frame.size.height)];
                    
                    [recommendedbuyBtn setEnabled:YES];
                }
            }
            
        }
        
        sectionNameArray=[[NSMutableArray alloc]initWithObjects:@"",@"Recommended For You",@"Top Paid",@"Top Free", nil];
        
        recommendedAppArray = [[NSMutableArray alloc]initWithObjects:@"Store Timings",@"Image Gallery",@"Business Timings", nil];
        
        dataArray = [[NSMutableArray alloc] init];
        

        secondSectionPriceArray = [[NSMutableArray alloc] init];


        //Zeroth section data
        NSArray *zerothItemArray=[[NSArray alloc]initWithObjects:@"Item 0", nil];
        NSMutableDictionary *zerothItemsArrayDict = [NSMutableDictionary dictionaryWithObject:zerothItemArray forKey:@"data"];
        [dataArray addObject:zerothItemsArrayDict];
        
        
        //First section data
        NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Item 1", nil];
        NSMutableDictionary *firstItemsArrayDict = [NSMutableDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
        [dataArray addObject:firstItemsArrayDict];
        
        
        //Second section data
        //if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
        
            [secondSectionMutableArray addObject:@"Image Gallery"];
            if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
            {
                NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.imagegallery"];
                [secondSectionPriceArray addObject:titlePrice];
                
                
            }
            
            else
            {
                [secondSectionPriceArray addObject:@"PURCHASED"];
            }
            
            
            [secondSectionTagArray addObject:@"1004"];
        
            [secondSectionDescriptionArray addObject:@"Add pictures of your products/services to your site."];
            
            [secondSectionImageArray addObject:@"NFBizStore-image-gallery_y.png"];
        
        
        //if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
        
            [secondSectionMutableArray addObject:@"Business Enquiries"];
            if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
            {
                NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.tob"];
                [secondSectionPriceArray addObject:titlePrice];
            }
            else{
                [secondSectionPriceArray addObject:@"PURCHASED"];
            }
            
            [secondSectionTagArray addObject:@"1002"];
            
            [secondSectionDescriptionArray addObject:@"Let your site visitors become leads."];
            
            [secondSectionImageArray addObject:@"NFBizStore-TTB_y.png"];
        
        
        //if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        
            [secondSectionMutableArray addObject:@"Business Hours"];
            
            if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
            {
                NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.businesstimings"];
                [secondSectionPriceArray addObject:titlePrice];
            }
            
            else{
                [secondSectionPriceArray addObject:@"PURCHASED"];
            }
            
            
            [secondSectionTagArray addObject:@"1006"];
            
            [secondSectionDescriptionArray  addObject:@"Tell people when you are open and when you aren't."];
            
            [secondSectionImageArray addObject:@"NFBizStore-timing_y.png"];
        
        
        NSMutableDictionary *secondItemsArrayDict = [NSMutableDictionary dictionaryWithObject:secondSectionMutableArray  forKey:@"data"];
        
        [secondItemsArrayDict setValue:secondSectionPriceArray forKey:@"price"];
        
        [secondItemsArrayDict setValue:secondSectionTagArray forKey:@"tag"];
        
        [secondItemsArrayDict setValue:secondSectionDescriptionArray forKey:@"description"];
        
        [secondItemsArrayDict setValue:secondSectionImageArray forKey:@"picture"];
        
        [dataArray addObject:secondItemsArrayDict];
        
        
        //Third Section data
        
        //Third Party App
        [thirdSectionMutableArray addObject:@"InTouchApp"];
        
        [thirdSectionPriceArray addObject:@"FREE"];
        
        [thirdSectionTagArray addObject:@"1011"];
        
        [thirdSectionDescriptionArray addObject:@"Are your phone contacts safely backed up?"];
        
        [thirdSectionImageArray addObject:@"intouchyellow.png"];
        
        
        //if (![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
        {
            [thirdSectionMutableArray addObject:@"Auto-SEO"];
            
            if (![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
            {
                [thirdSectionPriceArray addObject:@"FREE"];
            }
            
            else
            {
                [thirdSectionPriceArray addObject:@"PURCHASED"];
            }
            
            [thirdSectionTagArray addObject:@"1008"];
            
            [thirdSectionDescriptionArray addObject:@"A plug-in to optimize content for SEO automatically."];
            
            [thirdSectionImageArray addObject:@"NFBizStore-SEO_y.png"];
        }
        
        //Google Places
        [thirdSectionMutableArray addObject:@"Google Places"];
        
        [thirdSectionPriceArray addObject:@"FREE"];
        
        [thirdSectionTagArray addObject:@"1010"];
        
        [thirdSectionDescriptionArray addObject:@"Put your business on the map."];
        
        [thirdSectionImageArray addObject:@"GPlaces-yellow.png"];
        
        
        
        
        
        
        
        NSMutableDictionary *thirdItemsArrayDict = [NSMutableDictionary dictionaryWithObject:thirdSectionMutableArray forKey:@"data"];
        
        [thirdItemsArrayDict setValue:thirdSectionPriceArray forKey:@"price"];
        
        [thirdItemsArrayDict setValue:thirdSectionTagArray forKey:@"tag"];
        
        [thirdItemsArrayDict setValue:thirdSectionDescriptionArray forKey:@"description"];
        
        [thirdItemsArrayDict setValue:thirdSectionImageArray forKey:@"picture"];
        
        [dataArray addObject:thirdItemsArrayDict];
        


        [self setNoWidgetView];
        
        [self reloadRecommendedArray];
    }
    
    @catch (NSException *e) {}
    
}

-(void)setUpDisplayDataWithOutBanner
{
    @try
    {
        dataArray = [[NSMutableArray alloc] init];
        
        sectionNameArray=[[NSMutableArray alloc]initWithObjects:@"Recommended For You",@"Top Paid",@"Top Free", nil];
        
        recommendedAppArray = [[NSMutableArray alloc]initWithObjects:@"Store Timings",@"Image Gallery",@"Business Timings", nil];

        [self reloadRecommendedArray];
        
        //First section data
        NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Item 1", nil];
        NSMutableDictionary *firstItemsArrayDict = [NSMutableDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
        [dataArray addObject:firstItemsArrayDict];
        
        //Second section data
        if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
        {
            [secondSectionMutableArray addObject:@"Image Gallery"];
            
            NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.imagegallery"];
            
            [secondSectionPriceArray addObject:titlePrice];
            
            [secondSectionTagArray addObject:@"1004"];
            
            [secondSectionDescriptionArray addObject:@"Add pictures of your products/services to your site."];
            
            [secondSectionImageArray addObject:@"NFBizStore-image-gallery_y.png"];
        }
        
        if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
        {
            [secondSectionMutableArray addObject:@"Talk-To-Business"];
            
            NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.tob"];
            
            [secondSectionPriceArray addObject:titlePrice];
            
            [secondSectionTagArray addObject:@"1002"];
            
            [secondSectionDescriptionArray addObject:@"Let your site visitors become leads."];
            
            [secondSectionImageArray addObject:@"NFBizStore-TTB_y.png"];
        }
        
        if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        {
            [secondSectionMutableArray addObject:@"Business Hours"];
            
            NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.businesstimings"];
            
            [secondSectionPriceArray addObject:titlePrice];
            
            [secondSectionTagArray addObject:@"1006"];
            
            [secondSectionDescriptionArray  addObject:@"Tell people when you are open and when you aren't."];
            
            [secondSectionImageArray addObject:@"NFBizStore-timing_y.png"];
        }
        
        
        
        NSMutableDictionary *secondItemsArrayDict = [NSMutableDictionary dictionaryWithObject:secondSectionMutableArray  forKey:@"data"];
        
        [secondItemsArrayDict setValue:secondSectionPriceArray forKey:@"price"];
        
        [secondItemsArrayDict setValue:secondSectionTagArray forKey:@"tag"];
        
        [secondItemsArrayDict setValue:secondSectionDescriptionArray forKey:@"description"];
        
        [secondItemsArrayDict setValue:secondSectionImageArray forKey:@"picture"];
        
        [dataArray addObject:secondItemsArrayDict];
        
        
        //Third Section data
        
        if (![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
        {
            [thirdSectionMutableArray addObject:@"Auto-SEO"];
            
            [thirdSectionPriceArray addObject:@"FREE"];
            
            [thirdSectionTagArray addObject:@"1008"];
            
            [thirdSectionDescriptionArray addObject:@"A plug-in to optimize content for SEO automatically."];
            
            [thirdSectionImageArray addObject:@"NFBizStore-SEO_y.png"];
        }
        
        
        //Google Places
        [thirdSectionMutableArray addObject:@"Google Places"];
        
        [thirdSectionPriceArray addObject:@"FREE"];
        
        [thirdSectionTagArray addObject:@"1010"];
        
        [thirdSectionDescriptionArray addObject:@"Put your business on the map"];
        
        [thirdSectionImageArray addObject:@"GPlaces-Grey.png"];
        
        
        
        //Third Party App
        [thirdSectionMutableArray addObject:@"InTouchApp"];
        
        [thirdSectionPriceArray addObject:@"FREE"];
        
        [thirdSectionTagArray addObject:@"1011"];
        
        [thirdSectionDescriptionArray addObject:@"Are your phone contacts safely backed up?"];
        
        [thirdSectionImageArray addObject:@"intouchyellow.png"];
        
        
        
        
        
        NSMutableDictionary *thirdItemsArrayDict = [NSMutableDictionary dictionaryWithObject:thirdSectionMutableArray forKey:@"data"];
        
        [thirdItemsArrayDict setValue:thirdSectionPriceArray forKey:@"price"];
        
        [thirdItemsArrayDict setValue:thirdSectionTagArray forKey:@"tag"];
        
        [thirdItemsArrayDict setValue:thirdSectionDescriptionArray forKey:@"description"];
        
        [thirdItemsArrayDict setValue:thirdSectionImageArray forKey:@"picture"];
        
        [dataArray addObject:thirdItemsArrayDict];
        
        
        if (productSubViewsArray.count==0)
        {
            if ([sectionNameArray containsObject:@"Recommended For You"])
            {
                [sectionNameArray removeObject:@"Recommended For You"];
            }
        }
        
        
        if (secondSectionMutableArray.count==0 && thirdSectionMutableArray.count>0)
        {
            
            [sectionNameArray removeObject:@"Top Paid"];
            
            if (thirdSectionMutableArray.count>0)
            {
                [dataArray removeObjectAtIndex:2];
                [secondItemsArrayDict removeAllObjects];
                [secondItemsArrayDict addEntriesFromDictionary:thirdItemsArrayDict];
                [dataArray addObject:secondItemsArrayDict];
            }
        }
        
        
        if (secondSectionMutableArray.count==0)
        {
            [sectionNameArray removeObject:@"Top Paid"];
        }
        
        
        if (thirdSectionMutableArray.count==0)
        {
            if ([sectionNameArray containsObject:@"Top Free"])
            {
                [sectionNameArray removeObject:@"Top Free"];
            }
        }
        
        
        [self setNoWidgetView];
        
    }
    @catch (NSException *exception) {    }
}

-(void)setUpTableViewWithBanner
{
    
    if (viewHeight==480)
    {
        if (version.floatValue<7.0)
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+20,bizStoreTableView.frame.size.width, 425)];
        }
        
        else
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+30, bizStoreTableView.frame.size.width, 450)];
        }
    }
    
    else
    {
        if (version.floatValue<7.0)
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+20, bizStoreTableView.frame.size.width, 520)];
        }
        
        else
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+30, bizStoreTableView.frame.size.width,534)];
        }
    }
    
    // NSLog(@"bizStoreTableView.frame.origin.y:%f",bizStoreTableView.frame.origin.y);
}

-(void)setUpTableViewWithOutBanner
{
    
    if (viewHeight==480)
    {
        if (version.floatValue<7.0)
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+44, bizStoreTableView.frame.size.width, 420)];
        }
        
        else
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+64, bizStoreTableView.frame.size.width, 406)];
        }
    }
    
    else
    {
        if (version.floatValue<7.0)
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+44, bizStoreTableView.frame.size.width, 520)];
        }
        
        else
        {
            [bizStoreTableView setFrame:CGRectMake(bizStoreTableView.frame.origin.x, bizStoreTableView.frame.origin.y+74, bizStoreTableView.frame.size.width,504)];
        }
    }
    
}

-(void)setUpStoreIndia
{
    
    if([[appDelegate.storeDetailDictionary objectForKey:@"PaymentLevel"] floatValue] < 20)
    {
        leftToolBarBtn = [[UIView alloc] initWithFrame:CGRectMake(20, 44, 140, 55)];
        leftToolBarBtn.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:leftToolBarBtn.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = leftToolBarBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        leftToolBarBtn.layer.mask = maskLayer;
        
        rightToolBarBtn = [[UIView alloc] initWithFrame:CGRectMake(161, 44, 140, 55)];
        rightToolBarBtn.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:rightToolBarBtn.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = rightToolBarBtn.bounds;
        maskLayer1.path = maskPath1.CGPath;
        rightToolBarBtn.layer.mask = maskLayer1;
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftBtn setFrame:CGRectMake(0,0,140,44)];
        
        [leftBtn setImage:[UIImage imageNamed:@"Mach-3-Active.png"] forState:UIControlStateNormal];
        
        [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(12,30, 5, 25)];
        
        [leftBtn addTarget:self action:@selector(showMach1Screen) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightBtn setFrame:CGRectMake(0,0,140,44)];
        
        //[rightBtn setImage:[UIImage imageNamed:@"Mach-3-Normal.png"] forState:UIControlStateNormal];
        
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(12,30, 5, 25)];
        
        [rightBtn addTarget:self action:@selector(showMach2Screen) forControlEvents:UIControlEventTouchUpInside];
        
        [leftToolBarBtn addSubview:leftBtn];
        
        [rightToolBarBtn addSubview:rightBtn];
        
        [self.view addSubview:leftToolBarBtn];
        
        [self.view addSubview:rightToolBarBtn];
        
        [self showMach2Screen];
        
    }
    else
    {
        [self setNoWidgetView];
    }
}

-(void)showMach1Screen
{

    
    [leftBtn setImage:[UIImage imageNamed:@"Mach-3-Active.png"] forState:UIControlStateNormal];
    [leftToolBarBtn setBackgroundColor:[UIColor colorFromHexCode:@"#4d4d4d"]];
    [rightToolBarBtn setBackgroundColor:[UIColor colorFromHexCode:@"#767676"]];

    [rightBtn setImage:[UIImage imageNamed:@"Direct-Inactive.png"] forState:UIControlStateNormal];
   // [leftBtn setImage:[UIImage imageNamed:@"Direct-Active.png"] forState:UIControlStateNormal];

    
    contactUsBtn.tag = 17;
    
    [mach3Screen removeFromSuperview];
    UIView *mach1view = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 300)];
    [mach1TableView setFrame:CGRectMake(0, 0, 280,300)];
    mach1TableView.backgroundColor = [UIColor redColor];
    mach1TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [mach1view addSubview:mach1Screen];
    mach1view.layer.masksToBounds = YES;
    mach1view.layer.cornerRadius = 5;
    mach1Screen.layer.masksToBounds = YES;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         mach1view.transform = CGAffineTransformMakeScale(-1, 1);
                         mach1view.transform = CGAffineTransformMakeScale(1, 1);
                         [self.view addSubview:mach1view];
                     }
                     completion:nil];
    
    
    [self.view addSubview:contactUsBtn];
}

-(void)showMach2Screen
{

   
    [rightBtn setImage:[UIImage imageNamed:@"Direct-Active.png"] forState:UIControlStateNormal];


  //  [rightBtn setImage:[UIImage imageNamed:@"Mach-3-Active.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"Mach-3-InActive.png"] forState:UIControlStateNormal];

    
    [rightToolBarBtn setBackgroundColor:[UIColor colorFromHexCode:@"#4d4d4d"]];
    [leftToolBarBtn setBackgroundColor:[UIColor colorFromHexCode:@"#767676"]];

    
    contactUsBtn.tag = 18;
    
    [mach1Screen removeFromSuperview];
    
    UIView *mach3view = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 300)];
    [mach3TableView setFrame:CGRectMake(0, 0, 280, 300)];
    mach3TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mach3TableView setBackgroundColor:[UIColor colorWithHexString:@"4d4d4d"]];
    mach3Screen.layer.masksToBounds = YES;
    
    
    [mach3view addSubview:mach3Screen];
    mach3view.layer.cornerRadius = 5;
    mach3view.layer.masksToBounds = YES;
    UIView *directView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 300)];
    [directView setBackgroundColor:[UIColor colorFromHexCode:@"#4d4d4d"]];
    [mach3TableView addSubview:directView];
    
    UIImageView *directImage = [[UIImageView alloc]initWithFrame:CGRectMake(65, 40, 160, 27)];
    directImage.image = [UIImage imageNamed:@"Mach3 n Wildfire.png"];
    [directView addSubview:directImage];
  
    
    
  
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(40, 75, 220, 400)];
    NSString *myText=@"Wildfire is NowFloats’ mixture of organic optimisation with a powerful inorganic boost. It auto-promotes the website using digital marketing channels like Google<sup>TM</sup> and Facebook<sup>TM</sup> .";
    NSString *loadString = [NSString stringWithFormat:@"<div style='text-align:left;font-size:14px;font-family:Helvetica;color:#FFFFFF;'>%@",myText];
    
    [web loadHTMLString:loadString baseURL:nil];
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    
    [directView addSubview:web];
    [web setOpaque:NO];
    web.backgroundColor=[UIColor clearColor];
    
    if(!isNoanimation)
    {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         mach3view.transform = CGAffineTransformMakeScale(-1, 1);
                         mach3view.transform = CGAffineTransformMakeScale(1, 1);
                         
                     }
                     completion:nil];
      
        
    }
    [self.view addSubview:mach3view];
      isNoanimation = NO;
    
    [self.view addSubview:contactUsBtn];
}


-(void)contactUsBtnClicked
{
    NSUserDefaults *userdetails=[NSUserDefaults standardUserDefaults];
    
    NSString *planType;
    if(contactUsBtn.tag == 18)
    {
        [mixPanel track:@"nfstoreIndia_direct"];
        planType = @"direct";
    }
    else
    {
        [mixPanel track:@"nfstoreIndia_mach3clicked"];
        planType = @"mach3";
    }
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/%@/requestplan?clientId=%@&plantype=%@",appDelegate.apiWithFloatsUri,[userdetails objectForKey:@"userFpId"],appDelegate.clientId,planType];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [storeRequest setHTTPMethod:@"GET"];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:storeRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Something went wrong, please check back later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        alertView = nil;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"Our customer support team will get in touch with you soon." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        alertView = nil;
    }
    
    
}


-(void)setNoWidgetView
{
    @try
    {
        if (sectionNameArray.count==0)
        {
            [bizStoreTableView setHidden:YES];
            [noWidgetView setHidden:NO];
        }
        
        else
        {
            [bizStoreTableView setHidden:NO];
            [noWidgetView setHidden:YES];
        }
        
    }
    @catch (NSException *exception) {}
}

-(void)showOwnedWidgetController
{
    OwnedWidgetsViewController *userWidgetController=[[OwnedWidgetsViewController alloc]initWithNibName:@"OwnedWidgetsViewController" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userWidgetController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == mach1TableView)
    {
        @try {
            return 1;
        }
        @catch (NSException *exception) {
            
        }
    }
    else if(tableView == mach3TableView)
    {
        @try {
            return 1;
        }
        @catch (NSException *exception) {
            
        }
    }
    else
    {
        @try
        {
            return [sectionNameArray count];
        }
        @catch (NSException *exception)
        {
            
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == mach1TableView)
    {
        return 8;
    }
    else if (tableView == mach3TableView)
    {
        return 8;
    }
    else
    {
        @try
        {
            NSDictionary *dictionary = [dataArray objectAtIndex:section];
            NSArray *array = [dictionary objectForKey:@"data"];
            return [array count];
        }
        @catch (NSException *exception){}
        
    }
}

-(void)imageSlider
{
    
    if(bannerNumber == 1)
    {
        [bannerScrollView setContentOffset:CGPointMake(290, 0) animated:YES];
        //[bannerScrollView setContentOffset:CGPointMake(290, 0)];
        bannerNumber = 2;
    }
    else if(bannerNumber == 0)
    {
        [bannerScrollView setContentOffset:CGPointMake(0,0) animated:YES];
        bannerNumber = 1;
    }
    else
    {
        [bannerScrollView setContentOffset:CGPointMake(580, 0) animated:YES];
        bannerNumber = 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.backgroundView=[[UIView alloc]initWithFrame:CGRectZero];
    
    if(tableView == mach3TableView)
    {
        
        
        if(indexPath.section == 0)
        {
            UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,15, 270, 20)];
            bgLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
            bgLabel.textColor = [UIColor whiteColor];
           
            if(indexPath.row == 0)
            {
                bgLabel.text = @"Update via Web portal";
                [cell addSubview:bgLabel];
                cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if (indexPath.row == 4)
            {
                bgLabel.text = @"25 Gallery Images";
                [cell addSubview:bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
                
            }
            else if( indexPath.row == 5)
            {
                bgLabel.text = @"5 Custom Email Addresses";
                [cell addSubview: bgLabel];
                [cell setBackgroundColor:[UIColor whiteColor]];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if (indexPath.row == 3)
            {
                bgLabel.text = @"2500 Email Subscribers";
                [cell addSubview:bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if(indexPath.row == 1)
            {
                bgLabel.text = @"Online Discovery (Location Based SEO)";
                [cell addSubview:bgLabel];
                cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if(indexPath.row == 2)
            {
                bgLabel.text = @"Free .com Domain";
                [cell addSubview:bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if(indexPath.row == 6)
            {
                bgLabel.text = @"Online Customer Query";
                [cell addSubview:bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];            }
        }
        
        
    }
    else if(tableView == mach1TableView)
    {
        if(indexPath.section == 0)
        {
            UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,15, 270, 20)];
            bgLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
            bgLabel.textColor = [UIColor whiteColor];
            if(indexPath.row == 0)
            {
                bgLabel.text = @"Update via Boost & Web portal";
                [cell addSubview:bgLabel];
                cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if (indexPath.row == 1)
            {
                bgLabel.text = @"Online Discovery (Location Based SEO)";
                [cell addSubview:bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if( indexPath.row == 2)
            {
                bgLabel.text = @"Free .com Domain";
                [cell addSubview: bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if (indexPath.row == 4)
            {
                bgLabel.text = @"Unlimited Gallery Images";
                [cell addSubview:bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if( indexPath.row == 5)
            {
                bgLabel.text = @"Unlimited Custom Email Addresses";
                [cell addSubview: bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if (indexPath.row == 6)
            {
                bgLabel.text = @"5000 Email Subscribers";
                [cell addSubview:bgLabel];
                cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];
            }
            else if (indexPath.row == 3)
            {
                bgLabel.text = @"Custom Background";
                [cell addSubview:bgLabel];
                 cell.backgroundColor = [UIColor colorFromHexCode:@"#4d4d4d"];            }
            
        }
        
    }
    else
    {
        @try
        {
            if (indexPath.section==0)
            {
                UILabel *bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
                [bgLabel setBackgroundColor:[UIColor whiteColor]];
                [cell addSubview:bgLabel];
                //UIImageView *dealImgView;
                
                
                if (version.floatValue<7.0)
                {
                    bannerScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(15,26, 290, 110)];
                }
                
                else
                {
                    bannerScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(15,15, 290, 110)];
                }
                
                
                [bannerScrollView setTag:BannerScrollViewTag];
                
                [bannerScrollView setBackgroundColor:[UIColor clearColor]];
                
                [bannerScrollView setDelegate:self];
                
                bannerScrollView.showsHorizontalScrollIndicator = NO;
                
                for (int i = 0; i < bannerArray.count; i++)
                {
                    CGRect frame;
                    frame.origin.x = 290 * i;
                    frame.origin.y=0;
                    frame.size.height = 110;
                    frame.size.width= 290;
                    
                    
                    UIView *subview = [[UIView alloc] initWithFrame:frame];
                    
                    [subview addSubview:[bannerArray objectAtIndex:i]];
                    
                    [bannerScrollView addSubview:subview];
                    
                }
                
                bannerScrollView.contentSize = CGSizeMake(290 * bannerArray.count,110);
                
                bannerScrollView.pagingEnabled = YES;
                
                pageControl = [[UIPageControl alloc] init];
                
                if (version.floatValue<7.0) {
                    [pageControl setFrame:CGRectMake(cell.center.x,bannerScrollView.center.y+50, cell.frame.size.width, 20)];
                }
                
                else{
                    [pageControl setFrame:CGRectMake(cell.center.x-5,bannerScrollView.center.y+50, cell.frame.size.width, 20)];
                }
                pageControl.numberOfPages =bannerArray.count;
                [pageControl sizeToFit];
                [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
                [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];
                
                
                [cell addSubview:pageControl];
                
                [cell addSubview:bannerScrollView];
                
            }
            
            if (indexPath.section==1)
            {
                [cell.backgroundView setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
                
                if (version.floatValue<7.0)
                {
                    recommendedAppScrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0,10, 310, 193)];
                }
                
                else
                {
                    recommendedAppScrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(10,10, 310, 193)];
                }
                
                NSMutableArray *productArray=[[NSMutableArray alloc]init];
                
                [productArray addObjectsFromArray:productSubViewsArray];
                
                
                if (productArray.count>5)
                {
                    [productArray removeObjectsInRange:NSMakeRange(5,productArray.count-5)];
                }
                
                for (int i = 0; i < productArray.count; i++)
                {
                    CGRect frame;
                    frame.origin.x = 135 * i;
                    frame.origin.y = 0;
                    frame.size.height = 193;
                    frame.size.width= 125;
                    
                    UIView *subview = [[UIView alloc] initWithFrame:frame];
                    
                    [subview addSubview:[productArray objectAtIndex:i]];
                    
                    [recommendedAppScrollView addSubview:subview];
                }
                
                recommendedAppScrollView.contentSize = CGSizeMake(135 * productArray.count,193);
                
                [recommendedAppScrollView setBackgroundColor:[UIColor clearColor]];
                
                [recommendedAppScrollView setPagingEnabled:YES];
                
                recommendedAppScrollView.tag=1;
                
                [recommendedAppScrollView setShowsHorizontalScrollIndicator:NO];
                
                [recommendedAppScrollView setScrollsToTop:NO];
                
                [cell.contentView addSubview:recommendedAppScrollView];
            }
            
            if (indexPath.section==2)
            {
                
                NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[dictionary objectForKey:@"data"]];
                
                [cell.backgroundView setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
                
                UILabel *paidAppBg;
                
                UIImageView *topPaidAppImgView;
                
                UILabel *topPaidTitleLabel;
                
                UILabel *topPaidDetailLabel;
                
                if (version.floatValue<7.0)
                {
                    paidAppBg=[[UILabel alloc]initWithFrame:CGRectMake(0,10, 300, 72)];
                    
                    topPaidAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                    
                    topPaidTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 280, 15)];
                    
                    topPaidDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
                    
                }
                
                else
                {
                    paidAppBg=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 72)];
                    topPaidAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                    topPaidTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
                    topPaidDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
                }
                
                
                
                if ([[[dictionary objectForKey:@"price"] objectAtIndex:[indexPath row]] isEqualToString:@"PURCHASED"]) {
                    topPaidBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57,80, 18)];
                }
                
                else
                {
                    topPaidBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57,50, 18)];
                }
                
                
                
                paidAppBg.tag=2;
                
                [paidAppBg setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
                
                [paidAppBg setClipsToBounds:YES];
                
                paidAppBg.layer.needsDisplayOnBoundsChange=YES;
                
                paidAppBg.layer.shouldRasterize=YES;
                
                [paidAppBg.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
                
                [topPaidTitleLabel setBackgroundColor:[UIColor clearColor]];
                
                [topPaidTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
                
                [topPaidTitleLabel setTextColor:[UIColor darkGrayColor]];
                
                [topPaidDetailLabel setBackgroundColor:[UIColor clearColor]];
                
                [topPaidDetailLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0]];
                
                [topPaidDetailLabel setTextColor:[UIColor lightGrayColor]];
                
                [topPaidBtn.layer setCornerRadius:3.0];
                
                [topPaidBtn setBackgroundColor:[UIColor colorWithHexString:@"8c8c8c"]];
                
                [topPaidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                topPaidBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:11.0];
                
                [topPaidBtn addTarget:self action:@selector(buyTopPaidWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [topPaidBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb900"]] forState:UIControlStateHighlighted];
                
                if (array.count>3)
                {
                    [array removeObjectsInRange:NSMakeRange(3, array.count-3)];
                }
                
                NSArray *priceArray=[dictionary objectForKey:@"price"];
                NSArray *descriptionArray=[dictionary objectForKey:@"description"];
                NSArray *tagArray=[dictionary objectForKey:@"tag"];
                NSArray *pictureArray=[dictionary objectForKey:@"picture"];
                
                [cell.contentView addSubview:paidAppBg];
                
                [paidAppBg addSubview:topPaidAppImgView];
                
                [topPaidAppImgView setImage:[UIImage imageNamed:[pictureArray objectAtIndex:[indexPath row]]]];
                
                [topPaidTitleLabel setText:[array objectAtIndex:indexPath.row]];
                
                [paidAppBg addSubview:topPaidTitleLabel];
                
                [topPaidDetailLabel setText:[descriptionArray objectAtIndex:[indexPath row]]];
                
                [paidAppBg addSubview:topPaidDetailLabel];
                
                
                [topPaidBtn setTitle:[priceArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
                
                [topPaidBtn setTag:[[tagArray objectAtIndex:[indexPath row]] intValue]];
                
                [cell addSubview:topPaidBtn];
            }
            
            if (indexPath.section==3)
            {
                
                NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
                NSArray *array = [dictionary objectForKey:@"data"];
                
                [cell.backgroundView setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
                
                UILabel *freeAppBg;
                
                UIImageView *freeAppImgView;
                
                UILabel *freeAppTitleLabel;
                
                UILabel *freeAppDetailLabel;
                
                if (version.floatValue<7.0)
                {
                    freeAppBg=[[UILabel alloc]initWithFrame:CGRectMake(0,10, 300, 72)];
                    freeAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                    freeAppTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
                    freeAppDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
                }
                
                else
                {
                    freeAppBg=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 72)];
                    freeAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                    freeAppTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
                    freeAppDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
                }
                
                if ([[[dictionary objectForKey:@"price"] objectAtIndex:[indexPath row]] isEqualToString:@"PURCHASED"])
                {
                    
                    topFreeBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57, 80, 18)];
                }
                else
                {
                    topFreeBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57, 40, 18)];
                    
                }
                
                
                [freeAppBg setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
                
                [freeAppBg.layer setCornerRadius:3.0];
                
                [freeAppBg setClipsToBounds:YES];
                
                freeAppBg.layer.needsDisplayOnBoundsChange=YES;
                
                freeAppBg.layer.shouldRasterize=YES;
                
                [freeAppBg.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
                
                
                [freeAppTitleLabel setBackgroundColor:[UIColor clearColor]];
                
                [freeAppTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
                
                [freeAppTitleLabel setTextColor:[UIColor darkGrayColor]];
                
                
                [freeAppDetailLabel setBackgroundColor:[UIColor clearColor]];
                
                [freeAppDetailLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0]];
                
                [freeAppDetailLabel setTextColor:[UIColor lightGrayColor]];
                
                [topFreeBtn.layer setCornerRadius:3.0];
                
                [topFreeBtn setBackgroundColor:[UIColor colorWithHexString:@"8c8c8c"]];
                
                [topFreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                topFreeBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:11.0];
                
                [topFreeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb900"]] forState:UIControlStateHighlighted];
                
                [topFreeBtn addTarget:self action:@selector(buyFreeWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                
                NSArray *priceArray=[dictionary objectForKey:@"price"];
                NSArray *descriptionArray=[dictionary objectForKey:@"description"];
                NSArray *tagArray=[dictionary objectForKey:@"tag"];
                NSArray *pictureArray=[dictionary objectForKey:@"picture"];
                
                [cell.contentView addSubview:freeAppBg];
                
                [freeAppBg addSubview:freeAppImgView];
                
                [freeAppImgView setImage:[UIImage imageNamed:[pictureArray objectAtIndex:[indexPath row]]]];
                
                [freeAppTitleLabel setText:[array objectAtIndex:indexPath.row]];
                
                [freeAppBg addSubview:freeAppTitleLabel];
                
                [freeAppDetailLabel setText:[descriptionArray objectAtIndex:[indexPath row]]];
                
                [freeAppBg addSubview:freeAppDetailLabel];
                
                [topFreeBtn setTitle:[priceArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
                
                [topFreeBtn setTag:[[tagArray objectAtIndex:[indexPath row]] intValue]];
                
                [cell addSubview:topFreeBtn];
            }
            
            NSLog(@"data array is %@", dataArray);
            
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        @catch (NSException *exception) {
            NSLog(@"Exception in populating International store details are %@", exception);
        }
        
        
    }
    
    
    //if ([appDelegate.storeRootAliasUri isEqualToString:@""])
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BizStoreDetailViewController *detailViewController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
    
    //-Dynamic Navigation-//
    
    if ([appDelegate.storeRootAliasUri isEqualToString:@""])
    {
        if (indexPath.row==0)
        {
            [mixPanel track:@"ttbdomainCombo_bannerClicked"];
            detailViewController.selectedWidget=TtbDomainCombo;
        }
    }
    
    if (secondSectionMutableArray.count>0)
    {
        if (![appDelegate.storeRootAliasUri isEqualToString:@""])
        {
            if (indexPath.section==1)
            {
                detailViewController.selectedWidget=[[secondSectionTagArray objectAtIndex:[indexPath row]] intValue];
            }
        }
        
        else
        {
            if (indexPath.section==2)
            {
                detailViewController.selectedWidget=[[secondSectionTagArray objectAtIndex:[indexPath row]] intValue];
            }
        }
    }
    
    else
    {
        if (![appDelegate.storeRootAliasUri isEqualToString:@""])
        {
            if (indexPath.section==1)
            {
                detailViewController.selectedWidget=[[thirdSectionTagArray objectAtIndex:[indexPath row]] intValue];
            }
        }
        
        else
        {
            if (indexPath.section==2)
            {
                detailViewController.selectedWidget=[[thirdSectionTagArray objectAtIndex:[indexPath row]] intValue];
            }
        }
    }
    
    if (thirdSectionMutableArray.count>0)
    {
        if (![appDelegate.storeRootAliasUri isEqualToString:@""])
        {
            
            if (indexPath.section==2)
            {
                detailViewController.selectedWidget=[[thirdSectionTagArray objectAtIndex:[indexPath row]] intValue];
            }
        }
        
        else
        {
            if (indexPath.section==3)
            {
                detailViewController.selectedWidget=[[thirdSectionTagArray objectAtIndex:[indexPath row]] intValue];
            }
        }
    }
    
    else
    {
        if (indexPath.section==3)
        {
            detailViewController.selectedWidget=[[secondSectionTagArray objectAtIndex:[indexPath row]] intValue];
        }
    }
    

    
    
    //- Hard Coded Navigation -//
    /*
     if (indexPath.section == 2)
     {
     
     if (indexPath.row == 0) {
     
     detailViewController.selectedWidget=ImageGalleryTag;
     
     }
     
     else if (indexPath.row == 1) {
     detailViewController.selectedWidget=TalkToBusinessTag;
     
     }
     
     else if (indexPath.row == 2) {
     detailViewController.selectedWidget=BusinessTimingsTag;
     
     }
     
     }
     
     if (indexPath.section == 3)
     {
     
     if (indexPath.row == 0) {
     
     detailViewController.selectedWidget=AutoSeoTag;
     
     }
     
     else if (indexPath.row == 1) {
     detailViewController.selectedWidget=GooglePlacesTag;
     
     }
     
     else if (indexPath.row == 2) {
     detailViewController.selectedWidget=InTouchTag;
     }
     }
     */

    [self setTitle:@"Store"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex == 0)
        {
            RequestGooglePlaces *requestPlaces = [[RequestGooglePlaces alloc] init];
            
            requestPlaces.delegate = self;
            
            [requestPlaces requestGooglePlaces];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CGFloat height;
    
    if(tableView == mach1TableView)
    {
        return 50;
    }
    else if (tableView == mach3TableView)
    {
        return 50;
    }
    else
    {
        
        
        if ([appDelegate.storeRootAliasUri isEqualToString:@""])
        {
            if ([indexPath section]==0)
            {
                if (version.floatValue<7.0)
                {
                    return height=150.0;
                }
                
                else
                {
                    return height = 150.0;
                }
            }
            
            else if ([indexPath section]==2 || [indexPath section]==3)
            {
                if (version.floatValue<7.0)
                {
                    return height=83;//73
                }
                else
                {
                    return height=83;//70
                }
            }
            
            else
            {
                return height=205.0;
            }
        }
        
        else
        {
            CGFloat height;
            
            if ([indexPath section]==1 || [indexPath section]==2)
            {
                if (version.floatValue<7.0)
                {
                    return height=83;//73
                }
                else
                {
                    return height=83;//70
                }
            }
            
            else
            {
                return height=205.0;
            }
        }
    }
    
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,25)];
    if(tableView  != mach1TableView || tableView != mach3TableView)
    {
        
        
        tempView.backgroundColor=[UIColor clearColor];
        
        UILabel *sectionBgLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
        
        [sectionBgLbl setText:[NSString stringWithFormat:@"    %@",[sectionNameArray objectAtIndex:section]]];
        
        [sectionBgLbl setFont:[UIFont fontWithName:@"Helvetica-Light" size:16.0]];
        
        [sectionBgLbl setTextColor:[UIColor colorWithHexString:@"979797"]];
        
        [sectionBgLbl setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];//
        
        
        UIButton *seeAllBtn=[[UIButton alloc]initWithFrame:CGRectMake(250,0,60,22)];
        
        [seeAllBtn setTitle:@"SEE ALL" forState:UIControlStateNormal];
        
        [seeAllBtn setTitleColor:[UIColor colorWithHexString:@"565656"] forState:UIControlStateNormal];
        
        seeAllBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:9];
        
        seeAllBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        
        [seeAllBtn setBackgroundColor:[UIColor colorWithHexString:@"bebebe"]];//a7a7a7
        
        [seeAllBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"a7a7a7"]] forState:UIControlStateHighlighted];
        
        [tempView addSubview:sectionBgLbl];
        
        
        
    }
    return tempView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == mach1TableView)
    {
        if(section == 0)
        {
            return 0;
        }
        else
        {
            return  25;
        }
        
    }
    else if (tableView == mach3TableView)
    {
        if(section == 0)
        {
            return 0;
        }
        else
        {
            return  25;
        }
    }
    else
    {
        if ([appDelegate.storeRootAliasUri isEqualToString:@""])
        {
            if (section==0)
            {
                return 0;
            }
            else
            {
                return 25;//35
            }
        }
        
        else
        {
            return 25;
        }
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == bizStoreTableView)
    {
        if (scrollView.contentOffset.y < 0)
        {
            //[bizStoreTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        }
        
        else{
            //[bizStoreTableView setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
        }
    }
    
    else if (scrollView.tag == BannerScrollViewTag)
    {
        UIScrollView *bScrollView = (UIScrollView *)scrollView;
        
        CGFloat pageWidth = bScrollView.frame.size.width;
        
        int page = floor((bScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        pageControl.currentPage = page;
    }
    
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
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {
        [revealFrontControllerButton setHidden:NO];
    }
    
    
    
}

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
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        [revealController performSelector:@selector(rightRevealToggle:)];
    }
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {
        [revealController performSelector:@selector(revealToggle:)];
    }
    
}

//Buy RecommendedWidget
- (IBAction)buyRecommendedWidgetBtnClicked:(id)sender
{
    [buyingActivity showCustomActivityView];
    
    UIButton *clickedBtn=(UIButton *)sender;
    
    clickedTag=clickedBtn.tag;
    
    //Talk-to-business
    if (clickedTag==TalkToBusinessTag)
    {
        [mixPanel track:@"buyTalktobusiness_BtnClicked"];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[2];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             else
             {
                 [buyingActivity hideCustomActivityView];
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@":(" message:@"Looks like something went wrong. Check back later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
                 [customCancelButton setEnabled:YES];
             }
             
             
         }];
        
    }
    
    //Image Gallery
    if (clickedTag ==ImageGalleryTag)
    {
        
        [mixPanel track:@"buyImageGallery_btnClicked"];
        
        [customCancelButton setEnabled:NO];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[1];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             
             else
             {
                 [buyingActivity hideCustomActivityView];
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@":(" message:@"Looks like something went wrong. Check back later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
                 //[activitySubView setHidden:YES];
                 //[customCancelButton setEnabled:YES];
             }
         }];
    }
    
    //Business Timings
    if (clickedTag == BusinessTimingsTag)
    {
        
        [mixPanel track:@"buyBusinessTimeings_btnClicked"];
        
        [customCancelButton setEnabled:NO];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[0];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             
             else
             {
                 
                 [buyingActivity hideCustomActivityView];
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@":(" message:@"Looks like something went wrong. Check back later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
                 //[activitySubView setHidden:YES];
                 //[customCancelButton setEnabled:YES];
             }
         }];
        
    }
    
    //Auto-SEO
    if (clickedTag == AutoSeoTag)
    {
        [mixPanel track:@"buyAutoSeo_btnClicked"];
        BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
        buyWidget.delegate=self;
        [buyWidget purchaseStoreWidget:AutoSeoTag];
    }
    
    if (clickedTag == NoAds) {
        BizStoreDetailViewController *detailViewController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
        
        detailViewController.selectedWidget=NoAds;
        
    }
    
    if (clickedTag == GooglePlacesTag) {
        BizStoreDetailViewController *detailViewController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
        
        detailViewController.selectedWidget=GooglePlacesTag;
        
    }
    if (clickedTag == InTouchTag) {
        BizStoreDetailViewController *detailViewController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
        
        detailViewController.selectedWidget=InTouchTag;
        
    }
    
}

//Go to DetaiView from the recommended section
- (IBAction)detailRecommendedBtnClicked:(id)sender
{
    UIButton *clickedBtn=(UIButton *)sender;
    
    clickedTag=clickedBtn.tag;
    
    BizStoreDetailViewController *detailViewController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
    
    if (clickedBtn.tag==BusinessTimingsTag)
    {
        [mixPanel track:@"gotoStoreDetail_businessTimings"];
        detailViewController.selectedWidget=BusinessTimingsTag;
    }
    
    if (clickedBtn.tag==ImageGalleryTag)
    {
        [mixPanel track:@"gotoStoreDetail_imagegallery"];
        detailViewController.selectedWidget=ImageGalleryTag;
    }
    
    if (clickedBtn.tag==AutoSeoTag)
    {
        [mixPanel track:@"gotoStoreDetail_autoseo"];
        detailViewController.selectedWidget=AutoSeoTag;
    }
    
    if (clickedBtn.tag==TalkToBusinessTag)
    {
        [mixPanel track:@"gotStoreDetail_talktobusiness"];
        detailViewController.selectedWidget=TalkToBusinessTag;
    }
    if (clickedBtn.tag == NoAds) {
        [mixPanel track:@"gotStoreDetail_NoAds"];
        detailViewController.selectedWidget=NoAds;
    }
    if (clickedBtn.tag == InTouchTag) {
        [mixPanel track:@"gotStoreDetail_InTouchApp"];
        detailViewController.selectedWidget=NoAds;
    }
    if (clickedBtn.tag == GooglePlacesTag) {
        [mixPanel track:@"gotStoreDetail_GPlaces"];
        detailViewController.selectedWidget=NoAds;
    }
    [self setTitle:@"Store"];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
}


- (IBAction)dismissOverlay:(id)sender
{
    [purchasedWidgetOverlay removeFromSuperview];
}

- (IBAction)detailBannerBtnClicked:(id)sender
{
    
    UIButton *clickedBtn = (UIButton *)sender;
    
    if(clickedBtn.tag == 1017)
    {
        ProPackController *internationalProPack = [[ProPackController alloc] initWithNibName:@"ProPackController" bundle:nil];
        
        [self setTitle:@"Store"];
        
        [self.navigationController pushViewController:internationalProPack animated:YES];
    }
    else
    {
        BizStoreDetailViewController *detailViewController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
        
        if (clickedBtn.tag == GooglePlacesTag) {
            [mixPanel track:@"googleplace_bannerClicked"];
            detailViewController.selectedWidget=GooglePlacesTag;
        }
        
        else if(clickedBtn.tag == TtbDomainCombo)
        {
            [mixPanel track:@"ttbdomainCombo_bannerClicked"];
            detailViewController.selectedWidget=TtbDomainCombo;
        }
        
        [self setTitle:@"Store"];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    
   
    
   
    
    
}

//Buy Top PaidWidget button click
-(void)buyTopPaidWidgetBtnClicked:(UIButton *)sender
{
    [buyingActivity showCustomActivityView];
    
    clickedTag=sender.tag;
    
    NSLog(@"clickedTag:%f",clickedTag);
    
    
    //Talk-to-business
    if (sender.tag==TalkToBusinessTag)
    {
        [mixPanel track:@"buyTopPaidTalktobusiness_BtnClicked"];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[3];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             else
             {
                 [buyingActivity hideCustomActivityView];
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@":(" message:@"Looks like something went wrong. Check back later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
             }
         }];
    }
    
    //Image Gallery
    if (sender.tag == ImageGalleryTag)
    {
        
        [mixPanel track:@"buyTopPaidImageGallery_btnClicked"];
        
        [customCancelButton setEnabled:NO];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[1];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             
             else
             {
                 [buyingActivity hideCustomActivityView];
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@":(" message:@"Looks like something went wrong. Check back later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
             }
         }];
    }
    
    //Business Timings
    if (sender.tag == BusinessTimingsTag)
    {
        [mixPanel track:@"buyTopPaidBusinessTimeings_btnClicked"];
        
        [customCancelButton setEnabled:NO];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[0];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             
             else
             {
                 
                 [buyingActivity hideCustomActivityView];
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@":(" message:@"Looks like something went wrong. Check back later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
             }
         }];
        
    }
    
    //Auto-SEO
    if (clickedTag == AutoSeoTag)
    {
        [mixPanel track:@"buyAutoSeo_btnClicked"];
        BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
        buyWidget.delegate=self;
        [buyWidget purchaseStoreWidget:AutoSeoTag];
    }
    
    
}


//Buy Free Widget Button Clicked
-(void)buyFreeWidgetBtnClicked:(UIButton *)sender
{
    [mixPanel track:@"buyFreeAutoSeo_btnClicked"];
    
    [buyingActivity showCustomActivityView];
    
    clickedTag=sender.tag;
    
    if (sender.tag==AutoSeoTag)
    {
        if (sender.tag == AutoSeoTag )
        {
            BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
            buyWidget.delegate=self;
            [buyWidget purchaseStoreWidget:AutoSeoTag];
        }
    }
    
    else if (sender.tag == GooglePlacesTag)
    {
        NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag = appDelegate.storeTag;
        
        [userSetting addEntriesFromDictionary:[fHelper openUserSettings]];
        
        if([userSetting objectForKey:@"googleRequest"] == nil)
        {
            [fHelper updateUserSettingWithValue:[NSNumber numberWithBool:YES] forKey:@"googleRequest"];
            
            RequestGooglePlaces *requestPlaces = [[RequestGooglePlaces alloc] init];
            
            requestPlaces.delegate = self;
            
            [requestPlaces requestGooglePlaces];
        }
        else
        {
            UIAlertView *requestSucceedAlert = [[UIAlertView alloc]initWithTitle:@"Done" message:@"Your request for Google places has already been placed. Do you want to Continue?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
            
            requestSucceedAlert.tag = 101;
            
            [requestSucceedAlert show];
        }
        
    }
    
    
    else if (sender.tag == InTouchTag)
    {
        [mixPanel track:@"buyInTouchApp-btnClicked"];
        
        [buyingActivity hideCustomActivityView];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/intouchid/id480094166?ls=1&mt=8"]];
    }
    
}

//Banner Button Clicked
-(void)bannerBtnClicked:(UIButton *)sender;
{
}


#pragma IAPHelperProductPurchasedNotification

- (void)productPurchased:(NSNotification *)notification
{
    
    BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
    
    buyWidget.delegate=self;
    
    if (clickedTag == TalkToBusinessTag)
    {
        [mixPanel track:@"purchased_talkTobusiness"];
        [buyWidget purchaseStoreWidget:TalkToBusinessTag];
    }
    
    if (clickedTag == ImageGalleryTag)
    {
        [mixPanel track:@"purchased_imageGallery"];
        [buyWidget purchaseStoreWidget:ImageGalleryTag];
    }
    
    
    if (clickedTag == BusinessTimingsTag )
    {
        [mixPanel track:@"purchased_businessTimings"];
        [buyWidget purchaseStoreWidget:BusinessTimingsTag];
    }
    
    
}

-(void)removeProgressSubview
{
    [buyingActivity hideCustomActivityView];

    //    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"The transaction was not completed. Sorry to see you go. If this was by mistake please re-initiate transaction in store by hitting Buy" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //
    //    [alertView show];
    //
    //    alertView=nil;

}

#pragma BuyStoreWidgetDelegate

-(void)buyStoreWidgetDidSucceed
{
    [buyingActivity hideCustomActivityView];
    
    [self dismissAllPopTipViews];
    
    contentMessage=nil;
    
    if (clickedTag==TalkToBusinessTag)
    {
        [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];

        /*
         if ([secondSectionMutableArray containsObject:@"Talk-To-Business"])
         {
         
         [secondSectionMutableArray removeObject:@"Talk-To-Business"];
         
         [secondSectionPriceArray removeObject:@"$3.99"];
         
         [secondSectionTagArray removeObject:@"1002"];
         
         [secondSectionDescriptionArray removeObject:@"TTB description"];
         
         [secondSectionImageArray removeObject:@"NFBizStore-TTB_y.png"];
         
         }
         
         [productSubViewsArray removeObject:talkTobusinessSubView];
         */

        contentMessage = [self.popUpContentDictionary objectForKey:@"TTB"];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Talk to business widget purchased successfully.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"View";
        customPopUp.cancelBtnText=@"Done";
        customPopUp.tag=1100;
        [customPopUp showPopUpView];
        
        
    }
    
    if (clickedTag== ImageGalleryTag)
    {
        [appDelegate.storeWidgetArray insertObject:@"IMAGEGALLERY" atIndex:0];

        /*
         if ([secondSectionMutableArray containsObject:@"Image Gallery"])
         {
         [secondSectionMutableArray removeObject:@"Image Gallery"];
         
         [secondSectionPriceArray removeObject:@"$2.99"];
         
         [secondSectionTagArray removeObject:@"1004"];
         
         [secondSectionDescriptionArray removeObject:@"Image gallery description"];
         
         [secondSectionImageArray removeObject:@"NFBizStore-image-gallery_y.png"];
         }
         
         [productSubViewsArray removeObject:imageGallerySubView];
         */

        contentMessage = [self.popUpContentDictionary objectForKey:@"IG"];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Image gallery widget purchased successfully.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        customPopUp.tag=1101;
        [customPopUp showPopUpView];
        
    }
    
    if (clickedTag == BusinessTimingsTag)
    {
        [appDelegate.storeWidgetArray insertObject:@"TIMINGS" atIndex:0];

        /*
         if ([secondSectionMutableArray containsObject:@"Business Hours"])
         {
         [secondSectionMutableArray removeObject:@"Business Hours"];
         
         [secondSectionPriceArray removeObject:@"$0.99"];
         
         [secondSectionTagArray removeObject:@"1006"];
         
         [secondSectionDescriptionArray  removeObject:@"Business timings description"];
         
         [secondSectionImageArray removeObject:@"NFBizStore-timing_y.png"];
         }
         
         [productSubViewsArray removeObject:businessTimingsSubView];
         */

        contentMessage = [self.popUpContentDictionary objectForKey:@"BT"];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Business Hours widget purchased successfully.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        customPopUp.tag=1106;
        [customPopUp showPopUpView];
        
    }
    
    if (clickedTag == AutoSeoTag)
    {
        [appDelegate.storeWidgetArray insertObject:@"SITESENSE" atIndex:0];

        /*
         if ([thirdSectionMutableArray containsObject:@"Auto-SEO"])
         {
         [thirdSectionMutableArray removeObject:@"Auto-SEO"];
         
         [thirdSectionPriceArray removeObject:@"FREE"];
         
         [thirdSectionTagArray removeObject:@"1008"];
         
         [thirdSectionDescriptionArray  removeObject:@"Auto-SEO description"];
         
         [thirdSectionImageArray removeObject:@"NFBizStore-SEO_y.png"];
         }
         
         [productSubViewsArray removeObject:autoSeoSubView];
         */


        contentMessage = [self.popUpContentDictionary objectForKey:@"AS"];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Auto-SEO widget purchased successfully.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        [customPopUp showPopUpView];
        
    }
    

 
    
    [secondSectionMutableArray removeAllObjects];
    
    [secondSectionPriceArray removeAllObjects];
    
    [secondSectionTagArray  removeAllObjects];
    
    [secondSectionDescriptionArray removeAllObjects];
    
    [secondSectionImageArray removeAllObjects];
    
    [thirdSectionMutableArray removeAllObjects];
    
    [thirdSectionPriceArray removeAllObjects];
    
    [thirdSectionTagArray removeAllObjects];
    
    [thirdSectionDescriptionArray removeAllObjects];
    
    [thirdSectionImageArray removeAllObjects];
    
    [dataArray removeAllObjects];
    
    [bannerArray removeAllObjects];
    
    [self setUpDisplayData];
    
    [bizStoreTableView reloadData];
    
}

-(void)buyStoreWidgetDidFail
{
    [buyingActivity hideCustomActivityView];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while adding this widget. Reach us at hello@nowfloats.com" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
}

- (void)dismissAllPopTipViews
{
	while ([self.visiblePopTipViews count] > 0) {
		CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
		[popTipView dismissAnimated:YES];
		[self.visiblePopTipViews removeObjectAtIndex:0];
	}
}


#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
	[self.visiblePopTipViews removeObject:popTipView];
	self.currentPopTipViewTarget = nil;
}

#pragma PopUpDelegate

-(void)successBtnClicked:(id)sender;
{
    [self showToolTip];
}

-(void)cancelBtnClicked:(id)sender;
{
    [self showToolTip];
}

-(void)showToolTip
{
    UIColor *backgroundColor = [UIColor colorWithHexString:@"454545"];
    UIColor *textColor = [UIColor whiteColor];
    CMPopTipView *popTipView;
    popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
    popTipView.delegate = self;
    popTipView.backgroundColor = backgroundColor;
    popTipView.borderColor=[UIColor colorWithHexString:@"454545"];
    popTipView.textColor = textColor;
    popTipView.animation = arc4random() % 2;
    popTipView.has3DStyle = NO;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:3.0];
    
    if (version.floatValue<7.0)
    {
        [popTipView presentPointingAtView:rightCustomButton inView:navBar animated:YES];
    }
    else
    {
        [popTipView presentPointingAtView:rightCustomButton inView:self.navigationController.navigationBar animated:YES];
    }
}

-(void)reloadRecommendedArray
{
    
    
    [productSubViewsArray removeAllObjects];
    if (![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        [productSubViewsArray addObject:autoSeoSubView];
    }
    
    if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
    {
        [productSubViewsArray addObject:imageGallerySubView];
    }
    
    if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
    {
        [productSubViewsArray addObject:businessTimingsSubView];
    }
    
    if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
    {
        [productSubViewsArray  addObject:talkTobusinessSubView];
    }
    
    if(productSubViewsArray.count != 4)
    {
        [productSubViewsArray addObject:noAdsSubView];
        
        if([appDelegate.storeWidgetArray containsObject:@"NOADS"])
        {
            [productSubViewsArray removeObject:noAdsSubView];
        }
    }
    
    
}




-(void)reloadTopPaidArray
{
    //Second section data
    if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
    {
        [secondSectionMutableArray addObject:@"Image Gallery"];
        
        NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.imagegallery"];
        
        [secondSectionPriceArray addObject:titlePrice];
        
        [secondSectionTagArray addObject:@"1004"];
        
        [secondSectionDescriptionArray addObject:@"Add pictures of your products/services to your site."];
        
        [secondSectionImageArray addObject:@"NFBizStore-image-gallery_y.png"];
    }
    
    if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
    {
        [secondSectionMutableArray addObject:@"Talk-To-Business"];
        
        NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.tob"];
        
        [secondSectionPriceArray addObject:titlePrice];
        
        [secondSectionTagArray addObject:@"1002"];
        
        [secondSectionDescriptionArray addObject:@"Let your site visitors become leads."];
        
        [secondSectionImageArray addObject:@"NFBizStore-TTB_y.png"];
    }
    
    if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
    {
        [secondSectionMutableArray addObject:@"Business Hours"];
        
        NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.businesstimings"];
        
        [secondSectionPriceArray addObject:titlePrice];
        
        [secondSectionTagArray addObject:@"1006"];
        
        [secondSectionDescriptionArray  addObject:@"Tell people when you are open and when you aren't."];
        
        [secondSectionImageArray addObject:@"NFBizStore-timing_y.png"];
    }
    
    NSMutableDictionary *secondItemsArrayDict = [NSMutableDictionary dictionaryWithObject:secondSectionMutableArray  forKey:@"data"];
    
    [secondItemsArrayDict setValue:secondSectionPriceArray forKey:@"price"];
    
    [secondItemsArrayDict setValue:secondSectionTagArray forKey:@"tag"];
    
    [secondItemsArrayDict setValue:secondSectionDescriptionArray forKey:@"description"];
    
    [secondItemsArrayDict setValue:secondSectionImageArray forKey:@"picture"];
    
    [dataArray addObject:secondItemsArrayDict];
    
}

#pragma RequsestGooglePlacesDelegate


-(void)requestGooglePlacesDidSucceed
{
    [buyingActivity hideCustomActivityView];
    
    UIAlertView *requestSucceedAlert = [[UIAlertView alloc]initWithTitle:@"Done" message:@"Request for Google Places submitted successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [requestSucceedAlert show];
    
    requestSucceedAlert = nil;
    
}

-(void)requestGooglePlaceDidFail
{
    [buyingActivity hideCustomActivityView];
    
    UIAlertView *requestPlacesFailAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not request Google Places." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [requestPlacesFailAlert show];
    
    requestPlacesFailAlert = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
