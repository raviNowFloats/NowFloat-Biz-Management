//
//  RightViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 24/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@protocol RightViewControllerDelegate <NSObject>

-(void)messageDidUpdate;

@end

@interface RightViewController : UIViewController
{

    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;


    NSMutableArray *selectionArray;
    
    NSMutableArray *textArray;
}


@property (nonatomic,strong) id<RightViewControllerDelegate>delegate;

- (IBAction)messageUploadButtonClicked:(id)sender;

- (IBAction)imageUploadButtonClicked:(id)sender;

@end
