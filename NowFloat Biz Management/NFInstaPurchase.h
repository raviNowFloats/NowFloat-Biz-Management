//
//  NFInstaPurchase.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 20/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NFInstaPurchaseDelegate <NSObject>

-(void)instaPurchaseViewDidClose;

@end

@interface NFInstaPurchase : UIView
{
    IBOutlet UITableView *instaPurchaseTableView;
}

@property (nonatomic,strong) IBOutlet UIView *containerView;

@property(nonatomic) int selectedWidget;

@property(nonatomic,strong) NSMutableArray *descriptionArray;

@property(nonatomic,strong) NSMutableArray *titleArray;

@property(nonatomic,strong) NSMutableArray *introductionArray;

@property(nonatomic,strong) NSMutableArray *priceArray;

@property(nonatomic,strong) NSMutableArray *widgetImageArray;

@property(nonatomic,strong) id<NFInstaPurchaseDelegate> delegate;

- (IBAction)closeBtnClicked:(id)sender;

-(void)showInstantBuyPopUpView;

-(void)closeInstantBuyPopUpView;

-(id)init;



@end
