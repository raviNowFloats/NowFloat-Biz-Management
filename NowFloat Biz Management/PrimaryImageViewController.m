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
    
    [replaceImageButton setHidden:YES];
    
    self.title = NSLocalizedString(@"Primary Image", nil);
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *imageStringUrl=[NSString stringWithFormat:@"https://api.withfloats.com%@",[appDelegate.storeDetailDictionary objectForKey:@"ImageUri"]];

    [imgView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
    
    [imageBg.layer setCornerRadius:7];
    
    
    UIBarButtonItem *editButton= [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                style:UIBarButtonItemStyleBordered
                                               target:self
                                               action:@selector(editButtonClicked)];
    
    self.navigationItem.rightBarButtonItem=editButton;
    

    
}




-(void)editButtonClicked
{

    [replaceImageButton setHidden:NO];
    
    
    UIBarButtonItem *cancelEdit= [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                            style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(cancelEditButtonClicked)];
    
    self.navigationItem.rightBarButtonItem=cancelEdit;

}



-(void)cancelEditButtonClicked
{

    UIBarButtonItem *editButton= [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                    style:UIBarButtonItemStyleBordered
                                                    target:self
                                                    action:@selector(editButtonClicked)];
    
    self.navigationItem.rightBarButtonItem=editButton;
    
    [replaceImageButton setHidden:YES];

}




-(void)updateImage
{
    uploadPrimaryImage *uploadPrimary=[[uploadPrimaryImage alloc]init];
    
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];

    UIImage *img = uploadImage;
    
    NSData *dataObj=UIImagePNGRepresentation(img);
    
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
        
    }
    
    while (offset < length);
    
    
    for (int i=0; i<[chunkArray count]; i++)
    {
        [uploadPrimary uploadImage:[chunkArray objectAtIndex:i] uuid:uuid numberOfChunks:[chunkArray count] currentChunk:i];
    }
    

}



- (IBAction)selectButtonClicked:(id)sender
{
    
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select From" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
    
    
    selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    selectAction.tag=1;
    [selectAction showInView:self.view];
    
    
}



-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 0)
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
        
    }
    
}



- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [imgView setContentMode:UIViewContentModeScaleAspectFit];

    imgView.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    uploadImage =[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker1 dismissModalViewControllerAnimated:NO];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                        style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(updateImage)];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    

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
    replaceImageButton = nil;
    [super viewDidUnload];
}





@end
