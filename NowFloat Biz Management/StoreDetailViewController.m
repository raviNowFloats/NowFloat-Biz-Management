//
//  StoreDetailViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"
#import "AddWidgetController.h"
#import "DomainSelectViewController.h"
#import "AddWidgetController.h"
#import <StoreKit/StoreKit.h>
#import "BizStoreIAPHelper.h"
#import "BizWebViewController.h"


@interface StoreDetailViewController ()<AddWidgetDelegate>
{
    NSArray *_products;

}
@end

@implementation StoreDetailViewController
@synthesize buttonTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];
    
    
    if (buttonTag==1001 || buttonTag ==2001)
    {
        if ([appDelegate.storeRootAliasUri length]==0)
        {
            [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
            
        }
        
        else
        {
            [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
            [buyButton setEnabled:NO];
        
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    [detailImageView  setImage:[self setDetailImage:buttonTag]];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height==480)
        {

            [topBackgroundImageView setFrame:CGRectMake(topBackgroundImageView.frame.origin.x+10, topBackgroundImageView.frame.origin.y,280,topBackgroundImageView.frame.size.height)];

            
            [bottomBackgroundIMageView setFrame:CGRectMake(bottomBackgroundIMageView.frame.origin.x+10, bottomBackgroundIMageView.frame.origin.y,280,312)];
            
            [buyButton setFrame:CGRectMake(buyButton.frame.origin.x,378, buyButton.frame.size.width, buyButton.frame.size.height)];
            
            [textViewBgScrollView setFrame:CGRectMake(textViewBgScrollView.frame.origin.x,textViewBgScrollView.frame.origin.y, textViewBgScrollView.frame.size.width, textViewBgScrollView.frame.size.height-90)];
        
            [lineLabel setFrame:CGRectMake(lineLabel.frame.origin.x, lineLabel.frame.origin.y-87, lineLabel.frame.size.width, lineLabel.frame.size.height)];
         
            textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height+150);
            
            if (buttonTag==2001)
            {
            
                textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height+90);

            }
            
            
            if (buttonTag==2002)
            {
            
                textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height+200);

            }
            
            
            if (buttonTag==2004)
            {
            
                textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height+110);

            
            }
            
            if (buttonTag==2006) {

                textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height);
                
            }
            
            

        }
        
        
        else{
        
            
            if (buttonTag==1001)
            {

            textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height+25);
            }
        
            
            if (buttonTag==1002)
            {
                textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height+120);
            
            }
            
            
            if (buttonTag==1004)
            {
                textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height+50);
            }
            
            if (buttonTag==1006) {
                
                textViewBgScrollView.contentSize=CGSizeMake(textViewBgScrollView.frame.size.width,textViewBgScrollView.frame.size.height);

            }

            
        }
        
    }
    
    bottomBackgroundIMageView.layer.cornerRadius=12.0;
    bottomBackgroundIMageView.layer.masksToBounds = YES;
    bottomBackgroundIMageView.layer.needsDisplayOnBoundsChange=YES;
    bottomBackgroundIMageView.layer.shouldRasterize=YES;
    [bottomBackgroundIMageView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];

    
    UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
    
    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setFrame:CGRectMake(5,9,32,26)];
    
    [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];

    [activitySubView setHidden:YES];
    
    
    if (buttonTag==1001 || buttonTag ==2001)
    {
        
        if ([appDelegate.storeRootAliasUri length]==0)
        {
            [buyButton setTitle:@"Buy" forState:UIControlStateNormal];

        }
        
        else
        {
            [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
            [buyButton setEnabled:NO];
        }
    }
    
    
    if ([appDelegate.storeWidgetArray containsObject:@"TOB"])

    {
        if (buttonTag==1002 || buttonTag ==2002)
        {
            [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
            [buyButton setEnabled:NO];
        }
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
    {
    
        if (buttonTag==1004 || buttonTag ==2004)
        {
            [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
            [buyButton setEnabled:NO];
        }
    
    }
    
    
    
    if ([appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
    {
        
        if (buttonTag==1006 || buttonTag ==2006)
        {
            [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
            [buyButton setEnabled:NO];
        }
        
    }

    
    
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIImage *)setDetailImage:(int)tag
{

    UIImage *detailImage;
    
    if (buttonTag==1001 || buttonTag==2001)
    {
        detailImage=[UIImage imageNamed:@"storedetaildomain.png"];
        
        productName.text=@"Personalised Domain";
        
        productPrice.text=@"$14.99";
        
        buyButton.tag=101;
        
        productDescriptionTextView.text=@"Having your own domain will create an authentic identity for your brand. A dot-com for your business will not only boost your credibility it will also be easier to share with your clients & contacts.businessname.com is classier than just a businessname.nowfloats.com";
        
    }
    
    if (buttonTag==1002 || buttonTag==2002)
    {
        detailImage=[UIImage imageNamed:@"storedetailttb.png"];
        
        productName.text=@"Talk To Business";
        
        productPrice.text=@"$3.99";
        
        buyButton.tag=102;
        
        
        [descriptionImageView setImage:[UIImage imageNamed:@"productdescriptionTTB.png"]];
        
        [descriptionImageView setFrame:CGRectMake(descriptionImageView.frame.origin.x, descriptionImageView.frame.origin.y, descriptionImageView.frame.size.width, 173)];
        
        [productDescriptionTextView setFrame:CGRectMake(productDescriptionTextView.frame.origin.x, descriptionImageView.frame.size.height+20, productDescriptionTextView.frame.size.width, productDescriptionTextView.frame.size.height)];
        
        productDescriptionTextView.text=@"Visitors to your site can contact you directly by leaving a message with their phone number or email address. You will get these messages instantly over email and can see them in your NowFloats app inbox at any time. Talk To Business is a lead generating mechanism for your business.";
        
        
        
    }
    

    if (buttonTag==1003 || buttonTag==2003)
    {

        detailImage=[UIImage imageNamed:@"storedetailpicturemessage.png"];
        productName.text=@"Picture Message";

    }
    

    if (buttonTag==1004 || buttonTag==2004)
    {

        detailImage=[UIImage imageNamed:@"storedetailimagegallery.png"];
        
        productName.text=@"Image Gallery";
        
        productPrice.text=@"$2.99";
        
        buyButton.tag=103;
        
        [descriptionImageView setFrame:CGRectMake(descriptionImageView.frame.origin.x, descriptionImageView.frame.origin.x, descriptionImageView.frame.size.width, 122)];
        
        [descriptionImageView setImage:[UIImage imageNamed:@"descriptionImage.jpg"]];
        
        [productDescriptionTextView setFrame:CGRectMake(productDescriptionTextView.frame.origin.x, descriptionImageView.frame.size.height+20, productDescriptionTextView.frame.size.width, productDescriptionTextView.frame.size.height)];
        
        productDescriptionTextView.text=@"Some people are visual. They might not have the patience to read through your website. An image gallery on the site with good pictures of your products and services might just grab their attention. Upload upto 25 pictures and showcase your offerings.";
        
    }
    
    
    
    
    
    if (buttonTag==1006 || buttonTag==2006)
    {
        detailImage=[UIImage imageNamed:@"storeDetailTimings.png"];
        
        productPrice.text=@"$0.99";
        
        productName.text=@"Business Timings";
        
        [descriptionImageView setFrame:CGRectMake(descriptionImageView.frame.origin.x, descriptionImageView.frame.origin.x, descriptionImageView.frame.size.width, 122)];
        
        [descriptionImageView setImage:[UIImage imageNamed:@"timingsScreenshot.jpg"]];

        
        [productDescriptionTextView setFrame:CGRectMake(productDescriptionTextView.frame.origin.x, descriptionImageView.frame.size.height+20 , productDescriptionTextView.frame.size.width, productDescriptionTextView.frame.size.height)];
        
        productDescriptionTextView.text=@"Visitors to your site would like to drop in at your store. Let them know when you are open and when you aren’t.";
        
        buyButton.tag=106;

    }
    

    return detailImage;

}



- (IBAction)buyBtnClicked:(id)sender
{
    
    
    [activitySubView setHidden:NO];
    
    UIButton *btn=(UIButton *)sender;
    
    clickedTag=btn.tag;
    
    
    if (clickedTag==101 || clickedTag==201)
    {
        
        [activitySubView setHidden:YES];
        
        DomainSelectViewController *domainSelectController=[[DomainSelectViewController alloc]initWithNibName:@"DomainSelectViewController" bundle:nil];
        
        [self.navigationController pushViewController:domainSelectController animated:YES];
        
        
    }
    
    
    if (clickedTag == 202 || clickedTag== 102)
    {
        
        [customCancelButton setEnabled:NO];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 /*
                  for (int i=0; i<_products.count; i++)
                  {
                  SKProduct *product = [_products objectAtIndex:i];
                  
                  NSLog(@"Available %@...at %d", product.productIdentifier,i);
                  }
                  */
                 SKProduct *product = _products[2];
                 NSLog(@"Buying %@...", product.productIdentifier);
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             else
             {
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
                 [activitySubView setHidden:YES];
                 [customCancelButton setEnabled:YES];
             }
             
             
         }];
    }
    
    
    
    if (clickedTag == 203 || clickedTag== 103)
    {
        
        [customCancelButton setEnabled:NO];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;

                 SKProduct *product = _products[1];
                 NSLog(@"Buying %@...", product.productIdentifier);
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             
             else
             {
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
                 [activitySubView setHidden:YES];
                 [customCancelButton setEnabled:YES];
             }
         }];

        }
    
    if (clickedTag == 206 || clickedTag== 106)
    {
        
        [customCancelButton setEnabled:NO];
        
        [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             _products = nil;
             
             if (success)
             {
                 _products = products;
                 
                 SKProduct *product = _products[0];
                 NSLog(@"Buying %@...", product.productIdentifier);
                 [[BizStoreIAPHelper sharedInstance] buyProduct:product];
             }
             
             
             else
             {
                 UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Could not populate list of products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alertView show];
                 alertView=nil;
                 [activitySubView setHidden:YES];
                 [customCancelButton setEnabled:YES];
             }
         }];

    
    
    }
    
    
    
    
}



#pragma AddWidgetDelegate
-(void)addWidgetDidSucceed
{
    
    [activitySubView setHidden:YES];
    [customCancelButton setEnabled:YES];

    if (buyButton.tag == 101  || buyButton.tag==201 )
    {
        [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
        
        [buyButton setEnabled:NO];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Domain name purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        
        [successAlert show];
        
        successAlert=nil;
        
    }
    
    
    if (buyButton.tag == 102  || buyButton.tag==202 )
    {
        [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
        
        [buyButton setEnabled:NO];

        [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Talk to business widget purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        
        successAlert.tag=1100;
        
        [successAlert show];
        
        successAlert=nil;
        
    }
    
    
    if (buyButton.tag == 103  || buyButton.tag==203 )
    {
        [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
        
        [buyButton setEnabled:NO];
        
        [appDelegate.storeWidgetArray insertObject:@"IMAGEGALLERY" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Image gallery widget purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        
        successAlert.tag=1101;

        [successAlert show];
        
        successAlert=nil;
    }
    
    
    if (buyButton.tag == 106  || buyButton.tag==206 )
    {
        [buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
        
        [buyButton setEnabled:NO];
        
        [appDelegate.storeWidgetArray insertObject:@"TIMINGS" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Business timings widget purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        
        successAlert.tag=1106;
        
        [successAlert show];
        
        successAlert=nil;
    }
    

    
    
    
}


-(void)addWidgetDidFail
{
    
    [activitySubView setHidden:YES];
    [customCancelButton setEnabled:YES];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong.Call our customer care for support at +91 9160004303" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
    
    /*
    if (clickedTag==101 || clickedTag==201)
    {
        
        
    }
    
    
    if (clickedTag ==102  || clickedTag==202 )
    {
        
        
    }
    
    if (clickedTag == 103  || clickedTag==203 )
    {
        
        
        
    }
    */
}


- (void)productPurchased:(NSNotification *)notification
{
    
    if (clickedTag==102 || clickedTag==202)
    {

        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
        [NSString stringWithFormat:@"com.biz.nowfloats.tob"],@"clientProductId",
        [NSString stringWithFormat:@"Talk to business"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:3.99],@"paidAmount",
        [NSString stringWithFormat:@"TOB"],@"widgetKey",
        nil];
        
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];

    }
    
    
    if (clickedTag==103 || clickedTag==203)
    {

        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
        [NSString stringWithFormat:@"com.biz.nowfloats.imagegallery"],@"clientProductId",
        [NSString stringWithFormat:@"Image gallery"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:2.99],@"paidAmount",
        [NSString stringWithFormat:@"IMAGEGALLERY"],@"widgetKey",
        nil];
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];
        
    }
    
    
    if (clickedTag==106 || clickedTag==206)
    {
        
        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
[NSString stringWithFormat:@"com.biz.nowfloats.businesstimings"],@"clientProductId",
        [NSString stringWithFormat:@"Business timings"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:0.99],@"paidAmount",
        [NSString stringWithFormat:@"TIMINGS"],@"widgetKey",
        nil];
                
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];
        
    }

    
    
}


-(void)removeProgressSubview
{
    [activitySubView setHidden:YES];
    [customCancelButton setEnabled:YES];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"The transaction was not completed. Sorry to see you go. If this was by mistake please re-initiate transaction in store by hitting Buy" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

{
    
    
    if (alertView.tag==1100 || alertView.tag==1101 || alertView.tag==1106)
    {
        
        if (buttonIndex==1) {
            
            
            BizWebViewController *webViewController=[[BizWebViewController alloc]initWithNibName:@"BizWebViewController" bundle:nil];
            
            [self presentModalViewController:webViewController animated:YES];
            
            webViewController=nil;
            
            
            
        }
        
        
    }
    
    
}


@end
