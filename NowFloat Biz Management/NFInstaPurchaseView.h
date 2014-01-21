//
//  NFInstaPurchaseView.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 15/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFInstaPurchaseView : UIViewController
{
    IBOutlet UITableView *instaPurchaseTableView;
}

@property(nonatomic) int selectedWidget;

@property(nonatomic,strong) NSMutableArray *descriptionArray;

@property(nonatomic,strong) NSMutableArray *titleArray;

@property(nonatomic,strong) NSMutableArray *introductionArray;

@property(nonatomic,strong) NSMutableArray *priceArray;

@property(nonatomic,strong) NSMutableArray *widgetImageArray;

@end
