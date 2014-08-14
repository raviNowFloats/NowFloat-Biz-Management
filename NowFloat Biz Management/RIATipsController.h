//
//  RIATipsController.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/25/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface RIATipsController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *tip1Button;
- (IBAction)tip1Action:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *step2View;
@property (strong, nonatomic) IBOutlet UIView *step1View;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController,*moviePlayerController1;
@property (strong, nonatomic) IBOutlet UIButton *tip2button;
- (IBAction)tip2Action:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *step3View;
@property (strong, nonatomic) IBOutlet UIButton *tip3button;
- (IBAction)tip3Action:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *riaScrollview;

- (IBAction)skipView1:(id)sender;
- (IBAction)skipView2:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *skipLbael1;
@property (strong, nonatomic) IBOutlet UILabel *skipLbael2;

@end
