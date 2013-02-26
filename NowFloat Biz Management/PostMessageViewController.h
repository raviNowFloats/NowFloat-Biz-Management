//
//  PostMessageViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 27/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostMessageViewController : UIViewController
{

    __weak IBOutlet UILabel *characterCount;

    __weak IBOutlet UIView *downloadSubview;
}
@property (weak, nonatomic) IBOutlet UITextView *postMessageTextView;

-(IBAction)dismissKeyboardOnTap:(id)sender;

@end
