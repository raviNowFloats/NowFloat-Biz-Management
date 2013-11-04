//
//  TutorialViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController
{

    IBOutlet UIScrollView *tutorialScrollView;

    IBOutlet UILabel *bottomLabel;
    
//    NSMutableArray *iphone4TutorialImageArray;
//    
//    NSMutableArray *iphone5TutorialImageArray;
    
    int viewWidth;
    
    int viewHeight;
    
    int w;
    
    NSTimer *scrollTimer;
    
    IBOutlet UIView *finalSubView;

    IBOutlet UIPageControl* pageControl;

    IBOutlet UIButton *bottomBarSignInButton;
    
    IBOutlet UIButton *bottomBarRegisterButton;
        
    IBOutlet UIButton *finalRegisterButton;
    
    IBOutlet UIButton *finalSignInButton;
    
    IBOutlet UIView *getStartedSubView;
    
    NSMutableArray *tutorialImageArray;
    
}

- (IBAction)finalRegisterBtnClicked:(id)sender;

- (IBAction)finalLoginBtnClicked:(id)sender;

- (IBAction)bottomBarRegisterBtnClicked:(id)sender;

- (IBAction)bottomBarLoginBtnClicked:(id)sender;

@end
