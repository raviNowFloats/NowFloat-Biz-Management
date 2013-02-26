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
@synthesize uploadProgressSubview;

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
    
    [uploadProgressSubview setHidden:YES];
    
    [editSubview setHidden:YES];
    
    uploadArray=[[NSMutableArray alloc]init];
    
    if ([[appDelegate.storeDetailDictionary objectForKey:@"SecondaryTileImages"] isEqual:[NSNull null]])
    {

        
    }
    
    
    else
    {

    [imagesArray addObjectsFromArray:[appDelegate.storeDetailDictionary objectForKey:@"SecondaryTileImages"]];

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
    UIBarButtonItem *uploadMore= [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(enableEditMode)];
    
    
    self.navigationItem.rightBarButtonItem=uploadMore;
    self.title = NSLocalizedString(@"Other Images", nil);

    

}



-(void)enableEditMode
{
    UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(cancelEditMode)];

    
    [editSubview setHidden:NO];
    self.navigationItem.rightBarButtonItem=cancelButton;
    self.title = NSLocalizedString(@"Edit", nil);
    

}



-(void)cancelEditMode
{
    UIBarButtonItem *uploadMore= [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(enableEditMode)];
    

    [editSubview setHidden:YES];
    self.navigationItem.rightBarButtonItem=uploadMore;
    self.title = NSLocalizedString(@"Other Images", nil);


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
                                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", nil];
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
            
            [self showImagePicker];
            
        }
        
        
    }
    

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

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [uploadArray addObjectsFromArray:assets];
    
    [self performSelector:@selector(uploadSecondaryImages) withObject:nil afterDelay:2];
    
}



-(void)uploadSecondaryImages
{
    int index=0;
    
    [self.uploadProgressSubview setHidden:NO];


    if (uploadArray.count==0)
    {
        [self.uploadProgressSubview setHidden:YES];
        return;
    }
    
    
    else
    {
        for (ALAsset *asset in uploadArray)
        {
            
            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            index++;
            
            NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
            
            NSRange range = NSMakeRange (0, 36);
            
            uuid=[uuid substringWithRange:range];
            
            NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
            
            uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
            
            NSData *dataObj=UIImagePNGRepresentation(image);
            
            NSUInteger length = [dataObj length];
            
            NSUInteger chunkSize = 3072*10;
            
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
                
                NSLog(@"Index :%d",index);
                
                
                
                
            }
            
            while (offset < length);
            
            for (int i=0; i<[chunkArray count]; i++)
            {
                
                [uploadSecondary uploadImage:[chunkArray objectAtIndex:i] uuid:uuid numberOfChunks:[chunkArray count] currentChunk:i];
                
                currentImageUpload.text=[NSString stringWithFormat:@"%d",i+1];
                totalImagesToUpload.text=[NSString stringWithFormat:@"%d",[chunkArray count]+1];
                
            }
            
        }

//        [uploadProgressSubview setHidden:YES];
    
    }
    

}





- (void)viewDidUnload
{

    [self setUploadProgressSubview:nil];
    editSubview = nil;
    currentImageUpload = nil;
    totalImagesToUpload = nil;
    [super viewDidUnload];
    
}
@end
