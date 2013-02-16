//
//  SelectMessageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectMessageViewController : UIViewController
{


    __weak IBOutlet UILabel *bgLabel;
    
    __weak IBOutlet UIButton *floatMsgButton;
    __weak IBOutlet UIButton *floatImgButton;
    
    __weak IBOutlet UIButton *floatOfferButton;
    
    __weak IBOutlet UILabel *lineLabel;
    
    
}
- (IBAction)floatAMessageButtonClicked:(id)sender;

- (IBAction)floatAnImageButtonClicked:(id)sender;

- (IBAction)floatAnOfferButtonClicked:(id)sender;

@end
