//
//  PostOfferViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostOfferViewController : UIViewController
{

    __weak IBOutlet UILabel *characterCount;

    __weak IBOutlet UITextView *postMessageTextView;

    __weak IBOutlet UIDatePicker *datePicker;
    
    __weak IBOutlet UIButton *dealStartDateBtn;
    
    __weak IBOutlet UIButton *dealEndDateBtn;
    
    __weak IBOutlet UIView *datePickerSubView;
    
    NSString *dealStartDateString;
    
    NSString *dealEndDateString;
    
    BOOL isStartDate;
    
    BOOL isEndDate;

    BOOL isStartDateFilled;
    
    BOOL isEndDateFilled;


}


-(IBAction)dismissKeyboardOnTap:(id)sender;

- (IBAction)dealStartDateClicked:(id)sender;
- (IBAction)dealEndDateClicked:(id)sender;

-(IBAction)displayDate:(id)sender;

- (IBAction)cancelButtonClicked:(id)sender;


@end
