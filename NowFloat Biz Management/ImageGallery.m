//
//  ImageGallery.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 11/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "ImageGallery.h"
#import "Mixpanel.h"
#import "SWRevealViewController.h"
#import "DownloadControl.h"
#import "DeleteSecondaryImage.h"
#import "AsyncDowloadImages.h"

@interface ImageGallery ()<SWRevealViewControllerDelegate,DownloadDelegate,AsyncDownloadDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DeleteSecondaryImageDelegate>
{
     double viewHeight;
    
     Mixpanel *mixPanel;
    
    UIImageView *scrollImage;
    
    UIView *detailViewImage;
    
    UINavigationBar *bottomNav, *topNav;
    
    UINavigationItem *navItem, *topNavItem;
    
     UIScrollView *detailImageView;
    
    UIButton *backButton;
    
    NSInteger *currentIndex;
    
    UIImageView *secondaryImage;
    
    UIButton *leftCustomButton,*rightCustomButton,*deleteButton , *goBackButton, *moveRight;
    
    UIBarButtonItem *leftNav, *rightNav, *deleteImage, *backNav, *plusButton, *backMove;
    
}

@end

@implementation ImageGallery

@synthesize imageList,scrollGallery,myScrollImage,dataObj,uniqueIdString,chunkArray,request,theConnection;


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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
        }
        
        else
        {
            viewHeight=568;
            
            
        }
        
    }
    
    version=[UIDevice currentDevice].systemVersion;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    mixPanel=[Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    secondaryImage = [[UIImageView alloc] init];
    
    chunkArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    currentIndex = 0;
    
    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Image Gallery";
        
        bottomNav.barStyle = UIBarStyleDefault;
        topNav.barStyle = UIBarStyleDefault;
        if(viewHeight == 480)
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,420, self.view.frame.size.width, 44.0)];
        }
        else
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,self.view.frame.size.height+44, self.view.frame.size.width, 44.0)];
        }
        
    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Image Gallery";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationController.navigationBar.translucent = NO;
        
        if(viewHeight == 480)
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,420, self.view.frame.size.width, 44.0)];
        }
        else
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 454, self.view.frame.size.width + 2, 50.0)];
            
        }
        bottomNav.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        bottomNav.translucent = NO;
        bottomNav.tintColor = [UIColor whiteColor];
        
        
    }
    
    leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftCustomButton setFrame:CGRectMake(25,0,35,15)];
    [leftCustomButton setImage:[UIImage imageNamed:@"Menu-Burger.png"] forState:UIControlStateNormal];
    
    [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightCustomButton setFrame:CGRectMake(0,0,15,15)];
    [rightCustomButton setImage:[UIImage imageNamed:@"Plus-Button.png"] forState:UIControlStateNormal];
    [rightCustomButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftCustomButton];
    
    
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    plusButton = [[UIBarButtonItem alloc] initWithCustomView:rightCustomButton];
    
   
    
    self.navigationItem.rightBarButtonItem = plusButton;
    
    
    if(viewHeight == 480)
    {
        detailViewImage = [[UIView alloc] initWithFrame: CGRectMake ( 0, 0, 320, 480)];
        detailImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
    }
    else
    {
        detailViewImage = [[UIView alloc] initWithFrame: CGRectMake ( 0, 0, 320, 568)];
        detailImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
    }
    
    
    navItem  = [[UINavigationItem alloc] init];
    
    topNavItem = [[UINavigationItem alloc] init];
    
    goBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [goBackButton setFrame:CGRectMake(25,0,16,16)];
    [goBackButton setImage:[UIImage imageNamed:@"moveBack.png"] forState:UIControlStateNormal];
    
    
    [goBackButton addTarget:self action:@selector(goToPrev) forControlEvents:UIControlEventTouchUpInside];
    
    backMove = [[UIBarButtonItem alloc] initWithCustomView:goBackButton];
    
   // backNav = [[UIBarButtonItem alloc] initWithCustomView:goBackButton];
    
    
    deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteButton setFrame:CGRectMake(0,0,15,20)];
    [deleteButton setImage:[UIImage imageNamed:@"newDelete.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteImageEvent) forControlEvents:UIControlEventTouchUpInside];
    
    deleteImage = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    
    
               
    
    
     backButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"moveLeft.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(moveLeft:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 16, 16)];
    
    
    moveRight =  [UIButton buttonWithType:UIButtonTypeCustom];
    [moveRight setImage:[UIImage imageNamed:@"moveRight.png"] forState:UIControlStateNormal];
    [moveRight addTarget:self action:@selector(moveRight:) forControlEvents:UIControlEventTouchUpInside];
    [moveRight setFrame:CGRectMake(0, 0, 16, 16)];
    
    leftNav = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    rightNav = [[UIBarButtonItem alloc] initWithCustomView:moveRight];
    
    [self startLoadingImages];
}

-(void)startLoadingImages
{
    DownloadControl *downloadCntl =[[DownloadControl alloc]init];
    downloadCntl.delegate = self;
    [downloadCntl startDownload];
}

-(void)downloadDidSucceed:(NSDictionary *)imageDict
{
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    
    argsArray = [imageDict objectForKey:@"SecondaryTileImages"];
    
    NSMutableArray *newImages = [[NSMutableArray alloc] init];
    
    newImages = [imageDict objectForKey:@"SecondaryImages"];

    int height=80;
    imageList = [[NSMutableArray alloc] init];
    for(int i= 0; i < argsArray.count; i++)
    {
        
        NSString *urlstring = [NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[newImages objectAtIndex:i]];
        UIImageView *subview = [[UIImageView alloc] init];
        CGRect frame;
        frame.origin.x = 100 * i + 13;
        if(i < 3)
        {
            frame.origin.y = 10;
        }
        frame.size.height = 80;
        frame.size.width = 95;
        
        if(frame.origin.x > 200.000000 )
        {
            int j = i % 3;
            frame.origin.x = 100 * j + 13;
            if( j == 0)
            {
                height +=80;
                frame.origin.y += 90;
            }
        }
        
        scrollGallery.pagingEnabled = YES;
        subview.tag = i;
        subview.frame = frame;
        [imageList addObject:urlstring];
        subview.userInteractionEnabled = YES;
        
        [scrollGallery addSubview:subview];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [subview addGestureRecognizer:tap];
        
        AsyncDowloadImages *downloadCntl = [[AsyncDowloadImages alloc] init];
        downloadCntl.delegate = self;
        
        [downloadCntl downloadImage:urlstring andIndex:[NSNumber numberWithInt:i]];
        
    }
    
    scrollGallery.contentSize =  CGSizeMake(scrollGallery.frame.size.width, height);
    
    [self.view addSubview:scrollGallery];
   
}

-(void)addImage
{
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Add from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
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
            [self presentViewController:picker animated:NO completion:nil];
            picker=nil;
        }
        
        
        if (buttonIndex==1)
        {
            picker=[[UIImagePickerController alloc] init];
            picker.allowsEditing=YES;
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:picker animated:YES completion:NULL];
            picker=nil;
            
        }
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker1 dismissViewControllerAnimated:NO completion:nil];
    
    secondaryImage.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self performSelector:@selector(pushStoreGalleryVC:) withObject:[info objectForKey:UIImagePickerControllerEditedImage] afterDelay:0.5];
    
    
}

-(void)pushStoreGalleryVC:(id)sender
{
    @try
    {
        NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
        
        NSRange range = NSMakeRange (0, 36);
        
        uuid=[uuid substringWithRange:range];
        
        NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
        
        uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
        
        uniqueIdString=[[NSString alloc]initWithString:uuid];
        
        UIImage *img = secondaryImage.image;
        
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
    @catch (NSException *exception) {
        NSLog(@"Exception in uploading image is %@", exception);
    }
    
  
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
        
        
    }
    
}

-(void)refreshJson
{
    [self startLoadingImages];
}

-(void)downloadDidFail
{
    NSLog(@"Delegate method failure block");
}

-(void) AsyncDownloadDidFinishWithImage:(UIImage *)downloadedImage atIndex:(NSNumber *)imageIndex
{
    for(UIImageView *view in scrollGallery.subviews)
    {
        if(view.tag == imageIndex.intValue)
        {
            [view setImage:downloadedImage];
            [scrollGallery addSubview:view];
        }
    }
}

-(void) AsyncDownloadDidFail:(NSNumber *) imageIndex{
    for(UIImageView *view in scrollGallery.subviews)
    {
        if(view.tag == imageIndex.intValue)
        {
            [view setImage:[UIImage imageNamed:@"notfound.jpg"]];
            [scrollGallery addSubview:view];
            [self.view addSubview:scrollGallery];
        }
    }
    
}

-(void)imageTapped:(UITapGestureRecognizer *)gesture
{
    UIImageView *imgView = (UIImageView *)gesture.view;
    // NSString *url = [imageList objectAtIndex:imgView.tag];
    NSInteger index = imgView.tag;
    // NSLog(@"Index of image clicked is : %@", url);
    [self performSelector:@selector(scrollableImage:) withObject:[NSNumber numberWithInt:index]];
}


-(void)deleteImageEvent
{
    [self deleteImage:[NSNumber numberWithInteger:currentIndex]];
}

-(void)deleteImage:(NSNumber *)index
{
    @try {
        
        NSString *imageNameString=[[NSString alloc]init];
        
        DeleteSecondaryImage *deleteController=[[DeleteSecondaryImage alloc]init];
        
        deleteController.delegate=self;
        
        for (int i=0; i<[[appDelegate.storeDetailDictionary objectForKey:@"SecondaryImages"] count]; i++)
        {
            
            if (i==index.intValue) {
                
                imageNameString=[[appDelegate.storeDetailDictionary objectForKey:@"SecondaryImages"] objectAtIndex:i];
                
            }
            
        }
        
        NSRange range=NSMakeRange(11, 28);
        
        imageNameString=[imageNameString substringWithRange:range];
        
        [deleteController deleteImage:imageNameString];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in deleting image is %@", exception);
    }
   
}


-(void)updateSecondaryImage:(NSString *)responseCode
{
    @try {
        
        if(currentIndex != 0)
        {
            NSNumber *newIndex = [NSNumber numberWithInteger:currentIndex];
            NSNumber *imageIndex = [NSNumber numberWithInt:newIndex.intValue-1];
            [self scrollableImage:imageIndex];
        }
        else
        {
            [self imageHomeView];
        }
    }
    @catch (NSException *exception) {
         NSLog(@"Exception in deleting image is %@", exception);
    }
    
}

-(void)imageHomeView
{
    for(UIImageView *view in scrollGallery.subviews)
    {
        NSNumber *newIndex = [NSNumber numberWithInteger:currentIndex];
        
        if(view.tag == newIndex.intValue)
        {
            [view removeFromSuperview];
        }
    }
    [self goToPrev];
    [self refreshJson];
}


-(void)scrollableImage:(NSNumber *) index
{
    @try {
        
        currentIndex = index.integerValue;
        detailViewImage.backgroundColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = backMove;
        self.navigationItem.rightBarButtonItem = deleteImage;
        scrollImage.image = nil;
        
        NSString *url = [imageList objectAtIndex:index.intValue];
        NSURL *urlstring = [NSURL URLWithString:url];
        NSData *imageData = [NSData dataWithContentsOfURL:urlstring];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if(viewHeight == 480)
        {
            scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320,392)];
        }
        else{
            scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10,myScrollImage.frame.size.width,myScrollImage.frame.size.height-20)];
        }
        
        [scrollImage setImage:image];
        scrollImage.contentMode = UIViewContentModeScaleAspectFit;
        detailImageView.showsHorizontalScrollIndicator = YES;
        
        [detailViewImage addSubview:scrollImage];
        detailImageView.contentSize = CGSizeMake(detailImage.frame.size.width, detailImage.frame.size.height);
        
        [detailImage addSubview:detailImageView];
        
        
        topNavItem.leftBarButtonItem = backNav;
        topNav.items = [NSArray arrayWithObject:topNavItem];
        
        navItem.leftBarButtonItem = leftNav;
        leftNav.tag = index.intValue;
        rightNav.tag = index.intValue;
        navItem.rightBarButtonItem = rightNav;
        
        
        if(index.intValue == imageList.count-1)
        {
            rightNav.enabled = NO;
            if(imageList.count == 1)
            {
                leftNav.enabled = NO;
            }
        }
        else{
            if(index.intValue == 0 )
            {
                leftNav.enabled = NO;
            }
            else{
                rightNav.enabled = YES;
                leftNav.enabled = YES;
            }
        }
        
        bottomNav.items = [NSArray arrayWithObject:navItem];
        [detailViewImage addSubview:bottomNav];
        [detailViewImage addSubview:topNav];
        [self.view addSubview:detailViewImage];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in scrolling is %@", exception);
    }

}

-(void)goToPrev
{

    self.navigationItem.rightBarButtonItem = plusButton;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftCustomButton];
    
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
   
    [detailViewImage removeFromSuperview];
    
    [self refreshJson];
}


-(void)moveLeft:(id)sender{
    
    NSNumber *index = [NSNumber numberWithInt:leftNav.tag-1];
    
    [self performSelector:@selector(scrollableImage:) withObject:index];
    
}

-(void)moveRight:(id)sender{
    
    NSNumber *index = [NSNumber numberWithInt:rightNav.tag + 1];
    
    [self performSelector:@selector(scrollableImage:) withObject:index];
}

-(void)moveBack:(id)sender{
    
    [detailImage removeFromSuperview];
    

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
