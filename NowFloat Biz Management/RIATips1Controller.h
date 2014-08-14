//
//  RIATips1Controller.h
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/26/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RIATips1Controller : UIViewController
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController1;
@property (strong, nonatomic) IBOutlet UILabel *cancelLabel;
- (IBAction)cancelAction:(id)sender;

@end
