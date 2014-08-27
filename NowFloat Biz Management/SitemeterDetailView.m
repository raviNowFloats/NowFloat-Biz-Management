//
//  SitemeterDetailView.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 25/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "SitemeterDetailView.h"
#import "sitemetercell.h"
#import "ProgressCell.h"
#import "UIColor+HexaString.h"
#import "BusinessAddressViewController.h"
#import "BusinessDetailsViewController.h"
#import "PrimaryImageViewController.h"
#import "BusinessContactViewController.h"
#import "BusinessHoursViewController.h"
#import "SettingsViewController.h"
#import "BizMessageViewController.h"
#import "BuyStoreWidget.h"

@interface SitemeterDetailView ()<UIActionSheetDelegate,BuyStoreWidgetDelegate>
{
    float viewHeight;
    
    int percentageComplete;
    
    float percentComplete;
    
    UIImage *primaryImage;
    
    NSMutableArray *percentageArray, *headArray, *descArray;
    
    NSMutableArray *completedHeadArray, *completedPercentageArray, *completedDescArray;
}

@end

@implementation SitemeterDetailView

@synthesize picker = _picker;

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
    
    version = [[UIDevice currentDevice] systemVersion];
    
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
    
    percentageArray = [[NSMutableArray alloc] init];
    
    headArray = [[NSMutableArray alloc] init];
    
    descArray = [[NSMutableArray alloc] init];
    
    completedDescArray = [[NSMutableArray alloc] init];
    
    completedHeadArray = [[NSMutableArray alloc] init];
    
    completedPercentageArray = [[NSMutableArray alloc] init];
    
<<<<<<< HEAD
  
=======
    percentageComplete = 0;
    
    percentComplete = 0.0;
    
    primaryImage = [[UIImage alloc] init];
    
    userDetails=[NSUserDefaults standardUserDefaults];
    
>>>>>>> FETCH_HEAD
    
    if([appDelegate.businessName length] == 0)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Business Name"];
        [descArray addObject:@"Enter your Business name"];
    }
    else
    {
        percentageComplete += 5;
        percentComplete += 0.05;
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Business Name"];
        [completedDescArray addObject:@"Enter your Business name"];
    }
    
    if([appDelegate.businessDescription length] == 0)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Business Desc"];
        [descArray addObject:@"Enter your Business Desc"];
    }
    else
    {
        percentageComplete += 10;
        percentComplete += 0.1;
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Business Desc"];
        [completedDescArray addObject:@"Enter your Business Desc"];
    }
    
    if([appDelegate.storeCategoryName length] == 0)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Business Category"];
        [descArray addObject:@"Enter your Business category"];
    }
    else
    {
        percentageComplete += 5;
        percentComplete += 0.05;
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Business Category"];
        [completedDescArray addObject:@"Enter your Business Category"];
    }
    
    if([appDelegate.primaryImageUri length] == 0)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Featured Image"];
        [descArray addObject:@"Upload your featured image"];
    }
    else
    {
        percentageComplete += 10;
        percentComplete += 0.1;
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Featured Image"];
        [completedDescArray addObject:@"Upload your featured image"];
    }
    
    if([appDelegate.storeDetailDictionary objectForKey:@"PrimaryNumber"] == NULL)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Primary Number"];
        [descArray addObject:@"Enter your Primary number"];
    }
    else
    {
        percentageComplete += 5;
        percentComplete += 0.05;
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Primary Number"];
        [completedDescArray addObject:@"Enter your Primary Number"];
    }
    if([appDelegate.storeDetailDictionary objectForKey:@"Email"] == NULL)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Email"];
        [descArray addObject:@"Enter your Email"];
    }
    else
    {
        percentageComplete += 5;
        percentComplete += 0.05;
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Email"];
        [completedDescArray addObject:@"Enter your Email"];
    }
    if([appDelegate.storeDetailDictionary objectForKey:@"Address"] == NULL)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Business Address"];
        [descArray addObject:@"Enter your Business Address"];
    }
    else
    {
        percentageComplete += 10;
        percentComplete += 0.1;
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Business Address"];
        [completedDescArray addObject:@"Enter your Business Address"];
    }
    if([appDelegate.storeDetailDictionary objectForKey:@"Timings"] == NULL)
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Business Timings"];
        [descArray addObject:@"Enter your Business Timings"];
    }
    else
    {
        percentageComplete += 5;
        percentComplete += 0.05;
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Business Timings"];
        [completedDescArray addObject:@"Enter your Business Timings"];
    }
    
    if([appDelegate.socialNetworkNameArray count]==0)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Facebook"];
        [descArray addObject:@"Connect to facebook/twitter"];
    }
    else
    {
        percentageComplete += 10;
        percentComplete += 0.1;
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Facebook"];
        [completedDescArray addObject:@"Connect to facebook/twitter"];
    }
   
    
    if([appDelegate.dealDescriptionArray count] < 5)
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Update"];
        [descArray addObject:@"Update your website"];
    }
    else
    {
        percentageComplete += 10;
        percentComplete += 0.1;
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Update"];
        [completedDescArray addObject:@"Update your website"];
    }
    if(![appDelegate.storeWidgetArray containsObject:@"SITESENSE"])
    {
        [percentageArray addObject:@"5 %"];
        [headArray addObject:@"Buy Auto SEO"];
        [descArray addObject:@"Boost your site with auto seo for free"];
    }
    else
    {
        percentageComplete += 5;
        percentComplete += 0.05;
        [completedPercentageArray addObject:@"5 %"];
        [completedHeadArray addObject:@"Buy Auto SEO"];
        [completedDescArray addObject:@"Boost your site with auto seo for free"];
    }
    if([appDelegate.storeRootAliasUri isEqualToString:@""])
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Buy .com"];
        [descArray addObject:@"Book your own domain"];
    }
    else
    {
        percentageComplete += 10;
        percentComplete += 0.1;
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Buy .com"];
        [completedDescArray addObject:@"Book your own domain"];
    }
    
    if([appDelegate.storeDetailDictionary objectForKey:@"hasShared"] == [NSNumber numberWithBool:YES])
    {
        
        percentageComplete += 10;
        percentComplete += 0.1;
        [completedPercentageArray addObject:@"10 %"];
        [completedHeadArray addObject:@"Share"];
        [completedDescArray addObject:@"Promote your website"];
        
    }
    else
    {
        [percentageArray addObject:@"10 %"];
        [headArray addObject:@"Share"];
        [descArray addObject:@"Promote your website"];
    }
    

    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        
        if(section == 0)
        {
            return 1;
        }
        else if(section == 1)
        {
            return headArray.count;
        }
        else
        {
            return completedHeadArray.count;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in number of rows is %@", exception);
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        return 30;
    }
    else
    {
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
<<<<<<< HEAD
    
        static NSString *simpleTableIdentifier = @"Sitemetercell";
        
        sitemetercell *cell = (sitemetercell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"sitemetercell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        
        
        
=======
    @try
    {
      
>>>>>>> FETCH_HEAD
        if(indexPath.section == 0)
        {
            ProgressCell *theCell = (ProgressCell *)[tableView dequeueReusableCellWithIdentifier:@"ProgressCell"];
            if(theCell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProgressCell" owner:self options:nil];
                theCell = [nib objectAtIndex:0];
            }
            
            theCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row ==0)
            {
                theCell.frame = CGRectMake(theCell.frame.origin.x, theCell.frame.origin.y, 320, 77);
                theCell.progressText.text = [NSString stringWithFormat:@"%d %@ complete",percentageComplete,@"%"];
                theCell.progressText.font = [UIFont fontWithName:@"HelveticaNueu" size:13];
            
                
                theCell.myProgressView.progress = percentComplete;
                CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 15.0f);
                theCell.myProgressView.transform = transform;
               
                
                return theCell;
            }
        }
        else
        {
            static NSString *simpleTableIdentifier = @"Sitemetercell";
            
            sitemetercell *cell = (sitemetercell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"sitemetercell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
            }
            
            if (indexPath.section == 1)
            {
                
                
                cell.percentage.textColor = [UIColor colorFromHexCode:@"#ffb900"];
                cell.percentage.font = [UIFont fontWithName:@"Helvetica" size:16];
                
                cell.headText.textColor = [UIColor colorFromHexCode:@"#6e6e6e"];
                cell.headText.font = [UIFont fontWithName:@"Helvetica" size:18];
                
                cell.descriptionText.textColor= [UIColor colorFromHexCode:@"#8f8f8f"];
                cell.descriptionText.font = [UIFont fontWithName:@"Helvetica" size:14];
                cell.descriptionText.numberOfLines = 2;
                
                cell.arrowImage.image = [UIImage imageNamed:@"Arrow.png"];
                
                cell.percentage.text = [percentageArray objectAtIndex:indexPath.row];
                cell.headText.text = [headArray objectAtIndex:indexPath.row];
                cell.descriptionText.text = [descArray objectAtIndex:indexPath.row];
                
            }
            else if (indexPath.section == 2)
            {
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.percentage.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
                cell.percentage.font = [UIFont fontWithName:@"Helvetica" size:16];
                
                cell.headText.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
                cell.headText.font = [UIFont fontWithName:@"Helvetica" size:18];
                
                cell.descriptionText.textColor= [UIColor colorFromHexCode:@"#b0b0b0"];
                cell.descriptionText.font = [UIFont fontWithName:@"Helvetica" size:14];
                cell.descriptionText.numberOfLines = 2;
                
                cell.arrowImage.image = [UIImage imageNamed:@"Arrow.png"];
                
                cell.percentage.text = [completedPercentageArray objectAtIndex:indexPath.row];
                cell.headText.text = [completedHeadArray objectAtIndex:indexPath.row];
                cell.descriptionText.text = [completedDescArray objectAtIndex:indexPath.row];
            }
            
            return cell;
        }
   
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in cell for row is %@", exception);
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        
        if(indexPath.section == 2)
        {
            sitemetercell *theSelectedCell = (sitemetercell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    
            [self selectedAction:theSelectedCell.headText.text];
                
                  
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in selecting cells is %@",exception);
    }
    
}

-(void)selectedAction:(NSString *)actionText
{
    if([actionText isEqualToString:@"Business Name"])
    {
        BusinessDetailsViewController *businessName=[[BusinessDetailsViewController alloc]initWithNibName:@"BusinessDetailsViewController" bundle:Nil];
        
        [self.navigationController presentViewController:businessName animated:YES completion:nil];
    }
    else if([actionText isEqualToString:@"Business Desc"] )
    {
        BusinessDetailsViewController *businessDesc=[[BusinessDetailsViewController alloc]initWithNibName:@"BusinessDetailsViewController" bundle:Nil];
        
        [self.navigationController presentViewController:businessDesc animated:YES completion:nil];
        
    }
    else if ([actionText isEqualToString:@"Business Category"] )
    {
        BusinessDetailsViewController *businessCat=[[BusinessDetailsViewController alloc]initWithNibName:@"BusinessDetailsViewController" bundle:Nil];
        
        [self.navigationController presentViewController:businessCat animated:YES completion:nil];
    }
    else if ([actionText isEqualToString:@"Featured Image"] )
    {
        UIActionSheet *selectAction=[[UIActionSheet alloc]initWithTitle:@"Select from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
        selectAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        selectAction.tag=2;
        [selectAction showInView:self.view];
    }
    else if ([actionText isEqualToString:@"Primary Number"] )
    {
        BusinessContactViewController *mobileNumber=[[BusinessContactViewController alloc]initWithNibName:@"BusinessContactViewController" bundle:Nil];
        
        [self.navigationController pushViewController:mobileNumber animated:YES];
    }
    else if ([actionText isEqualToString:@"Email"] )
    {
        BusinessContactViewController *email=[[BusinessContactViewController alloc]initWithNibName:@"BusinessContactViewController" bundle:Nil];
        
        [self.navigationController pushViewController:email animated:YES];
    }
    else if ([actionText isEqualToString:@"Business Address"] )
    {
        
        BusinessAddressViewController *businessAddress=[[BusinessAddressViewController alloc]initWithNibName:@"BusinessAddressViewController" bundle:Nil];
        
        [self.navigationController pushViewController:businessAddress animated:YES];
        
    }
    else if ([actionText isEqualToString:@"Business Timings"] )
    {
        BusinessHoursViewController *businessHour=[[BusinessHoursViewController alloc]initWithNibName:@"BusinessHoursViewController" bundle:Nil];
        
        [self.navigationController pushViewController:businessHour animated:YES];
        
    }
    else if ([actionText isEqualToString:@"Facebook"] )
    {
        SettingsViewController *facebook=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:Nil];
        facebook.isGestureAvailable = NO;
        
        [self.navigationController pushViewController:facebook animated:YES];
    }
    else if ([actionText isEqualToString:@"Update"] )
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([actionText isEqualToString:@"Buy Auto SEO"] )
    {
        if(![[appDelegate.storeDetailDictionary objectForKey:@"CountryPhoneCode"]  isEqual: @"91"])
        {
            BuyStoreWidget *buyWidget=[[BuyStoreWidget alloc]init];
            buyWidget.delegate=self;
            [buyWidget purchaseStoreWidget:1008];
        }
        else
        {
            UIAlertView *imageUploadFailAlert=[[UIAlertView alloc]initWithTitle:@"Contact Us" message:@"Please drop in a mail to ria@nowfloats.com to enable auto seo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
<<<<<<< HEAD
            cell.descriptionText.textColor= [UIColor colorWithRed:176.0f/255.0f green:176.0f/255.0f blue:176.0f/255.0f alpha:1.0];
            
            cell.descriptionText.font = [UIFont fontWithName:@"Helvetica" size:14];
            cell.descriptionText.numberOfLines = 2;
=======
            [imageUploadFailAlert  show];
>>>>>>> FETCH_HEAD
            
            imageUploadFailAlert=nil;
        }
    }
    else if ([actionText isEqualToString:@"Buy .com"] )
    {
        
    }
    else if ([actionText isEqualToString:@"Share"] )
    {
        
    }
}

-(void)buyStoreWidgetDidSucceed
{
    
        [appDelegate.storeWidgetArray insertObject:@"SITESENSE" atIndex:0];
    
}

-(void)buyStoreWidgetDidFail
{
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==2)
    {
        
        if(buttonIndex == 0)
        {
            _picker = [[UIImagePickerController alloc] init];
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.delegate = self;
            _picker.allowsEditing=YES;
            _picker.navigationBar.barStyle=UIBarStyleBlackOpaque;
            [self presentViewController:_picker animated:NO completion:nil];
            _picker=nil;
            [_picker setDelegate:nil];
        }
        
        
        if (buttonIndex==1)
        {
            _picker=[[UIImagePickerController alloc] init];
            _picker.allowsEditing=YES;
            [_picker setDelegate:self];
            //          [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            _picker.navigationBar.barStyle=UIBarStyleBlackOpaque;
            [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:_picker animated:YES completion:NULL];
            _picker=nil;
            [_picker setDelegate:nil];
            
        }
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    primaryImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
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
    appDelegate.primaryImageUploadUrl = [NSMutableString stringWithFormat:@"%@",localImageUri];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [picker1 dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(displayPrimaryImageModalView:) withObject:localImageUri afterDelay:1.0];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    [picker1 dismissViewControllerAnimated:YES completion:nil];
}

-(void)displayPrimaryImageModalView:(NSString *)path
{
    
    
    PrimaryImageViewController *primaryController=[[PrimaryImageViewController alloc]initWithNibName:@"PrimaryImageViewController" bundle:Nil];
    
    primaryController.isFromHomeVC=YES;
    
    primaryController.localImagePath=path;
    
    // UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:primaryController];
    
    // [self presentViewController:navController animated:YES completion:nil];
    
    NSMutableArray *chunkArray = [[NSMutableArray alloc]init];
    
    
    NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    NSRange range = NSMakeRange (0, 36);
    
    uuid=[uuid substringWithRange:range];
    
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    uuid = [[uuid componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @""];
    
    NSString *uniqueIdString=[[NSString alloc]initWithString:uuid];
    
    UIImage *img = primaryImage;
    
    NSData *dataObj=UIImageJPEGRepresentation(img,0.1);
    
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
        
<<<<<<< HEAD
        return cell;
   
=======
    }
    
    while (offset < length);
    
    totalImageDataChunks=[chunkArray count];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] init];
    
    for (int i=0; i<[chunkArray count]; i++)
    {
        
        NSString *urlString=[NSString stringWithFormat:@"%@/createImage?clientId=%@&fpId=%@&reqType=parallel&reqtId=%@&totalChunks=%d&currentChunkNumber=%d",appDelegate.apiWithFloatsUri,appDelegate.clientId,[userDetails objectForKey:@"userFpId"],uniqueIdString,totalImageDataChunks,i];
        
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
    
    
>>>>>>> FETCH_HEAD
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    NSLog(@"code:%d",code);
    
   
        if (code==200)
        {
            successCode++;
            
            if (successCode==totalImageDataChunks)
            {
                successCode=0;
                
                appDelegate.primaryImageUri=[NSMutableString stringWithFormat:@"%@",appDelegate.primaryImageUploadUrl];
                
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
