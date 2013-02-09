//
//  PrimaryImageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 04/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "PrimaryImageViewController.h"
#import "StoreGalleryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PrimaryImageViewController ()

@end

@implementation PrimaryImageViewController

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
    
    self.title = NSLocalizedString(@"Primary Image", nil);
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];


    NSString *imageStringUrl=[NSString stringWithFormat:@"https://api.withfloats.com%@",[appDelegate.storeDetailDictionary objectForKey:@"ImageUri"]];

    [imgView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
    
    [imgView setContentMode:UIViewContentModeScaleToFill];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Post" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self     action:@selector(updateMessage)];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;

    
}



-(void)updateMessage
{
    
    NSLog(@"update message");
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    imgView = nil;
    [super viewDidUnload];
}





- (IBAction)uploadPicButtonClicked:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",@"Secondary Image", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag=1;
    [actionSheet showInView:self.view];
    
    
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==1)
    {
        
        if (buttonIndex==0)
        {
            picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing=YES;
            [self presentModalViewController:picker animated:NO];
            
            
            picker=nil;
            [picker setDelegate:nil];

        }
        
        
        
        if (buttonIndex==1) {
            
            picker=[[UIImagePickerController alloc] init];
            picker.allowsEditing=YES;
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [self presentViewController:picker animated:YES completion:NULL];
            
            picker=nil;
            [picker setDelegate:nil];
        }
        
        
        if (buttonIndex==2)
        {
            
            
            
        }

        
        
    }
    
    
    
    
    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    imgView.image=[info objectForKey:UIImagePickerControllerEditedImage];


    [picker1 dismissModalViewControllerAnimated:NO];

}
@end
