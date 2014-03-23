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


#define TtbDomainCombo 1100
#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002


#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface BizStoreViewController ()<SWRevealViewControllerDelegate,BuyStoreWidgetDelegate,CMPopTipViewDelegate,PopUpDelegate>
{
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
    
    UIButton *rightCustomButton;
    
    BOOL is3rdSectionRemoved,is2ndSectionRemoved,is1stSectionRemoved;
    
    NSString *contentMessage;
    
    BOOL isBannerAvailable;
}

@end

@implementation BizStoreViewController
@synthesize pageViews;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];
    
    [rightCustomButton setHidden:NO];
    [self setUpDisplayData];
    [bizStoreTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
    
    is1stSectionRemoved=NO;
    
    is2ndSectionRemoved=NO;
    
    is3rdSectionRemoved=NO;
    
    [noWidgetView setHidden:YES];
    
    noWidgetView.center=self.view.center;
    
    version=[UIDevice currentDevice].systemVersion;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    topPaidAppArray=[[NSMutableArray alloc]init];
    
    topFreeAppArray=[[NSMutableArray  alloc]init];
    
    secondSectionMutableArray=[[NSMutableArray alloc]init];
    
    secondSectionPriceArray=[[NSMutableArray alloc]init];
    
    secondSectionTagArray=[[NSMutableArray alloc]init];
    
    secondSectionDescriptionArray =[[NSMutableArray alloc]init];
    
    secondSectionImageArray=[[NSMutableArray alloc]init];
    
    thirdSectionMutableArray=[[NSMutableArray alloc]init];;
    
    thirdSectionPriceArray=[[NSMutableArray alloc]init];;
    
    thirdSectionTagArray=[[NSMutableArray alloc]init];;
    
    thirdSectionDescriptionArray=[[NSMutableArray alloc]init];;
    
    thirdSectionImageArray=[[NSMutableArray alloc]init];;
    
    self.visiblePopTipViews = [NSMutableArray array];
    
    productSubViewsArray=[[NSMutableArray alloc]initWithObjects: autoSeoSubView,imageGallerySubView,businessTimingsSubView,talkTobusinessSubView,nil];
    
    self.popUpContentDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Image Gallery added to owned widgets",@"IG",@"Business Hours added to owned widgets",@"BT",@"Auto-SEO added to owned widgets",@"AS",@"Talk-To-Business added to owned widgets",@"TTB",nil];
    
    mixPanel=[Mixpanel sharedInstance];
    
    buyingActivity=[[NFActivityView alloc]init];
    
    buyingActivity.activityTitle=@"Buying";
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
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
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(0,0,44,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=100.0;
    revealController.rightViewRevealOverdraw=0.0;
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    [bizStoreTableView setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
    
    [bizStoreTableView setBackgroundView:Nil];
    
    [bizStoreTableView setScrollsToTop:YES];
    
    [recommendedAppScrollView setScrollsToTop:NO];
    
    for (UIButton *recommendedbuyBtn in recommendedBuyBtnCollection)
    {
        [recommendedbuyBtn.layer setCornerRadius:3.0];
        [recommendedbuyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb900"]] forState:UIControlStateHighlighted];
    }
    
    if ([appDelegate.storeRootAliasUri isEqualToString:@""])
    {
        [self setUpTableViewWithBanner];
    }
    else
    {
        [self setUpTableViewWithOutBanner];
    }
    
}

-(void)setUpDisplayData
{
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
}

-(void)setUpDisplayDataWithBanner
{
    @try
    {
        sectionNameArray=[[NSMutableArray alloc]initWithObjects:@"",@"Recommended For You",@"Top Paid",@"Top Free", nil];
        
        recommendedAppArray = [[NSMutableArray alloc]initWithObjects:@"Store Timings",@"Image Gallery",@"Business Timings", nil];
        
        dataArray = [[NSMutableArray alloc] init];
        
        if ([appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
        {
            [productSubViewsArray removeObject:autoSeoSubView];
        }
        
        if ([appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
        {
            [productSubViewsArray removeObject:imageGallerySubView];
        }
        
        if ( [appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        {
            [productSubViewsArray removeObject:businessTimingsSubView];
        }
        
        if ([appDelegate.storeWidgetArray containsObject:@"TOB"])
        {
            [productSubViewsArray removeObject:talkTobusinessSubView];
        }
        
        
        //Zeroth section data
        NSArray *zerothItemArray=[[NSArray alloc]initWithObjects:@"Item 0", nil];
        NSMutableDictionary *zerothItemsArrayDict = [NSMutableDictionary dictionaryWithObject:zerothItemArray forKey:@"data"];
        [dataArray addObject:zerothItemsArrayDict];
        
        
        //First section data
        NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Item 1", nil];
        NSMutableDictionary *firstItemsArrayDict = [NSMutableDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
        [dataArray addObject:firstItemsArrayDict];
        
        
        //Second section data
        if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
        {
            [secondSectionMutableArray addObject:@"Image Gallery"];
            
            [secondSectionPriceArray addObject:@"$2.99"];
            
            [secondSectionTagArray addObject:@"1004"];
            
            [secondSectionDescriptionArray addObject:@"Add pictures of your products/services to your site."];
            
            [secondSectionImageArray addObject:@"NFBizStore-image-gallery_y.png"];
        }
        
        if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
        {
            [secondSectionMutableArray addObject:@"Talk-To-Business"];
            
            [secondSectionPriceArray addObject:@"$3.99"];
            
            [secondSectionTagArray addObject:@"1002"];
            
            [secondSectionDescriptionArray addObject:@"Let your site visitors become leads."];
            
            [secondSectionImageArray addObject:@"NFBizStore-TTB_y.png"];
        }
        
        if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        {
            [secondSectionMutableArray addObject:@"Business Hours"];
            
            [secondSectionPriceArray addObject:@"$0.99"];
            
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
    
    @catch (NSException *e) {}
    
}

-(void)setUpDisplayDataWithOutBanner
{
    @try
    {
        dataArray = [[NSMutableArray alloc] init];

        sectionNameArray=[[NSMutableArray alloc]initWithObjects:@"Recommended For You",@"Top Paid",@"Top Free", nil];

        recommendedAppArray = [[NSMutableArray alloc]initWithObjects:@"Store Timings",@"Image Gallery",@"Business Timings", nil];

        if ([appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
        {
            [productSubViewsArray removeObject:autoSeoSubView];
        }
        
        if ([appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
        {
            [productSubViewsArray removeObject:imageGallerySubView];
        }
        
        if ( [appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        {
            [productSubViewsArray removeObject:businessTimingsSubView];
        }
        
        if ([appDelegate.storeWidgetArray containsObject:@"TOB"])
        {
            [productSubViewsArray removeObject:talkTobusinessSubView];
        }
        
        
        //First section data
        NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Item 1", nil];
        NSMutableDictionary *firstItemsArrayDict = [NSMutableDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
        [dataArray addObject:firstItemsArrayDict];
        
        //Second section data
        if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
        {
            [secondSectionMutableArray addObject:@"Image Gallery"];
            
            [secondSectionPriceArray addObject:@"$2.99"];
            
            [secondSectionTagArray addObject:@"1004"];
            
            [secondSectionDescriptionArray addObject:@"Add pictures of your products/services to your site."];
            
            [secondSectionImageArray addObject:@"NFBizStore-image-gallery_y.png"];
        }
        
        if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
        {
            [secondSectionMutableArray addObject:@"Talk-To-Business"];
            
            [secondSectionPriceArray addObject:@"$3.99"];
            
            [secondSectionTagArray addObject:@"1002"];
            
            [secondSectionDescriptionArray addObject:@"Let your site visitors become leads."];
            
            [secondSectionImageArray addObject:@"NFBizStore-TTB_y.png"];
        }
        
        if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
        {
            [secondSectionMutableArray addObject:@"Business Hours"];
            
            [secondSectionPriceArray addObject:@"$0.99"];
            
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
    
    [self presentModalViewController:navigationController animated:YES];
}

-(void)back
{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    @try
    {
        return [sectionNameArray count];
    }
    @catch (NSException *exception)
    {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try
    {
        NSDictionary *dictionary = [dataArray objectAtIndex:section];
        NSArray *array = [dictionary objectForKey:@"data"];
        return [array count];
    }
    @catch (NSException *exception){}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.backgroundView=[[UIView alloc]initWithFrame:CGRectZero];
    
    if ([appDelegate.storeRootAliasUri isEqualToString:@""])
    {
        if (indexPath.section==0)
        {
            UILabel *bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 130)];
            [bgLabel setBackgroundColor:[UIColor whiteColor]];
            [cell addSubview:bgLabel];
            
            UIImageView *dealImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320, 130)];
            [dealImgView setBackgroundColor:[UIColor clearColor]];
            [dealImgView setImage:[UIImage imageNamed:@"ttb+com biz.png"]];
            [cell addSubview:dealImgView];
            
            /*
            UILabel *dealDescriptionLbl=[[UILabel alloc]initWithFrame:CGRectMake(43,90,234, 40)];
            [dealDescriptionLbl setBackgroundColor:[UIColor clearColor]];
            [dealDescriptionLbl setTextAlignment:NSTextAlignmentCenter];
            [dealDescriptionLbl setLineBreakMode:NSLineBreakByWordWrapping];
            [dealDescriptionLbl setNumberOfLines:2];
            
            [dealDescriptionLbl setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
            [dealDescriptionLbl setTextColor:[UIColor darkGrayColor]];
            [dealDescriptionLbl setText:@".com domain and Talk-To-Business costing $14 is up for grabs for 5$"];
            [cell addSubview:dealDescriptionLbl];
             */
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
            
            
            if (productArray.count>3)
            {
                [productArray removeObjectsInRange:NSMakeRange(3,productArray.count-3)];
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
            
            recommendedAppScrollView.contentSize = CGSizeMake(135 * productSubViewsArray.count,193);
            
            [recommendedAppScrollView setBackgroundColor:[UIColor clearColor]];
            
            [recommendedAppScrollView setPagingEnabled:YES];
            
            recommendedAppScrollView.tag=1;
            
            [recommendedAppScrollView setShowsHorizontalScrollIndicator:NO];
            
            [recommendedAppScrollView setScrollsToTop:NO];
            
            [cell.contentView addSubview:recommendedAppScrollView];
        }
        
        if (indexPath.section==2)
        {
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
                
                topPaidBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57,40, 18)];
            }
            
            else
            {
                paidAppBg=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 72)];
                topPaidAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                topPaidTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
                topPaidDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
                topPaidBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57,40, 18)];
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
            
            NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[dictionary objectForKey:@"data"]];
            
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
                topFreeBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57, 40, 18)];
            }
            
            else
            {
                freeAppBg=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 72)];
                freeAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                freeAppTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
                freeAppDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
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
            
            NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
            NSArray *array = [dictionary objectForKey:@"data"];
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
    }
    
    else
    {
        if (indexPath.section==0 && indexPath.row==0)
        {
            
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
            
            
            if (productArray.count>3)
            {
                [productArray removeObjectsInRange:NSMakeRange(3,productArray.count-3)];
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
            
            recommendedAppScrollView.contentSize = CGSizeMake(135 * productSubViewsArray.count,193);
            
            [recommendedAppScrollView setBackgroundColor:[UIColor clearColor]];
            
            [recommendedAppScrollView setPagingEnabled:YES];
            
            recommendedAppScrollView.tag=1;
            
            [recommendedAppScrollView setShowsHorizontalScrollIndicator:NO];
            
            [recommendedAppScrollView setScrollsToTop:NO];
            
            [cell.contentView addSubview:recommendedAppScrollView];
        }
        
        
        if (indexPath.section==1 )
        {
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
                
                topPaidBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57,40, 18)];
            }
            
            else
            {
                paidAppBg=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 72)];
                topPaidAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                topPaidTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
                topPaidDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
                topPaidBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57,40, 18)];
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
            
            NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[dictionary objectForKey:@"data"]];
            
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
        
        
        if (indexPath.section==2)
        {
            
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
                topFreeBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57, 40, 18)];
            }
            
            else
            {
                freeAppBg=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 72)];
                freeAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
                freeAppTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
                freeAppDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
                topFreeBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57, 40, 18)];
            }
            
            [freeAppBg setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
            
            //[freeAppBg.layer setCornerRadius:3.0];
            
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
            
            NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
            NSArray *array = [dictionary objectForKey:@"data"];
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
        
        
    }
    
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BizStoreDetailViewController *detailViewController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
    
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
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height;
    
    if ([appDelegate.storeRootAliasUri isEqualToString:@""])
    {
        if ([indexPath section]==0)
        {
            return height=130.0;
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,25)];
    
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
    
    return tempView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
}


- (IBAction)dismissOverlay:(id)sender
{
    [purchasedWidgetOverlay removeFromSuperview];
}

//Buy Top PaidWidget button click
-(void)buyTopPaidWidgetBtnClicked:(UIButton *)sender
{
    [buyingActivity showCustomActivityView];
    
    clickedTag=sender.tag;
    
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
                 
                 SKProduct *product = _products[2];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             else
             {
                 [buyingActivity hideCustomActivityView];
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    
    /*
     if (clickedTag == 207 || clickedTag== 107)
     {
     NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
     appDelegate.clientId,@"clientId",
     [NSString stringWithFormat:@"com.biz.nowfloats.subscribers"],@"clientProductId",
     [NSString stringWithFormat:@"Subscribers"],@"NameOfWidget" ,
     [userDefaults objectForKey:@"userFpId"],@"fpId",
     [NSNumber numberWithInt:12],@"totalMonthsValidity",
     [NSNumber numberWithDouble:0.99],@"paidAmount",
     [NSString stringWithFormat:@"SUBSCRIBERS"],@"widgetKey",
     nil];
     
     AddWidgetController *addController=[[AddWidgetController alloc]init];
     
     addController.delegate=self;
     
     [addController addWidgetsForFp:productDescriptionDictionary];
     }
     */
}

-(void)removeProgressSubview
{
    [buyingActivity hideCustomActivityView];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"The transaction was not completed. Sorry to see you go. If this was by mistake please re-initiate transaction in store by hitting Buy" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
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
        
        if ([secondSectionMutableArray containsObject:@"Talk-To-Business"])
        {
            
            [secondSectionMutableArray removeObject:@"Talk-To-Business"];
            
            [secondSectionPriceArray removeObject:@"$3.99"];
            
            [secondSectionTagArray removeObject:@"1002"];
            
            [secondSectionDescriptionArray removeObject:@"TTB description"];
            
            [secondSectionImageArray removeObject:@"NFBizStore-TTB_y.png"];
            
        }
        
        [productSubViewsArray removeObject:talkTobusinessSubView];
        
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
        
        if ([secondSectionMutableArray containsObject:@"Image Gallery"])
        {
            [secondSectionMutableArray removeObject:@"Image Gallery"];
            
            [secondSectionPriceArray removeObject:@"$2.99"];
            
            [secondSectionTagArray removeObject:@"1004"];
            
            [secondSectionDescriptionArray removeObject:@"Image gallery description"];
            
            [secondSectionImageArray removeObject:@"NFBizStore-image-gallery_y.png"];
        }
        
        
        [productSubViewsArray removeObject:imageGallerySubView];
        
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
        
        
        if ([secondSectionMutableArray containsObject:@"Business Hours"])
        {
            [secondSectionMutableArray removeObject:@"Business Hours"];
            
            [secondSectionPriceArray removeObject:@"$0.99"];
            
            [secondSectionTagArray removeObject:@"1006"];
            
            [secondSectionDescriptionArray  removeObject:@"Business timings description"];
            
            [secondSectionImageArray removeObject:@"NFBizStore-timing_y.png"];
        }
        
        [productSubViewsArray removeObject:businessTimingsSubView];
        
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
        
        if ([thirdSectionMutableArray containsObject:@"Auto-SEO"])
        {
            [thirdSectionMutableArray removeObject:@"Auto-SEO"];
            
            [thirdSectionPriceArray removeObject:@"FREE"];
            
            [thirdSectionTagArray removeObject:@"1008"];
            
            [thirdSectionDescriptionArray  removeObject:@"Auto-SEO description"];
            
            [thirdSectionImageArray removeObject:@"NFBizStore-SEO_y.png"];
        }
        
        [productSubViewsArray removeObject:autoSeoSubView];
        
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
    
    if (productSubViewsArray.count==0)
    {
        if (!is1stSectionRemoved)
        {
            is1stSectionRemoved=YES;
            
            if ([sectionNameArray containsObject:@"Recommended For You"])
            {
                [sectionNameArray removeObject:@"Recommended For You"];
            }
        }
    }
    
    if (secondSectionMutableArray.count==0)
    {
        if (!is2ndSectionRemoved)
        {
            is2ndSectionRemoved=YES;
            
            [dataArray removeObjectAtIndex:2];
            
            if ([sectionNameArray containsObject:@"Top Paid"])
            {
                [sectionNameArray removeObject:@"Top Paid"];
            }
        }
    }
    
    if (thirdSectionMutableArray.count==0 && [sectionNameArray containsObject:@"Top Free"])
    {
        if (!is3rdSectionRemoved)
        {
            if (is2ndSectionRemoved)
            {
                is3rdSectionRemoved=YES;
                
                [dataArray removeObjectAtIndex:2];
                
                if ([sectionNameArray containsObject:@"Top Free"])
                {
                    [sectionNameArray removeObject:@"Top Free"];
                }
            }
            else
            {
                is3rdSectionRemoved=YES;
                
                if (isBannerAvailable)
                {
                    [dataArray removeObjectAtIndex:3];
                }
                
                if (!isBannerAvailable)
                {
                    [dataArray removeObjectAtIndex:2];
                }
                
                
                if ([sectionNameArray containsObject:@"Top Free"])
                {
                    [sectionNameArray removeObject:@"Top Free"];
                }
            }
        }
    }
    
    if (!noWidgetView.isHidden)
    {
        [self setNoWidgetView];
    }
    
    
    [self reloadRecommendedArray];
    
    [bizStoreTableView reloadData];
    
    
}

-(void)buyStoreWidgetDidFail
{
    [buyingActivity hideCustomActivityView];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while adding this widget.Call our customer care for support at +91 9160004303" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
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
    if ([appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        [productSubViewsArray removeObject:autoSeoSubView];
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
    {
        [productSubViewsArray removeObject:imageGallerySubView];
    }
    
    if ( [appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
    {
        [productSubViewsArray removeObject:businessTimingsSubView];
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"TOB"])
    {
        [productSubViewsArray removeObject:talkTobusinessSubView];
    }
}

-(void)reloadTopPaidArray
{
    //Second section data
    if (![appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
    {
        [secondSectionMutableArray addObject:@"Image Gallery"];
        
        [secondSectionPriceArray addObject:@"$2.99"];
        
        [secondSectionTagArray addObject:@"1004"];
        
        [secondSectionDescriptionArray addObject:@"Add pictures of your products/services to your site."];
        
        [secondSectionImageArray addObject:@"NFBizStore-image-gallery_y.png"];
    }
    
    if (![appDelegate.storeWidgetArray containsObject:@"TOB"])
    {
        [secondSectionMutableArray addObject:@"Talk-To-Business"];
        
        [secondSectionPriceArray addObject:@"$3.99"];
        
        [secondSectionTagArray addObject:@"1002"];
        
        [secondSectionDescriptionArray addObject:@"Let your site visitors become leads."];
        
        [secondSectionImageArray addObject:@"NFBizStore-TTB_y.png"];
    }
    
    if (![appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
    {
        [secondSectionMutableArray addObject:@"Business Hours"];
        
        [secondSectionPriceArray addObject:@"$0.99"];
        
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
