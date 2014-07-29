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
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexaString.h"
#import "Mixpanel.h"
#import "NFActivityView.h"
#import "FpCategoryController.h"
#import "BusinessDescCell.h"
#import "AlertViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

UITextView *businessTextView;
UITapGestureRecognizer *remove1;

@interface BusinessDetailsViewController ()<updateStoreDelegate,UIPickerViewDataSource,UIPickerViewDelegate,FpCategoryDelegate>
{
    NFActivityView *nfActivity;
    UIPickerView *descriptionPicker;
    UIView *catView;
    NSMutableArray *categoryArray;
    BOOL isCategoryChanged;
}
@end

@implementation BusinessDetailsViewController
@synthesize businessDescriptionTextView,businessNameTextView;
@synthesize uploadArray,primaryImageView;


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
    
    remove1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyboard)];
    remove1.numberOfTapsRequired=1;
    remove1.numberOfTouchesRequired=1;
       
    self.businessDetTable.bounces = NO;
    
       appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate.primaryImageUri isEqualToString:@""])
    {
        [primaryImageView setAlpha:1.0];
        
        NSString *imageUriSubString=[appDelegate.primaryImageUri  substringToIndex:5];
        
        if ([imageUriSubString isEqualToString:@"local"])
        {
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@",[appDelegate.primaryImageUri substringFromIndex:5]];
            
            [primaryImageView setImage:[UIImage imageWithContentsOfFile:imageStringUrl]];
        }
        
        else
        {
            NSString *imageStringUrl=[NSString stringWithFormat:@"%@%@",appDelegate.apiUri,appDelegate.primaryImageUri];
            
            [primaryImageView setImageWithURL:[NSURL URLWithString:imageStringUrl]];
        }
    }
    
    else
    {
        [primaryImageView   setImage:[UIImage imageNamed:@"defaultPrimaryimage.png"]];
        [primaryImageView setAlpha:0.6];
    }


    primaryImageView.layer.cornerRadius = 10.0f;
    primaryImageView.layer.masksToBounds = YES;
  
    
   
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            detailScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+50);
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            detailScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+20);
            
        }
    }
    
   
    


    businessTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 358, 320, 200)];
   
    businessTextView.delegate =self;
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    
 

    version = [[UIDevice currentDevice] systemVersion];

    nfActivity=[[NFActivityView alloc]init];
    
    categoryArray = [[NSMutableArray alloc] init];
    
    nfActivity.activityTitle=@"Updating";
    
    upLoadDictionary=[[NSMutableDictionary alloc]init];
    
    uploadArray=[[NSMutableArray alloc]init];
    
    businessNameString=[[NSString alloc]init];
    
    businessDescriptionString=[[NSString alloc]init];
    
    isStoreDescriptionChanged=NO;
    
    isStoreTitleChanged=NO;
    
    isCategoryChanged = NO;
    
    businessDescriptionString=appDelegate.businessDescription;
    
    businessNameString=appDelegate.businessName;

    [businessDescriptionTextView.layer  setCornerRadius:6.0f];
    
    [businessDescriptionTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [businessDescriptionTextView.layer setBorderWidth:1.0];
    
    [businessNameTextView.layer setCornerRadius:6.0f];
    
    [businessNameTextView.layer setBorderColor:[UIColor colorWithHexString:@"dcdcda"].CGColor];
    
    [businessNameTextView.layer setBorderWidth:1.0];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;

    
    customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setFrame:CGRectMake(280,22, 30, 30)];
    
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"]  forState:UIControlStateNormal];
    [self.view addSubview:customButton];
    [customButton setHidden:YES];

    
    /*Design the NavigationBar here*/

    
//    if (version.floatValue<7.0) {
//
//    self.navigationController.navigationBarHidden=YES;
//
//    CGFloat width = self.view.frame.size.width;
//    
//    navBar = [[UINavigationBar alloc] initWithFrame:
//                               CGRectMake(0,0,width,44)];
//    
//    [self.view addSubview:navBar];
//    
//    
//    UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
//    
//    [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
//    
//    [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [navBar addSubview:leftCustomButton];
//        
//    [navBar addSubview:customButton];
//        
//    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(84, 13,164, 20)];
//    
//    headerLabel.text=@"Name & Description";
//    
//    headerLabel.backgroundColor=[UIColor clearColor];
//    
//    headerLabel.textAlignment=NSTextAlignmentCenter;
//    
//    headerLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
//    
//    headerLabel.textColor=[UIColor  colorWithHexString:@"464646"];
//    
//    [navBar addSubview:headerLabel];
//        
//    }
//    
//    
//    else
//    {
//        self.automaticallyAdjustsScrollViewInsets=YES;
//        
//        self.navigationController.navigationBarHidden=NO;
//        
//        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
//        
//        self.navigationController.navigationBar.translucent = NO;
//        
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        
//        self.navigationItem.title=@"Name & Description";
//        
//        UIButton *leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [leftCustomButton setFrame:CGRectMake(5,0,50,44)];
//        
//        [leftCustomButton setImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
//        
//        [leftCustomButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftCustomButton];
//        
//        self.navigationItem.leftBarButtonItem = leftBtnItem;
//        
//        [contentSubView setFrame:CGRectMake(0,2000, contentSubView.frame.size.width, contentSubView.frame.size.height)];
//        
//    }
    
   // [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
//Set the RightRevealWidth 0
   // revealController.rightViewRevealWidth=0;
   // revealController.rightViewRevealOverdraw=0;
//
//
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(textViewKeyPressed:) name: UITextViewTextDidChangeNotification object: nil];


    /*Set The TextViews Here*/

    [businessNameTextView setText:businessNameString];

    [businessDescriptionTextView setText:businessDescriptionString];
    
    [businessDescriptionTextView setFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
    
    [businessNameTextView setFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
    
    
    if ([businessNameString length]==0)
    {
        [businessNamePlaceHolderLabel setHidden:NO];
    }
    
    
    if ([businessDescriptionString length]==0)
    {
        [businessDescriptionPlaceHolderLabel setHidden:NO];
        
    }
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    categoryText.leftView = paddingView;
    categoryText.leftViewMode = UITextFieldViewModeAlways;
    
    [categoryText setText:appDelegate.storeCategoryName];
    
    [catPicker setHidden:YES];
    [pickerToolBar setHidden:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView)
                                                 name:@"update" object:nil];

 
    FpCategoryController *categoryController=[[FpCategoryController alloc]init];
    
    categoryController.delegate=self;
    
    [categoryController downloadFpCategoryList];
    
}
-(void)removeKeyboard
{
    
        self.view.frame = CGRectMake(0, 0, 320, 560);
        BusinessDescCell *theCell;
        theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        [theCell.businessDescrText resignFirstResponder];
         [self.view removeGestureRecognizer:remove1];
    
    self.businessDetTable.frame = CGRectMake(self.businessDetTable.frame.origin.x, self.businessDetTable.frame.origin.y, self.businessDetTable.frame.size.width, self.businessDetTable.frame.size.height-32);
        
    
}

-(void)revealRearViewController
{
    
//    [businessDescriptionTextView resignFirstResponder];
//    [businessNameTextView resignFirstResponder];

    [self.view endEditing:YES];
    //revealToggle:
    
}


- (IBAction)cancelPicker:(id)sender {
    [pickerToolBar setHidden:YES];
    [catPicker setHidden:YES];
    [catView setHidden:YES];
}

- (IBAction)donePicker:(id)sender {
    [pickerToolBar setHidden:YES];
    [catPicker setHidden:YES];
    [catView setHidden:YES];
    
    for (int i=0; i <2; i++){
        
        BusinessDescCell *theCell;
        theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [theCell.businessText resignFirstResponder];
        
      
        
        
        if (i==1)
        {
         
            theCell.businessText.text = categoryText.text;
            
        }
        
        
    }
    

   
}

- (IBAction)businessCategories:(id)sender
{
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"update_Business_category"];
    
    isCategoryChanged = YES;
    
    if (version.floatValue<7.0)
    {
        [customButton setHidden:NO];
    }
    else
    {
    
     [customButton setFrame:CGRectMake(280,22, 30, 30)];
    
    [customButton setHidden:NO];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
    
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    }
    catView = [[UIView alloc] init];
    catPicker.hidden = NO;
    pickerToolBar.hidden = NO;
    
    
    pickerToolBar.frame = CGRectMake(0, 0, 320, 44);
    catPicker.frame = CGRectMake(0, 45,320, 200);
    catView.frame = CGRectMake(0,300, 320, 150);
    [catView addSubview:catPicker];
    [catView addSubview:pickerToolBar];
    catView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:catView];

   
}

#pragma FpCategoryDelegate

-(void)fpCategoryDidFinishDownload:(NSArray *)downloadedArray
{
    if (downloadedArray!=NULL)
    {
        [categoryArray addObjectsFromArray:downloadedArray];
        [catPicker reloadAllComponents];
    }
    
}

-(void)fpCategoryDidFailWithError
{
    
    
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return categoryArray.count;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
   
    NSString *text =[[categoryArray objectAtIndex: row] lowercaseString] ;
    text =  [text stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[text substringToIndex:1] uppercaseString]];
    return text;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    categoryText.text = [[categoryArray objectAtIndex: row] lowercaseString];
    categoryText.text =  [categoryText.text stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[categoryText.text substringToIndex:1] uppercaseString]];
}


-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (version.floatValue<7.0)
    {
        [customButton setHidden:NO];
    }
    else
    {
        
        [customButton setFrame:CGRectMake(280,22, 30, 30)];
        
        [customButton setHidden:NO];
        
        UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
        
        self.navigationItem.rightBarButtonItem=rightBarBtn;
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BusinessDescCell *theCell;
    theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [theCell.businessText resignFirstResponder];

    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    textFieldTag=textView.tag;
    
    if (textFieldTag==2)
    {
        if ([businessDescriptionString length]==0)
        {
            [businessDescriptionPlaceHolderLabel setHidden:YES];
        }
        
        CGSize kbSize=CGSizeMake(320,216);
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        
        detailScrollView.contentInset = contentInsets;
        
        detailScrollView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        
        aRect.size.height -= kbSize.height;
        
        if (!CGRectContainsPoint(aRect, textView.frame.origin) )
        {
            CGPoint scrollPoint = CGPointMake(0.0, textView.frame.origin.y-kbSize.height+120);
            
            [detailScrollView setContentOffset:scrollPoint animated:YES];
        }
        
        else
        {
            CGPoint scrollPoint = CGPointMake(0.0, textView.frame.origin.y-kbSize.height+120);
            
            [detailScrollView setContentOffset:scrollPoint animated:YES];
        }        
    }
    
    if (textFieldTag==1) {
        
        
        if ([businessNameString length]==0) {
            
            
            [businessNamePlaceHolderLabel setHidden:YES];
            
        }
        
    }
    
    if(textFieldTag==200)
    {
        [customButton setFrame:CGRectMake(280,22, 30, 30)];
        
        [customButton setHidden:NO];

          [self.view addGestureRecognizer:remove1];
        self.view.frame = CGRectMake(0, -120, 320, 800);
            self.businessDetTable.frame = CGRectMake(self.businessDetTable.frame.origin.x, self.businessDetTable.frame.origin.y, self.businessDetTable.frame.size.width, self.businessDetTable.frame.size.height-32);

    }
    
    
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView;
{
    
    if (textView.tag==1)
    {
        isStoreTitleChanged=YES;
        
        if ([textView.text length]==0)
        {
            [businessNamePlaceHolderLabel setHidden:NO];
        }
    }
    
    
    else if (textView.tag==2)
    {
        isStoreDescriptionChanged=YES;
        
        
        if ([textView.text length]==0) {
            
            [businessDescriptionPlaceHolderLabel setHidden:NO];
            
        }
    }
    
    if(textFieldTag==200)
    {
        self.view.frame = CGRectMake(0, 0, 320, 600);
        BusinessDescCell *theCell;
        theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        [theCell.businessDescrText resignFirstResponder];

        
    }

}


-(void) textViewKeyPressed: (NSNotification*) notification
{
    
    if ([[[notification object] text] hasSuffix:@"\n"])
    {
        [[notification object] resignFirstResponder];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
   
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView;
{

    if (textView.tag==1 || textView.tag==2)
    {        
        
        if (version.floatValue<7.0)
        {
            [customButton setHidden:NO];
        }
        
        else
        {
             [customButton setFrame:CGRectMake(280,22, 30, 30)];
            
            [customButton setHidden:NO];
            
            UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
            
            self.navigationItem.rightBarButtonItem=rightBarBtn;
        }
    }

}


-(void)updateMessage
{
    
    [businessDescriptionTextView resignFirstResponder];
    
    [businessNameTextView resignFirstResponder];
    
    [businessTextView resignFirstResponder];

    [nfActivity showCustomActivityView];
 
    
        
        BusinessDescCell *theCell;
        theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [theCell.businessText resignFirstResponder];
    
    
    BusinessDescCell *theCell1;
    theCell1 = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
        
    businessNameTextView.text = theCell.businessText.text;
    businessDescriptionTextView.text = theCell1.businessDescrText.text;
    
    NSString *str = categoryText.text;
    
    
    if(![businessNameString isEqualToString:businessNameTextView.text])
    {
          isStoreTitleChanged = YES;
    }
    if(![businessDescriptionString isEqualToString:businessDescriptionTextView.text])
    {
        isStoreDescriptionChanged = YES;
    }
    if(![str isEqualToString:appDelegate.storeCategoryName])
    {
      
        isCategoryChanged=YES;
    }
   
    
    
   

    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    strData.delegate=self;
    
    if (isStoreTitleChanged && isStoreDescriptionChanged)
    {
        [upLoadDictionary setObject:businessDescriptionTextView.text   forKey:@"DESCRIPTION"];
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
        
        [uploadArray addObject:textDescriptionDictionary];
                
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [upLoadDictionary setObject:businessNameTextView.text forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        isStoreDescriptionChanged=NO;
        
        isStoreTitleChanged=NO;
    }
    
    if (isStoreDescriptionChanged)
    {
        [upLoadDictionary setObject:businessDescriptionTextView.text   forKey:@"DESCRIPTION"];
        
        if ([[upLoadDictionary objectForKey:@"DESCRIPTION"] length] == 0)
        {
            //[upLoadDictionary setObject:[NSNull null] forKey:@"DESCRIPTION"];
        }
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
        
        [uploadArray addObject:textDescriptionDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        isStoreDescriptionChanged=NO;
    }
    
    if (isStoreTitleChanged)
    {
        
        [upLoadDictionary setObject:businessNameTextView.text forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
                
        isStoreTitleChanged=NO;

    }
    
    if(isCategoryChanged)
    {
        [self updateCategory];
    }
    
}

-(void)updateCategory
{
    
    NSString *urlString=[NSString stringWithFormat:
                         @"%@/ChangeFPCategory/%@/%@",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"],categoryText.text];
    
    NSMutableString *clientIdString=[[NSMutableString alloc]initWithFormat:@"\"%@\"",appDelegate.clientId];
    
    NSData *postData = [clientIdString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [storeRequest setHTTPMethod:@"POST"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [storeRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [storeRequest setHTTPBody:postData];
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:storeRequest delegate:self];
    
    // Discover/v1/floatingPoint/ChangeFPCategory/{fpTag}/{category}
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code!=200)
    {
        [self removeSubView];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Something went wrong, come back later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        alertView = nil;
    }
    else
    {
        [self removeSubView];
        NSString *catText = [categoryText.text uppercaseString];
        
        [appDelegate.storeDetailDictionary setObject:catText forKey:@"Categories"];
        [AlertViewController CurrentView:self.view errorString:@"Business Profile Updated" size:60 success:YES];
       
    }

    
    
}


-(void)storeUpdateComplete
{
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"update_Business information"];
    
    appDelegate.businessName=[NSMutableString stringWithFormat:@"%@",businessNameTextView.text];

    appDelegate.businessDescription=[NSMutableString stringWithFormat:@"%@",businessDescriptionTextView.text ];
    
    businessDescriptionString = @"";
    businessNameString=@"";
 

    
    [self removeSubView];
    
}


-(void)storeUpdateFailed
{
    [businessNamePlaceHolderLabel setHidden:YES];
    
    [businessDescriptionPlaceHolderLabel setHidden:YES];
    
    
    
    UIAlertView *failedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Business information could not be updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [failedAlert show];
    
    failedAlert=nil;
    
    [self removeSubView];
}


-(void)removeSubView
{
    [nfActivity hideCustomActivityView];

    [customButton setHidden:YES];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    detailScrollView.contentInset = contentInsets;
    detailScrollView.scrollIndicatorInsets = contentInsets;
    
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
        
        [businessDescriptionTextView resignFirstResponder];
        
        [businessNameTextView resignFirstResponder];

    }
    
    //FrontViewPositionCenter
    if ([frontViewPosition isEqualToString:@"FrontViewPositionLeft"])
    {
        [revealFrontControllerButton setHidden:YES];
    }
    
    //FrontViewPositionRight
    
    if ([frontViewPosition isEqualToString:@"FrontViewPositionRight"])
    {        
        [revealFrontControllerButton setHidden:NO];
        
        [businessDescriptionTextView resignFirstResponder];
        
        [businessNameTextView resignFirstResponder];
        
    }
    
    
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 2;
    else
        return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"businessDesc";
    BusinessDescCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"BusinessDescCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        
    }
    
    businessTextView = [[UITextView alloc]initWithFrame:CGRectMake(14, 10, 300, 135)];
    
    cell.businessText.delegate = self;
    cell.businessDescrText.delegate =self;
    cell.businessDescrText.tag=200;
    
    if(indexPath.section==0)
    {
        
        
        if(indexPath.row==0)
        {
            cell.businessLabel.text = @"Business Name";
            cell.businessText.hidden = NO;
            [cell.businessText setText:businessNameString];
            cell.businessDescrText.hidden =YES;
            
            
        }
        if(indexPath.row==1)
        {
            
            cell.businessLabel.text = @"Business Category";
            
            cell.businessText.hidden = NO;
            [cell.businessText setEnabled:NO];
            cell.businessDescrText.hidden =YES;
            cell.businessText.text= appDelegate.storeCategoryName;
            
            
        }
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            [cell.businessDescrText setText:businessDescriptionString];
//            businessTextView.text = @"Having a great time scaling it up @ NowFloats in Hyderabad, India. An Entrepreneur, staunch believer in execution is everything, cricket fan, Having a great time scaling it up @ NowFloats in Hyderabad, India. An Entrepreneur, staunch believer in execution is everything, cricket fan, traveler & explorer, technology traveler & explorer, technology and history enthusiast. ";
           // [cell.contentView addSubview:businessTextView];
            businessTextView.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0f];
            cell.businessText.hidden = YES;
            cell.businessDescrText.hidden =NO;
        }
        
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17, 13, tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:@"Helvetica Neue-Regular" size:15.0]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    label.textColor = [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]];
    
    if(section==0)
    {
        label.text = @"";
    }
    if(section==1)
    {
        label.text = @"Business Description";
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 0;
    else
    return 35;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            return 160;
        }
    }
    else
    {
        return 45;
    }
    
    return 1;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section==0)
    {
        if(indexPath.row==1)
        {
            BusinessDescCell *theCell;
            theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            [theCell.businessText resignFirstResponder];
            [businessTextView resignFirstResponder];
            
            Mixpanel *mixPanel=[Mixpanel sharedInstance];
            
            [mixPanel track:@"update_Business_category"];
            
            isCategoryChanged = YES;
            
            if (version.floatValue<7.0)
            {
                [customButton setHidden:NO];
            }
            else
            {
                
                 [customButton setFrame:CGRectMake(280,22, 30, 30)];
                
                [customButton setHidden:NO];
                
                UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
                
                self.navigationItem.rightBarButtonItem=rightBarBtn;
            }
            catView = [[UIView alloc] init];
            catPicker.hidden = NO;
            pickerToolBar.hidden = NO;
            
            
            pickerToolBar.frame = CGRectMake(0, 0, 320, 44);
            catPicker.frame = CGRectMake(0, 45,320, 250);
            catView.frame = CGRectMake(0,350, 320, 250);
            [catView addSubview:catPicker];
            [catView addSubview:pickerToolBar];
            catView.backgroundColor = [UIColor whiteColor];
            
            [self.view addSubview:catView];
        }
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
    detailScrollView = nil;
    businessNamePlaceHolderLabel = nil;
    businessDescriptionPlaceHolderLabel = nil;
    [super viewDidUnload];
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}



- (IBAction)closeView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
