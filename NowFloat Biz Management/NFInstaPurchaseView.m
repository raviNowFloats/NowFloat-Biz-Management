//
//  NFInstaPurchaseView.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 15/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "NFInstaPurchaseView.h"
#import "AppDelegate.h"
#import "UIColor+HexaString.h"
#import "UIImage+ImageWithColor.h"

#define BusinessTimingsTag 1006
#define ImageGalleryTag 1004
#define AutoSeoTag 1008
#define TalkToBusinessTag 1002

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f


@interface NFInstaPurchaseView ()
{
    NSString *versionString;
    AppDelegate *appDelegate;
    double viewHeight;
    int selectedIndex;
    UIButton *widgetBuyBtn;


}
@end

@implementation NFInstaPurchaseView
@synthesize introductionArray,descriptionArray,titleArray,priceArray,widgetImageArray,selectedWidget;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    versionString=[UIDevice currentDevice].systemVersion;
    
    introductionArray=[[NSMutableArray alloc]initWithObjects:
                       @"Let your customers follow you directly. Messages are delivered from the website to your app and phone inbox instantly",
                       @"Show off your wares or services offered in a neatly arranged picture gallery.",
                       @"Visitors to your site would like to drop in at your store. Let them know when you are open and when you aren’t.",
                       @"Ensure every update you post and your website is optimised for search results. This plugin enhances of you being discovered considerably.",
                       nil];
    

    descriptionArray=[[NSMutableArray alloc]initWithObjects:
                      @"Visitors to your site can contact you directly by leaving a message with their phone number or email address. You will get these messages instantly over email and can see them in your NowFloats app inbox at any time. Talk To Business is a lead generating mechanism for your business.",
                      @"Some people are visual. They might not have the patience to read through your website. An image gallery on the site with good pictures of your products and services might just grab their attention. Upload upto 25 pictures and showcase your offerings.",
                      @"Visitors to your site would like to drop in at your store. Let them know when you are open and when you aren’t.",
                      @"Ensure every update you post and your website is optimised for search results. This plugin enhances of you being discovered considerably." ,nil];
    
    
    widgetImageArray=[[NSMutableArray alloc]initWithObjects:@"NFBizstore-Detail-ttb.png",@"NFBizstore-Detail-imggallery.png",@"NFBizstore-Detail-timings.png",@"NFBizstore-Detail-autoseo.png", nil];

    
    
    selectedIndex=0;
    
    switch (selectedWidget)
    {
        case BusinessTimingsTag:
            selectedIndex=2;
            break;
            
        case ImageGalleryTag:
            selectedIndex=1;
            break;
            
        case TalkToBusinessTag:
            selectedIndex=0;
            break;
            
        case AutoSeoTag:
            selectedIndex=3;
            break;
            
        default:
            break;
    }

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        
        else
        {
            viewHeight=568;
        }
    }
    

    if (viewHeight==480) {

        if (versionString.floatValue<7.0)
        {
            [instaPurchaseTableView setFrame:CGRectMake(instaPurchaseTableView.frame.origin.x, instaPurchaseTableView.frame.origin.y+44, instaPurchaseTableView.frame.size.width, 420)];
        }
        
        else
        {
            [instaPurchaseTableView setFrame:CGRectMake(instaPurchaseTableView.frame.origin.x, instaPurchaseTableView.frame.origin.y+64, instaPurchaseTableView.frame.size.width, 416)];
        }

        
    }
    
    
    else
    {
        if (versionString.floatValue<7.0)
        {
            [instaPurchaseTableView setFrame:CGRectMake(instaPurchaseTableView.frame.origin.x, instaPurchaseTableView.frame.origin.y+44, instaPurchaseTableView.frame.size.width, 520)];
        }
        
        else
        {
            [instaPurchaseTableView setFrame:CGRectMake(instaPurchaseTableView.frame.origin.x, instaPurchaseTableView.frame.origin.y+64, instaPurchaseTableView.frame.size.width,504)];
        }

    }
    
    if (versionString.floatValue<7.0)
    {
        
    }
    
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [instaPurchaseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    
    instaPurchaseTableView.alpha = 1;
    
    [UIView animateWithDuration:0.5 animations:^
                            {instaPurchaseTableView.alpha = 1.0;}];
    
    instaPurchaseTableView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.5;
    bounceAnimation.removedOnCompletion = NO;
    [instaPurchaseTableView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    instaPurchaseTableView.layer.transform = CATransform3DIdentity;

    
}


#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UILabel *introLbl=nil;
    
    if (indexPath.row==0)
    {
        UIImageView *widgetImgView;
        
        UILabel *widgetTitleLbl;
        
        widgetBuyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if (versionString.floatValue<7.0)
        {
            widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30,30, 85, 85)];
            
            widgetTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(135,25,85, 50)];
            
            [widgetBuyBtn setFrame:CGRectMake(135, 85, 85, 30)];
            
        }
        else
        {
            widgetImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30,30, 85, 85)];
            
            widgetTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(135,25, 85, 50)];
            
            [widgetBuyBtn setFrame:CGRectMake(135, 85, 85, 30)];
        }
        
        
    
        if (selectedWidget == TalkToBusinessTag)
        {
            widgetTitleLbl.text=@"Talk-To-Business";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-TTB_y.png"];
            [widgetBuyBtn setTitle:@"$3.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        if (selectedWidget == ImageGalleryTag)
        {
            widgetTitleLbl.text=@"Image Gallery";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-image-gallery_y.png"];
            [widgetBuyBtn setTitle:@"$2.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        if (selectedWidget == AutoSeoTag)
        {
            widgetTitleLbl.text=@"Auto-SEO";
            [widgetBuyBtn setTitle:@"FREE" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (selectedWidget == BusinessTimingsTag)
        {
            widgetTitleLbl.text=@"Business Timings";
            widgetImgView.image=[UIImage imageNamed:@"NFBizStore-timing_y.png"];
            [widgetBuyBtn setTitle:@"$0.99" forState:UIControlStateNormal];
            [widgetBuyBtn addTarget:self action:@selector(buyWidgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [widgetImgView  setBackgroundColor:[UIColor clearColor]];
        
        widgetTitleLbl.font=[UIFont fontWithName:@"Helvetica-Light" size:20.0];
        
        widgetTitleLbl.numberOfLines=2;
        
        widgetTitleLbl.lineBreakMode=UILineBreakModeWordWrap;
        
        widgetTitleLbl.backgroundColor=[UIColor clearColor];
        
        widgetTitleLbl.textColor=[UIColor colorWithHexString:@"2d2d2d"];
        
        [cell.contentView addSubview:widgetImgView];
        
        [cell.contentView addSubview:widgetTitleLbl];
        
        
        [widgetBuyBtn setBackgroundColor:[UIColor colorWithHexString:@"9F9F9F"]];
        
        widgetBuyBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Light" size:14.0];
        [widgetBuyBtn setTag:selectedWidget];
        
        [widgetBuyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb900"]] forState:UIControlStateHighlighted];
        
        [widgetBuyBtn.layer setCornerRadius:3.0];
        
        widgetBuyBtn.titleLabel.textColor=[UIColor whiteColor];
        
        [cell addSubview:widgetBuyBtn];
        
        UILabel *yellowLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,140, 320,2)];
        [yellowLbl setBackgroundColor:[UIColor colorWithHexString:@"ffb900"]];
        [cell.contentView addSubview:yellowLbl];
    }
    
    if (indexPath.row==1)
    {
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"ececec"];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,10,190,30)];
        [titleLabel setText:@"Introduction"];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:titleLabel];
        
        
        NSString *text = [introductionArray objectAtIndex:selectedIndex];
        
        NSString *stringData;
        
        stringData=[NSString stringWithFormat:@"\n%@",text];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14]
                             constrainedToSize:constraint
                                 lineBreakMode:nil];
        
        introLbl=[[UILabel alloc]init];
        [introLbl setFrame:CGRectMake(CELL_CONTENT_MARGIN+5,CELL_CONTENT_MARGIN-5,254, MAX(size.height, 44.f)+5)];
        [introLbl setText:stringData];
        [introLbl setNumberOfLines:30];
        [introLbl setLineBreakMode:NSLineBreakByWordWrapping];
        if (versionString.floatValue<7.0) {
            [introLbl setTextAlignment:NSTextAlignmentLeft];
        }
        else{
            [introLbl setTextAlignment:NSTextAlignmentJustified];
        }
        introLbl.textColor=[UIColor colorWithHexString:@"4f4f4f"];
        [introLbl setFont:[UIFont fontWithName:@"Helvetica-Light" size:13.0]];
        [introLbl setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:introLbl];
    }
    
    if (indexPath.row==2)
    {
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"d0d0d0"];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,10,190,30)];
        [titleLabel setText:@"How it works?"];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:titleLabel];
        
        
        NSString *text = [descriptionArray objectAtIndex:selectedIndex];
        
        NSString *stringData;
        
        stringData=[NSString stringWithFormat:@"\n%@",text];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14]
                             constrainedToSize:constraint
                                 lineBreakMode:nil];
        
        introLbl=[[UILabel alloc]init];
        [introLbl setFrame:CGRectMake(CELL_CONTENT_MARGIN+5,CELL_CONTENT_MARGIN-5,254, MAX(size.height, 44.f)+5)];
        [introLbl setText:stringData];
        [introLbl setNumberOfLines:30];
        [introLbl setLineBreakMode:NSLineBreakByWordWrapping];
        if (versionString.floatValue<7.0) {
            [introLbl setTextAlignment:NSTextAlignmentLeft];
        }
        else
        {
            [introLbl setTextAlignment:NSTextAlignmentJustified];
        }
        introLbl.textColor=[UIColor colorWithHexString:@"282828"];
        [introLbl setFont:[UIFont fontWithName:@"Helvetica-Light" size:13.0]];
        [introLbl setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:introLbl];
        
    }
    
    if (indexPath.row==3)
    {
        cell.contentView.backgroundColor=[UIColor colorWithHexString:@"8b8b8b"];
        
        UIImageView  *screenShotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,20,cell.frame.size.width, 196)];
        
        [screenShotImageView setImage:[UIImage imageNamed:[widgetImageArray objectAtIndex:selectedIndex]]];
        
        [screenShotImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [screenShotImageView setBackgroundColor:[UIColor clearColor]];
        
        [cell addSubview:screenShotImageView];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CGFloat height;
    
    if ([indexPath row]==0)
    {
        return 142;
    }
    
    else if([indexPath row]==1)
    {
        NSString *stringData=[NSString stringWithFormat:@"Introduction \n\n%@",[introductionArray objectAtIndex:selectedIndex]];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN);
    }
    
    else if([indexPath row]==2)
    {
        NSString *stringData=[NSString stringWithFormat:@"How it works \n\n%@",[descriptionArray objectAtIndex:selectedIndex]];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [stringData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        height = MAX(size.height,44.0f);
        
        return height + (CELL_CONTENT_MARGIN);
    }
    
    else
    {
        return height=240;
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
