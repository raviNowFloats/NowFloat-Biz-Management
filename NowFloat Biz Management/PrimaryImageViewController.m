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
#import "UIColor+HexaString.h"
#import "Mixpanel.h"


@interface PrimaryImageViewController ()

@end

@implementation PrimaryImageViewController
@synthesize imgView,chunkArray;
@synthesize uniqueIdString,uniqueIdArray,dataObj;
@synthesize request,theConnection;
@synthesize isFromHomeVC;
@synthesize localImagePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
-(void)viewDidAppear:(BOOL)animated
{
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }

}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    version = [[UIDevice currentDevice] systemVersion];

    chunkArray=[[NSMutableArray alloc]init];
    
    uniqueIdArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    successCode=0;//Used in the delegate method to show a success alertView.
    
    
    //Check wether image is uploaded to show it from the local storage or is to be downloaded from the URL
    
    if (!isFromHomeVC)
    {
        if (![appDelegate.primaryImageUri isEqualToString:@""])
        {
            
            NSString *imageUriSubString=[appDelegate.primaryImageUri  substringToIndex:5];
            
            if ([imageUriSubString isEqualToString:@"local"])
            {
                        
                NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[appDelegate.primaryImageUri substringFromIndex:5]];
                
                imgView.image=[UIImage imageWithContentsOfFile:imageStringUrl];
            }
            
            else
            {
                
                NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,appDelegate.primaryImageUri];
                
                [imgView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
                
            }
            
        }
    }
    
    
    else
    {
        NSString *imageUriSubString=[localImagePath  substringToIndex:5];
        
        if ([imageUriSubString isEqualToString:@"local"])
        {
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[localImagePath substringFromIndex:5]];
            
            imgView.image=[UIImage imageWithContentsOfFile:imageStringUrl];
        }
    }
    
    
    [imageBg.layer setCornerRadius:7];
    
    [imageBg.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [imageBg.layer setBorderWidth:1.0];
    
    
    if (!isFromHomeVC)
    {
        revealController = [self revealViewController];
        
        revealController.delegate=self;

        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        
        revealController.rightViewRevealWidth=0;
        
        revealController.rightViewRevealOverdraw=0;
    }
    
    //Design a custom navigation bar here
    
    if (version.floatValue<7.0)
    {

        self.title = NSLocalizedString(@"Featured Image", nil);

        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        [contentSubView setFrame:CGRectMake(0,44,contentSubView.frame.size.width, contentSubView.frame.size.height)];

        
        if (isFromHomeVC)
        {

            UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
            
            UIButton  *customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [customCancelButton setFrame:CGRectMake(5,9,32,26)];
            
            [customCancelButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
            
            [customCancelButton setShowsTouchWhenHighlighted:YES];
            
            if (version.floatValue<7.0)
            {
                [navBar addSubview:customCancelButton];
            }
            
            [changeBtnClicked setHidden:YES];
            
            [saveButton setHidden:NO];

        }
        
        else
        {
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
            
        [changeBtnClicked addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];

        [saveButton setHidden:YES];
        }

    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];

        self.navigationItem.title=@"Featured Image";
        
        [self.navigationController.navigationBar addSubview:view];

        
        if (isFromHomeVC)
        {

            UIImage *buttonCancelImage = [UIImage imageNamed:@"pre-btn.png"];
            
            UIButton  *customCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [customCancelButton setFrame:CGRectMake(5,9,32,26)];
            
            [customCancelButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
            
            [customCancelButton setImage:buttonCancelImage  forState:UIControlStateNormal];
            
            [customCancelButton setShowsTouchWhenHighlighted:YES];
            

            UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:customCancelButton];
            
            self.navigationItem.leftBarButtonItem = leftBtnItem;

            [changeBtnClicked setHidden:YES];

            [saveButton setHidden:NO];
        }
        
        else
        {
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;
            
        [changeBtnClicked addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
        [saveButton setHidden:YES];
        }
    }
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(85,13,160, 20)];
    
    headerLabel.text=@"Featured Image";
    
    headerLabel.backgroundColor=[UIColor clearColor];
    
    headerLabel.textAlignment=NSTextAlignmentCenter;
    
    headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
    
    [navBar addSubview:headerLabel];

    
    
    
    [activitySubview setHidden:YES];

    
}


-(void)backToHome
{
    [self dismissModalViewControllerAnimated:YES];
}



-(void)editBtnClicked
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
        
        NSString *urlString=[NSString stringWithFormat:@"%@/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueIdString,[chunkArray count],i];
        
        NSLog(@"urlString:%@",urlString);
        
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
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:picker animated:YES completion:NULL];

        }
        
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }

    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];

    [imgView setContentMode:UIViewContentModeScaleAspectFit];

    imgView.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData* imageData = UIImageJPEGRepresentation(imgView.image, 0.7);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];

    appDelegate.primaryImageUploadUrl=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];

    [picker1 dismissModalViewControllerAnimated:NO];
    
    /*
    UIButton *rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightCustomButton setFrame:CGRectMake(280,5,30,30)];
    
    [rightCustomButton setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    
    [rightCustomButton addTarget:self action:@selector(updateImage) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:rightCustomButton];
    */
    
    [saveButton setHidden:NO];
    [changeBtnClicked setHidden:YES];

    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];


}



- (IBAction)saveBtnClicked:(id)sender
{
    
    [self updateImage];
    
}


-(void)removeActivityIndicatorSubView
{
    
    [saveButton setHidden:YES];
    [changeBtnClicked setHidden:NO];
    [activitySubview setHidden:YES];
    
}



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code==200)
    {
        successCode++;
        
        if (successCode==totalImageDataChunks)
        {
            successCode=0;
            
            UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Display image uploaded" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            if (isFromHomeVC)
            {
                [successAlert setTag:1001];
                appDelegate.primaryImageUri=[NSMutableString stringWithFormat:@"%@",localImagePath];
            }
            
            else
            {
                appDelegate.primaryImageUri=[NSMutableString stringWithFormat:@"%@",appDelegate.primaryImageUploadUrl];
            }
            
            [successAlert show];
            successAlert=nil;
            
            [self removeActivityIndicatorSubView];
                        
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"Change featured image"];
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
            action:@selector(cancelEditBtnClicked)];
        
        self.navigationItem.rightBarButtonItem=cancelButton;
    }
}


-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in Primary Image Upload:%d",[error code]);
    
}



#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001)
    {
        if (buttonIndex==0)
        {
            [self backToHome];
        }
    }
}


#pragma SWRevealViewControllerDelegate


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    else if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    else if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    else if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    
    else if ( position == FrontViewPositionLeftSide ) str = @"FrontViewPositionLeftSide";
    
    else if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    
    return str;
}


- (IBAction)revealFrontController:(id)sender
{
    
    revealController = [self revealViewController];
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"]) {
        
        [revealController performSelector:@selector(rightRevealToggle:)];
        
    }
    
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealController performSelector:@selector(revealToggle:)];
        
    }
    
}


- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;
{
    
    frontViewPosition=[self stringFromFrontViewPosition:position];
    
    //FrontViewPositionLeft
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeftSide"])
    {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    //FrontViewPositionCenter
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeft"]) {
        
        [revealFrontControllerButton setHidden:YES];
        
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"]) {
        
        [revealFrontControllerButton setHidden:NO];
        
    }
    
    
    
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
    changeBtnClicked = nil;
    saveButton = nil;
    revealFrontControllerButton = nil;
    [super viewDidUnload];
}

@end
