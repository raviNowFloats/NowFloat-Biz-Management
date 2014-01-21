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
#import "UIColor+HexaString.h"
#import "WidgetViewController.h"


@interface RightViewController ()<PostMessageViewControllerDelegate,DLCImagePickerDelegate,DLCImageSuccessDelegate>

@end

@implementation RightViewController
@synthesize delegate;


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
    
    UIImage *postMessageImage=[UIImage imageNamed:@"PostMsg.png"];
    
    UIImage *postImageImage=[UIImage imageNamed:@"PostPicture.png"];
    
    selectionArray=[[NSMutableArray alloc]initWithObjects:postMessageImage,postImageImage,nil];
    
    textArray=[[NSMutableArray alloc]initWithObjects:@"Post\nMessage",@"Upload\nPicture",nil];
    
    revealController = self.revealViewController;
    
    frontNavigationController = (id)revealController.frontViewController;

}


#pragma UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{

    return selectionArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{


    NSString *identifierString=@"stringIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierString];
    
    if (cell==nil)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString  ];
            
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(30,8,40, 40)];
        
        imgView.tag=1;
        
        [imgView setBackgroundColor:[UIColor clearColor]];
        
        [cell addSubview:imgView];
                
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,50,100,40)];
                
        lbl.textAlignment=NSTextAlignmentCenter;
        
        lbl.numberOfLines=2;
        
        lbl.lineBreakMode = UILineBreakModeWordWrap;

        
        lbl.tag=2;
        
        [lbl setBackgroundColor:[UIColor clearColor]];
        
        [cell addSubview:lbl];
        
        
    }
    
    UIImageView *imageView=(UIImageView *)[cell viewWithTag:1];
    
    imageView.image=[selectionArray objectAtIndex:[indexPath row]];

    UILabel *label=(UILabel *)[cell viewWithTag:2];
    
    label.contentMode=UIControlContentHorizontalAlignmentCenter;

    label.text=[textArray objectAtIndex:[indexPath row]];
    
    label.textColor=[UIColor colorWithHexString:@"464646"];
    
    label.font=[UIFont fontWithName:@"Helvetica" size:14.0];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    return cell;

}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row==0)
    {
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Post Deal"];
        
        PostMessageViewController *messageController=[[PostMessageViewController alloc]initWithNibName:@"PostMessageViewController" bundle:nil];

        messageController.delegate=self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:messageController];
        
        // You can even set the style of stuff before you show it
        navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        // And now you want to present the view in a modal fashion
        [self presentModalViewController:navigationController animated:YES];
            
    }
    
    if (indexPath.row==1)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel track:@"Post Image Deal"];
        
        DLCImagePickerController *picker = [[DLCImagePickerController alloc] init];
        
        picker.successDelegate=self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:picker];
        
        // And now you want to present the view in a modal fashion
        [self presentModalViewController:navigationController animated:YES];
    }
    

}


#pragma PostMessageViewControllerDelegate


-(void)messageUpdatedSuccessFully
{
    [revealController performSelector:@selector(rightRevealToggle:) withObject:nil afterDelay:1.0];
}


-(void)messageUpdateFailed
{


}


#pragma DLCImagePickerDelegate

-(void)imageDidFinishedUpload
{
    
    [revealController performSelector:@selector(rightRevealToggle:) withObject:nil afterDelay:1.0];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)messageUploadBtnClicked:(id)sender
{
    

    
    
}


- (IBAction)imageUploadBtnClicked:(id)sender
{
        

}



@end
