//
//  EmailShareController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 3/24/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface EmailShareController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>{
    MFMailComposeViewController *mailComposer;
    
     NSString *version;
    
     UILabel *headerLabel;
    
     UINavigationBar *navBar;
    
     UIButton *leftCustomButton;
}

-(IBAction)sendMail:(id)sender;

@end
