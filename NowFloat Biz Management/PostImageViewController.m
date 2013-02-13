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




@interface PostImageViewController ()

@end

@implementation PostImageViewController

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
    
    [bgLabel.layer setCornerRadius:6.0];
    
    
    
    /*Notification To Move View Up Or Down*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    /*Set the navigation bar button here*/
    UIBarButtonItem *postMessageButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self     action:@selector(postImage)];
    
    
    
    self.navigationItem.rightBarButtonItem=postMessageButtonItem;

    
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



-(void)postImage
{

    NSLog(@"Post Image");

}


-(void)resignKeyBoard
{
    
    if ([imageDescriptionTextView.text length]==0) {
        
        
        saySomthingLabel.hidden=NO;

    }
    
    [imageDescriptionTextView resignFirstResponder];
        
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    saySomthingLabel.hidden=YES;

    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
        replacementText:(NSString *)text
{
    
    //TO LIMIT NUMBER OF CHARACTERS TO 60
    if (textView.text.length > 160 && range.length == 0)
    {
        return NO;
    }
    
    
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    bgLabel = nil;
    postImageView = nil;
    imageDescriptionTextView = nil;
    saySomthingLabel = nil;
    [super viewDidUnload];
}


- (IBAction)cameraButtonClicked:(id)sender
{
    
    
    picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing=YES;
    [self presentModalViewController:picker animated:NO];
    
    
    picker=nil;
    [picker setDelegate:nil];
    
}

- (IBAction)galleryButtonClicked:(id)sender
{
    picker=[[UIImagePickerController alloc] init];
    picker.allowsEditing=YES;
    [picker setDelegate:self];
    [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:picker animated:YES completion:NULL];
    
    picker=nil;
    [picker setDelegate:nil];
    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    postImageView.image=[info objectForKey:UIImagePickerControllerEditedImage];

    [picker1 dismissModalViewControllerAnimated:YES];

    
    
}






- (IBAction)downArrowButtonClicked:(id)sender
{
    [self resignKeyBoard];
    
    
}



@end
