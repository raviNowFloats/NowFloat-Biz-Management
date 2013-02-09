//
//  MessageDetailsViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 30/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailsViewController : UIViewController<UITextViewDelegate>
@property(nonatomic,strong) NSString *messageDescription;
@property(nonatomic,strong) NSString *messageDate;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

- (IBAction)returnKeyBoard:(id)sender;


@end
