//
//  TutorialViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "TutorialViewController.h"
#import "IntroControll.h"
#import "UIColor+HexaString.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"


@interface TutorialViewController ()<UIScrollViewDelegate>
{

    IntroModel *model1;
    IntroModel *model2;
    IntroModel *model3;
    IntroModel *model4;
    IntroModel *model5;
    IntroModel *model6;
    
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
    
    self.navigationController.navigationBarHidden=YES;
    
    
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

    
    iphone4TutorialImageArray=[[NSMutableArray alloc]initWithObjects:iphone4Tutorial1,iphone4Tutorial2,iphone4Tutorial3,iphone4Tutorial4,iphone4Tutorial5,iphone4Tutorial6, nil];

    
    iphone5TutorialImageArray=[[NSMutableArray alloc]initWithObjects:iphone5Tutorial1,iphone5Tutorial2,iphone5Tutorial3,iphone5Tutorial4,iphone5Tutorial5,iphone5Tutorial6,nil];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=result.height;
            
            viewWidth=result.width;
/*
[self setTutorialImageForIphone4];
self.view = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,416) pages:@[model1, model2, model3,model4,model5,model6]];
*/
            [bottomBarSignInButton  setFrame:CGRectMake(160,436, 160, 44)];
            [bottomBarSignInButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];

            [bottomBarRegisterButton setFrame:CGRectMake(0,436, 160, 44)];
            [bottomBarRegisterButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];
            
//            [finalRegisterButton setFrame:CGRectMake(92, 166, 150, 150)];
//            [finalSignInButton setFrame:CGRectMake(220,415,80, 44)];
            
            
            tutorialScrollView.pagingEnabled = YES;
            
            CGRect frame=CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 436);
            
            [bottomLabel setFrame:CGRectMake(0, 436, [[UIScreen mainScreen] bounds].size.width, 44)];
            
            [tutorialScrollView setFrame:frame];
            
            NSInteger numberOfViews = [iphone4TutorialImageArray count];
            
            UIImageView *tutorialView;
            
            for (int i = 0; i < numberOfViews; i++)
            {
                CGFloat xOrigin = i * frame.size.width;
                
                
                if (i==6)
                {
                    [tutorialScrollView setFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,460)];
                    
                    tutorialView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,frame.size.width, frame.size.height+44)];
                    
                    [tutorialView addSubview:finalSubView];
                    
                    [tutorialView setUserInteractionEnabled:YES];
                    
                }
                
                else
                {
                    tutorialView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,frame.size.width, frame.size.height)];
                    [tutorialView setImage:[iphone4TutorialImageArray objectAtIndex:i]];

                }
                
                [tutorialScrollView addSubview:tutorialView];
                
            }
            
            tutorialScrollView.contentSize = CGSizeMake(frame.size.width * numberOfViews,   frame.size.height);
            
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(115,380, 116, 20)];
            pageControl.numberOfPages = iphone4TutorialImageArray.count;
            [pageControl sizeToFit];
            [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
            [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];
            
            [self.view addSubview:pageControl];
            
        }
        
        else
        {
            viewHeight=result.height;
/*
            [self setTutorialImageForIphone5];
            self.view = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,504) pages:@[model1, model2, model3,model4,model5,model6]];
*/
            viewWidth=result.width;

            [bottomBarSignInButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];
            [bottomBarRegisterButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];
            
            [getStartedSubView setFrame:CGRectMake(0,63, 320, 96)];
                        
            tutorialScrollView.pagingEnabled = YES;
            
            CGRect frame=CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,524);
            
            [tutorialScrollView setFrame:frame];
            
            NSInteger numberOfViews = [iphone5TutorialImageArray count];
            
            UIImageView *tutorialView;
            
            for (int i = 0; i < numberOfViews; i++)
            {
                CGFloat xOrigin = i * frame.size.width;
                
                if (i==6)
                {                    
                    [tutorialScrollView setFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,568)];
                    
                    tutorialView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,frame.size.width, frame.size.height+44)];
                    
                    [tutorialView setUserInteractionEnabled:YES];
                    
                    [tutorialView addSubview:finalSubView];

                    //[tutorialView setBackgroundColor:[UIColor redColor]];

                }
                else
                {
                    tutorialView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,frame.size.width, frame.size.height)];
                    
                    [tutorialView setImage:[iphone5TutorialImageArray objectAtIndex:i]];

                }
                
                
                [tutorialScrollView addSubview:tutorialView];
                
            }
            
            tutorialScrollView.contentSize = CGSizeMake(frame.size.width * numberOfViews,   frame.size.height);
            
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(115,470,80, 20)];
            pageControl.numberOfPages = iphone5TutorialImageArray.count;
            [pageControl sizeToFit];
            [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"969696"]];
            [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"4b4b4b"]];
            [self.view addSubview:pageControl];

        }

    }
 
    

    
   // scrollTimer= [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
 
    
}

/*
-(void)setTutorialImageForIphone5
{
    model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen1-568h@2x.png"];
    
    model2 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen2-568h@2x.png"];
    
    model3 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen3-568h@2x.png"];
    
    model4 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen4-568h@2x.png"];
    
    model5 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen5-568h@2x.png"];
    
    model6 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen6-568h@2x.png"];
}


-(void)setTutorialImageForIphone4
{
    model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen1.png"];
    
    model2 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen2.png"];
    
    model3 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen3.png"];
    
    model4 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen4.png"];
    
    model5 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen5.png"];
    
    model6 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"tutorialscreen6.png"];
}
*/


- (void) onTimer
{
    
    w += 320;
        
    if (w==1920)
    {
        w=0;
        [tutorialScrollView setContentOffset:CGPointMake(w,0) animated:NO];

    }
    
    //This makes the scrollView scroll to the desired position
    [tutorialScrollView setContentOffset:CGPointMake(w,0) animated:YES];
    

    
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

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = tutorialScrollView.frame.size.width;
    int page = floor((tutorialScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page!=0)
    {
        [bottomLabel setBackgroundColor:[UIColor colorWithHexString:@"ffb900"]];
    }
    
    else
    {
    
        [bottomLabel setBackgroundColor:[UIColor whiteColor]];

    }
    
    if (page==6)
    {
        [bottomBarRegisterButton setHidden:YES];
        [bottomBarSignInButton setHidden:YES];
        [bottomLabel setHidden:YES];        
    }
    
    
    else
    {
        [bottomBarRegisterButton setHidden:NO];
        [bottomBarSignInButton setHidden:NO];
        [bottomLabel setHidden:NO];
    }
    
    if (page==0)
    {
        
        
        [bottomBarSignInButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];

        [bottomBarRegisterButton setTitleColor:[UIColor colorWithHexString:@"ffb900"] forState:UIControlStateNormal];

    }
    
    else
    {

        [bottomBarSignInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [bottomBarRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    
        pageControl.currentPage = page;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    
    w=scrollView.contentOffset.x;
    
}


- (IBAction)finalRegisterButtonClicked:(id)sender
{
    [self setUpSignUpViewController];
}


- (IBAction)finalLoginButtonClicked:(id)sender
{
    [self setUpLoginViewController];

}


- (IBAction)bottomBarRegisterButtonClicked:(id)sender
{
    [self setUpSignUpViewController];

}


- (IBAction)bottomBarLoginButtonClicked:(id)sender
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
    scrollTimer= [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

}


-(void)viewDidDisappear:(BOOL)animated
{

    [scrollTimer invalidate];

}



@end
