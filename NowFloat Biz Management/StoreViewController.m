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


@interface StoreViewController ()
{

    NSInteger *currentPage;
}
@end

@implementation StoreViewController
@synthesize scrollView,pageControl,productSubViewsArray,pageViews,bottomBarScrollView,bottomBarImageArray;

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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self.scrollView setBackgroundColor:[UIColor greenColor]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
        
            self.scrollView.frame=CGRectMake(30,60,259,433);
            
            self.productSubViewsArray=[NSArray arrayWithObjects:websiteDomainSubviewiPhone4,talkToBusinessSubViewiPhone4,pictureMessageSubviewiPhone4,storeImageGalleryiPhone4,storeSocialSharingiPhone4, nil];
            
            [self.scrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

            self.pageControl.frame=CGRectMake(141,400, 38, 36);
            
            [bottomBarSubView setFrame:CGRectMake(0,result.height-50,result.width, 50)];
        }
        
        else
        {
        
            self.productSubViewsArray=[NSArray arrayWithObjects:websiteDomainSubView,talkToBusinessSubview,pictureMessageSubview ,storeImageGallery,storeSocialSharing, nil];

        }
            
    }
    
    self.navigationController.navigationBarHidden=YES;
    
    [navBar setBackgroundColor:[UIColor colorWithHexString:@"3E3E3E"]];
    
    [bottomBarSubView setBackgroundColor:[UIColor colorWithHexString:@"242424"]];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
    
    UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
    
    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setFrame:CGRectMake(5,9,32,26)];
    
    [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];

    
    NSInteger pageCount = self.productSubViewsArray.count;

    self.pageControl.currentPage = 0;
    
    self.pageControl.numberOfPages = pageCount;

    self.pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews addObject:[NSNull null]];
    }
    
    
        UIImage *img1=[UIImage imageNamed:@"domainBottomBar.png"];
        UIImage *img2=[UIImage imageNamed:@"talktobusinessBottomBar.png"];
        UIImage *img3=[UIImage imageNamed:@"pictmsgBottomBar.png"];
        UIImage *img4=[UIImage imageNamed:@"imagegalleryBottomBar.png"];
        UIImage *img5=[UIImage imageNamed:@"socialSharingBottomBar.png"];
    
    self.bottomBarImageArray=[NSArray arrayWithObjects:img1,img2,img3,img4,img5,nil];

    
    for(int i = 0; i< self.bottomBarImageArray.count; i++)
    {
        
        CGFloat xOrigin = i*60;
    
        buttonImageView= [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin+141,6,38, 38)];
        
        [buttonImageView setImage:[self.bottomBarImageArray objectAtIndex:i]];
        
        buttonImageView.tag=i;
        
        
        if (i==0) {
            
            buttonImageView.alpha=0.8;
            
        }
        
        else
        {
            buttonImageView.alpha=0.2;
        }
        
        
        [self.bottomBarScrollView addSubview:buttonImageView];
        
    }
    
    self.bottomBarScrollView.contentSize = CGSizeMake(180 * self.bottomBarImageArray.count,38);

    
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
    if (_scrollView.tag==101)
    {
        [self loadVisiblePages];
        
        [self matchScrollView:self.bottomBarScrollView toScrollView:self.scrollView];
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (_scrollView.tag==101)
    {
        
        NSNumber *pageNumber=[NSNumber numberWithInteger:currentPage];
        

        for (int i=0; i<self.productSubViewsArray.count; i++)
        {

            imgView=(UIImageView *)[self.bottomBarScrollView viewWithTag:i];
            
            
            if (pageNumber.intValue==0)
            {
                
                
                if (pageNumber.intValue==0 && imgView.tag==0)
                {
                    imgView.alpha=0.8;
                }
                else
                    
                {
                    imgView.alpha=0.2;
                }
                
                
            }

            
           else if (pageNumber.intValue==1)
            {


                if (pageNumber.intValue==1 && imgView.tag==1)
                {
                    imgView.alpha=0.8;
                }
                
                else
                    
                {
                    imgView.alpha=0.2;
                }
            
            }
            
            
            else if (pageNumber.intValue==2)
            {
               
                if (pageNumber.intValue==2 && imgView.tag==2)
                {
                    imgView.alpha=0.8;
                }
                else
                    
                {
                    imgView.alpha=0.2;
                }
 
            }
            
            
            
           else if (pageNumber.intValue==3) {
                
                
                if (pageNumber.intValue==3 && imgView.tag==3)
                {
                    imgView.alpha=0.8;
                }
                
                else
                    
                {
                    imgView.alpha=0.2;
                }
                
                
            }

            
           else if (pageNumber.intValue==4){
                
                
                if (pageNumber.intValue==4 && imgView.tag==4)
                {
                    imgView.alpha=0.8;
                }
                
                else
                    
                {
                    imgView.alpha=0.2;
                }
            }

        }
        
        
        self.bottomBarScrollView.alpha=1.0;
        
    }
    


}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
