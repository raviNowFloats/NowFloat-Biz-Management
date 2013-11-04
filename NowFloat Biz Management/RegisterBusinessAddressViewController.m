//
//  RegisterBusinessAddressViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 15/08/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "RegisterBusinessAddressViewController.h"
#import "RegisterContactDetailsViewController.h"



@interface RegisterBusinessAddressViewController ()
{

    float viewHeight;

}
@end

@implementation RegisterBusinessAddressViewController

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
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            /*For iphone 3,3gS,4,42*/
            viewHeight=480;
        }
        if(result.height == 568)
        {
            /*For iphone 5*/
            viewHeight=568;
            
        }
    }
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [navBar setClipsToBounds:YES];
    
    navBar.topItem.title=@"Business Address";
    
    UIImage *cancelbuttonImage = [UIImage imageNamed:@"_back.png"];
    
    customCancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customCancelBtn setFrame:CGRectMake(-10,0,90,44)];
    
    [customCancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customCancelBtn setImage:cancelbuttonImage  forState:UIControlStateNormal];
    
    [customCancelBtn setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customCancelBtn];
    
    
    
    
    
    UIImage *nextbuttonImage = [UIImage imageNamed:@"nextButton.png"];
    
    
    customNextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customNextButton setFrame:CGRectMake(240, 0, 90, 44)];
    
    [customNextButton addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [customNextButton setImage:nextbuttonImage  forState:UIControlStateNormal];
    
    [customNextButton setShowsTouchWhenHighlighted:YES];
    
    [navBar addSubview:customNextButton];

}


-(void)back
{

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)nextBtnClicked
{

    RegisterContactDetailsViewController *contactDetailsController=[[RegisterContactDetailsViewController alloc]initWithNibName:@"RegisterContactDetailsViewController" bundle:nil ];
    
    [self.navigationController pushViewController:contactDetailsController animated:YES];
    
    contactDetailsController=nil;


}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    navBar = nil;
    stepSubView = nil;
    [super viewDidUnload];
}
@end
