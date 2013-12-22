//
//  BusinessAddressViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessAddressViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"
#import "MyAnnotation.h"
#import "UpdateStoreData.h"
#import "Mixpanel.h"

@interface BusinessAddressViewController ()<updateStoreDelegate>
{

    NSString *version;
    UIImageView *pinImageView;
}
@end

@implementation BusinessAddressViewController


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
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            
            addressScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+160);

        }
        if(result.height == 568)
        {
            // iPhone 5
            //[addressScrollView setContentSize:CGSizeMake(320, 568)];
            
        }
    }

    
    version = [[UIDevice currentDevice] systemVersion];
    
    if ([version floatValue]==7.0)
    {
        
        [addressTextView  setTextContainerInset:UIEdgeInsetsMake(-5,0 , 0, 0)];

        self.automaticallyAdjustsScrollViewInsets=NO;

    }
    
    
    
    else
    {
        [addressTextView setContentInset:UIEdgeInsetsMake(-10,0 , 0, 0)];
        
    }

    

    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    version = [[UIDevice currentDevice] systemVersion];

    [addressTextView.layer setCornerRadius:6.0f];
    
    [addressTextView.layer setBorderWidth:1.0];
    
    [addressTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    addressTextView.textColor=[UIColor colorWithHexString:@"9c9b9b"];
    
    noteTextView.textColor=[UIColor colorWithHexString:@"464646"];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;

    /*Design the NavigationBar here*/
    
    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                                   CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 13,160, 20)];
        
        headerLabel.text=@"Business Address";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];


    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        

        self.navigationItem.title=@"Business Address";

        
        [contentSubView setFrame:CGRectMake(0,-44, contentSubView.frame.size.width, contentSubView.frame.size.height)];
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;

    }
    


    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    revealController.rightViewRevealOverdraw=0;

    

    customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,5, 30, 30)];
    
    [customButton addTarget:self action:@selector(updateAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    [navBar addSubview:customButton];
    
    [customButton setHidden:YES];

    
    
    if ([appDelegate.storeDetailDictionary objectForKey:@"Address"]!=[NSNull null])
    {
    
    addressTextView.text=[appDelegate.storeDetailDictionary objectForKey:@"Address"];
        
        NSString *spList=addressTextView.text;
        NSArray *list = [spList componentsSeparatedByString:@","];
        
        addressTextView.text=[NSString stringWithFormat:@"%@",list];
        
        addressTextView.text=[addressTextView.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        addressTextView.text=[addressTextView.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
        addressTextView.text=[addressTextView.text stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        addressTextView.text=[addressTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        noteTextView.text=[NSString stringWithFormat:@"Note:\nThe address cannot be changed through the app.You can contact our customer care to make any changes." ];
        
        
        
        
        if ([version doubleValue]==7.0)
        {
            CGRect frame = addressTextView.frame;
            frame.size.height = addressTextView.contentSize.height+20;
            addressTextView.frame = frame;
            
            CGRect noteFrame=CGRectMake(21, addressTextView.frame.size.height+290, noteTextView.frame.size.width, noteTextView.frame.size.height);
            noteFrame.size.height=noteTextView.contentSize.height;
            noteTextView.frame=noteFrame;

            [noteTextView setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];

            UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [callButton setFrame:CGRectMake(255, noteTextView.frame.origin.y+20,55,55)];
            [callButton setBackgroundImage:[UIImage imageNamed:@"customercare.png"] forState:UIControlStateNormal];
            [callButton addTarget:self
                           action:@selector(callCustomerSupport)
                 forControlEvents:UIControlEventTouchDown];
            
            [addressScrollView addSubview:callButton];

        }
        
        else
        {
            
            CGRect noteFrame=CGRectMake(21, addressTextView.frame.origin.y+180, noteTextView.frame.size.width, noteTextView.frame.size.height);
            noteFrame.size.height=noteTextView.contentSize.height;
            noteTextView.frame=noteFrame;

            CGRect frame = addressTextView.frame;
            frame.size.height = addressTextView.contentSize.height-20;
            addressTextView.frame = frame;
            
            
            UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [callButton setFrame:CGRectMake(245,noteTextView.frame.origin.y+10,55, 55)];
            [callButton setBackgroundImage:[UIImage imageNamed:@"customercare.png"] forState:UIControlStateNormal];
            [callButton addTarget:self
                           action:@selector(callCustomerSupport)
                 forControlEvents:UIControlEventTouchDown];
            
            [addressScrollView addSubview:callButton];

        }


        
        
    }
    
    else
    {
    
    addressTextView.text=@"No Description";
    
    }

    

    
    
    CLLocationCoordinate2D center;
    
    center.latitude=[[appDelegate.storeDetailDictionary objectForKey:@"lat"] doubleValue];
    
    center.longitude=[[appDelegate.storeDetailDictionary objectForKey:@"lng"] doubleValue];
    
    MyAnnotation *myPin = [[MyAnnotation alloc] initWithCoordinate:center];
    
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = center;
    
    [storeMapView addAnnotation:myPin];
    [storeMapView setRegion:region animated:TRUE];
    [storeMapView regionThatFits:region];

    [activitySubView setHidden:YES];
    
    miniActivitySubView.center=self.view.center;
    

}

#pragma MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation
{
    
    pinImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mappin.png"]];

    MKAnnotationView *pin = (MKAnnotationView *) [storeMapView  dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    
    if (pin == nil)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"];
    }
    
    else
    {
        pin.annotation = annotation;
    }
    
    pin.draggable = YES;
    pin.clipsToBounds=YES;
    pin.contentMode=UIViewContentModeScaleAspectFit;
    pin.image=pinImageView.image;
    
    return pin;
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        strLat= droppedAt.latitude;
        strLng=droppedAt.longitude;
        [customButton setHidden:NO];
    }
}


-(void)updateAddress
{
    [activitySubView setHidden:NO];
    
    NSMutableArray *uploadArray=[[NSMutableArray alloc]init];
    
    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    strData.delegate=self;

    NSString *uploadString=[NSString stringWithFormat:@"%f,%f",strLat,strLng];
    
    NSDictionary *upLoadDictionary=@{@"value":uploadString,@"key":@"GEOLOCATION"};
    
    [uploadArray addObject:upLoadDictionary];
    
    [strData updateStore:uploadArray];
}


-(void)storeUpdateComplete
{
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"update_Business Address"];
    
    [activitySubView setHidden:YES];

    [customButton setHidden:YES];
    
    UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Business location changed successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
    
    [successAlert show];
    
    successAlert=nil;

}


-(void)storeUpdateFailed
{
    UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Business Address could not be updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedAlert show];
    
    failedAlert=nil;
    
    [activitySubView setHidden:NO];
    
    
}


#pragma SWRevealViewControllerDelegate


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    else if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    else if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    else if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    
    else if ( position == FrontViewPositionLeftSide ) str = @"FrontViewPositionLeftSide";
    
    else if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    
    return str;
}


- (IBAction)revealFrontController:(id)sender
{
    
    SWRevealViewController *revealController = [self revealViewController];
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"]) {
        
        [revealController performSelector:@selector(rightRevealToggle:)];
        
    }
    
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealController performSelector:@selector(revealToggle:)];
        
    }
    
}


- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;
{
    
    frontViewPosition=[self stringFromFrontViewPosition:position];
    
    //FrontViewPositionLeft
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    //FrontViewPositionCenter
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeft"]) {
        
        [revealFrontControllerButton setHidden:YES];
        
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {
        [revealFrontControllerButton setHidden:NO];        
    }
    
}


-(void)callCustomerSupport
{
    
    UIAlertView *callAlertView=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to call the customer care?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    callAlertView.tag=1;
    [callAlertView show];
    callAlertView=nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{

    if (alertView.tag==1)
    {
        
        if (buttonIndex==1) {
            
            
            NSString* phoneNumber=@"919160004303";
            
            NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",phoneNumber]];
            
            if([[UIApplication sharedApplication] canOpenURL:callUrl])
            {
                [[UIApplication sharedApplication] openURL:callUrl];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            

        }
        
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    addressTextView = nil;
    noteTextView = nil;
    [super viewDidUnload];
}




@end
