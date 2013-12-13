//
//  PopUpView.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 22/11/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpDelegate <NSObject>

-(void)successBtnClicked:(id)sender;

-(void)cancelBtnClicked:(id)sender;

@end

@interface PopUpView : UIView
{
    NSMutableDictionary *popUpDetails;
}

@property (nonatomic,strong) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) IBOutlet UILabel *descriptionLabel;

@property (nonatomic,strong) IBOutlet UIImageView *popUpImageView;

@property (nonatomic,strong) IBOutlet UIView *containerView;

@property (nonatomic,strong) NSString *titleText;

@property (nonatomic,strong) NSString *descriptionText;

@property (nonatomic,strong) NSString *successBtnText;

@property (nonatomic,strong) NSString *cancelBtnText;

@property (nonatomic,strong) UIImage *popUpImage;

@property (nonatomic,strong) IBOutlet UIButton *successBtn;

@property (nonatomic,strong) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UIImageView *freeBadgeView;

@property (nonatomic,strong) UIImage *badgeImage;

@property (nonatomic) int tag;

@property(nonatomic,strong) id<PopUpDelegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel *bgLabel;


-(id)init;

-(void)showPopUpView;

- (IBAction)successBtnClicked:(id)sender;

- (IBAction)cancelBtnClicked:(id)sender;

@end
