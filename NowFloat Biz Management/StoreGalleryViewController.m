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
#import "WSAssetPicker.h"




@interface StoreGalleryViewController () <WSAssetPickerControllerDelegate>
@property (nonatomic, strong) WSAssetPickerController *pickerController;

@end

@implementation StoreGalleryViewController
@synthesize storeGalleryScrollView;
@synthesize pickerController = _pickerController;


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
    
    uploadSecondary=[[uploadSecondaryImage alloc]init];
    
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
        
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x,y,80,75)];
        
        [imageView setBackgroundColor:[UIColor clearColor]];
        
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
        
        [imageView addSubview:postImage];
        
        [storeGalleryScrollView addSubview:button];
        [storeGalleryScrollView addSubview:imageView];
        
        
    }
    
    [storeGalleryScrollView setContentSize:CGSizeMake(320, y+80)];
    

    }
    
    
    //Design the navigation bar and navigation button here
    UIBarButtonItem *uploadMore= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus.png"]
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(showImagePicker)];
    
    
    self.navigationItem.rightBarButtonItem=uploadMore;
    self.title = NSLocalizedString(@"Other Images", nil);

    

}


-(void)showImagePicker
{

    self.pickerController = [[WSAssetPickerController alloc] initWithDelegate:self];
    
    [self presentViewController:self.pickerController animated:YES completion:NULL];


}


- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        int index = 0;
        
        for (ALAsset *asset in assets)
        {
        
            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            index++;
            
            NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
            
            NSRange range = NSMakeRange (0, 36);
            
            uuid=[uuid substringWithRange:range];
            
            NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
            
            uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
            
            NSData *dataObj=UIImagePNGRepresentation(image);
            
            int bytes = [dataObj length];
            
            NSLog(@"number of bytes:%d",bytes);
            
            NSUInteger length = [dataObj length];
            
            NSUInteger chunkSize = 1024*10;
            
            NSUInteger offset = 0;
            
            int numberOfChunks=0;
            
            NSMutableArray *chunkArray=[[NSMutableArray alloc]init];
            
            do
            {
                
                NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
                
                NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[dataObj bytes] + offset
                                                     length:thisChunkSize
                                               freeWhenDone:NO];
                
                offset += thisChunkSize;
                
                [chunkArray insertObject:chunk atIndex:numberOfChunks];
                
                numberOfChunks++;
                
            }
            
            while (offset < length);
            
            NSLog(@"chunkArray count:%d",chunkArray.count);

            
            for (int i=0; i<[chunkArray count]; i++)
            {
                NSLog(@"uuid:%@",uuid);
                
                [uploadSecondary uploadImage:[chunkArray objectAtIndex:i] uuid:uuid numberOfChunks:[chunkArray count] currentChunk:i];
                
            }
         
            
            
            
            
            
            
        }
    }];
    
}



-(void)addPopup:(id)sender
{
    
    UIButton *b=(UIButton *)sender;
    
    [b setFrame:CGRectMake(b.frame.origin.x,b.frame.origin.y,b.frame.size.width,b.frame.size.height)];

    [b setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    
    [storeGalleryScrollView addSubview:b];
        
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
