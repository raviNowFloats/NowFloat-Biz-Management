//
//  BizStoreViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 23/09/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BizStoreViewController.h"
#import "BizStoreIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface BizStoreViewController ()
{

    NSArray *_products;
    NSNumberFormatter * _priceFormatter;

}

@end

@implementation BizStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressSubview) name:IAPHelperProductPurchaseRestoredNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden=YES;
    
    [navBar setClipsToBounds:YES];
    
    //Create the custom cancel button here
    
    UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
    
    customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelButton setFrame:CGRectMake(5,9,32,26)];
    
    [customCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
    
    [customCancelButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelButton];
    
    [bizStoreTableView setHidden:YES];
    
    // Add to end of viewDidLoad
    _priceFormatter = [[NSNumberFormatter alloc] init];
    
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    [processingPurchaseRequestSubview setHidden:YES];
    
    [self reload];
    
}


-(void)back
{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}


- (void)reload
{
    _products = nil;
    [bizStoreTableView reloadData];
    [[BizStoreIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            _products = products;
            [bizStoreTableView reloadData];
            [loadingProductsActivityIndicator stopAnimating];
            [bizStoreTableView setHidden:NO];
        }
    }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier=@"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==Nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    SKProduct * product = (SKProduct *) _products[indexPath.row];
    
    cell.textLabel.text = product.localizedTitle;
    
    [_priceFormatter setLocale:product.priceLocale];
    
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
    
    if ([[BizStoreIAPHelper sharedInstance] productPurchased:product.productIdentifier])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        cell.accessoryView = nil;
    }
    
    else
    {
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 72, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
    }
    
    
    return cell;
}


- (void)buyButtonTapped:(id)sender
{
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[BizStoreIAPHelper sharedInstance] buyProduct:product];
    
    [processingPurchaseRequestSubview setHidden:NO];
    
}


- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {
            [bizStoreTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
    [processingPurchaseRequestSubview setHidden:YES];
    
}


-(void)removeProgressSubview
{

    [processingPurchaseRequestSubview setHidden:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
