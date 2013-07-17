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
        
    self.navigationController.navigationBarHidden=NO;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    chunkArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    [bgImageView.layer setCornerRadius:7.0];
    
    [bgImageView.layer setBorderWidth:1.0];
    
    [bgImageView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    

    
    
    [activityIndicatorSubview setHidden:YES];
        
    secondaryImageView.image=secondaryImage;
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-btn.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;

    
//    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"Post"
//                        style:UIBarButtonItemStyleBordered
//                       target:self
//                       action:@selector(updateImage)];
    
    
    
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,5,30,30)];
    
    [customButton addTarget:self action:@selector(updateImage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithCustomView:customButton];

    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;

        
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)updateView
{
    FGalleryViewController *networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];

    [networkGallery reloadGallery];

    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:networkGallery];
    [[self navigationController] setViewControllers:viewControllers animated:YES];

    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Add secondary image"];
    
 
    
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
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img = secondaryImageView.image;
    
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
    
    NSLog(@"Total Chunks:%d",totalImageDataChunks);
    
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
    
    [self performSelector:@selector(refreshJson)];
    
}


-(void)refreshJson
{
    
    RefreshFpDetails *refrehImageUri=[[RefreshFpDetails alloc]init];
    
    refrehImageUri.delegate=self;
    
    [refrehImageUri fetchFpDetail];
    
//    [activityIndicatorSubview setHidden:YES];
    
    
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"Code:%d",code);
    
    if (code==200)
    {
        successCode++;

        if (successCode == totalImageDataChunks)
        {
            
            UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Secondary image uploaded" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [successAlert show];
            successAlert=nil;

        }
        
    }
    
    else
    {
        successCode=0;
        
        [connection cancel];
        
        UIAlertView *imageUploadFailAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Yikes! Image upload failed please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [imageUploadFailAlert  show];
        
        imageUploadFailAlert=nil;

    }
    
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in Secondary Image Upload:%d",[error code]);
    
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
