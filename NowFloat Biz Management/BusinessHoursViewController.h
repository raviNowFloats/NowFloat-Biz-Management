//
//  BusinessHoursViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BusinessHoursViewController : UIViewController<UITextFieldDelegate>
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
}


@property (weak, nonatomic) IBOutlet UIPickerView *buisnesHourDatePicker;

@property (weak, nonatomic) IBOutlet UITextField *fromTextView;

@property (weak, nonatomic) IBOutlet UITextField *toTextView;

@property (weak, nonatomic) IBOutlet UITableView *buisnessHourTableView;

@property (weak, nonatomic) IBOutlet UIView *pickerSubView;

@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

- (IBAction)toButtonClicked:(id)sender;

- (IBAction)fromButtonClicked:(id)sender;

- (IBAction)setFromStoreTime:(id)sender;

- (IBAction)setToStoreTime:(id)sender;

- (IBAction)hidePickerView:(id)sender;

@end
