//
//  NFInstaPurchase.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 20/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "NFInstaPurchase.h"
#import "AppDelegate.h"
#import "UIColor+HexaString.h"
#import "UIImage+ImageWithColor.h"
#import "Mixpanel.h"
#import "NFActivityView.h"
#import "BizStoreIAPHelper.h"
#import "BuyStoreWidget.h"
#import "PopUpView.h"


#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002
#define NoAds 1100

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f

@interface NFInstaPurchase ()<BuyStoreWidgetDelegate,PopUpDelegate>
{
    NSString *versionString;
    AppDelegate *appDelegate;
    double viewHeight;
    int selectedIndex;
    UIButton *widgetBuyBtn;
    double clickedTag;
    Mixpanel *mixPanel;
    NFActivityView *buyingActivity;
    NSArray *_products;
    BOOL isPurchased;
}
@end

@implementation NFInstaPurchase
@synthesize containerView;
@synthesize introductionArray,descriptionArray,titleArray,priceArray,widgetImageArray,selectedWidget,delegate;


-(id)init
{
    NFInstaPurchase *customPopUp=[[[NSBundle mainBundle] loadNibNamed:@"NFInstaPurchase"
                owner:self
                options:nil]
                lastObject];
    
    if ([customPopUp isKindOfClass:[customPopUp class]])
    {
        return customPopUp;
    }
    else
    {
        return nil;
    }
}


-(void)layoutSubviews
{
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    versionString=[UIDevice currentDevice].systemVersion;
    
    mixPanel=[Mixpanel sharedInstance];
    
    buyingActivity=[[NFActivityView alloc]init];
    
    buyingActivity.activityTitle=@"buying";
    
    isPurchased=NO;
    
    introductionArray=[[NSMutableArray alloc]initWithObjects:
                       @"Let your customers contact you directly. Messages sent from the website are delivered to you instantly. Talk-To-Business is a lead generating mechanism for your business.",
                       @"Show off your wares or services offered in a neatly arranged picture gallery.",
                       @"Visitors to your site would like to drop in at your store. Let them know when you are open and when you aren’t.",
                       @"The Auto-SEO plugin optimizes your content for search results and enhances the discovery of your website.",@"Remove ads from your NowFloats site by purchasing this widget.",
                       nil];
    
    
    descriptionArray=[[NSMutableArray alloc]initWithObjects:
                      @" Visitors to your site can contact you directly by leaving a message with their phone number or email address. You will get these messages instantly over email and can see them in your NowFloats app at any time. Revert back to these leads quickly and generate business.",
                      @"Some people are visual. They might not have the patience to read through your website. An image gallery on the site with good pictures of your products and services might just grab their attention. Upload upto 25 pictures.",
                      @"Once you set timings for your store, a widget shows up on your site telling the visitors when your working hours are. It is optimized for visitors on mobile too.",
                      @"When you post an update, it is analysed and keywords are generated. These keywords are tagged to your content so that search engines can get better context about your content. This gives better search results for relevant queries.",@"There is a teeny cost for us to provide you with a site and the app.It is still free forever for if you don't mind the ads.So go ahead, go ad free. Make your good looking NowFloats site even better.",nil];
    
    
    widgetImageArray=[[NSMutableArray alloc]initWithObjects:@"NFBizstore-Detail-ttb.png",@"NFBizstore-Detail-imggallery.png",@"NFBizstore-Detail-timings.png",@"NFBizstore-Detail-autoseo.png",@"AdSense LayOut1.jpg", nil];
    
    
    
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
            
        case NoAds:
            selectedIndex =4;
            break;
            
        default:
            break;
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
    
    if (versionString.floatValue<7.0)
    {
        
    }
    
    else
    {
        [instaPurchaseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    self.containerView.alpha = 1;
    
    
    containerView.center=self.window.center;
/*
    [UIView animateWithDuration:0.5 animations:^{self.containerView.alpha = 1.0;}];
    
    self.containerView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.5;
    bounceAnimation.removedOnCompletion = NO;
    [self.containerView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    self.containerView.layer.transform = CATransform3DIdentity;
*/
    
    self.containerView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:1],
                              [NSNumber numberWithFloat:1],
                              [NSNumber numberWithFloat:1], nil];
    bounceAnimation.duration = 0.7;
    bounceAnimation.removedOnCompletion = NO;
    [self.containerView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    self.containerView.layer.transform = CATransform3DIdentity;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];

}


#pragma UITableView

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
        
        UIImageView *bgImageView;
        
        widgetBuyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        cell.backgroundColor=[UIColor colorWithHexString:@"ffffff"];
        
        widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(17,17,80,80)];
        
        widgetTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(114,12,75, 50)];
        
        bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 114)];
        
        [bgImageView setBackgroundColor:[UIColor whiteColor]];
        
        [cell.contentView addSubview:bgImageView];
        
        [widgetBuyBtn setFrame:CGRectMake(114,67, 85, 30)];
        
        if (selectedWidget == TalkToBusinessTag)
        {
            widgetTitleLbl.text=@"Talk-To-Business";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-TTB_y.png"];
            [widgetBuyBtn setTitle:@"$3.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        if (selectedWidget == ImageGalleryTag)
        {
            widgetTitleLbl.text=@"Image Gallery";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-image-gallery_y.png"];
            [widgetBuyBtn setTitle:@"$2.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        if (selectedWidget == AutoSeoTag)
        {
            widgetTitleLbl.text=@"Auto-SEO";
            [widgetBuyBtn setTitle:@"FREE" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (selectedWidget == BusinessTimingsTag)
        {
            widgetTitleLbl.text=@"Business Hours";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-timing_y.png"];
            [widgetBuyBtn setTitle:@"$0.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        if (selectedWidget  == NoAds)
        {
            widgetTitleLbl.text=@"Ad Free Site";
            widgetImgView.image=[UIImage imageNamed:@"removeads.png"];
            [widgetBuyBtn setTitle:@"$3.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [widgetImgView  setBackgroundColor:[UIColor clearColor]];
        
        widgetTitleLbl.font=[UIFont fontWithName:@"Helvetica-Light" size:18.0];
        
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
        
        UILabel *yellowLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,112, 320,2)];
        [yellowLbl setBackgroundColor:[UIColor colorWithHexString:@"ffb900"]];
        [cell.contentView addSubview:yellowLbl];
    }
    
    if (indexPath.row==1)
    {
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"ececec"];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(17,10,115,30)];
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
        [introLbl setFrame:CGRectMake(17,CELL_CONTENT_MARGIN-5,229, MAX(size.height, 44.f)+5)];
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
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(17,10,190,30)];
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
        [introLbl setFrame:CGRectMake(17,CELL_CONTENT_MARGIN-5,229, MAX(size.height, 44.f)+5)];
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
        //cell.backgroundColor=[UIColor colorWithHexString:@"8b8b8b"];
        
       UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 228)];
        
        [bgImageView setBackgroundColor:[UIColor colorWithHexString:@"8b8b8b"]];
        
        [cell.contentView addSubview:bgImageView];

        UIScrollView *imageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(17,17,cell.frame.size.width, 196)];
        
        [imageScrollView setBackgroundColor:[UIColor clearColor]];
        
        imageScrollView.showsHorizontalScrollIndicator=NO;
        
        [imageScrollView setScrollsToTop:NO];
        
        [imageScrollView setContentSize:CGSizeMake(390,196)];
        
        UIImageView  *screenShotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,299,196)];
        
        [screenShotImageView setImage:[UIImage imageNamed:[widgetImageArray objectAtIndex:selectedIndex]]];
        
        [screenShotImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [screenShotImageView setBackgroundColor:[UIColor clearColor]];
        
        [imageScrollView addSubview:screenShotImageView];
        
        [cell addSubview:imageScrollView];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CGFloat height;
    
    if ([indexPath row]==0)
    {
        return 114;
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
        return height=228;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == instaPurchaseTableView)
    {
        if (scrollView.contentOffset.y < 0)
        {
            [instaPurchaseTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        }
        

        if (scrollView.contentOffset.y > 280)
        {
            [instaPurchaseTableView setBackgroundColor:[UIColor clearColor]];
        }

        
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
    
    
    if (sender.tag == NoAds) {
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
                 
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
             }
         }];

        
    }
}

-(void)buyStoreWidgetDidFail
{
    
    [buyingActivity hideCustomActivityView];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while adding this widget.Call our customer care for support at +91 9160004303" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;

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
    
    
    if (clickedTag == NoAds) {
        [mixPanel track:@"purchased_noAds"];
        [buyWidget purchaseStoreWidget:NoAds];
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

    isPurchased=YES;
    
    if (clickedTag==TalkToBusinessTag)
    {
        [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
        
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
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Business timings widget purchased successfully.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        customPopUp.tag=1106;
        [customPopUp showPopUpView];
    }
    
    if (clickedTag == AutoSeoTag)
    {
        [appDelegate.storeWidgetArray insertObject:@"SITESENSE" atIndex:0];
        
        PopUpView *customPopUp=[[PopUpView alloc]init];
        customPopUp.delegate=self;
        customPopUp.titleText=@"Thank you!";
        customPopUp.descriptionText=@"Auto-SEO widget purchased successfully.";
        customPopUp.popUpImage=[UIImage imageNamed:@"thumbsup.png"];
        customPopUp.successBtnText=@"Ok";
        customPopUp.cancelBtnText=@"Done";
        [customPopUp showPopUpView];

    }
    
    if (clickedTag == NoAds) {
        
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

#pragma PopUpDelegate

-(void)successBtnClicked:(id)sender;
{
    [buyingActivity hideCustomActivityView];
    
    if (isPurchased)
    {
        if ([delegate respondsToSelector:@selector(instaPurchaseViewDidClose)])
        {
            [delegate performSelector:@selector(instaPurchaseViewDidClose)];            
        }
    }
}

-(void)cancelBtnClicked:(id)sender;
{
    [buyingActivity hideCustomActivityView];
    
    if (isPurchased)
    {
        if ([delegate respondsToSelector:@selector(instaPurchaseViewDidClose)])
        {
            [delegate performSelector:@selector(instaPurchaseViewDidClose)];
        }
    }
}

- (IBAction)closeBtnClicked:(id)sender
{
    [self closeInstantBuyPopUpView];
}

-(void)showInstantBuyPopUpView
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

-(void)closeInstantBuyPopUpView
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
