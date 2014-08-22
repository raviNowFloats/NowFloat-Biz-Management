//
//  ProPackController.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 13/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "ProPackController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"
#import "BizStoreIAPHelper.h"
#import "BuyStoreWidget.h"

@interface ProPackController ()<BuyStoreWidgetDelegate,SKProductsRequestDelegate>
{
    int viewHeight;
    
    NSString *versionString;
    
     NSArray *_products;
    
    UIButton *buyButton;
}

@end

@implementation ProPackController

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
    
    versionString=[[UIDevice currentDevice]systemVersion];
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    mixPanel = [Mixpanel sharedInstance];
    
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
      //   bizStoreDetailsTableView.separatorInset=UIEdgeInsetsZero;
        
     //   self.navigationItem.backBarButtonItem.title = @"NFStore";
        
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

    priceButton.tag = 1017;
   
    
    [mainScroll addSubview:priceButton];
    
    featureLabel.textColor = [UIColor colorFromHexCode:@"#6e6e6e"];
    
    mainScroll.contentSize = CGSizeMake(320, 620);
    
    mainScroll.scrollEnabled = YES;
    
    [self setScrollViews];
   
}

-(void)setScrollViews
{
    
     NSString *titlePrice = [appDelegate.productDetailsDictionary objectForKey:@"com.biz.nowfloatsthepropack"];
    buyButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 137, 240, 30)];
    [buyButton setTitleColor:[UIColor colorFromHexCode:@"#ffb900"] forState:UIControlStateNormal];
    [buyButton setTitle:titlePrice forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    [buyButton addTarget:self action:@selector(buyWidget:) forControlEvents:UIControlEventTouchUpInside];
   
    buyButton.layer.borderColor = [UIColor colorFromHexCode:@"#ffb900"].CGColor;
    buyButton.layer.borderWidth = 1;
    
    buyButton.layer.cornerRadius = 5.0;
    buyButton.layer.masksToBounds = YES;
   
    [self.view addSubview:buyButton];
   
    
    
    UIImageView *dotComImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 248, 50, 13)];
    dotComImageView.image = [UIImage imageNamed:@"com.png"];
    [mainScroll addSubview:dotComImageView];
    
    UILabel *domainHeadText = [[UILabel alloc] initWithFrame:CGRectMake(100, 215, 220, 20)];
    domainHeadText.text = @"Your Own Domain";
    domainHeadText.font = [UIFont fontWithName:@"Helvetica-Neue" size:17.0];
    domainHeadText.textColor = [UIColor colorFromHexCode:@"#535353"];
    [mainScroll addSubview:domainHeadText];
    
    UILabel *domainText = [[UILabel alloc] initWithFrame:CGRectMake(100, 220, 220, 80)];
    domainText.text = @"If you already have a domain with your existing site, we will integrate your NowFloats site with the same";
    domainText.numberOfLines = 3;
    domainText.textAlignment = NSTextAlignmentLeft;
    domainText.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    domainText.textColor = [UIColor colorFromHexCode:@"#858585"];
    [mainScroll addSubview:domainText];
    
    UIImageView *adFreeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 320, 30, 30)];
    adFreeImageView.image = [UIImage imageNamed:@"Block-Ads.png"];
    [mainScroll addSubview:adFreeImageView];
    
    UILabel *adFreeHeadText = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 220, 20)];
    adFreeHeadText.text = @"Ad Free Site";
    adFreeHeadText.font = [UIFont fontWithName:@"Helvetica-Neue" size:17.0];
    adFreeHeadText.textColor = [UIColor colorFromHexCode:@"#535353"];
    [mainScroll addSubview:adFreeHeadText];
    
    UILabel *adFreeText = [[UILabel alloc] initWithFrame:CGRectMake(100, 305, 220, 80)];
    adFreeText.text = @"If you already have a domain with your existing site, we will integrate your NowFloats site with the same";
    adFreeText.numberOfLines = 3;
    adFreeText.textAlignment = NSTextAlignmentLeft;
    adFreeText.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    adFreeText.textColor = [UIColor colorFromHexCode:@"#858585"];
    [mainScroll addSubview:adFreeText];
    
    
    UIImageView *ttbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 420, 30, 30)];
    ttbImageView.image = [UIImage imageNamed:@"ttbDetail.png"];
    [mainScroll addSubview:ttbImageView];
    
    UILabel *ttbHeadText = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 220, 20)];
    ttbHeadText.text = @"Business Enquiries";
    ttbHeadText.font = [UIFont fontWithName:@"Helvetica-Neue" size:17.0];
    ttbHeadText.textColor = [UIColor colorFromHexCode:@"#535353"];
    [mainScroll addSubview:ttbHeadText];
    
    UILabel *ttbText = [[UILabel alloc] initWithFrame:CGRectMake(100, 405, 220, 80)];
    ttbText.text = @"If you already have a domain with your existing site, we will integrate your NowFloats site with the same";
    ttbText.numberOfLines = 3;
    ttbText.textAlignment = NSTextAlignmentLeft;
    ttbText.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    ttbText.textColor = [UIColor colorFromHexCode:@"#858585"];
    [mainScroll addSubview:ttbText];
    
    
    
    UIImageView *galleryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 500, 30, 30)];
    galleryImageView.image = [UIImage imageNamed:@"galleryDetail.png"];
    [mainScroll addSubview:galleryImageView];
    
    UILabel *galleryHeadText = [[UILabel alloc] initWithFrame:CGRectMake(100, 490, 220, 20)];
    galleryHeadText.text = @"Image Gallery";
    galleryHeadText.font = [UIFont fontWithName:@"Helvetica-Neue" size:17.0];
    galleryHeadText.textColor = [UIColor colorFromHexCode:@"#535353"];
    [mainScroll addSubview:galleryHeadText];
    
    UILabel *galleryText = [[UILabel alloc] initWithFrame:CGRectMake(100, 495, 220, 80)];
    galleryText.text = @"If you already have a domain with your existing site, we will integrate your NowFloats site with the same";
    galleryText.numberOfLines = 3;
    galleryText.textAlignment = NSTextAlignmentLeft;
    galleryText.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    galleryText.textColor = [UIColor colorFromHexCode:@"#858585"];
    [mainScroll addSubview:galleryText];
    
    
}


-(void)back
{
     [self.navigationController popViewControllerAnimated:YES];
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

-(void)buyStoreWidgetDidSucceed
{
    
    [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
    [appDelegate.storeWidgetArray insertObject:@"NOADS" atIndex:1];
    [appDelegate.storeWidgetArray insertObject:@"IMAGEGALLERY" atIndex:2];
    [appDelegate.storeWidgetArray insertObject:@"TIMINGS" atIndex:3];
    
}


-(void)buyStoreWidgetDidFail
{
   
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while adding this widget. Reach us at ria@nowfloats.com" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
}


- (IBAction)buyWidget:(id)sender
{
    
        [mixPanel track:@"buyTalktobusiness_BtnClicked"];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[5];
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             else
             {
                 
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@":(" message:@"Looks like something went wrong. Check back later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
             }
         }];

    
}

- (void)productPurchased:(NSNotification *)notification
{
    BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
    
    buyWidget.delegate=self;
    
   
        
        [mixPanel track:@"purchased_propack"];
    
        [buyWidget purchaseStoreWidget:1100];
    
        [buyWidget purchaseStoreWidget:1008];
    
        
        [buyWidget purchaseStoreWidget:1004];
  
        [buyWidget purchaseStoreWidget:1006];
         
        [buyWidget purchaseStoreWidget:11000];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
