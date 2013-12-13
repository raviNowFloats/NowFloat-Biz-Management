//
//  StoreGalleryViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 03/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "StoreGalleryViewController.h"
#import "UIColor+HexaString.h"
#import <QuartzCore/QuartzCore.h>
#import "SWRevealViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RefreshFpDetails.h"
#import "Mixpanel.h"    


@interface StoreGalleryViewController ()<RefreshFpDetailDelegate>

@end


@implementation StoreGalleryViewController

@synthesize secondaryImageView,secondaryImage;
@synthesize uniqueIdString,chunkArray,dataObj;
@synthesize request,theConnection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    successCode=0;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    version = [[UIDevice currentDevice] systemVersion];

    chunkArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    [bgImageView.layer setCornerRadius:7.0];
    
    [bgImageView.layer setBorderWidth:1.0];
    
    [bgImageView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];

    [activityIndicatorSubview setHidden:YES];
        
    secondaryImageView.image=secondaryImage;
    
    
    if (version.floatValue<7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"back-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
     
        customRightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [customRightButton setFrame:CGRectMake(280,5,30,30)];
        
        [customRightButton addTarget:self action:@selector(updateImage) forControlEvents:UIControlEventTouchUpInside];
        
        [customRightButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
        
        [navBar addSubview:customRightButton];
    }

    else
    {
    
    self.navigationController.navigationBarHidden=NO;

    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,5,30,30)];
    
    [customButton addTarget:self action:@selector(updateImage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
        

    
    }
        
}


-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}



- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    num = [appDelegate.secondaryImageArray count];
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [appDelegate.secondaryImageArray objectAtIndex:index];
}


-(void)updateImage
{
    [activityIndicatorSubview setHidden:NO];
    [self performSelector:@selector(postImage) withObject:nil afterDelay:0.1];
}


-(void)postImage
{
    
    if (version.floatValue<7.0)
    {
        [customRightButton setEnabled:NO];
        [leftCustomButton setEnabled:NO];
    }
    
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img = secondaryImageView.image;
    
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
        offset += thisChunkSize;
        
        [chunkArray insertObject:chunk atIndex:numberOfChunks];
        
        numberOfChunks++;
        
    }
    
    while (offset < length);
    
    totalImageDataChunks=[chunkArray count];
    
    request=[[NSMutableURLRequest alloc] init];
    
    for (int i=0; i<[chunkArray count]; i++)
    {        
        NSString *urlString=[NSString stringWithFormat:@"%@/createSecondaryImage/?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueIdString,[chunkArray count],i];
        
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
    
    
}


-(void)refreshJson
{
    RefreshFpDetails *refrehImageUri=[[RefreshFpDetails alloc]init];
    
    refrehImageUri.delegate=self;
    
    [refrehImageUri fetchFpDetail];
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code==200)
    {
        successCode++;

        if (successCode == totalImageDataChunks)
        {
            UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Secondary image uploaded" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [successAlert show];
            successAlert=nil;

            [self performSelector:@selector(refreshJson) withObject:Nil afterDelay:5];
        }
    }
    
    else
    {
        successCode=0;
        
        [connection cancel];
        
        UIAlertView *imageUploadFailAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Yikes! Image upload failed please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [imageUploadFailAlert  show];
        
        imageUploadFailAlert=nil;

        if (version.floatValue<7.0)
        {
            [customRightButton setEnabled:YES];
            [leftCustomButton setEnabled:YES];
        }
        else
        {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [self.navigationItem.leftBarButtonItem setEnabled:YES];
        }
    }
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in Secondary Image Upload:%d",[error code]);
    
}


-(void)updateView
{
    [self back];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Add secondary image"];
}


-(void)updateViewFailedWithError
{
    [activityIndicatorSubview setHidden:YES];
    
    if (version.floatValue<7.0)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    
    else
    {
        [customRightButton setEnabled:YES];
        [leftCustomButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setSecondaryImageView:nil];
    bgImageView = nil;
    activityIndicatorSubview = nil;
    [super viewDidUnload];    
}

@end
