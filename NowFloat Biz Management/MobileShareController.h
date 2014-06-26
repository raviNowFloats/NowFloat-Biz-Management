//
//  MobileShareController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/6/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MobileShareController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    AppDelegate *appDelegate;
    
     NSString *version;
}
@property(strong,nonatomic) UIActivityIndicatorView *loadActivity;

@property (strong,nonatomic) UISearchBar *filter;

-(void)accessContacts;

@end
