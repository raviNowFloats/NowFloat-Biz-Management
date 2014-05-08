//
//  EmailShareController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 3/24/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface EmailShareController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>{
    
    MFMailComposeViewController *mailComposer;
    
    NSString *mailReportStatus;
    
    NSString *version;
}

-(IBAction)sendMail:(id)sender;

-(void)accessContacts;

@end