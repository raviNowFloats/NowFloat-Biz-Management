//
//  BusinessLogoUploadViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 18/10/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessLogoUploadViewController.h"
#import "UIColor+HexaString.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NFActivityView.h"
#import "Mixpanel.h"
#import "AlertViewController.h"

@interface BusinessLogoUploadViewController ()
{
    float viewWidth;
    float viewHeight;
    NFActivityView *nfActivity;
}
@end

@implementation BusinessLogoUploadViewController
@synthesize dataObj;


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
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    nfActivity=[[NFActivityView alloc]init];
    
    nfActivity.activityTitle=@"Updating";

    receivedData=[[NSMutableData alloc]init];
    
    version = [[UIDevice currentDevice] systemVersion];

    dataObj=[[NSData alloc]init];

    imgView.contentMode=UIViewContentModeScaleAspectFit;
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    if (![appDelegate.storeLogoURI isEqualToString:@""])
    {
        
        NSString *imageUriSubString=[appDelegate.storeLogoURI  substringToIndex:5];
        
        if ([imageUriSubString isEqualToString:@"local"])
        {
            
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[appDelegate.storeLogoURI substringFromIndex:5]];

            
            [imgView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
            CGSize sacleSize = CGSizeMake(200, 200);
            UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
            [imgView.image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
            UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imgView.image = resizedImage;

            

        }
        
        else
        {
            
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,appDelegate.storeLogoURI];
            
           [imgView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
            CGSize sacleSize = CGSizeMake(200, 200);
            UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
            [imgView.image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
            UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imgView.image = resizedImage;

            
           
            
        }
        
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        viewWidth=result.width;
        if(result.height == 480)
        {
            if (version.floatValue<7.0)
            {
                [contentSubView setFrame:CGRectMake(contentSubView.frame.origin.x, contentSubView.frame.origin.y-40, contentSubView.frame.size.width, contentSubView.frame.size.height)];
            }
            else
            {
                [contentSubView setFrame:CGRectMake(contentSubView.frame.origin.x, contentSubView.frame.origin.y-30, contentSubView.frame.size.width, contentSubView.frame.size.height)];
            }
        }
        
        else
        {
            if (version.floatValue<7.0)
            {
                [contentSubView setFrame:CGRectMake(contentSubView.frame.origin.x, contentSubView.frame.origin.y+20, contentSubView.frame.size.width, contentSubView.frame.size.height)];
            }
        }
        
    }
    
    
    if (version.floatValue<7.0)
    {
        
        /*Design a custom navigation bar here*/
        
        self.navigationController.navigationBarHidden=NO;
        

        
        self.navigationItem.title=@"Business Logo";

    }
    
    else
    {
         self.navigationItem.title=@"Business Logo";
    

    
    }
    
    [imageBg.layer setCornerRadius:7];
    
    [imageBg.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [imageBg.layer setBorderWidth:1.0];
    
    
    
    
    
    
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    //Set the RightRevealWidth 0
    revealController.rightViewRevealWidth=0;
    
    revealController.rightViewRevealOverdraw=0;
    
    [changeBtnClicked addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [saveButton setHidden:YES];
    
    
    @try
    {
        if ([appDelegate.storeDetailDictionary objectForKey:@"LogoUrl"]==[NSNull null])
        {
            [changeBtnClicked setTitle:@"Add" forState:UIControlStateNormal];
            [changeBtnClicked setTitle:@"Add" forState:UIControlStateHighlighted];
        }
    }
    @catch (NSException *exception) {}
}


-(void)editBtnClicked
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
            [self presentViewController:picker animated:NO completion:nil];
            
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
    
    fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [picker1 dismissViewControllerAnimated:NO completion:nil];
    
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

-(void)updateImage
{

    [nfActivity showCustomActivityView];
    
    [self performSelector:@selector(postImage) withObject:nil afterDelay:0.1];
}


-(void)postImage
{

    UIImage *img = imgView.image;
    
    dataObj=UIImageJPEGRepresentation(img,0.7);

    NSString *urlString=[NSString stringWithFormat:@"%@/createLogoImage?clientId=%@&fpId=%@",appDelegate.apiWithFloatsUri,appDelegate.clientId,[appDelegate.storeDetailDictionary objectForKey:@"_id"]];
    
    NSURL *uploadUrl=[NSURL URLWithString:urlString];
    
    request=[[NSMutableURLRequest alloc] init];

    NSString *postLength=[NSString stringWithFormat:@"%ld",(unsigned long)[dataObj length]];
    
    [request setHTTPMethod:@"PUT"];
    [request setURL:uploadUrl];
    [request setTimeoutInterval:30000];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"binary/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataObj];
    [request setCachePolicy:NSURLCacheStorageAllowed];
    
    theConnection=[[NSURLConnection  alloc]initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [receivedData appendData:data1];
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    NSLog(@"code:%d",code);
    
    if (code!=200)
    {
        
        
        [AlertViewController CurrentView:self.view errorString:@"Business Logo upload failed. Please try again" size:0 success:NO];
    }
    
    else
    {
        appDelegate.storeLogoURI=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
        
        [changeBtn setTitle:@"Change" forState:UIControlStateNormal];
        
        [AlertViewController CurrentView:self.view errorString:@"Business Logo Uploaded" size:0 success:YES];
        
    }
    
    [nfActivity hideCustomActivityView];
    [saveButton setHidden:YES];
    [changeBtnClicked setHidden:NO];
}



-(void) connection:(NSURLConnection *)connection   didFailWithError: (NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in Logo Image Upload:%d",[error code]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
}


-(void)removeActivityIndicatorSubView
{
    
    [saveButton setHidden:YES];
    [changeBtnClicked setHidden:NO];
    [nfActivity hideCustomActivityView];
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
    
    SWRevealViewController *revealController = [self revealViewController];
    
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



-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=YES;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
