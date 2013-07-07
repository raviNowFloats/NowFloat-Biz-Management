//
//  RightViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 24/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface RightViewController : UIViewController
{

    SWRevealViewController *revealController;
    
    UINavigationController *frontNavigationController;


}


- (IBAction)messageUploadButtonClicked:(id)sender;

- (IBAction)imageUploadButtonClicked:(id)sender;

@end
