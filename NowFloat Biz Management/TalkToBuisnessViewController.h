//
//  TalkToBuisnessViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 25/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkToBuisnessViewController : UIViewController
{

    NSMutableArray *messageArray;
    NSMutableArray *dateArray;
    NSMutableArray *messageHeadingArray;

}
@property (weak, nonatomic) IBOutlet UITableView *talkToBuisnessTableView;



@end
