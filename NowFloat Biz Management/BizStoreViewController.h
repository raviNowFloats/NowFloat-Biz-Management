//
//  BizStoreViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BizStoreViewController : UIViewController
{

    IBOutlet UITableView *bizStoreTableView;
    
    IBOutlet UINavigationBar *navBar;

    UIButton *customCancelButton;

    IBOutlet UIActivityIndicatorView *loadingProductsActivityIndicator;

    IBOutlet UIView *processingPurchaseRequestSubview;
}


@end
