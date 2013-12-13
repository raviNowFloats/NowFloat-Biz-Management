//
//  StoreViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 26/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"
#import "StoreDetailViewController.h"
#import "DomainSelectViewController.h"
#import "AddWidgetController.h"
#import <StoreKit/StoreKit.h>
#import "BizStoreIAPHelper.h"
#import "BizWebViewController.h"


@interface StoreViewController ()<AddWidgetDelegate>
{
    NSInteger *currentPage;
    int clickedTag;
    NSArray *_products;
}

@end

@implementation StoreViewController
@synthesize scrollView,pageControl,productSubViewsArray,pageViews,bottomBarScrollView,bottomBarImageArray,currentScrollPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.productSubViewsArray.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
    
    if (currentScrollPage!=0)
    {
        
        if (currentScrollPage==1)
        {
            
            [self.scrollView setContentOffset:CGPointMake(pagesScrollViewSize.width*currentScrollPage, 0) animated:NO];
            
            currentScrollPage =0;
            
        }
        
        
        if (currentScrollPage==2)
        {
            [self.scrollView setContentOffset:CGPointMake(pagesScrollViewSize.width*currentScrollPage, 0) animated:YES];
            
            currentScrollPage =0;
        }
        
    }


    if ([appDelegate.storeRootAliasUri length]==0)
    {
        for (UIButton *button in purchaseDomainButton)
        {
            if (button.tag==101 || button.tag==201)
            {
                [button setEnabled:YES];
                [button setTitle:@"Purchase" forState:UIControlStateNormal];
            }
        }
    }
    
    else
    {
        for (UIButton *button in purchaseDomainButton)
        {
            if (button.tag==101 || button.tag==201)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
            
        }
        
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"TOB"])
    {
        for (UIButton *button in purchaseTtbButton)
        {
            if (button.tag==102 || button.tag==202)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"IMAGEGALLERY"])
    {
        
        for (UIButton *button in purchaseImageGallery)
        {
            if (button.tag==103 || button.tag==203)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        
        
    }
    
    
    if ([appDelegate.storeWidgetArray containsObject:@"TIMINGS"])
    {
        for (UIButton *button in purchaseBusinessTimings)
        {
            if (button.tag==106 || button.tag==206)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        
    }

    
    if ([appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        for (UIButton *button in purchaseAutoSeo)
        {
            if (button.tag==108 || button.tag==208)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];
}




- (void)viewWillDisappear:(BOOL)animated
{
    
    currentScrollPage=0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self.scrollView setBackgroundColor:[UIColor greenColor]];
    
    
    
    [activitySubView setHidden:YES];
    
    activitySubView.center=self.view.center;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
    
    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            self.productSubViewsArray=[NSArray arrayWithObjects:talkToBusinessSubViewiPhone4,storeImageGalleryiPhone4,storeBusinessTimingsiPhone4,storeSeoPluginiPhone4, nil];
            
            if (version.floatValue<7.0)
            {

            [customCancelButton setFrame:CGRectMake(5,9,32,26)];//9

            self.scrollView.frame=CGRectMake(30,65,259,443);
                
            [self.scrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

            self.pageControl.frame=CGRectMake(150,8, 38, 10);
            
            [bottomBarSubView setFrame:CGRectMake(0,result.height-40,result.width,20)];
            
            }
            
            else
            {
            
                [navBar setFrame:CGRectMake(0,-20, 320, 84)];
                
                [titleLbl setFrame:CGRectMake(0, 40, titleLbl.frame.size.width, titleLbl.frame.size.height)];

                [customCancelButton setFrame:CGRectMake(5,50,32,26)];//9

                self.scrollView.frame=CGRectMake(30,75,259,443);
                
                [self.scrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
                
                self.pageControl.frame=CGRectMake(150,8,38,10);
                
            }
        }
        
        else
        {
            if (version.floatValue>=7.0)
            {
                
                [customCancelButton setFrame:CGRectMake(5,30,32,26)];//9

                [navBar setFrame:CGRectMake(0,-20,320,64)];

                [contentSubview setFrame:CGRectMake(contentSubview.frame.origin.x, contentSubview.frame.origin.y+20, contentSubview.frame.size.width, contentSubview.frame.size.height)];
                
                [titleLbl setFrame:CGRectMake(0, 20, titleLbl.frame.size.width, titleLbl.frame.size.height)];
            }
            
            
            else
            {
                [customCancelButton setFrame:CGRectMake(5,9,32,26)];//9

            }
            self.productSubViewsArray=[NSArray arrayWithObjects:talkToBusinessSubview,storeImageGallery,storeBusinessTimings,storeSeoPlugin, nil];
        }
        
    }
    
    self.navigationController.navigationBarHidden=YES;
    
    [navBar setBackgroundColor:[UIColor colorWithHexString:@"3E3E3E"]];
    
    [bottomBarSubView setBackgroundColor:[UIColor colorWithHexString:@"242424"]];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
    
    [navBar addSubview:customCancelButton];

    
    NSInteger pageCount = self.productSubViewsArray.count;

    
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"ffb900"];
    
    self.pageControl.currentPage = 0;
    
    self.pageControl.numberOfPages = pageCount;

    self.pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews addObject:[NSNull null]];
    }
    
    
}


-(void)back
{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}


-(void)loadVisiblePages
{
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));

    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++)
    {
        [self purgePage:i];
    }
    
    for (NSInteger i=firstPage; i<=lastPage; i++)
    {
        [self loadPage:i];
    }
    
    for (NSInteger i=lastPage+1; i<self.productSubViewsArray.count; i++)
    {
        [self purgePage:i];
    }


    currentPage=page;
    
    
}


- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.productSubViewsArray.count)
    {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first checking if you've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    
    if ((NSNull*)pageView == [NSNull null])
    {
        //CGRect frame = self.scrollView.bounds;
        
        CGRect frame=CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
        frame.origin.x = frame.size.width * page;
        
        frame.origin.y = 0.0f;
        
        frame = CGRectInset(frame,10.0f, 0.0f);
        
        UIView *newPageView = [productSubViewsArray objectAtIndex:page];
        
        newPageView.frame = frame;
        
        [self.scrollView addSubview:newPageView];
        
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
        
        
    }
    
}


- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.productSubViewsArray.count)
    {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
    
}


-(void)positionBottomBarContents:(NSInteger *)page
{
/*
    NSNumber *currentPage=[NSNumber numberWithInteger:page];
    
    
    if (currentPage.intValue==0)
    {
        self.bottomBarScrollView.contentOffset = CGPointMake(0,0);
    }
    
    if (currentPage.intValue==1)
    {
        self.bottomBarScrollView.contentOffset = CGPointMake(40,0);
    }

    if (currentPage.intValue==2)
    {
        self.bottomBarScrollView.contentOffset = CGPointMake(90,0);
    }
    
    if (currentPage.intValue==3)
    {
        self.bottomBarScrollView.contentOffset = CGPointMake(150,0);
    }
    
    if (currentPage.intValue==4)
    {
        self.bottomBarScrollView.contentOffset = CGPointMake(190,0);
    }
*/
}


- (void)matchScrollView:(UIScrollView *)firstScrollView toScrollView:(UIScrollView *)secondScrollView
{
    
    NSNumber *pageNumber=[NSNumber numberWithInteger:currentPage];
    
    /*
    CGPoint offset = firstScrollView.contentOffset;
    offset.x = secondScrollView.contentOffset.x/4-5;
    [firstScrollView setContentOffset:offset];
     */
    

    if (pageNumber.intValue==0)
    {
        CGPoint offset = firstScrollView.contentOffset;
        offset.x = secondScrollView.contentOffset.x/5;
        [firstScrollView setContentOffset:offset];
    }
    
    
    if (pageNumber.intValue==1) {

        
        CGPoint offset = firstScrollView.contentOffset;
        offset.x = secondScrollView.contentOffset.x/5+8;
        [firstScrollView setContentOffset:offset];
        
    }
    
    if (pageNumber.intValue==2) {
        
        
        CGPoint offset = firstScrollView.contentOffset;
        offset.x = secondScrollView.contentOffset.x/5+16;
        [firstScrollView setContentOffset:offset];
        
        
    }

    
    
    if (pageNumber.intValue==3) {
        
        
        CGPoint offset = firstScrollView.contentOffset;
        offset.x = secondScrollView.contentOffset.x/5+25;
        [firstScrollView setContentOffset:offset];
        
        
    }

    
    if (pageNumber.intValue==4) {
        
        
        
        CGPoint offset = firstScrollView.contentOffset;
        offset.x = secondScrollView.contentOffset.x/5+32;
        [firstScrollView setContentOffset:offset];

    }

    

    
}


#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    // Load the pages that are now on screen
    
    [self loadVisiblePages];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)moreInfoBtnClicked:(id)sender
{
    
    UIButton *clickedButton=(UIButton *)sender;
    
    int buttonTag=clickedButton.tag;
    
    NSLog(@"buttonTag:%d",buttonTag);
    
    StoreDetailViewController *storeDetailController=[[StoreDetailViewController alloc]initWithNibName:@"StoreDetailViewController" bundle:nil];
    
    storeDetailController.buttonTag=buttonTag;
    
    [self.navigationController pushViewController:storeDetailController animated:YES];
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
    
    
    
    if (clickedTag == 207 || clickedTag ==107)
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
                 //[[BizStoreIAPHelper sharedInstance] buyProduct:product];
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

    
    if (clickedTag == 208 || clickedTag ==108)
    {
        [customCancelButton setEnabled:NO];
        
        NSDictionary *productDescriptionDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:
        appDelegate.clientId,@"clientId",
        [NSString stringWithFormat:@"com.biz.nowfloats.sitesense"],@"clientProductId",
        [NSString stringWithFormat:@"Auto-SEO"],@"NameOfWidget" ,
        [userDefaults objectForKey:@"userFpId"],@"fpId",
        [NSNumber numberWithInt:12],@"totalMonthsValidity",
        [NSNumber numberWithDouble:0.00],@"paidAmount",
        [NSString stringWithFormat:@"SITESENSE"],@"widgetKey",
        nil];
        
        
        AddWidgetController *addController=[[AddWidgetController alloc]init];
        
        addController.delegate=self;
        
        [addController addWidgetsForFp:productDescriptionDictionary];
    }
}


- (void)productPurchased:(NSNotification *)notification
{

    if (clickedTag == 202 || clickedTag== 102)
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
    
    if (clickedTag == 203 || clickedTag== 103)
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
    
    
    if (clickedTag == 206 || clickedTag== 106)
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
}


-(void)removeProgressSubview
{
    [activitySubView setHidden:YES];
    [customCancelButton setEnabled:YES];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"The transaction was not completed. Sorry to see you go. If this was by mistake please re-initiate transaction in store by hitting Buy" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    alertView=nil;
}


#pragma AddWidgetDelegate

-(void)addWidgetDidSucceed
{
    [activitySubView setHidden:YES];
    [customCancelButton setEnabled:YES];
    
    if (clickedTag==101 || clickedTag==201)
    {
        for (UIButton *button in purchaseDomainButton)
        {
            if (button.tag==101 || button.tag==201)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Domain name purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        
        [successAlert show];
        
        successAlert=nil;
        
    }
    
    
    if (clickedTag ==102  || clickedTag==202 )
    {
        for (UIButton *button in purchaseTtbButton)
        {
            if (button.tag==102 || button.tag==202)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        [appDelegate.storeWidgetArray insertObject:@"TOB" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Talk to business widget purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"View", nil];
        
        successAlert.tag=1100;
        
        [successAlert show];
        
        successAlert=nil;
        
    }
    
    
    if (clickedTag == 103  || clickedTag==203 )
    {
        for (UIButton *button in purchaseImageGallery)
        {
            if (button.tag==103 || button.tag==203)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        [appDelegate.storeWidgetArray insertObject:@"IMAGEGALLERY" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Image gallery widget purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"View", nil];
        
                successAlert.tag=1101;
        
        [successAlert show];
        
        successAlert=nil;
    }
    
    
    if (clickedTag == 106  || clickedTag==206 )
    {
    
        for (UIButton *button in purchaseBusinessTimings)
        {
            if (button.tag==106 || button.tag==206)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        [appDelegate.storeWidgetArray insertObject:@"TIMINGS" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Business timings widget purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"View", nil];
        
        successAlert.tag=1106;
        
        [successAlert show];
        
        successAlert=nil;
    }
    
    
    if (clickedTag == 107 || clickedTag == 207)
    {
        for (UIButton *button in purchaseAutoSeo)
        {
            if (button.tag==107 || button.tag==207)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        
        [appDelegate.storeWidgetArray insertObject:@"SUBSCRIBERS" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Subscribers widget purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"View", nil];
        
        successAlert.tag=1106;
        
        [successAlert show];
        
        successAlert=nil;
    }
    
    
    
    if (clickedTag == 108  || clickedTag==208 )
    {
        for (UIButton *button in purchaseAutoSeo)
        {
            if (button.tag==108 || button.tag==208)
            {
                [button setEnabled:NO];
                [button setTitle:@"Purchased" forState:UIControlStateNormal];
            }
        }
        
        [appDelegate.storeWidgetArray insertObject:@"SITESENSE" atIndex:0];
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Auto-SEO plugin purchased successfully" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Ok", nil];
        
        [successAlert show];
        
        successAlert=nil;

    }

    
    
}



-(void)addWidgetDidFail
{
    
    [activitySubView setHidden:YES];
    [customCancelButton setEnabled:YES];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Something went wrong while adding this widget.Call our customer care for support at +91 9160004303" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
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





#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

{
    if (alertView.tag==1100 ||alertView.tag==1101 || alertView.tag==1106)
    {
        if (buttonIndex==1)
        {
            BizWebViewController *webViewController=[[BizWebViewController alloc]initWithNibName:@"BizWebViewController" bundle:nil];
            
            [self presentModalViewController:webViewController animated:YES];
            
            webViewController=nil;
        }
    }


}



@end
