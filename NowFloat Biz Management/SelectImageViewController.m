//
//  SelectImageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "SelectImageViewController.h"
#import "StoreGalleryViewController.h"
#import "SWRevealViewController.h"
#import "PrimaryImageViewController.h"


@interface SelectImageViewController ()

@end

@implementation SelectImageViewController

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
    self.title = NSLocalizedString(@"Image Gallery", nil);

    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detail-btn.png"]
             style:UIBarButtonItemStyleBordered
            target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];


    
    



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [super viewDidUnload];
}
- (IBAction)primaryImageClicked:(id)sender
{
    
    
    PrimaryImageViewController *primaryController=[[PrimaryImageViewController alloc]initWithNibName:@"PrimaryImageViewController" bundle:nil];
    
    [self.navigationController pushViewController:primaryController animated:YES];
    
    
}

- (IBAction)secondaryImageClicked:(id)sender
{
    
    StoreGalleryViewController *galleryController=[[StoreGalleryViewController   alloc]initWithNibName:@"StoreGalleryViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:galleryController animated:YES];
    

}
@end
