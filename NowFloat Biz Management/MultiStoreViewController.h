//
//  MultiStoreViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 22/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@protocol downloadStoreDetail <NSObject>

-(void)downloadStoreDetails;

@end



@interface MultiStoreViewController : UIViewController
{

    IBOutlet UITableView *multiStoreTableView;
    
    AppDelegate *appDelegate;

    NSUserDefaults *userdetails;
    
    NSMutableArray *storeArray;
    
    id<downloadStoreDetail>delegate;
    
    
}


@property (nonatomic,strong)     id<downloadStoreDetail>delegate;

@end
