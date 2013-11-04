//
//  SignUpViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 17/07/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>




@interface AddressAnnotation : NSObject <MKAnnotation,MKMapViewDelegate>

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end


@interface SignUpViewController : UIViewController
{
    AppDelegate *appDelegate;
    
    IBOutlet UIImageView *businessVerticalBg;

    IBOutlet UIImageView *businessNameBg;
    
    IBOutlet UIImageView *houseNumberImageViewBg;
    
    IBOutlet UIImageView *streetNameImageViewBg;
    
    IBOutlet UIImageView *cityImageViewBg;
        
    IBOutlet UIImageView *pinCodeImageViewBg;
    
    IBOutlet UIImageView *stateImageViewBg;
    
    IBOutlet UIImageView *countryImageViewBg;
    
    IBOutlet UIImageView *emailAddressImageViewBg;
    
    IBOutlet UIImageView *mobileNumberImageViewBg;
    
    IBOutlet UIImageView *countryCodeImageViewBg;
    
    IBOutlet UIImageView *suggestedUriImageViewBg;
    
    IBOutlet UITextView *suggestedUriTextView;
    
    IBOutlet UINavigationBar *navBar;
    
    UIButton *customCancelButton;
    
    UIButton *customNextButton;
    
    UIView *_container;
        
    IBOutlet UIView *stepControllerSubView;

    IBOutlet UIView *stepOneSubView;
    
    IBOutlet UIView *stepTwoSubView;
    
    IBOutlet UIView *stepThreeSubView;
    
    IBOutlet UIView *stepFourSubVIew;
    
    IBOutlet UIScrollView *stepOneSubViewScrollView;

    IBOutlet UIScrollView *stepTwoScrollView;
    
    IBOutlet UIButton *stepOneNextButton;
 
    IBOutlet UIButton *stepTwoNextButton;
        
    IBOutlet UIButton *stepThreeNextButton;
    
    IBOutlet UIButton *stepFourNextButton;

    IBOutlet UIButton *stepOneButton;
    
    IBOutlet UIButton *stepTwoButton;
    
    IBOutlet UIButton *stepThreeButton;
    
    IBOutlet UIButton *stepFourButton;
    
    IBOutlet UITextField *businessVerticalTextField;
    
    IBOutlet UITextField *businessNameTextField;
    
    IBOutlet UITextField *businessDescriptionTextField;
    
    IBOutlet UITextField *houseNumberTextField;
    
    IBOutlet UITextField *streetNameTextField;
    
    IBOutlet UITextField *localityTextField;
    
    IBOutlet UITextField *landMarkTextField;
    
    IBOutlet UITextField *cityNameTextField;
    
    IBOutlet UITextField *pincodeTextField;

    IBOutlet UITextField *fpTagTextField;
    
    IBOutlet UITextField *annotationTextField;
    
    UITextField *textFieldBeingEdited;

    IBOutlet UIImageView *checkMarkImageView;
    
    IBOutlet UIActivityIndicatorView *verifyValidFpActivityIndicator;
    
    BOOL isVerified;
    
    IBOutlet UIView *categorySubView;
    
    IBOutlet UITableView *categoryTableView;
    
    NSMutableArray *categoryArray;
    
    NSMutableArray *listOfStatesArray;
    
    IBOutlet UIActivityIndicatorView *categoryActivityIndicator;
    
    IBOutlet UITextField *countryNameTextField;
    
    IBOutlet UITextField *stateNameTextField;
    
    IBOutlet MKMapView *mapView;
    
    IBOutlet UIView *mapSubView;
    
    double storeLatitude,storeLongitude;
    
    IBOutlet UITextField *businessPhoneNumberTextField;
    
    IBOutlet UITextField *ownerNameTextField;
    
    IBOutlet UITextField *emailTextField;
    
    IBOutlet UITextField *countryCodeTextField;
    
    IBOutlet UILabel *countryCodeBg;
    
    IBOutlet UIView *activitySubView;
    
    IBOutlet UITableView *listOfStatesTableView;
    
    IBOutlet UIView *listOfStatesSubView;
    
    NSString *addressString;
    
    NSMutableArray *countryListArray,*countryCodeArray;    
    
    IBOutlet UIView *countryCodeSubView;
    
    IBOutlet UITableView *countryCodesTableView;
    
    IBOutlet UIView *creatingWebsiteActivitySubView;
    
    IBOutlet UIView *pickerViewSubView;
    
    IBOutlet UIView *pickerView;
    
    IBOutlet UIPickerView *categoryPickerView;
    
    IBOutlet UIView *downloadingCategoriesActivityView;
    
    IBOutlet UIView *countryPickerSubView;
    
    IBOutlet UIView *countryPickerViewContainer;
    
    IBOutlet UIPickerView *countryPickerView;

    IBOutlet UIView *countryCodePickerSubView;
    
    IBOutlet UIView *countryCodePickerContainer;
    
    IBOutlet UIView *suggestingActivitySubView;

}




@property (strong, nonatomic) AddressAnnotation *addressAnnotation;

- (IBAction)stepOneNextBtnClicked:(id)sender;

- (IBAction)stepTwoNextBtnClicked:(id)sender;

- (IBAction)stepThreeNextBtnClicked:(id)sender;

- (IBAction)stepFourNextBtnClicked:(id)sender;

- (IBAction)stepOneDismissBtnClicked:(id)sender;

- (IBAction)stepTwoKeyBoardShouldReturn:(id)sender;

- (IBAction)stepThreeKeyBoardShouldReturn:(id)sender;

- (IBAction)categorySubViewBtnClicked:(id)sender;

- (IBAction)mapSaveBtnClicked:(id)sender;

- (IBAction)mapCancelBtnClicked:(id)sender;

- (IBAction)stepFourKeyBoardShouldReturn:(id)sender;

- (IBAction)countryBtnClicked:(id)sender;

- (IBAction)countryCodeBtnClicked:(id)sender;

- (IBAction)categoryDoneBtnClicked:(id)sender;

- (IBAction)categoryCancelBtnClicked:(id)sender;

- (IBAction)countryDoneBtnClicked:(id)sender;

- (IBAction)countryCancelBtnClicked:(id)sender;

- (IBAction)endEditingButtonPressed:(id)sender;

- (IBAction)countryCodeDoneBtnClicked:(id)sender;

- (IBAction)countryCodeCancelBtnClicked:(id)sender;

- (IBAction)changeStoreTag:(id)sender;

 - (IBAction)stepOneBtnClicked:(id)sender;
 
 - (IBAction)stepTwoBtnClicked:(id)sender;
 
 - (IBAction)stepThreeBtnClicked:(id)sender;
 
 - (IBAction)stepFourBtnClicked:(id)sender;

- (IBAction)createWebSiteBtnClicked:(id)sender;

@end
