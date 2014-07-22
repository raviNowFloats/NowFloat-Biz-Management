//
//  BusinessAddressViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>


@interface BusinessAddressViewController : UIViewController<UIAlertViewDelegate,SWRevealViewControllerDelegate,GMSMapViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
    
    IBOutlet UIToolbar *toolBar;
    
    IBOutlet UIBarButtonItem *spaceToolBarButton;
    
    IBOutlet UIView *contentSubView;
 
    UINavigationBar *navBar;
}



@property(nonatomic) BOOL isFromOtherViews;

- (IBAction)cancelButton:(id)sender;

- (IBAction)doneButton:(id)sender;

- (IBAction)cancelToolBarButton:(id)sender;

- (IBAction)doneToolBarButton:(id)sender;

- (IBAction)revealFrontController:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *businessAddTable1;
@property (strong, nonatomic) IBOutlet UITableView *businessAddTable2;

@end
