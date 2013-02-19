//
//  BusinessDetailsViewController.m
//  NowFloats Biz Management
//
//  Created by Sumanta Roy on 31/01/13.
//  Copyright (c) 2013 NowFloats Technologies. All rights reserved.
//

#import "BusinessDetailsViewController.h"
#import "SWRevealViewController.h"
#import "UpdateStoreData.h"

@interface BusinessDetailsViewController ()

@end

@implementation BusinessDetailsViewController
@synthesize businessDescriptionTextView,businessNameTextView;
@synthesize uploadArray;


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
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    upLoadDictionary=[[NSMutableDictionary alloc]init];
    uploadArray=[[NSMutableArray alloc]init];
    
    businessNameString=[[NSString alloc]init];
    businessDescriptionString=[[NSString alloc]init];
    
    isStoreDescriptionChanged=NO;
    isStoreTitleChanged=NO;
    
    
    businessDescriptionString=appDelegate.businessDescription;
    businessNameString=appDelegate.businessName;

    
    

    self.title = NSLocalizedString(@"Business Details", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                             style:UIBarButtonItemStyleBordered
                                             target:revealController
                                             action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    UIBarButtonItem *postMessageButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"Post"                                                                             style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(updateMessage)];

    self.navigationItem.rightBarButtonItem=postMessageButtonItem;
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(textViewKeyPressed:) name: UITextViewTextDidChangeNotification object: nil];


    /*Set The TextViews Here*/

    [businessNameTextView setText:businessNameString];

    [businessDescriptionTextView setText:businessDescriptionString];
    
    
}


-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    textFieldTag=textView.tag;
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{

    if (textView.tag==1)
    {
        isStoreTitleChanged=YES;
        
    }
    
    
    else if (textView.tag==2)
    {
        isStoreDescriptionChanged=YES;
    }
    
    
    
    

}


- (void) keyboardWillShow: (NSNotification*) aNotification
{
    if (textFieldTag==1 )
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
    
    if (textFieldTag==2)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y -= 130;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
	
	
}


- (void) keyboardWillHide: (NSNotification*) aNotification
{
    
    if (textFieldTag==1)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 0;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
    
    
    if (textFieldTag==2)
    {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = [[self view] frame];
        
        rect.origin.y += 130;
        
        [[self view] setFrame: rect];
        
        [UIView commitAnimations];
        
    }
    
    
	
}




-(void) textViewKeyPressed: (NSNotification*) notification {
    
    if ([[[notification object] text] hasSuffix:@"\n"])
    {
        [[notification object] resignFirstResponder];
    }
}



-(void)updateMessage
{
    
    [businessDescriptionTextView resignFirstResponder];
    [businessNameTextView resignFirstResponder];
    
    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    if (isStoreTitleChanged && isStoreDescriptionChanged)
    {
        
        
        [upLoadDictionary setObject:businessDescriptionTextView.text   forKey:@"DESCRIPTION"];
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
        
        [uploadArray addObject:textDescriptionDictionary];
                
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        appDelegate.businessDescription=[NSMutableString stringWithFormat:@"%@",businessDescriptionTextView.text ];

        
        [upLoadDictionary setObject:businessNameTextView.text forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        

        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        appDelegate.businessName=[NSMutableString stringWithFormat:@"%@",businessNameTextView.text];

        
        
        isStoreDescriptionChanged=NO;
        isStoreTitleChanged=NO;
        
    }
    
    
    
    
    
    if (isStoreDescriptionChanged)
    {
    
        
        [upLoadDictionary setObject:businessDescriptionTextView.text   forKey:@"DESCRIPTION"];
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
        
        [uploadArray addObject:textDescriptionDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        appDelegate.businessDescription=[NSMutableString stringWithFormat:@"%@",businessDescriptionTextView.text ];
        
        isStoreDescriptionChanged=NO;
        
    }
    
    
    if (isStoreTitleChanged) {
        
        
        [upLoadDictionary setObject:businessNameTextView.text forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        
        
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        appDelegate.businessName=[NSMutableString stringWithFormat:@"%@",businessNameTextView.text];
        
        isStoreTitleChanged=NO;

    }
    
    
    

    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setBusinessNameTextView:nil];
    [self setBusinessDescriptionTextView:nil];
    [super viewDidUnload];
}
@end
