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
#import "NFActivityView.h"



@interface BusinessDetailsViewController ()<updateStoreDelegate,UIPickerViewDataSource,UIPickerViewDelegate,FpCategoryDelegate,UIImagePickerControllerDelegate>
{
    NFActivityView *nfActivity;
    UIPickerView *descriptionPicker;
    UIView *catView;
    NSMutableArray *categoryArray;
    BOOL isCategoryChanged;
    NSString *userName;
    NSString *businessName;
    NSString *businessDescription;
    UITextView *businessTextView;
    UITapGestureRecognizer *remove1;
    UIImage *uploadImage;
    BOOL isPrimaryImage;
    BOOL isUserNAmeChanged;
    
    
}
@end

@implementation BusinessDetailsViewController
@synthesize businessDescriptionTextView,businessNameTextView;
@synthesize uploadArray,primaryImageView,errorView,picker;
@synthesize chunkArray,request,dataObj,uniqueIdString,theConnection;


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
    
    uploadImage = [[UIImage alloc]init];
    
    remove1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyboard)];
    remove1.numberOfTapsRequired=1;
    remove1.numberOfTouchesRequired=1;
    
    self.businessDetTable.bounces = NO;
    userDetails=[NSUserDefaults standardUserDefaults];
    
    
    nfActivity=[[NFActivityView alloc]init];
    nfActivity.activityTitle=@"Updating";
    
    
    
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
    
    
    primaryImageView.layer.cornerRadius = 5.0f;
    primaryImageView.layer.masksToBounds = YES;
    
    
    
    UITapGestureRecognizer *changeImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeFeatured)];
    changeImage.numberOfTouchesRequired = 1;
    changeImage.numberOfTapsRequired    = 1;
    primaryImageView.userInteractionEnabled = YES;
    [primaryImageView addGestureRecognizer:changeImage];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            detailScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+50);
            self.businessDetTable.frame = CGRectMake(self.businessDetTable.frame.origin.x, self.businessDetTable.frame.origin.y, self.businessDetTable.frame.size.width, 310);
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            detailScrollView.contentSize=CGSizeMake(self.view.frame.size.width,result.height+20);
            
            self.businessDetTable.frame = CGRectMake(self.businessDetTable.frame.origin.x, self.businessDetTable.frame.origin.y, self.businessDetTable.frame.size.width, 272);
        }
    }
    
    
    self.businessDetTable.scrollEnabled = NO;
    
    
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
    
    [customButton setFrame:CGRectMake(260,26, 60, 30)];
    
    
    [customButton setTitle:@"Save" forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue-Regular" size:17.0f];
    [customButton addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customButton];
    [customButton setHidden:YES];
    
    
       self.navigationController.navigationBarHidden=NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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
    
    [categoryText setText: [appDelegate.storeDetailDictionary objectForKey:@"Categories"]];
    
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
    
    
    BusinessDescCell *theCell;
    theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    
    BusinessDescCell *theCell1;
    theCell1 = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [theCell.businessDescrText resignFirstResponder];
    [theCell1.businessText resignFirstResponder];
    [self.view removeGestureRecognizer:remove1];
    
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            self.businessDetTable.frame = CGRectMake(self.businessDetTable.frame.origin.x, self.businessDetTable.frame.origin.y, self.businessDetTable.frame.size.width, 290);
            self.view.frame = CGRectMake(0, 20, 320, 560);
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            self.businessDetTable.frame = CGRectMake(self.businessDetTable.frame.origin.x, self.businessDetTable.frame.origin.y, self.businessDetTable.frame.size.width, 365);
            self.view.frame = CGRectMake(0, 0, 320, 570);
        }
    }
    
    
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
    
    for (int i=0; i <3; i++){
        
        BusinessDescCell *theCell;
        theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [theCell.businessText resignFirstResponder];
        
        
        if (i==2)
        {
            
            theCell.businessText.text = [categoryText.text capitalizedString];
            
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
        
        [customButton setFrame:CGRectMake(260,24, 60, 30)];
        
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
        
        [customButton setFrame:CGRectMake(260,24, 60, 30)];
        
        [customButton setHidden:NO];
        
        UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
        
        self.navigationItem.rightBarButtonItem=rightBarBtn;
    }
    
    if(textField.tag==201)
    {
        [self.view addGestureRecognizer:remove1];
        
        
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
        [customButton setFrame:CGRectMake(260,24, 60, 30)];
        
        [customButton setHidden:NO];
        
        [self.view addGestureRecognizer:remove1];
        self.view.frame = CGRectMake(0, -180, 320, 800);
        
        self.businessDetTable.frame = CGRectMake(self.businessDetTable.frame.origin.x, self.businessDetTable.frame.origin.y, self.businessDetTable.frame.size.width, 335);
        
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
            [customButton setFrame:CGRectMake(260,24, 60, 30)];
            
            [customButton setHidden:NO];
            
            UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
            
            self.navigationItem.rightBarButtonItem=rightBarBtn;
        }
    }
    
}


-(void)updateMessage
{
    
    customButton.layer.opacity = 0.1f;
    customButton.alpha = 0.4f;
    
    [businessDescriptionTextView resignFirstResponder];
    
    [businessNameTextView resignFirstResponder];
    
    [businessTextView resignFirstResponder];
    
    [nfActivity showCustomActivityView];
    
    [self.view endEditing:YES];
    
    BusinessDescCell *theCell;
    
    
    [theCell.businessText resignFirstResponder];
    
    
    BusinessDescCell *theCell1;
    theCell1 = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    for(int i=0;i<2;i++)
    {
        theCell = (id)[self.businessDetTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if(i==0)
        {
            userName = theCell.businessText.text;
        }
        if(i==1)
        {
            businessName = theCell.businessText.text;
        }
    }
    
    
    
    businessDescription = theCell1.businessDescrText.text;
    
    NSString *str = categoryText.text;
    
    
    if(![businessNameString isEqualToString:businessName])
    {
        isStoreTitleChanged = YES;
    }
    if(![businessDescriptionString isEqualToString:businessDescription])
    {
        isStoreDescriptionChanged = YES;
    }
    if(![str isEqualToString:appDelegate.storeCategoryName])
    {
        
        isCategoryChanged=YES;
    }
    
    if(![userName isEqualToString:[appDelegate.storeDetailDictionary objectForKey:@"ContactName"]])
    {
        
        isUserNAmeChanged=YES;
    }
    
    
    
    
    
    UpdateStoreData *strData=[[UpdateStoreData  alloc]init];
    
    strData.delegate=self;
    
    if (isStoreTitleChanged && isStoreDescriptionChanged)
    {
        [upLoadDictionary setObject:businessDescription   forKey:@"DESCRIPTION"];
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"DESCRIPTION"],@"key":@"DESCRIPTION"};
        
        [uploadArray addObject:textDescriptionDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [upLoadDictionary setObject:businessName forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        
    }
    
    if (isStoreDescriptionChanged)
    {
        [upLoadDictionary setObject:businessDescription  forKey:@"DESCRIPTION"];
        
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
        
        
    }
    
    if (isUserNAmeChanged)
    {
        [upLoadDictionary setObject:userName   forKey:@"CONTACTNAME"];
        
        textDescriptionDictionary=@{@"value":[upLoadDictionary objectForKey:@"CONTACTNAME"],@"key":@"CONTACTNAME"};
        
        
        [uploadArray addObject:textDescriptionDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        
    }
    
    if (isStoreTitleChanged)
    {
        
        [upLoadDictionary setObject:businessName forKey:@"NAME"];
        
        textTitleDictionary=@{@"value":[upLoadDictionary objectForKey:@"NAME"],@"key":@"NAME"};
        
        [uploadArray addObject:textTitleDictionary];
        
        strData.uploadArray=[[NSMutableArray alloc]init];
        
        [strData.uploadArray addObjectsFromArray:uploadArray];
        
        [strData updateStore:uploadArray];
        
        [uploadArray removeAllObjects];
        
        
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
    
    
    theConnection =[[NSURLConnection alloc] initWithRequest:storeRequest delegate:self];
    
    
}




-(void)storeUpdateComplete
{
    
    Mixpanel *mixPanel=[Mixpanel sharedInstance];
    
    [mixPanel track:@"update_Business information"];
    
    
    appDelegate.businessName=[NSMutableString stringWithFormat:@"%@",businessName];
    
    appDelegate.businessDescription=[NSMutableString stringWithFormat:@"%@",businessDescription];
    
    [appDelegate.storeDetailDictionary setObject:userName forKey:@"ContactName"];
    
    businessDescriptionString = @"";
    businessNameString=@"";
    [self removeSubView];
    
    if(isCategoryChanged)
    {
        [self word:@"Business category has been updated" isSuccess:YES];
    }
    if(isStoreDescriptionChanged)
    {
        [self word:@"Business description has been updated" isSuccess:YES];
        
    }
    if(isStoreTitleChanged)
    {
        [self word:@"Business name has been updated" isSuccess:YES];
        
    }
    if(isUserNAmeChanged)
    {
        [self word:@"Your name has been updated" isSuccess:YES];
        
    }
    isCategoryChanged = NO;
    isStoreTitleChanged = NO;
    isStoreDescriptionChanged = NO;
    isUserNAmeChanged = NO;
    customButton.layer.opacity = 1.0f;
    customButton.alpha = 1.0f;
    
}


-(void)storeUpdateFailed
{
    [businessNamePlaceHolderLabel setHidden:YES];
    
    [businessDescriptionPlaceHolderLabel setHidden:YES];
    [self word:@"Business information could not be updated" isSuccess:NO];
    customButton.layer.opacity = 1.0f;
    customButton.alpha = 1.0f;

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
        return 3;
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
    
    businessTextView = [[UITextView alloc]initWithFrame:CGRectMake(14, 10, 300, 150)];
    
    cell.businessText.delegate = self;
    cell.businessDescrText.delegate =self;
    cell.businessDescrText.tag=200;
    cell.businessText.tag=201;
    
    if(indexPath.section==0)
    {
        
        
        if(indexPath.row==0)
        {
            if([appDelegate.storeDetailDictionary objectForKey:@"ContactName"]== [NSNull null])
            {
                [cell.businessText setText:@""];
            }
            else
            {
                [cell.businessText setText:[appDelegate.storeDetailDictionary objectForKey:@"ContactName"]];
            }
            cell.businessLabel.text = @"Your Name";
            cell.businessText.hidden = NO;
            
            cell.businessDescrText.hidden =YES;
            
        }
        if(indexPath.row==1)
        {
            
            cell.businessLabel.text = @"Business Name";
            cell.businessText.hidden = NO;
            cell.businessText.text = [businessNameString capitalizedString];
            cell.businessDescrText.hidden =YES;
            
        }
        if(indexPath.row==2)
        {
            
            cell.businessLabel.text = @"Business Category";
            cell.businessText.hidden = NO;
            [cell.businessText setEnabled:NO];
            cell.businessDescrText.hidden =YES;
            cell.businessText.text= [appDelegate.storeCategoryName capitalizedString];
            
            
        }
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            [cell.businessDescrText setText:businessDescriptionString];
            
            businessTextView.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0f];
            cell.businessText.hidden = YES;
            cell.businessDescrText.hidden =NO;
        }
        
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17, 10, tableView.frame.size.width, 20)];
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
        return 40;
    
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
        if(indexPath.row==2)
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
                
                [customButton setFrame:CGRectMake(260,24, 60, 30)];
                
                [customButton setHidden:NO];
                
                UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithCustomView:customButton];
                
                self.navigationItem.rightBarButtonItem=rightBarBtn;
            }
            catView = [[UIView alloc] init];
            catPicker.hidden = NO;
            pickerToolBar.hidden = NO;
            
            
            pickerToolBar.frame = CGRectMake(0, 0, 320, 44);
            catPicker.frame = CGRectMake(0, 45,320, 250);
            
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height == 480)
                {
                    // iPhone Classic
                    catView.frame = CGRectMake(0,250, 320, 250);
                    
                }
                if(result.height == 568)
                {
                    // iPhone 5
                    catView.frame = CGRectMake(0,350, 320, 250);
                }
            }
            
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

- (void)word:(NSString*)string isSuccess:(BOOL)success
{
    
    if(success)
    {
        errorView.backgroundColor = [UIColor colorWithRed:93.0f/255.0f green:172.0f/255.0f blue:1.0f/255.0f alpha:1.0];
        
        
    }
    else
    {
        errorView.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:34.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    }
    
    UILabel  *errorLabel = [[UILabel alloc]init];
    
    
    errorLabel.frame=CGRectMake(20, 0, 280, 40);
    errorLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    errorLabel.textAlignment =NSTextAlignmentCenter;
    
    errorLabel.text = string;
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.backgroundColor =[UIColor clearColor];
    [errorLabel setNumberOfLines:0];
    
    
    errorView.tag = 55;
    errorView.frame=CGRectMake(0, -200, 320, 40);
    [UIView animateWithDuration:0.8f
                          delay:0.03f
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         errorView.frame=CGRectMake(0, 57, 320, 40);
                         
                         [errorView addSubview:errorLabel];
                         
                     }completion:^(BOOL finished){
                         
                         double delayInSeconds = 1.5;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                             
                             
                             
                             [UIView animateWithDuration:0.8f
                                                   delay:0.10f
                                                 options:UIViewAnimationOptionTransitionFlipFromBottom
                                              animations:^{
                                                  
                                                  
                                                  errorView.alpha = 0.0;
                                                  errorView.frame = CGRectMake(0, -55, 320, 50);
                                                  errorLabel.frame = CGRectMake(-400, -200, 0, 0);
                                                  
                                                  
                                                  
                                                  
                                              }completion:^(BOOL finished){
                                                  
                                                  for (UIView *errorRemoveView in [self.view subviews]) {
                                                      if (errorRemoveView.tag == 55) {
                                                          // [errorRemoveView removeFromSuperview];
                                                          
                                                          
                                                      }
                                                      
                                                  }
                                                  
                                                  
                                              }];
                             
                         });
                         
                     }];
    
}

- (IBAction)closeView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.cancelLabel.layer.opacity = 0.1f;
    self.cancelLabel.alpha = 0.4f;
}

-(void)changeFeatured
{
    
    UIActionSheet *optionUploadImage = [[UIActionSheet alloc]initWithTitle:@"Choose Option" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
    [optionUploadImage showInView:self.view];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if(buttonIndex == 0)
    {
        picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        picker.allowsEditing = YES;
        
        
    }
    
    
    if (buttonIndex==1)
    {
        picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
        
        
        
    }
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [nfActivity showCustomActivityView];
    
    uploadImage =  [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0,5);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *imageName=[NSString stringWithFormat:@"%@.jpg",uuid];
    
    NSData* imageData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.1);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSString *localImageUri=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    appDelegate.primaryImageUploadUrl=[NSMutableString stringWithFormat:@"local%@",fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [picker1 dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(displayPrimaryImageModalView) withObject:localImageUri afterDelay:1.0];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1;
{
    
    [picker1 dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)displayPrimaryImageModalView
{
    
    
    chunkArray = [[NSMutableArray alloc]init];
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img = uploadImage;
    
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
        isPrimaryImage = YES;
    }
    
    
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if(isPrimaryImage)
    {
        if (code==200)
        {
            successCode++;
            
            if (successCode==totalImageDataChunks)
            {
                successCode=0;
                Mixpanel *mixPanel=[Mixpanel sharedInstance];
                
                primaryImageView.image = uploadImage;
                
                appDelegate.primaryImageUri=[NSMutableString stringWithFormat:@"%@",appDelegate.primaryImageUploadUrl];
                
                [nfActivity hideCustomActivityView];
                
                [self word:@"Featured Image uploaded successfully" isSuccess:YES];
                
                [mixPanel track:@"Change featured image"];
                [self performSelector:@selector(closeView:) withObject:self afterDelay:4.0f];
            }
        }
        
        else
        {
            successCode=0;
            
            [connection cancel];
            [nfActivity hideCustomActivityView];
            
            [self word:@"Oops! Something went wrong" isSuccess:NO];
            
        }
        
    }
    else
    {
        
        if (code!=200)
        {
            [self removeSubView];
            [self word:@"Oops! Something went wrong, come back later" isSuccess:NO];
            customButton.layer.opacity = 1.0f;
            customButton.alpha = 1.0f;

        }
        else
        {
            [self removeSubView];
            NSString *catText = [categoryText.text uppercaseString];
            [appDelegate.storeDetailDictionary setObject:catText forKey:@"Categories"];
            [self word:@"Business category has been updated" isSuccess:YES];
            customButton.layer.opacity = 1.0f;
            customButton.alpha = 1.0f;

            
        }
    }
    
    
}



@end
