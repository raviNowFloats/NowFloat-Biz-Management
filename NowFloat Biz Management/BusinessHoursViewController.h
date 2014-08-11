//
//  BusinessHoursViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DCRoundSwitch.h"

@interface BusinessHoursViewController : UIViewController<UITextFieldDelegate,SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{

    AppDelegate *appDelegate;
    NSMutableArray *storeTimingsArray;
    NSMutableArray *hoursArray;
    NSMutableArray *minutesArray;
    NSMutableArray *periodArray;
    NSMutableArray *holidayArray;
    NSMutableArray *storeTimingsBoolArray;
    NSString *hour;
    NSString *min;
    NSString *period;
    NSIndexPath* checkedIndexPath;
    NSString *storeFromTime;
    NSString *storeToTime;

    __weak IBOutlet UIButton *setFromStoreTimeButton;
    __weak IBOutlet UIButton *setToStoreTimeButton;
    __weak IBOutlet UIView *closedDaySubView;
    
    __weak IBOutlet UIView *activitySubView;
    
    UISegmentedControl *myButton;
    
    IBOutlet UILabel *fromBgLabel;
    
    IBOutlet UILabel *toBgLabel;
    
    UINavigationBar *navBar;
    
    BOOL isTimingsChanged;
        
    IBOutlet DCRoundSwitch *customSwitch0;
    
    IBOutlet DCRoundSwitch *customSwitch2;
    
    IBOutlet DCRoundSwitch *customSwitch1;
    
    IBOutlet DCRoundSwitch *customSwitch3;
    
    IBOutlet DCRoundSwitch *customSwitch4;
    
    IBOutlet DCRoundSwitch *customSwitch6;
    
    IBOutlet DCRoundSwitch *customSwitch7;
    
    UIButton *customRighNavButton;
    
    NSString *frontViewPosition;
    
    IBOutlet UIButton *revealFrontControllerButton;

    IBOutlet UIView *contentSubView;
    
    NSString *version ;
    
}


@property (weak, nonatomic) IBOutlet UIPickerView *buisnesHourDatePicker;

@property (weak, nonatomic) IBOutlet UITextField *fromTextView;

@property (weak, nonatomic) IBOutlet UITextField *toTextView;

@property (weak, nonatomic) IBOutlet UIView *pickerSubView;

@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@property (nonatomic,strong)     DCRoundSwitch *customSwitch;

- (IBAction)toBtnClicked:(id)sender;

- (IBAction)fromBtnClicked:(id)sender;

- (IBAction)setFromStoreTime:(id)sender;

- (IBAction)setToStoreTime:(id)sender;

- (IBAction)hidePickerView:(id)sender;

- (IBAction)revealFrontController:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *businessHrTable;

@property (strong, nonatomic) IBOutlet UIView *timingView;


@property (strong, nonatomic) IBOutlet UILabel *timingCloseLabel;
@property (strong, nonatomic) IBOutlet UILabel *borderlabel;

@end
