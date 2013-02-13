//
//  StoreGalleryViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreGalleryViewController.h"
#import "UIColor+HexaString.h"
#import "SWRevealViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface StoreGalleryViewController ()

@end

@implementation StoreGalleryViewController
@synthesize storeGalleryScrollView;

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
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    imagesArray=[[NSMutableArray alloc]init];
    
    imagesArray=[appDelegate.storeDetailDictionary objectForKey:@"SecondaryTileImages"];    
        
    if ([imagesArray isEqual:[NSNull null]])
    {
        
            
        
        
        
    }
    
    
    else{

    
    //Set The Grid View Here a basic ScrollView with the look of a grid
    int x,y;
    x=0;
    y=2;
    
    
    
    for(int j=0;j<[imagesArray count];j++)
    {
        
         NSString *imageStringUrl=[NSString stringWithFormat:@"https://api.withfloats.com%@",[imagesArray objectAtIndex:j]];
        
        image=[[UIImageView alloc] initWithFrame:CGRectMake(x,y,80,75)];
        
        [image setBackgroundColor:[UIColor clearColor]];
        
        postImage=[[UIImageView alloc]
                   initWithFrame:CGRectMake(5,5,76, 70)];//74*74 initial value
        
        [postImage setContentMode:UIViewContentModeScaleToFill];
        
        button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self
                   action:@selector(addPopup:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [button setFrame:CGRectMake(x+5, y+5, 76,70)];
        
        [button setTag:j];
        
        if (x>180)
        {
            x=0;
            y=y+80;
        }
        else
        {
            x=x+81;
        }
        if (x==0)
        {
            postImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,5, 67, 70)];
        }
        
        [postImage setImageWithURL:[NSURL URLWithString:imageStringUrl]];
        
        [image addSubview:postImage];
        
        [storeGalleryScrollView addSubview:button];
        [storeGalleryScrollView addSubview:image];
        
        
    }
    
    [storeGalleryScrollView setContentSize:CGSizeMake(320, y+80)];
    

    }
    
    
    
        
    self.title = NSLocalizedString(@"Other Images", nil);

}



-(void)addPopup:(id)sender
{
    
    UIButton *b=(UIButton *)sender;
    
    [b setFrame:CGRectMake(b.frame.origin.x,b.frame.origin.y,b.frame.size.width,b.frame.size.height)];

    [b setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    
    [storeGalleryScrollView addSubview:b];
    
//    NSLog(@"x:%f,y:%f,H:%f,W:%f",b.frame.origin.x,b.frame.origin.y,b.frame.size.width,b.frame.size.height);
    
    [b addTarget:self
          action:@selector(removeSelection:)
     forControlEvents:UIControlEventTouchUpInside];

    
    b=nil;
    sender=nil;


}



-(void)removeSelection:(id)sender
{

    UIButton *b=(UIButton *)sender;
    
    [b setFrame:CGRectMake(b.frame.origin.x,b.frame.origin.y,b.frame.size.width,b.frame.size.height)];
    
    [b setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [b addTarget:self
               action:@selector(addPopup:)
     forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPicButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
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
        
        if (buttonIndex==1)
        {
            
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


@end