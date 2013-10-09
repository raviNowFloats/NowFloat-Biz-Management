//
//  WidgetViewController.h
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 02/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "ATSDragToReorderTableViewController.h"

@interface WidgetViewController : ATSDragToReorderTableViewController
{
    NSMutableArray *arrayOfItems;
    
    IBOutlet UITableView *widgetTableView;
}
@end
