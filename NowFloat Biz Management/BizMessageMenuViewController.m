//
//  BizMessageMenuViewController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/17/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "BizMessageMenuViewController.h"

@interface BizMessageMenuViewController ()

@end

@implementation BizMessageMenuViewController

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
   // self.view.backgroundColor = [[UIColor whiteColor]
                                // colorWithAlphaComponent:0.45];
     // self.postUpdateView.hidden=YES;
   //  [self performSelector:@selector(showMenu) withObject:self afterDelay:0.2f];
    
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[self.postUpdateView layer] addAnimation:animation forKey:@"SwitchToView1"];
    
    [UIView animateWithDuration:0.1f delay:0.5f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.postUpdateView.frame = CGRectMake(20, 40, 280, 157);
    }completion:^(BOOL finished) {
        self.postUpdateView.hidden = NO;
        
        [self.postUpdateTextView becomeFirstResponder];
    }];

}

- (void)showMenu
{
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    menuView.backgroundColor = [[UIColor whiteColor]
                                colorWithAlphaComponent:0.45];
    
   

    
    [menuView addMenuItemWithTitle:@"" andIcon:[UIImage imageNamed:@"facebook-icon.png"] andSelectedBlock:^{
        NSLog(@"Text selected");
        self.view.backgroundColor = [UIColor whiteColor];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [menuView addMenuItemWithTitle:@"" andIcon:[UIImage imageNamed:@"twitter-icon.png"] andSelectedBlock:^{
        NSLog(@"Photo selected");
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromTop];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        self.postUpdateView.hidden = NO;
        self.postUpdateView.frame = CGRectMake(20, 40, 280, 157);
        [[self.postUpdateView layer] addAnimation:animation forKey:@"SwitchToView1"];
        
        [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            
        }completion:^(BOOL finished) {
            [self.postUpdateTextView becomeFirstResponder];
        }];
        
        
    }];
//    [menuView addMenuItemWithTitle:@"" andIcon:[UIImage imageNamed:@"instagram-icon.png"] andSelectedBlock:^{
//        NSLog(@"Quote selected");
//        self.view.backgroundColor = [UIColor whiteColor];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }];
//    [menuView addMenuItemWithTitle:@"" andIcon:[UIImage imageNamed:@"path-icon.png"] andSelectedBlock:^{
//        NSLog(@"Link selected");
//        // [self performSegueWithIdentifier:@"content" sender:self];
//        self.view.backgroundColor = [UIColor whiteColor];
//        
//        
//        //[self dismissViewControllerAnimated:NO completion:nil];
//        
//      
//        
//    }];
    
    
    
    
    [menuView show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
