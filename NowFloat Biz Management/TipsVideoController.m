//
//  TipsVideoController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/23/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "TipsVideoController.h"
#import "UIColor+HexaString.h"
@interface TipsVideoController ()

@end

@implementation TipsVideoController
@synthesize boostTipsTableview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   self.navigationController.navigationBarHidden = NO;
   self.navigationItem.title = @"Boost Tips";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"boostTipsCell";
    
    UITableViewCell *cell = [self.boostTipsTableview dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIWebView *boostTips = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 310, 160)];
    boostTips.scrollView.scrollEnabled = NO;
    boostTips.backgroundColor = [UIColor clearColor];
    boostTips.opaque = NO;
    
    UILabel *boostLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 167, 280, 60)];
    boostLabel.textColor = [UIColor darkGrayColor];
    boostLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    
    UIView *countView = [[UIView alloc]initWithFrame:CGRectMake(10, 183, 28, 28)];
    countView.backgroundColor = [UIColor colorFromHexCode:@"#ffb900"];
    countView.layer.cornerRadius = 13.0f;
    countView.layer.masksToBounds = YES;
    [cell addSubview:countView];
    
    
    UILabel *countlabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 4, 10, 20)];
    countlabel.textColor = [UIColor whiteColor];
    countlabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [countView addSubview:countlabel];
    

    
    if(indexPath.row==0)
    {
        [cell addSubview:boostTips];
        NSString *EmbedCode = @"<iframe width=\"310\" height=\"160\" src=\"http://www.youtube.com/embed/an9QTxLKnfg?modestbranding=0&;rel=0&;showinfo=0;autohide=1\" frameborder=\"0\" allowfullscreen></iframe>";
        [boostTips loadHTMLString:EmbedCode baseURL:nil];
        boostLabel.text = @"Boost Tip #1 - Content is King";
        countlabel.text = @"1";
        [cell addSubview:boostLabel];
    }
    
    if(indexPath.row==1)
    {
        [cell addSubview:boostTips];
       NSString *EmbedCode = @"<iframe width=\"310\" height=\"160\" src=\"http://www.youtube.com/embed/v-AO1i5k8ws?modestbranding=0&;rel=0&;showinfo=0;autohide=1\" frameborder=\"0\" allowfullscreen></iframe>";
        [boostTips loadHTMLString:EmbedCode baseURL:nil];
        boostLabel.text = @"Boost Tip #2 - Get Discovered on Search";
        countlabel.text = @"2";

        [cell addSubview:boostLabel];
    }
    
    
    return cell;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
