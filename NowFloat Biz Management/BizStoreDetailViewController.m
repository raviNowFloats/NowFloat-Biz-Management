//
//  BizStoreDetailViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 11/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BizStoreDetailViewController.h"
#import "AppDelegate.h"
#import "UIColor+HexaString.h"
#import "NFActivityView.h"
#import "UIImage+ImageWithColor.h"
#import "BuyStoreWidget.h"
#import "BizStoreIAPHelper.h"
#import "UIImage+ImageWithColor.h"
#import "Mixpanel.h"
#import "PopUpView.h"
#import "DomainSelectViewController.h"
#import "RequestGooglePlaces.h"
#import "BizStoreViewController.h"
#import "LeftViewController.h"
#import "BusinessAddressViewController.h"
#import "FileManagerHelper.h"

#import <StoreKit/StoreKit.h>

#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002
#define TtbDomainCombo 1100
#define GooglePlacesTag 1010
#define InTouchTag 1011
#define NoAds 11000


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f



@interface BizStoreDetailViewController ()<SKProductsRequestDelegate,BuyStoreWidgetDelegate,PopUpDelegate,RequsestGooglePlacesDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *versionString;
    double viewHeight;
    int selectedIndex;
    NFActivityView *buyingActivity;
    double clickedTag;
    Mixpanel *mixPanel;
    AppDelegate *appDelegate;
    NSArray *_products;
    UIScrollView *screenShotView;
    BOOL isTOBPurchased,isTimingsPurchased,isImageGalleryPurchased,isAutoSeoPurchased,isGPlacesPurchased;
    UIButton *widgetBuyBtn;
    SKProductsRequest *productsRequest;
    NSString *ttbComboPrice;
}
@end

@implementation BizStoreDetailViewController
@synthesize selectedWidget;
@synthesize isFromOtherViews;

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
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self fetchAvailableProducts:@"com.biz.ttbdomaincombo"];

    if ([appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
    {
        isImageGalleryPurchased=YES;
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"TOB"])
    {
        isTOBPurchased=YES;
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
    {
        isTimingsPurchased=YES;
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        isAutoSeoPurchased=YES;
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"GPlaces"])
    {
        isGPlacesPurchased=YES;
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

   // imageGalleryViewPicker.hidden = YES;
    
    buyingActivity=[[NFActivityView alloc]init];
    
    buyingActivity.activityTitle=@"Buying";
    
    versionString=[[UIDevice currentDevice]systemVersion];
    
    mixPanel=[Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    introductionArray=[[NSMutableArray alloc]initWithObjects:
                       @"Let your customers contact you directly. Messages sent from the website are delivered to you instantly. Talk-To-Business is a lead generating mechanism for your business.",
                       @"Show off your wares or services offered in a neatly arranged picture gallery.",
                       @"Visitors to your site would like to drop in at your store. Let them know when you are open and when you aren’t.",
                       @"The Auto-SEO plugin optimizes your content for search results and enhances the discovery of your website.",
                       @"Get Google Places for your business with ease and ensure it is discoverable on Google Search and Maps. Google Places is only applicable to those businesses with a physical address.",
                       @"Are your phone contacts safely backed up? Do you have latest numbers of your customers on your phone? And do they have your updated contact on their phone? With InTouchApp, ensure your contacts are always safe and your customers are reachable!",
                       @"Remove ads from your NowFloats site by purchasing this widget.",
                       nil];
    
    
    descriptionArray=[[NSMutableArray alloc]initWithObjects:
                      @"Visitors to your site can contact you directly by leaving a message with their phone number or email address. You will get these messages instantly over email and can see them in your NowFloats app at any time. Revert back to these leads quickly and generate business.",
                      @"Some people are visual. They might not have the patience to read through your website. An image gallery on the site with good pictures of your products and services might just grab their attention. Upload upto 25 pictures.",
                      @"Once you set timings for your store, a widget shows up on your site telling the visitors when your working hours are. It is optimized for visitors on mobile too.",
                      @"When you post an update, it is analysed and keywords are generated. These keywords are tagged to your content so that search engines can get better context about your content. This gives better search results for relevant queries." ,
                      @"Get this widget and get your business listed in Google Places. For this to happen correctly ensure that your business name, address, phone number and location on the map are correct.\n\nJust in case you are not sure. Click here to check if your address is correct.",
                      @"InTouchApp safely and automatically backs up your phone contacts to the cloud ensuring you never lose any contacts. You can bring your contacts to any new phone in minutes. You can also manage your contacts from the comfort of you PC.\n\n  InTouchApp keeps your phone contacts updated automatically. When a customer changes their number, it is updated automatically for you. Similarly, if you change your number (or other contact data) InTouchApp will update your customers' phone automatically with your new information. This will ensure you are always reachable and never lose business again just because your phone was not working.",
                      @"There is a teeny cost for us to provide you with an ad free site.It is still free forever if you don't mind the ads.So go ahead, go ad free. Make your good looking NowFloats site even better."
                      ,nil];
    
    widgetImageArray=[[NSMutableArray alloc]initWithObjects:@"NFBizstore-Detail-ttb.png",@"NFBizstore-Detail-imggallery.png",@"NFBizstore-Detail-timings.png",@"NFBizstore-Detail-autoseo.png",@"GooglePlacesdetail.png",@"intouchdetail.png",@"ADS.png", nil];
    
    
    selectedIndex=0;
    
    switch (selectedWidget)
    {
        case BusinessTimingsTag:
            selectedIndex=2;
            break;
            
        case ImageGalleryTag:
            selectedIndex=1;
            break;
            
        case TalkToBusinessTag:
            selectedIndex=0;
            break;
            
        case AutoSeoTag:
            selectedIndex=3;
            break;
            
        case GooglePlacesTag:
            selectedIndex = 4;
            break;
            
        case InTouchTag:
            selectedIndex = 5;
            break;
            
        case NoAds:
            selectedIndex=6 ;
            break;
            
        default:
            break;
    }

    if (versionString.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=NO;
        /*
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
         */
        UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
        
        customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customCancelButton setImage:buttonImage forState:UIControlStateNormal];
        
        [customCancelButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
        
        customCancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        
        [customCancelButton setFrame:CGRectMake(5,0,50,44)];
        
        [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [customCancelButton setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:    customCancelButton];

        self.navigationItem.leftBarButtonItem = leftBtnItem;


    }
    
    else
    {
        bizStoreDetailsTableView.separatorInset=UIEdgeInsetsZero;
        
        self.navigationItem.backBarButtonItem.title = @"NFStore";
        
        if (isFromOtherViews)
        {
            self.navigationController.navigationBarHidden=NO;
            self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
            self.navigationController.navigationBar.translucent = NO;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            

            UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
            
            customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [customCancelButton setImage:buttonImage forState:UIControlStateNormal];
            
            [customCancelButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
            
            customCancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
            
            [customCancelButton setFrame:CGRectMake(5,0,50,44)];
            
            [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton setShowsTouchWhenHighlighted:YES];
            
            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:customCancelButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;
        }
        else
        {
            
        }
        
        
    }
    
    if (viewHeight==480)
    {
        if (versionString.floatValue<7.0)
        {
            [bizStoreDetailsTableView setFrame:CGRectMake(bizStoreDetailsTableView.frame.origin.x, bizStoreDetailsTableView.frame.origin.y+44, bizStoreDetailsTableView.frame.size.width, 420)];
        }
        else
        {
            [bizStoreDetailsTableView setFrame:CGRectMake(bizStoreDetailsTableView.frame.origin.x, bizStoreDetailsTableView.frame.origin.y, bizStoreDetailsTableView.frame.size.width, 480)];
        
        }
    }
    
    else
    {
        if (versionString.floatValue<7.0)
        {
            [bizStoreDetailsTableView setFrame:CGRectMake(0, 44, bizStoreDetailsTableView.frame.size.width, bizStoreDetailsTableView.frame.size.height-44)];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];

}


-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count>0) {
        
        validProduct = [response.products objectAtIndex:0];
        if ([validProduct.productIdentifier isEqualToString:@"com.biz.ttbdomaincombo"])
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:validProduct.priceLocale];
           ttbComboPrice = [numberFormatter stringFromNumber:validProduct.price];
        }
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
    
}


-(void)fetchAvailableProducts:(NSString *)productID
{
    NSSet *productIdentifiers = [NSSet setWithObjects:productID,nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101 && buttonIndex == 1)
    {
        RequestGooglePlaces *requestPlaces = [[RequestGooglePlaces alloc] init];
        
        requestPlaces.delegate = self;
        
        [requestPlaces requestGooglePlaces];
    }
}


-(void)back
{    
    if(isFromOtherViews)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
      
    }
    else
    {
        
        
        if([appDelegate.storeDetailDictionary objectForKey:@"isFromDeeplink"] == [NSNumber numberWithBool:YES])
        {
            BizStoreViewController *storeView = [[BizStoreViewController alloc] initWithNibName:@"BizStoreViewController" bundle:nil];
            [self.navigationController pushViewController:storeView animated:NO];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    UILabel *introLbl=nil;
    
    if (indexPath.row==0)
    {
        UIImageView *widgetImgView;
        
        UILabel *widgetTitleLbl;
        
        widgetBuyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        if (versionString.floatValue<7.0)
        {
            widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30,30, 85, 85)];
            
            widgetTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(135,25,85, 50)];

            [widgetBuyBtn setFrame:CGRectMake(135, 85, 90, 30)];
        }

        else
        {
            widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30,30, 85, 85)];
        
            widgetTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(135,25, 85, 50)];
            
            [widgetBuyBtn setFrame:CGRectMake(135, 85, 90, 30)];
        }
        
        if (selectedWidget == TalkToBusinessTag)
        {
            widgetTitleLbl.text=@"Talk-To-Business";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-TTB_y.png"];
            if (isTOBPurchased)
            {
                [widgetBuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
            NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.tob"];
            [widgetBuyBtn setTitle:titlePrice forState:UIControlStateNormal];
          //  [widgetBuyBtn setTitle:@"$3.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        else if(selectedWidget == ImageGalleryTag)
        {
            widgetTitleLbl.text=@"Image Gallery";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-image-gallery_y.png"];
            if (isImageGalleryPurchased)
            {
                [widgetBuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
                
             
            NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.imagegallery"];
            [widgetBuyBtn setTitle:titlePrice forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        else if (selectedWidget == AutoSeoTag)
        {
            widgetTitleLbl.text=@"Auto-SEO";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-SEO_y.png"];
            if (isAutoSeoPurchased)
            {
                [widgetBuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
                [widgetBuyBtn setTitle:@"FREE" forState:UIControlStateNormal];
                [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        else if (selectedWidget == TtbDomainCombo)
        {
            cell.contentView.backgroundColor = [UIColor whiteColor];
            if (versionString.floatValue<7.0)
            {
                widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15,15, 290, 110)];
                
                if (BOOST_PLUS)
                {
                    widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15,15, 290, 110)];
                    widgetImgView.image=[UIImage imageNamed:@"ttb+com plus.png"];
                    
                    [widgetTitleLbl setHidden:YES];

                }
                else{
                    widgetImgView.image=[UIImage imageNamed:@"offer-banner1.png"];
                    
                    [widgetTitleLbl setHidden:YES];
                }
            }
            
            else
            {
                if (BOOST_PLUS)
                {
                    widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15,15, 290, 110)];
                    widgetImgView.image=[UIImage imageNamed:@"ttb+com plus.png"];
                    
                    [widgetTitleLbl setHidden:YES];
                }
                
                else
                {
                    widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15,15, 290, 110)];
                    widgetImgView.image=[UIImage imageNamed:@"offer-banner1.png"];
                    
                    [widgetTitleLbl setHidden:YES];
                }
            }
            
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        else if (selectedWidget == BusinessTimingsTag)
        {
            widgetTitleLbl.text=@"Business Timings";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-timing_y.png"];
            if (isTimingsPurchased)
            {
                [widgetBuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
                
                NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.businesstimings"];
                [widgetBuyBtn setTitle:titlePrice forState:UIControlStateNormal];
                [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        else if (selectedWidget == GooglePlacesTag)
        {
            widgetTitleLbl.text=@"Google Places";
            widgetImgView.image=[UIImage imageNamed:@"GPlaces-yellow.png"];
            if (isGPlacesPurchased)
            {
                [widgetBuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
                [widgetBuyBtn setTitle:@"FREE" forState:UIControlStateNormal];
                [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
 
        }
        
        else if (selectedWidget == InTouchTag)
        {
        
            widgetTitleLbl.text=@"IntouchApp";
            widgetImgView.image=[UIImage imageNamed:@"intouchyellow.png"];
            [widgetTitleLbl setFrame:CGRectMake(135,25, 120, 50)];

            [widgetBuyBtn setTitle:@"FREE" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        else if (selectedWidget == NoAds)
        {
            widgetTitleLbl.text=@"Ad Free Site";
            widgetImgView.image=[UIImage imageNamed:@"Remove-Ads-widget-icont1.png"];
            if ([appDelegate.storeWidgetArray containsObject:@"NOADS"])
            {
                [widgetBuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
                NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloats.noads"];
                [widgetBuyBtn setTitle:titlePrice forState:UIControlStateNormal];
                [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }

        
        
        
        [widgetImgView  setBackgroundColor:[UIColor clearColor]];
        
        widgetTitleLbl.font=[UIFont fontWithName:@"Helvetica-Light" size:20.0];
        
        widgetTitleLbl.numberOfLines=2;
        
        widgetTitleLbl.lineBreakMode=NSLineBreakByWordWrapping;
        
        widgetTitleLbl.backgroundColor=[UIColor clearColor];
        
        widgetTitleLbl.textColor=[UIColor colorWithHexString:@"2d2d2d"];
        
        [cell.contentView addSubview:widgetImgView];

        [cell.contentView addSubview:widgetTitleLbl];
        
        [widgetBuyBtn setBackgroundColor:[UIColor colorWithHexString:@"9F9F9F"]];
        
        widgetBuyBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Light" size:14.0];
        [widgetBuyBtn setTag:selectedWidget];
        
        [widgetBuyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb900"]] forState:UIControlStateHighlighted];
        
        [widgetBuyBtn.layer setCornerRadius:3.0];

        widgetBuyBtn.titleLabel.textColor=[UIColor whiteColor];

        [cell addSubview:widgetBuyBtn];

        UILabel *yellowLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,140, 320,2)];
        
        [yellowLbl setBackgroundColor:[UIColor colorWithHexString:@"ffb900"]];
        
        [cell.contentView addSubview:yellowLbl];
    }
    
    //SET THE WIDGETBUYBTN FOR BANNER
    
    if (selectedWidget==TtbDomainCombo)
    {
        [widgetBuyBtn setFrame:CGRectMake(230,95,63,20)];
        
        [widgetBuyBtn setTintColor:[UIColor clearColor]];
        
        [widgetBuyBtn setBackgroundColor:[UIColor clearColor]];
        
        if (BOOST_PLUS)
        {
            
            widgetBuyBtn.layer.cornerRadius = 6.0;
            
            [widgetBuyBtn setTitle:@"Book" forState:UIControlStateNormal];
            
            [widgetBuyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexCode:@"5A5A5A"]] forState:UIControlStateNormal];
            
            [widgetBuyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
            
            
        }
        
        else
        {
            
            [widgetBuyBtn setImage:[UIImage imageNamed:@"banner-buy-btn.png"] forState:UIControlStateNormal];
            
            [widgetBuyBtn setTitle:@"" forState:UIControlStateNormal];
            
            [widgetBuyBtn setTitle:@"" forState:UIControlStateHighlighted];
        }
        
    }
    
    if (indexPath.row==1)
    {
        if (selectedWidget==TtbDomainCombo) {
          
            cell.contentView.backgroundColor=[UIColor colorWithHexString:@"ececec"];
            
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,10,190,30)];
            [titleLabel setText:@"Domain"];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18.0]];
            [titleLabel setTextColor:[UIColor blackColor]];
            [cell addSubview:titleLabel];
            
            
            NSString *text = @"Your domain name is your identity. So we help you dotcom your business for more trust and verification.The domain is valid for one year.";
            
            NSString *stringData;
            
            stringData=[NSString stringWithFormat:@"\n%@",text];
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14]
                                 constrainedToSize:constraint
                                     lineBreakMode:nil];
            
            introLbl=[[UILabel alloc]init];
            [introLbl setFrame:CGRectMake(CELL_CONTENT_MARGIN+5,CELL_CONTENT_MARGIN-5,254, MAX(size.height, 44.f)+5)];
            [introLbl setText:stringData];
            [introLbl setNumberOfLines:30];
            [introLbl setLineBreakMode:NSLineBreakByWordWrapping];
            if (versionString.floatValue<7.0) {
                [introLbl setTextAlignment:NSTextAlignmentLeft];
            }
            else{
                [introLbl setTextAlignment:NSTextAlignmentJustified];
            }
            introLbl.textColor=[UIColor colorWithHexString:@"4f4f4f"];
            [introLbl setFont:[UIFont fontWithName:@"Helvetica-Light" size:13.0]];
            [introLbl setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:introLbl];
            
        }

        else
        {
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"ececec"];
        

        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,10,190,30)];
        [titleLabel setText:@"Introduction"];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:titleLabel];
        
        
        NSString *text = [introductionArray objectAtIndex:selectedIndex];
        
        NSString *stringData;
        
        stringData=[NSString stringWithFormat:@"\n%@",text];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14]
                             constrainedToSize:constraint
                                 lineBreakMode:nil];

        introLbl=[[UILabel alloc]init];
        [introLbl setFrame:CGRectMake(CELL_CONTENT_MARGIN+5,CELL_CONTENT_MARGIN-5,254, MAX(size.height, 44.f)+5)];
        [introLbl setText:stringData];
        [introLbl setNumberOfLines:30];
        [introLbl setLineBreakMode:NSLineBreakByWordWrapping];
            if (versionString.floatValue<7.0)
            {
                [introLbl setTextAlignment:NSTextAlignmentLeft];
            }
            else
            {
                [introLbl setTextAlignment:NSTextAlignmentJustified];
            }
            introLbl.textColor=[UIColor colorWithHexString:@"4f4f4f"];
            [introLbl setFont:[UIFont fontWithName:@"Helvetica-Light" size:13.0]];
            [introLbl setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:introLbl];
            
        }
    }
    
    if (indexPath.row==2)
    {
        if (selectedWidget==TtbDomainCombo)
        {
            cell.contentView.backgroundColor=[UIColor colorWithHexString:@"d0d0d0"];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,10,190,30)];
            [titleLabel setText:@"Talk-To-Business"];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18.0]];
            [titleLabel setTextColor:[UIColor blackColor]];
            [cell addSubview:titleLabel];
            
            
            NSString *text = @"Let your customers contact you directly. Messages sent from the website are delivered to you instantly. Talk-To-Business is a lead generating mechanism for your business.";
            
            NSString *stringData;
            
            stringData=[NSString stringWithFormat:@"\n%@",text];
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14]
                                 constrainedToSize:constraint
                                     lineBreakMode:nil];
            
            introLbl=[[UILabel alloc]init];
            [introLbl setFrame:CGRectMake(CELL_CONTENT_MARGIN+5,CELL_CONTENT_MARGIN-5,254, MAX(size.height, 44.f)+5)];
            [introLbl setText:stringData];
            [introLbl setNumberOfLines:30];
            [introLbl setLineBreakMode:NSLineBreakByWordWrapping];
            if (versionString.floatValue<7.0) {
                [introLbl setTextAlignment:NSTextAlignmentLeft];
            }
            else
            {
                [introLbl setTextAlignment:NSTextAlignmentJustified];
            }
            introLbl.textColor=[UIColor colorWithHexString:@"282828"];
            [introLbl setFont:[UIFont fontWithName:@"Helvetica-Light" size:13.0]];
            [introLbl setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:introLbl];
            
        }
        else
        {
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"d0d0d0"];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,10,190,30)];
        [titleLabel setText:@"How it works?"];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:titleLabel];
        
        
        NSString *text = [descriptionArray objectAtIndex:selectedIndex];
        
        NSString *stringData;
        
        stringData=[NSString stringWithFormat:@"\n%@",text];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14]
                             constrainedToSize:constraint
                                 lineBreakMode:nil];
        
        introLbl=[[UILabel alloc]init];
        [introLbl setFrame:CGRectMake(CELL_CONTENT_MARGIN+5,CELL_CONTENT_MARGIN-5,254, MAX(size.height, 44.f)+5)];
        [introLbl setText:stringData];
        [introLbl setNumberOfLines:30];
        [introLbl setLineBreakMode:NSLineBreakByWordWrapping];
        if (versionString.floatValue<7.0)
        {
            [introLbl setTextAlignment:NSTextAlignmentLeft];
        }
        else
        {
            [introLbl setTextAlignment:NSTextAlignmentJustified];
        }
        introLbl.textColor=[UIColor colorWithHexString:@"282828"];
        [introLbl setFont:[UIFont fontWithName:@"Helvetica-Light" size:13.0]];
        [introLbl setBackgroundColor:[UIColor clearColor]];
            
            if (selectedWidget == GooglePlacesTag)
            {
                
                UIButton *changeAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [changeAddressBtn setFrame: CGRectMake(0, introLbl.frame.size.height-34, introLbl.frame.size.width, 44) ];
                
                [changeAddressBtn addTarget:self action:@selector(changeAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                
                [changeAddressBtn setBackgroundColor:[UIColor clearColor]];
                
                [cell addSubview:introLbl];
                
                [cell addSubview:changeAddressBtn];
            }
            else{
                [cell addSubview:introLbl];
            }
        }
    }
    
    if (indexPath.row==3)
    {
        
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"8b8b8b"];
        
        UIImageView  *screenShotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,20,cell.frame.size.width, 196)];
        
        if (selectedWidget==TtbDomainCombo)
        {
            [screenShotImageView setImage:[UIImage imageNamed:@"verisignlogo.png"]];
        }
        
        else
        {
            [screenShotImageView setImage:[UIImage imageNamed:[widgetImageArray objectAtIndex:selectedIndex]]];
        }
        
        [screenShotImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [screenShotImageView setBackgroundColor:[UIColor clearColor]];
        
        [cell addSubview:screenShotImageView];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CGFloat height;
    
    if ([indexPath row]==0)
    {
        if (selectedWidget==TtbDomainCombo)
        {
            return 142;
        }
        else
        {
            return 142;
        }
    }
    
    else if([indexPath row]==1)
    {
        NSString *stringData;
        
        if (selectedWidget==TtbDomainCombo)
        {
            stringData=[NSString stringWithFormat:@"Domain \n\nYour domain name is your identity. So we help you dotcom your business for more trust and verification. Sponsored by Verisign."];
        }
        else;
        {
            stringData=[NSString stringWithFormat:@"Introduction \n\n%@",[introductionArray objectAtIndex:selectedIndex]];
        }
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN);
    }
    
    else if([indexPath row]==2)
    {
        NSString *stringData;
        if (selectedWidget==TtbDomainCombo)
        {
            stringData= @"Talk-To-Business \n\n.Let your customers contact you directly. Messages sent from the website are delivered to you instantly. Talk-To-Business is a lead generating mechanism for your business.";
        }
        else
        {
            stringData=[NSString stringWithFormat:@"How it works \n\n%@",[descriptionArray objectAtIndex:selectedIndex]];
        }
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN);
    }

    else
    {
        return height=240;
    }
}

//Buy Top Widget button click
-(void)buyWidgetBtnClicked:(UIButton *)sender
{

    clickedTag=sender.tag;
    
    [buyingActivity showCustomActivityView];
    
     //Talk-to-business
     if (sender.tag==TalkToBusinessTag)
     {
     [mixPanel track:@"buyTalktobusiness_BtnClicked"];
     
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
    else if (sender.tag == ImageGalleryTag)
     {
      [buyingActivity hideCustomActivityView];
         
     [mixPanel track:@"buyImageGallery_btnClicked"];
         
         [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
          {
              _products = nil;
              
              if (success)
              {
                  _products = products;
                  NSLog(@"_products:%@",_products);
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
         
//     imageGalleryViewPicker.hidden = NO;
//         
//    imageGalleryToolBar.frame = CGRectMake(0, -10, 320, 44);
//    imageGallertPicker.frame = CGRectMake(0, 45,320, 200);
//    imageGalleryViewPicker.frame = CGRectMake(0, 360, 320, 208);
//    [imageGalleryViewPicker addSubview:imageGallertPicker];
//    [imageGalleryViewPicker addSubview:imageGalleryToolBar];
//    imageGalleryViewPicker.backgroundColor = [UIColor whiteColor];
//        
//     [self.view addSubview:imageGalleryViewPicker];
         

         
     
     }
     
     //Business Timings
    else if (sender.tag == BusinessTimingsTag)
     {
     
     [mixPanel track:@"buyBusinessTimeings_btnClicked"];
         
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
     else if (sender.tag == AutoSeoTag )
     {
         [mixPanel track:@"buyAutoSeo_btnClicked"];
         BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
         buyWidget.delegate=self;
         [buyWidget purchaseStoreWidget:AutoSeoTag];
     }
    
     //TTB-Domain Combo
    else if (sender.tag== TtbDomainCombo)
    {
        if([appDelegate.storeDetailDictionary objectForKey:@"RootAliasUri"] == [NSNull null])
        {
            [mixPanel track:@"ttbdomaincombo_initiatePurchaseBtnClicked"];
            
            [buyingActivity hideCustomActivityView];
            
            DomainSelectViewController *selectController=[[DomainSelectViewController alloc]initWithNibName:@"DomainSelectViewController" bundle:Nil];
            
            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:selectController];
            
            [self presentViewController:navController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"You have already purchased domain" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            alertView=nil;
        }
        
        
    }
    
    else if (sender.tag == GooglePlacesTag)
    {
        NSMutableDictionary *userSetting=[[NSMutableDictionary alloc]init];
        
        
        FileManagerHelper *fHelper=[[FileManagerHelper alloc]init];
        
        fHelper.userFpTag = appDelegate.storeTag;
        
        [buyingActivity hideCustomActivityView];
        
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
            UIAlertView *requestSucceedAlert = [[UIAlertView alloc]initWithTitle:@"Resubmit" message:@"Your request for Google places has already been submitted. Do you want to re-submit?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            
            requestSucceedAlert.tag = 101;
            
            [requestSucceedAlert show];
        }
        
    
    }
    
    else if (sender.tag == InTouchTag)
    {
        
        [mixPanel track:@"buy_intouchBtnClicked"];
        
        [buyingActivity hideCustomActivityView];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/intouchid/id480094166?ls=1&mt=8"]];
    }
    
    
    else if (sender.tag == NoAds)
    {
        [mixPanel track:@"buynoAds_btnClicked"];
        
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
             }
         }];
        
        
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
    
    if (clickedTag == 11000)
    {
        [mixPanel track:@"purchased_noAds"];
        [buyWidget purchaseStoreWidget:11000];
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
    
    [widgetBuyBtn setTitle:@"PURCHASED" forState:UIControlStateNormal];
    
    [widgetBuyBtn setEnabled:NO];
    
    if (clickedTag==TalkToBusinessTag)
    {
        isTOBPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
                
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Talk to business widget purchased successfully.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.isOnlyButton=YES;
        customPopUp.successBtnText=@"View";
        customPopUp.cancelBtnText=@"Done";
        customPopUp.tag=1100;
        [customPopUp showPopUpView];
    }
    
    
    if (clickedTag== ImageGalleryTag)
    {
        isImageGalleryPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"IMAGEGALLERY" atIndex:0];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Image gallery widget purchased successfully.";
        customPopUp.isOnlyButton=YES;
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        customPopUp.tag=1101;
        [customPopUp showPopUpView];
    
        
    }
    
    
    if (clickedTag == BusinessTimingsTag)
    {
        isTimingsPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"TIMINGS" atIndex:0];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Business Hours widget purchased successfully.";
        customPopUp.isOnlyButton=YES;
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        customPopUp.tag=1106;
        [customPopUp showPopUpView];
        
    }
    
    
    if (clickedTag == AutoSeoTag)
    {
        isAutoSeoPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"SITESENSE" atIndex:0];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Auto-SEO widget purchased successfully.";
        customPopUp.isOnlyButton=YES;
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        [customPopUp showPopUpView];
    }
    
    if (clickedTag == NoAds || clickedTag == 11000) {
        
        [appDelegate.storeWidgetArray insertObject:@"NOADS" atIndex:0];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Now enjoy an ad free website.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.isOnlyButton=YES;
        customPopUp.successBtnText=@"Ok";
        [customPopUp showPopUpView];
        
    }

    
}

-(void)buyStoreWidgetDidFail
{
    [buyingActivity hideCustomActivityView];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while adding this widget. Reach us at hello@nowfloats.com" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
}


#pragma PopUpDelegate

-(void)successBtnClicked:(id)sender;
{
}

-(void)cancelBtnClicked:(id)sender;
{

}

-(void)changeAddressBtnClicked
{
    
    BusinessAddressViewController *addressController = [[BusinessAddressViewController alloc]initWithNibName:@"BusinessAddressViewController" bundle:nil];
    
    addressController.isFromOtherViews = YES;
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addressController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma RequsestGooglePlacesDelegate


-(void)requestGooglePlacesDidSucceed
{
    [buyingActivity hideCustomActivityView];
    
    [appDelegate.storeWidgetArray insertObject:@"GPlaces" atIndex:0];
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

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *text;
    if(row == 0)
    {
        text = @"3 months";
    }
    else if (row == 1)
    {
        text = @"6 months";
    }
    else
    {
        text = @"12 months";
    }
    
    return text;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
    {
        NSLog(@"you selected this");
    }
    else if (row == 1)
    {
        NSLog(@"you selected this");
    }
    else
    {
        NSLog(@"you selected this");
    }
}

- (IBAction)donePicker:(id)sender
{
    [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         _products = nil;
         
         if (success)
         {
             _products = products;
             NSLog(@"_products:%@",_products);
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

- (IBAction)cancelPicker:(id)sender
{
   // [imageGalleryViewPicker removeFromSuperview];
}
@end
