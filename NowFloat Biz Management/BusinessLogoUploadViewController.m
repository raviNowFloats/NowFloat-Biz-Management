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
    
    if (![appDelegate.storeLogoURI isEqualToString:@""])
    {
        
        NSString *imageUriSubString=[appDelegate.storeLogoURI  substringToIndex:5];
        
        if ([imageUriSubString isEqualToString:@"local"])
        {
            
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[appDelegate.storeLogoURI substringFromIndex:5]];
            
            imgView.image=[UIImage imageWithContentsOfFile:imageStringUrl];
        }
        
        else
        {
            
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,appDelegate.storeLogoURI];
            
            [imgView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
            
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
                [contentSubView setFrame:CGRectMake(contentSubView.frame.origin.x, contentSubView.frame.origin.y+20, contentSubView.frame.size.width, contentSubView.frame.size.height)];
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
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(85,13,160, 20)];
        
        headerLabel.text=@"Business Logo";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textAlignment=NSTextAlignmentCenter;
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headerLabel];

        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];

    }
    
    else
    {
    
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(105, 13,150, 20)];
        
        headerLabel.text=@"Business Logo";
        
        headerLabel.backgroundColor=[UIColor clearColor];
        
        headerLabel.textColor=[UIColor colorWithHexString:@"464646"];
        
        headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        [view addSubview:headerLabel];
        
        [self.navigationController.navigationBar addSubview:view];

        
        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
        
        self.navigationItem.leftBarButtonItem = leftBtnItem;

    
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
    
    fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [picker1 dismissModalViewControllerAnimated:NO];
    
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
        UIAlertView *logoAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Logo upload failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [logoAlertView show];
        
        logoAlertView=nil;
    }
    
    else
    {
        appDelegate.storeLogoURI=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
