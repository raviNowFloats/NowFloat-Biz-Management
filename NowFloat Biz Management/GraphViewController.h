//
//  GraphViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 09/03/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLineChartView.h"
#import "PCPieChart.h"
#import "AppDelegate.h" 


@interface GraphViewController : UIViewController
{
    AppDelegate *appDelegate;
    NSMutableArray *vistorCountArray;
    NSMutableArray *vistorWeekArray;
    int maxGraph;
    int minGraph;
    
    __weak IBOutlet UILabel *numberOfVisitsLabel;
    
    __weak IBOutlet UILabel *numberOfWeeksLabel;
    
    
}
@property (nonatomic, strong) PCLineChartView *lineChartView;

@property (nonatomic)     BOOL  isLineGraphSelected;

@property (nonatomic)     BOOL  isPieChartSelected;




@end
