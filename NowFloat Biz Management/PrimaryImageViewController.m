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
#import <QuartzCore/QuartzCore.h>
#import "uploadPrimaryImage.h"

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
                                                                            target:self     action:@selector(updateImage)];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;

    
    [imageBg.layer setCornerRadius:7];
    
}



-(void)updateImage
{
    
    uploadPrimaryImage *uploadPrimary=[[uploadPrimaryImage alloc]init];
    
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];

    UIImage *img = imgView.image;
    
    NSData *dataObj=UIImagePNGRepresentation(img);
    
    NSUInteger length = [dataObj length];
    
    NSUInteger chunkSize = 3000*10;
    
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

    
    for (int i=0; i<[chunkArray count]; i++)
    {
        
        [uploadPrimary uploadImage:[chunkArray objectAtIndex:i] uuid:uuid numberOfChunks:[chunkArray count] currentChunk:i];
        
    }
    

    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    imgView = nil;
    imageBg = nil;

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

- (IBAction)cameraButtonClicked:(id)sender
{
    
    picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing=YES;
    [self presentModalViewController:picker animated:NO];
    
    
    picker=nil;
    [picker setDelegate:nil];
}

- (IBAction)galleryButtonClicked:(id)sender
{
    
    
    picker=[[UIImagePickerController alloc] init];
    picker.allowsEditing=YES;
    [picker setDelegate:self];
    [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:picker animated:YES completion:NULL];
    
    picker=nil;
    [picker setDelegate:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    imgView.image=[info objectForKey:UIImagePickerControllerEditedImage];


    [picker1 dismissModalViewControllerAnimated:NO];

}
@end
