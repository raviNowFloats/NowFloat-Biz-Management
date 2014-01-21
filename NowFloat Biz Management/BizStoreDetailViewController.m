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
#import "Mixpanel.h"

#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f



@interface BizStoreDetailViewController ()<BuyStoreWidgetDelegate>
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
    BOOL isTOBPurchased,isTimingsPurchased,isImageGalleryPurchased,isAutoSeoPurchased;
    UIButton *widgetBuyBtn;

    
    
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

    
    buyingActivity=[[NFActivityView alloc]init];
    
    buyingActivity.activityTitle=@"Buying";
    
    versionString=[[UIDevice currentDevice]systemVersion];
    
    mixPanel=[Mixpanel sharedInstance];
    
    introductionArray=[[NSMutableArray alloc]initWithObjects:
                       @"Let your customers follow you directly. Messages are delivered from the website to your app and phone inbox instantly",
                       @"Show off your wares or services offered in a neatly arranged picture gallery.",
                       @"Visitors to your site would like to drop in at your store. Let them know when you are open and when you aren’t.",
                       @"Ensure every update you post and your website is optimised for search results. This plugin enhances of you being discovered considerably.",
                       nil];
    
    
    descriptionArray=[[NSMutableArray alloc]initWithObjects:
                      @"Visitors to your site can contact you directly by leaving a message with their phone number or email address. You will get these messages instantly over email and can see them in your NowFloats app inbox at any time. Talk To Business is a lead generating mechanism for your business.",
                      @"Some people are visual. They might not have the patience to read through your website. An image gallery on the site with good pictures of your products and services might just grab their attention. Upload upto 25 pictures and showcase your offerings.",
                      @"Visitors to your site would like to drop in at your store. Let them know when you are open and when you aren’t.",
                      @"Ensure every update you post and your website is optimised for search results. This plugin enhances of you being discovered considerably." ,nil];
    
    widgetImageArray=[[NSMutableArray alloc]initWithObjects:@"NFBizstore-Detail-ttb.png",@"NFBizstore-Detail-imggallery.png",@"NFBizstore-Detail-timings.png",@"NFBizstore-Detail-autoseo.png", nil];
    
    
    
    
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
            
        default:
            break;
    }

    if (versionString.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];

        UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
        
        customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customCancelButton setImage:buttonImage forState:UIControlStateNormal];
        
        [customCancelButton setTitleColor:[UIColor colorWithHexString:@"464646"] forState:UIControlStateNormal];
        
        customCancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        
        [customCancelButton setFrame:CGRectMake(5,0,50,44)];
        
        [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [customCancelButton setShowsTouchWhenHighlighted:YES];
        
        [navBar addSubview:customCancelButton];
        

    }
    
    else
    {
        bizStoreDetailsTableView.separatorInset=UIEdgeInsetsZero;
        
        
        if (isFromOtherViews)
        {
            self.navigationController.navigationBarHidden=NO;
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
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


-(void)back
{
    if (isFromOtherViews)
    {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
    
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
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

            [widgetBuyBtn setFrame:CGRectMake(135, 85, 85, 30)];

        }
        else
        {
            widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30,30, 85, 85)];
        
            widgetTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(135,25, 85, 50)];
            
            [widgetBuyBtn setFrame:CGRectMake(135, 85, 85, 30)];
        }
        

        
        
        if (selectedWidget == TalkToBusinessTag)
        {
            widgetTitleLbl.text=@"Talk-To-Business";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-TTB_y.png"];
            if (isTOBPurchased)
            {
                [widgetBuyBtn setTitle:@"Purchased" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
            [widgetBuyBtn setTitle:@"$3.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        if (selectedWidget == ImageGalleryTag)
        {
            widgetTitleLbl.text=@"Image Gallery";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-image-gallery_y.png"];
            if (isImageGalleryPurchased)
            {
                [widgetBuyBtn setTitle:@"Purchased" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
            [widgetBuyBtn setTitle:@"$2.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        if (selectedWidget == AutoSeoTag)
        {
            widgetTitleLbl.text=@"Auto-SEO";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-SEO_y.png"];
            if (isAutoSeoPurchased)
            {
                [widgetBuyBtn setTitle:@"Purchased" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
                [widgetBuyBtn setTitle:@"FREE" forState:UIControlStateNormal];
                [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        if (selectedWidget == BusinessTimingsTag)
        {
            widgetTitleLbl.text=@"Business Timings";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-timing_y.png"];
            if (isTimingsPurchased)
            {
                [widgetBuyBtn setTitle:@"Purchased" forState:UIControlStateNormal];
                [widgetBuyBtn setEnabled:NO];
            }
            else
            {
                [widgetBuyBtn setTitle:@"$0.99" forState:UIControlStateNormal];
                [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        
        [widgetImgView  setBackgroundColor:[UIColor clearColor]];
        
        widgetTitleLbl.font=[UIFont fontWithName:@"Helvetica-Light" size:20.0];
        
        widgetTitleLbl.numberOfLines=2;
        
        widgetTitleLbl.lineBreakMode=UILineBreakModeWordWrap;
        
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
    
    if (indexPath.row==1)
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
    
    if (indexPath.row==2)
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
    
    if (indexPath.row==3)
    {
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"8b8b8b"];
        
        UIImageView  *screenShotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,20,cell.frame.size.width, 196)];
        
        [screenShotImageView setImage:[UIImage imageNamed:[widgetImageArray objectAtIndex:selectedIndex]]];
        
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
        return 142;
    }
    
    else if([indexPath row]==1)
    {
        NSString *stringData=[NSString stringWithFormat:@"Introduction \n\n%@",[introductionArray objectAtIndex:selectedIndex]];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN);
    }
    
    else if([indexPath row]==2)
    {
        NSString *stringData=[NSString stringWithFormat:@"How it works \n\n%@",[descriptionArray objectAtIndex:selectedIndex]];
        
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
     
     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alertView show];
     alertView=nil;
     }
     }];
     }
     
     //Business Timings
     if (sender.tag == BusinessTimingsTag)
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
     
     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alertView show];
     alertView=nil;
     }
     }];
     
     }

     //Auto-SEO
     if (sender.tag == AutoSeoTag )
     {
        BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
        buyWidget.delegate=self;
        [buyWidget purchaseStoreWidget:AutoSeoTag];
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
    
    [widgetBuyBtn setTitle:@"Purchased" forState:UIControlStateNormal];
    
    [widgetBuyBtn setEnabled:NO];
    
    if (clickedTag==TalkToBusinessTag)
    {
        isTOBPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Talk to business widget purchased successfully." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"View", nil];
        
        successAlert.tag=1100;
        
        [successAlert show];
        
        successAlert=nil;
    }
    
    
    if (clickedTag== ImageGalleryTag)
    {
        isImageGalleryPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"IMAGEGALLERY" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Image gallery widget purchased successfully." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"View", nil];
        
        successAlert.tag=1101;
        
        [successAlert show];
        
        successAlert=nil;
    }
    
    
    if (clickedTag == BusinessTimingsTag)
    {
        isTimingsPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"TIMINGS" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Business timings widget purchased successfully." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"View", nil];
        
        successAlert.tag=1106;
        
        [successAlert show];
        
        successAlert=nil;
    }
    
    
    if (clickedTag == AutoSeoTag)
    {
        isAutoSeoPurchased=YES;
        [appDelegate.storeWidgetArray insertObject:@"SITESENSE" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Auto-SEO plugin purchased successfully." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Ok", nil];
        
        [successAlert show];
        
        successAlert=nil;
    }
    
}

-(void)buyStoreWidgetDidFail
{
    [buyingActivity hideCustomActivityView];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while adding this widget.Call our customer care for support at +91 9160004303" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
