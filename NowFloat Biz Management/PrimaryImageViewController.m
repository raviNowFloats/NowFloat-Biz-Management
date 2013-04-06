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
@synthesize imgView,pickedImage,chunkArray;
@synthesize uniqueIdString,uniqueIdArray,dataObj;
@synthesize requestArray,request;

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
    
    self.title = NSLocalizedString(@"Feature Image", nil);
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    chunkArray=[[NSMutableArray alloc]init];
    
    uniqueIdArray=[[NSMutableArray alloc]init];
    
    requestArray=[[NSMutableArray alloc]init];

    NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[appDelegate.storeDetailDictionary objectForKey:@"ImageUri"]];

    [imgView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
    
    [imageBg.layer setCornerRadius:7];
    
    
    UIBarButtonItem *editButton= [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                style:UIBarButtonItemStyleBordered
                                               target:self
                                               action:@selector(editButtonClicked)];
    
    self.navigationItem.rightBarButtonItem=editButton;
    
    /*Reveal Controller*/
    
    self.navigationController.navigationBarHidden=NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                style:UIBarButtonItemStyleBordered
                                                target:revealController
                                                action:@selector(revealToggle:)];

    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
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
    
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];

    uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img = imgView.image;
    
    dataObj=UIImageJPEGRepresentation(img,0.1);
    
    NSUInteger length = [dataObj length];
    
    NSUInteger chunkSize = 3000*10;
     
    NSUInteger offset = 0;

    int numberOfChunks=0;

    do
    {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[dataObj bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        
//        NSData *testChunk=[NSData dataWithBytes:(char *)[dataObj bytes] + offset length:thisChunkSize];
        
        
        offset += thisChunkSize;
        
        [chunkArray insertObject:chunk atIndex:numberOfChunks];
        
        numberOfChunks++;
        
    }
    
    while (offset < length);
    
    NSLog(@"Number Of Chunks:%d",[chunkArray count]);
    
    request=[[NSMutableURLRequest alloc] init];
    
    for (int i=0; i<[chunkArray count]; i++)
    {        
        NSString *postLength=[NSString stringWithFormat:@"%@",[chunkArray objectAtIndex:i]];
        
        NSString *urlString=[NSString stringWithFormat:@"%@/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueIdString,[chunkArray count],i];
            
        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *uploadUrl=[NSURL URLWithString:urlString];

        [request setURL:uploadUrl];
        [request setTimeoutInterval:20000];
        [request setHTTPMethod:@"PUT"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"binary/octet-stream" forHTTPHeaderField:@"Content-Type"];
        [request setCachePolicy:NSURLCacheStorageAllowed];
        [request setHTTPBody:dataObj];
        
        NSURLConnection *theConnection;
        //theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    [dataObj self];
    
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

        }
        
     
        if (buttonIndex==1)
        {
            picker=[[UIImagePickerController alloc] init];
                picker.allowsEditing=YES;
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [self presentViewController:picker animated:YES completion:NULL];

        }
        
    }
    
}



- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [imgView setContentMode:UIViewContentModeScaleAspectFit];

    imgView.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    pickedImage =[info objectForKey:UIImagePickerControllerEditedImage];
    
//    NSData* imageData = UIImageJPEGRepresentation(pickedImage, 0.1);
//    
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Image.jpg"]];
//    
//    NSLog(@"fullPathToFile:%@",fullPathToFile);
//    
//    [imageData writeToFile:fullPathToFile atomically:NO];
    

    [picker1 dismissModalViewControllerAnimated:NO];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"Post"
                                                        style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(updateImage)];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    

}



-(void)removeActivityIndicatorSubView
{
    
    
    UIAlertView *uploadSuccessAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Primary image was changed successfully" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    [uploadSuccessAlert show];
    
    uploadSuccessAlert=nil;
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code==200)
    {
        
        NSLog(@"code to upload image:%d",code);
        
        
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Feature image uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [successAlert show];
        successAlert=nil;
        
        
    }
    
    else
    {
        UIAlertView *imageUploadFailAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Yikes! Image upload failed please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [imageUploadFailAlert  show];
        
        imageUploadFailAlert=nil;
        
        
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in GetFpDetails:%d",[error code]);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload
{

    imageBg = nil;
    replaceImageButton = nil;
    activityIndicatorSubView = nil;
//    [self setImgView:nil];
    [super viewDidUnload];
}

@end
