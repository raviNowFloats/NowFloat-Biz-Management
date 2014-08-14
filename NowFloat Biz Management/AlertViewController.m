//
//  AlertViewController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/19/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "AlertViewController.h"
UIView* errorView;
#define CURRENT_TOAST_TAG 6984678
#define PROFILE_TAG 5446546

@interface AlertViewController ()

@end

@implementation AlertViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void) CurrentView:(UIView *)viewtoShow errorString:(NSString *)errorContent size:(int)Yaxis success:(BOOL)isSuccess
{

    errorView=[[UIView alloc]init];
    
    
   
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            errorView.frame=CGRectMake(0, Yaxis+60, 1024, 50);
            
            
        }
        else
        {
            errorView.frame=CGRectMake(0, -2000, 320, 40);
            
        }
    
    if(isSuccess)
    {
        errorView.backgroundColor = [UIColor colorWithRed:93.0f/255.0f green:172.0f/255.0f blue:1.0f/255.0f alpha:1.0];


    }
    else
    {
        errorView.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:34.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    }
    
    
    
    
    
    
    UILabel  *errorLabel = [[UILabel alloc]init];
 
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            errorLabel.frame=CGRectMake(60, 5, 900, 40);
            errorLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
            errorLabel.textAlignment =NSTextAlignmentCenter;
            
            
        }
        else
        {
            errorLabel.frame=CGRectMake(20, 0, 280, 40);
            errorLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
            errorLabel.textAlignment =NSTextAlignmentCenter;
            
        }
        
    
    errorLabel.text = errorContent;
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.backgroundColor =[UIColor clearColor];
    [errorLabel setNumberOfLines:0];
    
    
    //errorLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    errorView.tag =55;
    
   
    errorView.frame=CGRectMake(0, -200, 320, 40);
    [UIView animateWithDuration:0.8f
                          delay:0.03f
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                          errorView.frame=CGRectMake(0, Yaxis, 320, 40);
                        
                         [viewtoShow addSubview:errorView];
                         
                         [errorView addSubview:errorLabel];
                         
                     }completion:^(BOOL finished){
                         
                         double delayInSeconds = 1.5;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                             
                             
                             
                             [UIView animateWithDuration:0.8f
                                                   delay:0.10f
                                                 options:UIViewAnimationOptionTransitionFlipFromBottom
                                              animations:^{
                                                  if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                                                  {
                                                      errorView.alpha = 0.0;
                                                      errorView.frame = CGRectMake(0, -55, 1024, 50);
                                                      
                                                  }
                                                  else
                                                  {
                                                      errorView.alpha = 0.0;
                                                      errorView.frame = CGRectMake(0, -55, 320, 50);
                                                  }
                                                  
                                                  
                                                  
                                              }completion:^(BOOL finished){
                                                  
                                                  for (UIView *errorRemoveView in [viewtoShow subviews]) {
                                                      if (errorRemoveView.tag == 55) {
                                                          [errorRemoveView removeFromSuperview];
                                                          
                                                          
                                                      }
                                                      
                                                  }
                                                  
                                                  
                                              }];
                             
                         });
                         
                     }];
    
    
    
    
    
}


@end
