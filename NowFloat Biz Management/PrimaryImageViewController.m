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
@synthesize imgView,chunkArray;
@synthesize uniqueIdString,uniqueIdArray,dataObj;
@synthesize request,theConnection;

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
    
    self.title = NSLocalizedString(@"Feature Image", nil);
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    chunkArray=[[NSMutableArray alloc]init];
    
    uniqueIdArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    successCode=0;//Used in the delegate method to show a success alertView.
    
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
    
    
    [activitySubview setHidden:YES];

    
}


-(void)editButtonClicked
{ 
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select From" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
    selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    selectAction.tag=1;
    [selectAction showInView:self.view];
}



-(void)updateImage
{
    [activitySubview setHidden:NO];
    
    self.navigationItem.rightBarButtonItem=nil;
    
    [self performSelector:@selector(postImage) withObject:nil afterDelay:0.1];
}


-(void)postImage
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
    
    NSLog(@"Dataobject Length:%d",length);
    
    NSUInteger chunkSize = 3000*10;
    
    NSUInteger offset = 0;
    
    int numberOfChunks=0;
    
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
    
    totalImageDataChunks=[chunkArray count];
    
    request=[[NSMutableURLRequest alloc] init];
        
    for (int i=0; i<[chunkArray count]; i++)
    {
//       NSString *urlString=[NSString stringWithFormat:@"http://ec2-54-224-22-185.compute-1.amazonaws.com/Discover/v1/FloatingPoint/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueIdString,[chunkArray count],i];
        
        NSString *urlString=[NSString stringWithFormat:@"%@/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueIdString,[chunkArray count],i];
        
        NSString *postLength=[NSString stringWithFormat:@"%ld",(unsigned long)[[chunkArray objectAtIndex:i] length]];
        
        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *uploadUrl=[NSURL URLWithString:urlString];
    
        NSMutableData *tempData =[[NSMutableData alloc]initWithData:[chunkArray objectAtIndex:i]] ;
    
        [request setURL:uploadUrl];
        [request setTimeoutInterval:30000];
        [request setHTTPMethod:@"PUT"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"binary/octet-stream" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:tempData];
        [request setCachePolicy:NSURLCacheStorageAllowed];        
        
      theConnection=[[NSURLConnection  alloc]initWithRequest:request delegate:self startImmediately:YES];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
        [receivedData appendData:data1];    
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSMutableString *receivedString=[[NSMutableString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"receivedString:%@",receivedString);
    
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
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];

    [imgView setContentMode:UIViewContentModeScaleAspectFit];

    imgView.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData* imageData = UIImageJPEGRepresentation(imgView.image, 0.1);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];

    [imageData writeToFile:fullPathToFile atomically:NO];

    [picker1 dismissModalViewControllerAnimated:NO];

    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"Post"
                    style:UIBarButtonItemStyleBordered
                   target:self
                   action:@selector(updateImage)];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    
}



-(void)removeActivityIndicatorSubView
{
    
    [activitySubview setHidden:YES];
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code==200)
    {
        successCode++;
                
        NSLog(@"successCode:%d",successCode);
        
        if (successCode==totalImageDataChunks)
        {
            successCode=0;
            
            NSLog(@"code to upload image:%d",code);
            
            UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Feature image uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [successAlert show];
            successAlert=nil;
            
            [self removeActivityIndicatorSubView];
            
            UIBarButtonItem *editButton= [[UIBarButtonItem alloc] initWithTitle:@"Edit"                                                                      style:UIBarButtonItemStyleBordered                                                                     target:self
                action:@selector(editButtonClicked)];
            
            self.navigationItem.rightBarButtonItem=editButton;

        }
        
    }
    
    else
    {
        
        successCode=0;
        
        [connection cancel];
        
        UIAlertView *imageUploadFailAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Yikes! Image upload failed please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [imageUploadFailAlert  show];
        
        imageUploadFailAlert=nil;

        [self removeActivityIndicatorSubView];
        
        UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:@"Cancel"                                                                           style:UIBarButtonItemStyleBordered                                                                     target:self
            action:@selector(cancelEditButtonClicked)];
        
        self.navigationItem.rightBarButtonItem=cancelButton;
        
    }
    
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in Primary Image Upload:%d",[error code]);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload
{

    imageBg = nil;
//    [self setImgView:nil];
    activitySubview = nil;
    [super viewDidUnload];
}

@end
