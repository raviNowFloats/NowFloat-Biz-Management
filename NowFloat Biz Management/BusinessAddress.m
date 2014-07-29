//
//  BusinessAddress.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 4/9/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BusinessAddress.h"
#import "CMPopTipView.h"
#import "UIColor+HexaString.h"
#import "UpdateStoreData.h"
#import  "AlertViewController.h"
#import "BusinessAddressViewController.h"

@interface BusinessAddress ()<CMPopTipViewDelegate,updateStoreDelegate>
{
    CMPopTipView *popTipView;
    float viewHeight;
    UIImageView *pinImageView;
    GMSMapView *storeMapView;
    UIButton *doneButton, *cancelButton, *currentLocation;
    CLLocationCoordinate2D finalCoordinates, centreMapView;
    double storeLatitude, storeLongitude;
    
}

@end


@implementation BusinessAddress
@synthesize delegate;
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
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate=(AppDelegate *)[UIApplication  sharedApplication].delegate;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
            
            cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [cancelButton setFrame:CGRectMake(10,20, 30, 30)];
            
            [cancelButton addTarget:self action:@selector(removeMapView) forControlEvents:UIControlEventTouchUpInside];
            
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"Map-cancel.png"]  forState:UIControlStateNormal];
            
            
            currentLocation=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [currentLocation setFrame:CGRectMake(140,400, 40, 40)];
            
            [currentLocation addTarget:self action:@selector(setUserLocation) forControlEvents:UIControlEventTouchUpInside];
            
             [currentLocation setBackgroundImage:[UIImage imageNamed:@"navigate1.png"]  forState:UIControlStateNormal];
            
            doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [doneButton setFrame:CGRectMake(280,20, 30, 30)];
            
            [doneButton addTarget:self action:@selector(updateNewLocation) forControlEvents:UIControlEventTouchUpInside];
            
            [doneButton setBackgroundImage:[UIImage imageNamed:@"map-ok.png"]  forState:UIControlStateNormal];
        }
        else
        {
            viewHeight=568;
            
            cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [cancelButton setFrame:CGRectMake(10,30, 30, 30)];
            
            [cancelButton addTarget:self action:@selector(removeMapView) forControlEvents:UIControlEventTouchUpInside];
            
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"Map-cancel.png"]  forState:UIControlStateNormal];
            
            
            currentLocation=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [currentLocation setFrame:CGRectMake(140,500, 40, 40)];
            
            [currentLocation addTarget:self action:@selector(setUserLocation) forControlEvents:UIControlEventTouchUpInside];
            
            [currentLocation setBackgroundImage:[UIImage imageNamed:@"navigate1.png"]  forState:UIControlStateNormal];
            
            doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [doneButton setFrame:CGRectMake(280,30, 30, 30)];
            
            [doneButton addTarget:self action:@selector(updateNewLocation) forControlEvents:UIControlEventTouchUpInside];
            
            [doneButton setBackgroundImage:[UIImage imageNamed:@"map-ok.png"]  forState:UIControlStateNormal];
            
           
            
        }
    }
    
    CLLocationCoordinate2D center;
    
    center.latitude=[[appDelegate.storeDetailDictionary objectForKey:@"lat"] doubleValue];
    
    center.longitude=[[appDelegate.storeDetailDictionary objectForKey:@"lng"] doubleValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:center.latitude
                                                            longitude:center.longitude
                                                                 zoom:18];
    storeMapView = [GMSMapView mapWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    
    storeMapView.delegate = self;
    
    pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mappin12.png"]];
    
    pinImageView.center = appDelegate.window.center;
    
    [storeMapView addSubview:pinImageView];
    
    [storeMapView addSubview:currentLocation];
    
    [storeMapView addSubview:doneButton];
    
    [storeMapView addSubview:cancelButton];
    
    self.view = storeMapView;
    
    
   // [self showToolTip];
   // [self.view insertSubview:storeMapView atIndex:0];
    
    
    
   
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    CGPoint point = storeMapView.center;
    CLLocationCoordinate2D center = [storeMapView.projection coordinateForPoint:point];
    
    centreMapView = center;
    
    if(cancelButton.hidden == YES){
        cancelButton.hidden = NO;
    }
   
}

-(void)updateAddress
{
    
    NSMutableArray *uploadArray=[[NSMutableArray alloc]init];
    
    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    strData.delegate=self;
    
    NSString *uploadString=[NSString stringWithFormat:@"%f,%f",centreMapView.latitude,centreMapView.longitude];
    
    NSDictionary *upLoadDictionary=@{@"value":uploadString,@"key":@"GEOLOCATION"};
    
    [uploadArray addObject:upLoadDictionary];
    
    [strData updateStore:uploadArray];
}


-(void)updateNewLocation
{
    
    CGPoint point = storeMapView.center;
    CLLocationCoordinate2D center = [storeMapView.projection coordinateForPoint:point];
    finalCoordinates = center;

    NSLog(@"%f and %f", centreMapView.latitude,centreMapView.longitude);
    [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"changedAddress"];
    [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithDouble:centreMapView.latitude] forKey:@"lat"];
    [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithDouble:centreMapView.longitude] forKey:@"lng"];
    
    [self updateAddress];
    
    [self dismissViewControllerAnimated:YES completion:nil];}


-(void)updateNewAddressLocation
{
    CLLocationCoordinate2D center;
    
    center.latitude=[[appDelegate.storeDetailDictionary objectForKey:@"lat"] doubleValue];
    
    center.longitude=[[appDelegate.storeDetailDictionary objectForKey:@"lng"] doubleValue];
    
    GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:center zoom:18];
    
     NSLog(@"%f and %f",  center.latitude,center.longitude);
    
    [cancelButton setHidden:YES];
    
    [storeMapView animateWithCameraUpdate:cams];
}

-(void)setUserLocation
{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
   
    
    [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithDouble:locationManager.location.coordinate.latitude] forKey:@"lat"];
    [appDelegate.storeDetailDictionary setObject:[NSNumber numberWithDouble:locationManager.location.coordinate.longitude] forKey:@"lng"];
    
    [self updateNewAddressLocation];
}


-(void)showToolTip
{
    UIColor *backgroundColor = [UIColor colorWithHexString:@"454545"];
    UIColor *textColor = [UIColor whiteColor];
    popTipView = [[CMPopTipView alloc] initWithMessage:@"Set the pointer to your business location"];
    popTipView.delegate = self;
    popTipView.backgroundColor = backgroundColor;
    popTipView.borderColor=[UIColor colorWithHexString:@"454545"];
    popTipView.textColor = textColor;
    popTipView.animation = arc4random() % 2;
    popTipView.has3DStyle = NO;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:2];
    
    
    if (version.floatValue<7.0)
    {
        [popTipView presentPointingAtView:pinImageView inView:storeMapView animated:YES];
    }
    else
    {
        [popTipView presentPointingAtView:pinImageView inView:storeMapView animated:YES];
    }
    
}

-(void)storeUpdateComplete
{
    
//    UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Business Address Updated!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//    
//    [successAlert show];
//    
//    successAlert=nil;
    
    
    
}


-(void)storeUpdateFailed
{
    UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Business Address could not be updated." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedAlert show];
    
    failedAlert=nil;
    
}


#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)poptipView {
    // User can tap CMPopTipView to dismiss it
    poptipView = nil;
    
}


-(void)removeMapView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
