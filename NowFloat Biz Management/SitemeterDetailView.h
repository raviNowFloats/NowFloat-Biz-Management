//
//  SitemeterDetailView.h
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 25/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SitemeterDetailView : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AppDelegate *appDelegate;
    
    NSUserDefaults *userDetails;
    
    __weak IBOutlet UITableView *mainTableView;
    
    int successCode;
    
    int totalImageDataChunks;
    
    NSString *version;
    
    NSURLConnection *theConnection;
    
}

@property (nonatomic,strong) UIImagePickerController *picker;

@end
