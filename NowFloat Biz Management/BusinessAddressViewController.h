//
//  BusinessAddressViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>


@interface BusinessAddressViewController : UIViewController<UIAlertViewDelegate,SWRevealViewControllerDelegate,MKMapViewDelegate>
{
    IBOutlet UITextView *addressTextView;
    
    AppDelegate *appDelegate;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;

    IBOutlet UITextView *noteTextView;
    
    IBOutlet MKMapView *storeMapView;
    
    IBOutlet UIScrollView *addressScrollView;

    UIButton *customButton;
    
    double strLat,strLng;

    IBOutlet UIView *activitySubView;
    
    IBOutlet UIView *miniActivitySubView;
    
    
}


- (IBAction)revealFrontController:(id)sender;

@end
