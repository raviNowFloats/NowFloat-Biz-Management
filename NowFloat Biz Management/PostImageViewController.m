//
//  PostImageViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 12/02/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "PostImageViewController.h"
#import "UIColor+HexaString.h"  
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "CreatePictureDeal.h"
#import "BizMessageViewController.h"


@interface PostImageViewController ()

@end

@implementation PostImageViewController
@synthesize request,dataObj,uniqueIdString,chunkArray,theConnection;



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
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
    chunkArray=[[NSMutableArray alloc]init];
    
    receivedData=[[NSMutableData alloc]init];
    
    successCode=0;
    
    [bgLabel.layer setCornerRadius:6.0];
    
    [activitySubView setHidden:YES];

    
    /*Add a gesture recogniser to remove a keyboard*/
    
    tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    /*Notification To Move View Up Or Down*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    /*Notification to post a picture*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPicture) name:@"postPicture" object:nil ];
  
    
    /*Notification to post the failed view*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetView) name:@"FailedImageDeal" object:nil ];

    
}


- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];
    
    [postImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    postImageView.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData* imageData = UIImageJPEGRepresentation(postImageView.image, 0.1);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    appDelegate.localImageUri=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [picker1 dismissModalViewControllerAnimated:YES];    
    
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(0,0,60,25)];
    
    [customButton addTarget:self action:@selector(startUpload) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"update.png"]  forState:UIControlStateNormal];
    
    [customButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *postMessageButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customButton];
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;

    
}


-(void)startUpload
{

    [activitySubView setHidden:NO];
    [self performSelector:@selector(postImage) withObject:nil afterDelay:5.0];

}


-(void)postImage
{
    
    if ([imageDescriptionTextView.text length])
    {
        CreatePictureDeal *createDeal=[[CreatePictureDeal alloc]init];
        
        NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                @"0",@"DiscountPercent",
                           imageDescriptionTextView.text,@"Description",                  imageDescriptionTextView.text,@"Title",nil];
        
        createDeal.offerDetailDictionary=[[NSMutableDictionary alloc]init];
        
        [createDeal createDeal:uploadDictionary ];
        
    }
    
    else
    {
        UIAlertView *emptyAlert=[[UIAlertView alloc]initWithTitle:@"Uh-oh" message:@"Enter a description for the picture" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        emptyAlert.tag=1;
        [emptyAlert show];
        emptyAlert=nil;     
    }
            
}


-(void)uploadPicture
{
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img =postImageView.image;
    
    dataObj=UIImageJPEGRepresentation(img,0.1);
    
    NSUInteger length = [dataObj length];
    
//    NSLog(@"Dataobject Length:%d",length);
    
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
    
    NSString *imageDealString= [appDelegate.dealId objectAtIndex:0];
    
    NSLog(@"imageDealString:%@",imageDealString);
    
    for (int i=0; i<[chunkArray count]; i++)
    {
        //NSString *urlString=[NSString stringWithFormat:@"http://ec2-54-224-22-185.compute-1.amazonaws.com/Discover/v1/FloatingPoint/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueIdString,[chunkArray count],i];
                    
        NSString *urlString=[NSString stringWithFormat:@"%@/createBizImage?clientId=%@&bizMessageId=%@&requestType=parallel&requestId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,imageDealString,uniqueIdString,[chunkArray count],i];
        
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
    
    [appDelegate.dealImageArray insertObject:appDelegate.localImageUri atIndex:0];
    
    [self updateView];
    
    NSLog(@"receivedString:%@",receivedString);
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
                NSLog(@"SuccessCode:%d",code);

            }
        
    }
}


- (void) keyboardWillShow: (NSNotification*) aNotification
{
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = [[self view] frame];
    
    rect.origin.y -= 215;
    
    [[self view] setFrame: rect];
    
    [UIView commitAnimations];
    
}


- (void) keyboardWillHide: (NSNotification*) aNotification
{
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = [[self view] frame];
    
    rect.origin.y += 215;
    
    [[self view] setFrame: rect];
    
    [UIView commitAnimations];
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    saySomthingLabel.hidden=YES;

    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
        replacementText:(NSString *)text
{
    //TO LIMIT NUMBER OF CHARACTERS TO 160
    if (textView.text.length > 160 && range.length == 0)
    {
        return NO;
    }
        
    return YES;
}



-(void)textViewDidChange:(UITextView *)textView
{
    NSString *substring = [NSString stringWithString:textView.text];
    
    saySomthingLabel.hidden=YES;
    
    substring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];        
}



-(void)dismissKeyboard
{
    if ([imageDescriptionTextView.text length]==0)
    {
        saySomthingLabel.hidden=NO;   
    }
    [imageDescriptionTextView resignFirstResponder];
}


- (IBAction)pickButtonClicked:(id)sender
{
    if ([imageDescriptionTextView.text length]==0)
    {
        saySomthingLabel.hidden=NO;
    }

    [imageDescriptionTextView resignFirstResponder];
    
    UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
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


-(void)updateView
{
    [activitySubView setHidden:YES];

    BizMessageViewController *bizController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:bizController];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}


-(void)resetView
{
    
    [activitySubView setHidden:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    bgLabel = nil;
    postImageView = nil;
    imageDescriptionTextView = nil;
    saySomthingLabel = nil;
    activitySubView = nil;
    [super viewDidUnload];
}


-(void)viewDidDisappear:(BOOL)animated
{

    if ([imageDescriptionTextView.text length]==0)
    {
        saySomthingLabel.hidden=NO;
    }

    [imageDescriptionTextView resignFirstResponder];

}


@end
