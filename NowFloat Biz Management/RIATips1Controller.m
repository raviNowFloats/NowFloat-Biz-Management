//
//  RIATips1Controller.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/26/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "RIATips1Controller.h"

long viewHeight;
long viewWidth;
@interface RIATips1Controller ()

@end

@implementation RIATips1Controller

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
   
    UIButton *tip3Button = [[UIButton alloc]init];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        viewWidth=result.width;
        if(result.height == 480)
        {
            //For iphone 3,3gS,4,42
            viewHeight=480;
            
           
            tip3Button.frame = CGRectMake(20, 410, 280, 40);
        }
        
        
        if(result.height == 568)
        {
            //For iphone 5
            viewHeight=568;
            
            
           
            tip3Button.frame = CGRectMake(20, 484, 280, 40);
            
        }
    }
    
    
    
    
    tip3Button.layer.cornerRadius = 10.0f;
    tip3Button.layer.masksToBounds=YES;
    tip3Button.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:185.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [tip3Button setTitle:@"Get Auto-SEO Widget. For free!" forState:UIControlStateNormal];
    [tip3Button addTarget:self action:@selector(tip3Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tip3Button];
    
    
    tip3Button.layer.cornerRadius = 10.0f;
    tip3Button.layer.masksToBounds=YES;
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *moviePath = [bundle pathForResource:@"RIATip2" ofType:@"mp4"];
    
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath] ;
    
    
    
    self.moviePlayerController1 = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    self.moviePlayerController1.fullscreen = MPMovieControlStyleFullscreen;
    
    // moviePlayer.view.transform = CGAffineTransformConcat(moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    
    // UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    
    // [self.moviePlayerController.view setFrame:backgroundWindow.frame];
    
    //  [backgroundWindow addSubview:self.moviePlayerController.view];
    
    self.moviePlayerController1.view.frame = CGRectMake(23, 160, 277, 240);
    
    
    self.moviePlayerController1.backgroundView.backgroundColor = [UIColor whiteColor];
    for(UIView *aSubView in self.moviePlayerController1.view.subviews) {
        aSubView.backgroundColor = [UIColor whiteColor];
    }
    
    
    [self.moviePlayerController1 prepareToPlay];
    
   
        [self.view addSubview:self.moviePlayerController1.view];
        [self.moviePlayerController1 play];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
