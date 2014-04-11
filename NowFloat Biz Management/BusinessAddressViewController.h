//
//  BusinessAddressViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>


@interface BusinessAddressViewController : UIViewController<UIAlertViewDelegate,SWRevealViewControllerDelegate,GMSMapViewDelegate,UITextViewDelegate>
{
    IBOutlet UITextView *addressTextView;
    
    IBOutlet UIButton *showMapButton;
    
    AppDelegate *appDelegate;
    
    IBOutlet UIView *mapView;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;
    
    double storeLatitude, storeLongitude;

    IBOutlet UIScrollView *addressScrollView;

    UIButton *customButton, *doneButton;
    
    double strLat,strLng;
    
    IBOutlet UIView *contentSubView;
 
    UINavigationBar *navBar;
}


- (IBAction)revealFrontController:(id)sender;

@end
