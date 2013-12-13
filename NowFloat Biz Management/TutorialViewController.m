//
//  TutorialViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "TutorialViewController.h"
#import "UIColor+HexaString.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"

#define LEFT_EDGE_OFSET 0




@interface TutorialViewController ()<UIScrollViewDelegate>
{
    double WIDTH_OF_SCROLL_PAGE;
    double HEIGHT_OF_SCROLL_PAGE;
    double WIDTH_OF_IMAGE;
    double HEIGHT_OF_IMAGE;
}
@end

@implementation TutorialViewController


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
    
    [bottomLabel setBackgroundColor:[UIColor whiteColor]];
    
    tutorialImageArray=[[NSMutableArray alloc]init];
    
    self.navigationController.navigationBarHidden=YES;
    
    /*
    UIImage *iphone4Tutorial1=[UIImage imageNamed:@"Newtutorialscreen1.png"];
    UIImage *iphone4Tutorial2=[UIImage imageNamed:@"Newtutorialscreen2.png"];
    UIImage *iphone4Tutorial3=[UIImage imageNamed:@"Newtutorialscreen3.png"];
    UIImage *iphone4Tutorial4=[UIImage imageNamed:@"Newtutorialscreen4.png"];
    UIImage *iphone4Tutorial5=[UIImage imageNamed:@"Newtutorialscreen5.png"];
    UIImage *iphone4Tutorial6=[UIImage imageNamed:@"Newtutorialscreen6.png"];

    
    UIImage *iphone5Tutorial1=[UIImage imageNamed:@"Newtutorialscreen1-568h@2x.png"];
    UIImage *iphone5Tutorial2=[UIImage imageNamed:@"Newtutorialscreen2-568h@2x.png"];
    UIImage *iphone5Tutorial3=[UIImage imageNamed:@"Newtutorialscreen3-568h@2x.png"];
    UIImage *iphone5Tutorial4=[UIImage imageNamed:@"Newtutorialscreen4-568h@2x.png"];
    UIImage *iphone5Tutorial5=[UIImage imageNamed:@"Newtutorialscreen5-568h@2x.png"];
    UIImage *iphone5Tutorial6=[UIImage imageNamed:@"Newtutorialscreen6-568h@2x.png"];
     */
    
   // iphone4TutorialImageArray=[[NSMutableArray alloc]initWithObjects:iphone4Tutorial1,iphone4Tutorial2,iphone4Tutorial3,iphone4Tutorial4,iphone4Tutorial5,iphone4Tutorial6, nil];

    
   // iphone5TutorialImageArray=[[NSMutableArray alloc]initWithObjects:iphone5Tutorial1,iphone5Tutorial2,iphone5Tutorial3,iphone5Tutorial4,iphone5Tutorial5,iphone5Tutorial6,nil];


    
    version = [[UIDevice currentDevice] systemVersion];

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {

            
            if (version.floatValue>=7.0)
            {
                
            [tutorialImageArray addObject:@"Newtutorialscreen1.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen2.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen3.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen4.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen5.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen6.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen7.png"];
                
            WIDTH_OF_SCROLL_PAGE= 320;
            HEIGHT_OF_SCROLL_PAGE= 436;
            WIDTH_OF_IMAGE =320;
            
            HEIGHT_OF_IMAGE =436;

            [bottomBarSignInButton  setFrame:CGRectMake(160,436, 160, 44)];
            [bottomBarSignInButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];
            
            [bottomBarRegisterButton setFrame:CGRectMake(0,436, 160, 44)];
            [bottomBarRegisterButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];

            
            CGRect frame=CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 436);
            
            [bottomLabel setFrame:CGRectMake(0, 436, [[UIScreen mainScreen] bounds].size.width, 44)];
            
            [tutorialScrollView setFrame:frame];

            
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(115,380, 116, 20)];
            pageControl.numberOfPages =tutorialImageArray.count;
            [pageControl sizeToFit];
            [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
            [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];
            
            [self.view addSubview:pageControl];
            }
            
            
            
            else
            {
                [tutorialImageArray addObject:@"iOS6Newtutorialscreen1.png"];
                [tutorialImageArray addObject:@"iOS6Newtutorialscreen2.png"];
                [tutorialImageArray addObject:@"iOS6Newtutorialscreen3.png"];
                [tutorialImageArray addObject:@"iOS6Newtutorialscreen4.png"];
                [tutorialImageArray addObject:@"iOS6Newtutorialscreen5.png"];
                [tutorialImageArray addObject:@"iOS6Newtutorialscreen6.png"];
                [tutorialImageArray addObject:@"iOS6Newtutorialscreen7.png"];

                WIDTH_OF_SCROLL_PAGE= 320;
                HEIGHT_OF_SCROLL_PAGE= 416;
                WIDTH_OF_IMAGE =320;
                
                HEIGHT_OF_IMAGE =416;
                
                [bottomBarSignInButton  setFrame:CGRectMake(160,416, 160, 44)];
                [bottomBarSignInButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];
                
                [bottomBarRegisterButton setFrame:CGRectMake(0,416, 160, 44)];
                [bottomBarRegisterButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];
                
                
                CGRect frame=CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 416);
                
                [bottomLabel setFrame:CGRectMake(0, 416, [[UIScreen mainScreen] bounds].size.width, 44)];
                
                [tutorialScrollView setFrame:frame];
                
                
                pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(115,360, 116, 20)];
                pageControl.numberOfPages =tutorialImageArray.count;
                [pageControl sizeToFit];
                [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
                [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];
                
                [self.view addSubview:pageControl];
            }
            
        }
        
        else
        {
            
            
            if (version.floatValue>=7.0)
            {
        
            WIDTH_OF_SCROLL_PAGE= 320;
            HEIGHT_OF_SCROLL_PAGE= 524;
            WIDTH_OF_IMAGE =320;
            HEIGHT_OF_IMAGE =524;

            [tutorialImageArray addObject:@"Newtutorialscreen1-568h@2x.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen2-568h@2x.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen3-568h@2x.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen4-568h@2x.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen5-568h@2x.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen6-568h@2x.png"];
            [tutorialImageArray addObject:@"Newtutorialscreen7-568h@2x.png"];

            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(115,470,80, 20)];
            pageControl.numberOfPages = tutorialImageArray.count;
            [pageControl sizeToFit];
            [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
            [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];
            [self.view addSubview:pageControl];
                
            }
            
            else
            {
            
            
            
            
                WIDTH_OF_SCROLL_PAGE= 320;
                HEIGHT_OF_SCROLL_PAGE= 504;
                WIDTH_OF_IMAGE =320;
                HEIGHT_OF_IMAGE =504;
                
                [tutorialImageArray addObject:@"Newtutorialscreen1-568h@2x.png"];
                [tutorialImageArray addObject:@"Newtutorialscreen2-568h@2x.png"];
                [tutorialImageArray addObject:@"Newtutorialscreen3-568h@2x.png"];
                [tutorialImageArray addObject:@"Newtutorialscreen4-568h@2x.png"];
                [tutorialImageArray addObject:@"Newtutorialscreen5-568h@2x.png"];
                [tutorialImageArray addObject:@"Newtutorialscreen6-568h@2x.png"];
                [tutorialImageArray addObject:@"Newtutorialscreen7-568h@2x.png"];
                
                pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(115,450,80, 20)];
                pageControl.numberOfPages = tutorialImageArray.count;
                [pageControl sizeToFit];
                [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
                [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];
                [self.view addSubview:pageControl];

                [bottomLabel setFrame:CGRectMake(0, 504, [[UIScreen mainScreen] bounds].size.width, 44)];

                [bottomBarSignInButton  setFrame:CGRectMake(160,504, 160, 44)];
                [bottomBarSignInButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];
                
                [bottomBarRegisterButton setFrame:CGRectMake(0,504, 160, 44)];
                [bottomBarRegisterButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];

            }
            
        }
    
    }
    
    

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[tutorialImageArray objectAtIndex:([tutorialImageArray count]-1)]]];
    imageView.frame = CGRectMake(LEFT_EDGE_OFSET, 0, WIDTH_OF_IMAGE, HEIGHT_OF_IMAGE);
    [tutorialScrollView addSubview:imageView];

 
    for (int i = 0;i<[tutorialImageArray count];i++)
    {
    	//loop this bit
    	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[tutorialImageArray objectAtIndex:i]]];
    	imageView.frame = CGRectMake((WIDTH_OF_IMAGE * i) + LEFT_EDGE_OFSET + 320, 0, WIDTH_OF_IMAGE, HEIGHT_OF_IMAGE);
    	[tutorialScrollView addSubview:imageView];
    	//
    }

    
    
    //add the first image at the end
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[tutorialImageArray objectAtIndex:0]]];
    imageView.frame = CGRectMake((WIDTH_OF_IMAGE * ([tutorialImageArray count] + 1)) + LEFT_EDGE_OFSET, 0, WIDTH_OF_IMAGE, HEIGHT_OF_IMAGE);
    [tutorialScrollView addSubview:imageView];
    
    
    
    [tutorialScrollView setContentSize:CGSizeMake(WIDTH_OF_SCROLL_PAGE * ([tutorialImageArray count] + 2), HEIGHT_OF_IMAGE)];
    [tutorialScrollView setContentOffset:CGPointMake(0, 0)];

    [tutorialScrollView scrollRectToVisible:CGRectMake(WIDTH_OF_IMAGE,0,WIDTH_OF_IMAGE,HEIGHT_OF_IMAGE) animated:NO];

    
}




-(void)pushRegisterViewController
{
    SignUpViewController *registerController=[[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil ];
    
    [self.navigationController pushViewController:registerController animated:YES];
    
    registerController=nil;
}



-(void)pushLoginViewController
{

    LoginViewController *loginController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    [self.navigationController pushViewController:loginController animated:YES];

    
    loginController=nil;
}


#pragma UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{

    [scrollTimer invalidate];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible

    CGFloat pageWidth = tutorialScrollView.frame.size.width;
    
    int page = floor((tutorialScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
//    NSLog(@"page:%d",page);
    
    if (page!=1)
    {
        [bottomLabel setBackgroundColor:[UIColor colorWithHexString:@"ffb900"]];
    }
    
    else
    {
    
        [bottomLabel setBackgroundColor:[UIColor whiteColor]];

    }
    
    
    if (page==1)
    {
        
        
        [bottomBarSignInButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];

        [bottomBarRegisterButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];

    }
    
    else
    {

        [bottomBarSignInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [bottomBarRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    
        pageControl.currentPage = page-1;

}

/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   w=scrollView.contentOffset.x;
    
}
*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    w=scrollView.contentOffset.x;

    int currentPage = floor((tutorialScrollView.contentOffset.x - tutorialScrollView.frame.size.width / ([tutorialImageArray count]+2)) / tutorialScrollView.frame.size.width) + 1;
    if (currentPage==0)
    {
    	[tutorialScrollView scrollRectToVisible:CGRectMake(WIDTH_OF_IMAGE * [tutorialImageArray count],0,WIDTH_OF_IMAGE,HEIGHT_OF_IMAGE) animated:NO];
        
    }
    else if (currentPage==([tutorialImageArray count]+1))
    {
    	[tutorialScrollView scrollRectToVisible:CGRectMake(WIDTH_OF_IMAGE,0,WIDTH_OF_IMAGE,HEIGHT_OF_IMAGE) animated:NO];
    }
    
}


- (IBAction)finalRegisterBtnClicked:(id)sender
{
    [self setUpSignUpViewController];
}


- (IBAction)finalLoginBtnClicked:(id)sender
{
    [self setUpLoginViewController];

}


- (IBAction)bottomBarRegisterBtnClicked:(id)sender
{
    [self setUpSignUpViewController];

}


- (IBAction)bottomBarLoginBtnClicked:(id)sender
{
    [self setUpLoginViewController];
}


-(void)setUpSignUpViewController
{

    SignUpViewController *signUpController=[[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    
    [self.navigationController pushViewController: signUpController animated:YES];
    
    signUpController=nil;

}


-(void)setUpLoginViewController
{
    [self pushLoginViewController];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    tutorialScrollView = nil;
    bottomLabel = nil;
    bottomBarSignInButton = nil;
    bottomBarRegisterButton = nil;
    finalRegisterButton = nil;
    finalSignInButton = nil;
    finalSubView = nil;
    getStartedSubView = nil;
    [super viewDidUnload];
}


-(void)viewDidAppear:(BOOL)animated
{
    scrollTimer= [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

}


-(void)viewDidDisappear:(BOOL)animated
{

    [scrollTimer invalidate];

}


- (void)onTimer
{

     w += 320;
     
     if (w==1920+320+320)
     {
         w=320;
         [tutorialScrollView setContentOffset:CGPointMake(w,0) animated:YES];
     
     }
     
     [tutorialScrollView setContentOffset:CGPointMake(w,0) animated:YES];
    
}



@end
