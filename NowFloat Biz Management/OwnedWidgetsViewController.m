//
//  OwnedWidgetsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 16/01/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "OwnedWidgetsViewController.h"
#import "AppDelegate.h"
#import "UIColor+HexaString.h"
#import "UIImage+ImageWithColor.h"
#import "BizStoreDetailViewController.h"

@interface OwnedWidgetsViewController ()
{
    NSString *versionString;
    
    float viewHeight;
    
    UIButton *backButton;
    
    AppDelegate *appDelegate;
    
    NSMutableArray *dataArray;
    
    NSMutableArray *widgetArray;
    
    NSMutableArray *widgetDescriptionArray;
    
    NSMutableArray *widgetTitleArray;
    
    NSMutableArray *widgetTagArray;
    
    NSMutableArray *widgetImageArray;
    
    NSMutableArray *widgetPriceArray;
    
}
@end

@implementation OwnedWidgetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (versionString.floatValue>=7.0)
    {
        if (backButton.isHidden) {
            [backButton setHidden:NO];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (versionString.floatValue>=7.0)
    {
        if (!backButton.isHidden)
        {
            [backButton setHidden:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    versionString=[[UIDevice currentDevice]systemVersion];
    
    appDelegate=(AppDelegate *)[UIApplication  sharedApplication].delegate;
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];

    [noWidgetView setHidden:YES];
    
    noWidgetView.center=self.view.center;
    
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
    
    if (viewHeight==480)
    {
        if (versionString.floatValue<7.0)
        {
            [ownedWidgetsTableView setFrame:CGRectMake(ownedWidgetsTableView.frame.origin.x, ownedWidgetsTableView.frame.origin.y+44, ownedWidgetsTableView.frame.size.width, 420)];
        }
        
        else
        {
            [ownedWidgetsTableView setFrame:CGRectMake(ownedWidgetsTableView.frame.origin.x, ownedWidgetsTableView.frame.origin.y+64, ownedWidgetsTableView.frame.size.width, 416)];
        }
    }
    
    else
    {
        if (versionString.floatValue<7.0)
        {
            [ownedWidgetsTableView setFrame:CGRectMake(ownedWidgetsTableView.frame.origin.x, ownedWidgetsTableView.frame.origin.y+44, ownedWidgetsTableView.frame.size.width, 520)];
        }
        
        else
        {
            [ownedWidgetsTableView setFrame:CGRectMake(ownedWidgetsTableView.frame.origin.x, ownedWidgetsTableView.frame.origin.y+64, ownedWidgetsTableView.frame.size.width,504)];
        }
    }
    
    
    if (versionString.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 13, 140, 20)];
        
        headerLabel.text=@"My Widgets";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];
        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(13,11,25,25)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"cancelCross2.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];

    }
    
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;

        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationItem.title=@"My Widgets";
        
        UIImage *buttonImage = [UIImage imageNamed:@"cancelCross2.png"];
        
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        
        backButton.frame = CGRectMake(13,11,25,25);
        
        [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addSubview:backButton];

        [ownedWidgetsTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }

    
    dataArray=[[NSMutableArray alloc]init];
    
    countArray=[[NSMutableArray alloc]init];
    
    widgetArray=[[NSMutableArray alloc]init];
    
    widgetDescriptionArray=[[NSMutableArray alloc]init];
    
    widgetImageArray=[[NSMutableArray alloc] init];
    
    widgetTagArray=[[NSMutableArray alloc]init];
    
    widgetTitleArray=[[NSMutableArray alloc]init];
    
    widgetPriceArray=[[NSMutableArray alloc]init];
    
    widgetTitleArray=[[NSMutableArray alloc]init];
    
    [widgetArray addObjectsFromArray:appDelegate.storeWidgetArray];
    
    
    if ([appDelegate.storeWidgetArray containsObject:@"CONTACTDETAILS"])
    {
        [widgetArray removeObject:@"CONTACTDETAILS"];
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"PANAROMA"])
    {
        [widgetArray removeObject:@"PANAROMA"];
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"SOCIALSHARE"])
    {
        [widgetArray removeObject:@"SOCIALSHARE"];
    }
    
    if ([appDelegate.storeWidgetArray containsObject:@"SUBSCRIBERCOUNT"])
    {
        [widgetArray removeObject:@"SUBSCRIBERCOUNT"];
    }

    if ([appDelegate.storeWidgetArray containsObject:@"VISITORCOUNT"])
    {
        [widgetArray removeObject:@"VISITORCOUNT"];
    }
    
    if ([widgetArray containsObject:@"IMAGEGALLERY"])
    {
        [widgetTitleArray addObject:@"Image Gallery"];
        [widgetDescriptionArray addObject:@"Add pictures of your products/services to your site."];
        [widgetImageArray addObject:@"NFBizStore-image-gallery_y.png"];
        [widgetPriceArray addObject:@"$2.99"];
        [widgetTagArray addObject:@"1004"];
    }
    
    if ([widgetArray containsObject:@"TOB"])
    {
        [widgetTitleArray addObject:@"Talk-To-Business"];
        
        [widgetPriceArray addObject:@"$3.99"];
        
        [widgetTagArray addObject:@"1002"];
        
        [widgetDescriptionArray addObject:@"Let your site visitors become leads."];
        
        [widgetImageArray addObject:@"NFBizStore-TTB_y.png"];
    }
    
    if ([widgetArray containsObject:@"TIMINGS"])
    {
        [widgetTitleArray addObject:@"Business Timings"];
        
        [widgetPriceArray addObject:@"$0.99"];
        
        [widgetTagArray addObject:@"1006"];
        
        [widgetDescriptionArray  addObject:@"Tell people when you are open and when you aren't."];
        
        [widgetImageArray addObject:@"NFBizStore-timing_y.png"];
   
    }
    
    if ([widgetArray containsObject:@"SITESENSE"])
    {
        [widgetTitleArray addObject:@"Auto-SEO"];
        
        [widgetPriceArray addObject:@"FREE"];
        
        [widgetTagArray addObject:@"1008"];
        
        [widgetDescriptionArray addObject:@"A plug-in to optimize content for SEO automatically."];
        
        [widgetImageArray addObject:@"NFBizStore-SEO_y.png"];
    }
    
    
    NSMutableDictionary *secondItemsArrayDict = [NSMutableDictionary dictionaryWithObject:widgetTitleArray  forKey:@"data"];
    
    [secondItemsArrayDict setValue:widgetPriceArray forKey:@"price"];
    
    [secondItemsArrayDict setValue:widgetTagArray forKey:@"tag"];
    
    [secondItemsArrayDict setValue:widgetDescriptionArray forKey:@"description"];
    
    [secondItemsArrayDict setValue:widgetImageArray forKey:@"picture"];
    
    [dataArray addObject:secondItemsArrayDict];
    
    [ownedWidgetsTableView setBackgroundView:Nil];

    [ownedWidgetsTableView setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
    
    [self setNoUpdateView];

}


-(void)backBtnClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setNoUpdateView
{
    @try
    {
        if (widgetTitleArray.count==0)
        {
            [noWidgetView setHidden:NO];
            [ownedWidgetsTableView setHidden:YES];
        }
        
        else
        {
            [noWidgetView setHidden:YES];
            [ownedWidgetsTableView setHidden:NO];
        }
    }
    @catch (NSException *exception) {}

}

#pragma UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return widgetTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UILabel *freeAppBg;
    
    UIImageView *freeAppImgView;
    
    UILabel *freeAppTitleLabel;
    
    UILabel *freeAppDetailLabel;
    
    UIButton *buyBtn;

    UITableViewCell *cell=[[UITableViewCell alloc]init];
    
    cell.backgroundView=[[UIView alloc]initWithFrame:CGRectZero];
    
        if (versionString.floatValue<7.0)
        {
            freeAppBg=[[UILabel alloc]initWithFrame:CGRectMake(0,10, 300, 72)];
            freeAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
            freeAppTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
            freeAppDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
            buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57, 60, 18)];
        }
        
        else
        {
            freeAppBg=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 72)];
            freeAppImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6,6,60,60)];
            freeAppTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,6, 300, 15)];
            freeAppDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(82,23,280, 15)];
            buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(92,57, 60, 18)];
        }
        
        [freeAppBg setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        //[freeAppBg.layer setCornerRadius:3.0];
        
        [freeAppBg setClipsToBounds:YES];
        
        freeAppBg.layer.needsDisplayOnBoundsChange=YES;
        
        freeAppBg.layer.shouldRasterize=YES;
        
        [freeAppBg.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
        [freeAppTitleLabel setBackgroundColor:[UIColor clearColor]];
        
        [freeAppTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        
        [freeAppTitleLabel setTextColor:[UIColor darkGrayColor]];
        
        [freeAppDetailLabel setBackgroundColor:[UIColor clearColor]];
        
        [freeAppDetailLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0]];
        
        [freeAppDetailLabel setTextColor:[UIColor lightGrayColor]];
        
        [buyBtn.layer setCornerRadius:3.0];
        
        [buyBtn setBackgroundColor:[UIColor colorWithHexString:@"8c8c8c"]];
        
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        buyBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:9.0];
        
        [buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffb900"]] forState:UIControlStateHighlighted];
    
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"data"]];
        NSArray *descriptionArray=[NSArray arrayWithArray:[dictionary objectForKey:@"description"]];
        NSArray *tagArray=[NSArray arrayWithArray:[dictionary objectForKey:@"tag"]];
        NSArray *pictureArray=[NSArray arrayWithArray:[dictionary objectForKey:@"picture"]];
    
        [freeAppTitleLabel setText:[array objectAtIndex:indexPath.row]];
    
        [freeAppDetailLabel setText:[descriptionArray objectAtIndex:[indexPath row]]];
        
        [freeAppImgView setImage:[UIImage imageNamed:[pictureArray objectAtIndex:[indexPath row]]]];

        [buyBtn setTitle:@"Purchased" forState:UIControlStateNormal];
    
        [buyBtn setTag:[[tagArray objectAtIndex:[indexPath row]] intValue]];
    
    
        [cell.contentView addSubview:freeAppBg];
        
        [freeAppBg addSubview:freeAppImgView];
        
        [freeAppBg addSubview:freeAppTitleLabel];

        [freeAppBg addSubview:freeAppDetailLabel];

        [cell addSubview:buyBtn];
    
        cell.backgroundColor=[UIColor clearColor];
    
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height;
    
    return height=84.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BizStoreDetailViewController *detailController=[[BizStoreDetailViewController alloc]initWithNibName:@"BizStoreDetailViewController" bundle:Nil];
    
    detailController.selectedWidget=[[widgetTagArray objectAtIndex:[indexPath row]] intValue];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
