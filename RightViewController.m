//
//  RightViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 24/05/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "RightViewController.h"
#import "GPUImage.h"
#import "DLCImagePickerController.h"
#import "BizMessageViewController.h"
#import "PostMessageViewController.h"
#import "Mixpanel.h"

@interface RightViewController ()

@end

@implementation RightViewController

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
    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)messageUploadButtonClicked:(id)sender
{
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Post Deal"];
    

    PostMessageViewController *messageController=[[PostMessageViewController alloc]init];
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[DLCImagePickerController class]] )
    {
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:messageController];
            
        [revealController setFrontViewController:navigationController animated:YES];
        
    }
    
    else
    {
        [revealController rightRevealToggle:self];
    }

    
    
}

- (IBAction)imageUploadButtonClicked:(id)sender
{
        
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Post Image Deal"];

    
    DLCImagePickerController *picker = [[DLCImagePickerController alloc] init];
    
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[DLCImagePickerController class]] )
    {
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:picker];
            
        [revealController setFrontViewController:navigationController animated:YES];
        
    }
    
    else
    {
        [revealController rightRevealToggle:self];
    }
    

}


-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker
{
   
    
    if ([frontNavigationController.topViewController isKindOfClass:[BizMessageViewController class]] )
    {
        BizMessageViewController *frontViewController = [[BizMessageViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        navigationController.navigationBar.tintColor=[UIColor blackColor];
        
        [revealController setFrontViewController:navigationController animated:YES];
    }
    
    else
    {
        [revealController revealToggle:self];
    }

    
}



@end
