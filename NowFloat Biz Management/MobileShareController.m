//
//  MobileShareController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/6/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "MobileShareController.h"
#import "UIColor+HexaString.h"
#import "AddressBook/AddressBook.h"
#import <MessageUI/MessageUI.h>
#import "Mixpanel.h"
#import "NFActivityView.h"

@interface MobileShareController ()<MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *mobileTableView;
    float viewHeight;
    UINavigationBar *navBar;
    UILabel *headLabel;
    UIButton *leftCustomButton, *rightCustomButton;
    NSMutableArray *allNames;
    NSMutableArray *contactsArray;
    NSMutableArray *selectedStates;
    NSMutableArray *allMobileNumbers;
    NSMutableArray *filteredArray;
    NSMutableArray *sectionHeading;
    BOOL isSearch;

    ABAddressBookRef addressBk;
    NSMutableDictionary *sections;
}

@end

@implementation MobileShareController
@synthesize loadActivity;
@synthesize filter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(version.floatValue < 7.0)
    {
        rightCustomButton.hidden = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mobileTableView.hidden = YES;
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    allNames = [[NSMutableArray alloc] init];
    
    allMobileNumbers = [[NSMutableArray alloc] init];
    
    contactsArray = [[NSMutableArray alloc]init];
    
    selectedStates = [[NSMutableArray alloc]init];
    
    filteredArray = [[NSMutableArray alloc]init];
    
    sectionHeading = [[NSMutableArray alloc]init];
    
    loadActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadActivity.backgroundColor = [UIColor lightGrayColor];
    loadActivity.frame = CGRectMake(120, 170, 80, 80);
    loadActivity.color = [UIColor whiteColor];
    
    [mobileTableView addSubview:loadActivity];
    [loadActivity startAnimating];
    
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
    
    filter = [[UISearchBar alloc]init];
    filter.delegate=self;
    
    if(version.floatValue < 7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        
        filter.frame = CGRectMake(0,44, 320, 60);
        
        [self.view addSubview:filter];
        
        mobileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, 320, viewHeight) style:UITableViewStylePlain];
//        
        headLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 13, 140, 20)];
        
        headLabel.text=@"Message";
        
        headLabel.backgroundColor=[UIColor clearColor];
        
        headLabel.textAlignment=NSTextAlignmentCenter;
        
        headLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headLabel];
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,9,32,26)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"back-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
        
        rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(250,7,56,28)];
        
        [rightCustomButton setTitle:@"Invite" forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:rightCustomButton];
        
        [rightCustomButton setHidden:YES];
        
        
    }
    else{

        filter.frame = CGRectMake(0,60, 320, 60);
        
        [self.view addSubview:filter];
       
        mobileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, viewHeight) style:UITableViewStylePlain];
        
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Message";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        
        rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(250,7,56,26)];
        
        [rightCustomButton setTitle:@"Invite" forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    if (version.floatValue > 6.0)
    {
        addressBk = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBk, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                if(granted)
                {
                    
                    [self accessContacts];
                }
                else if(error)
                {
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Oops"
                                                                     message:(__bridge NSString *)(error)
                                                                    delegate:self
                                                           cancelButtonTitle:@"Done"
                                                           otherButtonTitles:nil, nil];
                    
                    [alertView show];
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            
            [self accessContacts];
        }
        else {
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Test Mail"
                                                                message:@"You have denied access to contacts, please change privacy settings in settings app"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            alertView.tag = 203;
            [alertView show];
            
        }
    }
    else{
        addressBk = ABAddressBookCreateWithOptions(NULL, NULL);
        [self accessContacts];
    }
    
    mobileTableView.dataSource = self;
    
    mobileTableView.delegate = self;
    
    mobileTableView.multipleTouchEnabled = YES;
    
    mobileTableView.allowsMultipleSelection = YES;
    
    [self.view addSubview:mobileTableView];

    // Do any additional setup after loading the view from its nib.
}

-(void)accessContacts
{
    @try {
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBk);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBk);
        
        for( CFIndex mobileIndex = 0; mobileIndex < nPeople; mobileIndex++ ) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, mobileIndex );
            
            ABMutableMultiValueRef mobileRef= ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            int mobileCount = ABMultiValueGetCount(mobileRef);
            if(!mobileCount)
            {
                CFErrorRef error = nil;
                ABAddressBookRemoveRecord(addressBk, person, &error);
                if (error) NSLog(@"Error: %@", error);
            }
            else {
                
                ABMultiValueRef mobileNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
                
                for(CFIndex j= 0; j< ABMultiValueGetCount(mobileNumbers);j++)
                {
                    NSString *mobile = (__bridge NSString *)ABMultiValueCopyValueAtIndex(mobileNumbers, j);
                    
                    [allMobileNumbers addObject:mobile];
                    
                    NSString *name = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    
                    if (name) {
                        [allNames addObject: name];
                        UIImage *image = [[UIImage alloc]init];
                        if (ABPersonHasImageData(person))
                        {
                            NSData  *imgData = (__bridge NSData *) ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
                            image = [UIImage imageWithData:imgData];
                        }
                        else
                        {
                            image = [UIImage imageNamed:@"Picture1.png"];
                        }
                        
                        NSMutableDictionary *contactDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            name, @"name",
                                                            mobile, @"mobile",
                                                            image,@"picture",
                                                            nil];
                        
                        
                        [contactsArray addObject:contactDict];
                        
                    }
                }
                
            }
            
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [contactsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        BOOL found;
       
        
        sections = [[NSMutableDictionary alloc]init];
        
        for(NSDictionary *contacts in contactsArray)
        {
            NSString *c = [[contacts objectForKey:@"name"] substringToIndex:1];
           
NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
            NSString *filtered = [[c componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
            if([c isEqualToString:filtered])
            {
                
            }
            else
            {
                c = @"#";
            }
          
            
            found = NO;
            for (NSString *str in [sections allKeys])
            {
                if ([str isEqualToString:c])
                {
                    found = YES;
                }
            }
            
            if (!found)
            {
                [sections setValue:[[NSMutableArray alloc] init] forKey:c];
            }
           
            
        }
        
        for (NSDictionary *contacts in contactsArray)
        {
           
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
            
            NSString *check = [[contacts objectForKey:@"name"] substringToIndex:1];
            
            NSString *filtered = [[check componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
            if([check isEqualToString:filtered])
            {
                [[sections objectForKey:[[contacts objectForKey:@"name"] substringToIndex:1]] addObject:contacts];

            }
            else
            {
                [[sections objectForKey:@"#"] addObject:contacts];
            }
            
           
           
           
        }
        
        // Sort each section array
        for (NSString *key in [sections allKeys])
        {
            [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
        }
        
      
        
        sectionHeading = [NSMutableArray arrayWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
       
        
     
     
        mobileTableView.hidden = NO;
        mobileTableView.multipleTouchEnabled = YES;
        [mobileTableView reloadData];
        
       
       
        
    }
    @catch (NSException *exception) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    

}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
 
    
    if(searchText.length==0){
                isSearch=FALSE;
    }
    else{
        isSearch=true;
        
        filteredArray = [NSMutableArray new];
        
        for(int i =0; i < [contactsArray count];i++)
        {
            tempDict = [contactsArray objectAtIndex:i];
           
            
            NSString *str = [tempDict objectForKey:@"name"];
            
                NSRange nameRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
                NSRange descriptionRange = [str.description rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
                {
                    
                    [filteredArray addObject:tempDict];
                    
                }
            
          
        }
        
    }

    [mobileTableView reloadData];
    
    
    

}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(isSearch)
    {
       
        return 1;
        
    }
    else
    {
        return [[sections allKeys]count];
    }
   
   
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(isSearch)
    {
        return 0;
    }
    else
    {
      return [[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section] uppercaseString];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     
    if(!isSearch)
    {
        
        
        return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        
    }
    else
    {
        
        return [filteredArray count];
    }
    
    
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
 
    if(isSearch)
    {
      return 0;
    }
    else
    {
    
    return sectionHeading;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if(isSearch)
    {
        return 0;
    }
    else
    {
        return 25;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    NSDictionary *book ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (!cell)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(105, 5, 240, 30)];
    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(105, 30, 240, 20)];
    
    UIView *displayImage = [[UIView alloc] initWithFrame:CGRectMake(45, 5, 50, 50)];
    displayImage.clipsToBounds = YES;
    displayImage.layer.cornerRadius = displayImage.frame.size.height/2;
    
    
    UIImageView *displayPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    
    if(isSearch)
    {
        labelOne.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        labelTwo.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"mobile"];
        [displayPic setImage:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    }
    else
    {
        book  = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        labelOne.text = [book objectForKey:@"name"];
         labelTwo.text = [book objectForKey:@"mobile"];
        [displayPic setImage:[book objectForKey:@"picture"]];

        [loadActivity stopAnimating];
    }
    
    
    
    labelOne.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
   
    labelTwo.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    labelTwo.textColor = [UIColor colorWithHexString:@"#5a5a5a"];
    
    
    
    displayPic.autoresizingMask = UIViewAutoresizingNone;
    displayImage.contentMode = UIViewContentModeScaleAspectFit;
    displayPic.contentMode = UIViewContentModeScaleAspectFit;
    
    //displayImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    displayPic.layer.cornerRadius = displayPic.frame.size.height/2;
    displayPic.layer.masksToBounds = YES;
    displayPic.layer.borderWidth = 0;
    
    displayPic.bounds = CGRectMake(0, 0, 60, 60);
    
    
    
    if(isSearch)
    {
        if([selectedStates containsObject:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"mobile"]])
        {
            cell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
        }
    }
    else
    {
        if([selectedStates containsObject:[book objectForKey:@"mobile"]])
        {
            cell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
        }
    }
    
    
   
    
    [displayImage addSubview:displayPic];
    
    [cell.contentView addSubview:displayImage];
    [cell.contentView addSubview:labelOne];
    [cell.contentView addSubview:labelTwo];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
   if(result == MessageComposeResultSent)
   {
       Mixpanel *mixPanel = [Mixpanel sharedInstance];
       
       [mixPanel track:@"Message share complete"];
       
       UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Message sent successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
       
       alertView.tag = 202;
       [alertView show];
       self.navigationItem.rightBarButtonItem = nil;
       [self dismissViewControllerAnimated:YES completion:nil];
   }
   else
   {
       
       [selectedStates removeAllObjects];
       
       [self dismissViewControllerAnimated:YES completion:nil];
       
       for (NSInteger s = 0; s < mobileTableView.numberOfSections; s++)
       {
           for (NSInteger r = 0; r < [mobileTableView numberOfRowsInSection:s]; r++)
           {
               UITableViewCell *theSelectedCell = [mobileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
               
               [mobileTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] animated:YES];
               
               if ( theSelectedCell.imageView.image == [UIImage imageNamed:@"Checked1.png"])
               {
                   theSelectedCell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
               }
           }
       }
   }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *theSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if(!isSearch)
    {
        if(theSelectedCell.imageView.image == [UIImage imageNamed:@"Unchecked1.png"])
        {
            
            NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
            NSString *selEmails  = [book objectForKey:@"mobile"];
            
            theSelectedCell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
            theSelectedCell.selectionStyle = UITableViewCellSelectionStyleGray;
            [selectedStates addObject:selEmails];
        }
        else
        {
            NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
            
            NSString *unselEmails = [book objectForKey:@"mobile"];
            theSelectedCell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
            [selectedStates removeObject:unselEmails];
        }
    }
    else
    {
        if(theSelectedCell.imageView.image == [UIImage imageNamed:@"Unchecked1.png"])
        {
            
            NSString *selEmails  = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"mobile"];
            theSelectedCell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
            theSelectedCell.selectionStyle = UITableViewCellSelectionStyleGray;
            [selectedStates addObject:selEmails];
        }
        else
        {
            NSString *unselEmails = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"mobile"];
            theSelectedCell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
            [selectedStates removeObject:unselEmails];
        }
    }
    
    
    
    if(version.floatValue < 7.0)
    {
        if(rightCustomButton.hidden == YES)
        {
            if(selectedStates.count > 0)
            {
                rightCustomButton.hidden = NO;
            }
        }
        
        if(selectedStates.count == 0)
        {
            rightCustomButton.hidden = YES;
        }
    }
    else
    {
        if(self.navigationItem.rightBarButtonItem == nil)
        {
            if(selectedStates.count > 0)
            {
                UIBarButtonItem *rightBtnItem =[[UIBarButtonItem alloc]initWithCustomView:rightCustomButton];
                
                self.navigationItem.rightBarButtonItem = rightBtnItem;
                
            }
        }
        
        if(selectedStates.count == 0)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(theSelectedCell.imageView.image == [UIImage imageNamed:@"Unchecked1.png"])
    {
        NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        NSString *selEmails  = [book objectForKey:@"mobile"];
        
        theSelectedCell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
        theSelectedCell.selectionStyle = UITableViewCellSelectionStyleGray;
        [selectedStates addObject:selEmails];

    }
    else
    {
        NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
        NSString *unselEmails = [book objectForKey:@"mobile"];
        theSelectedCell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
        [selectedStates removeObject:unselEmails];
    }
    
    if(version.floatValue < 7.0)
    {
        if(rightCustomButton.hidden == YES)
        {
            if(selectedStates.count > 0)
            {
                rightCustomButton.hidden = NO;
            }
        }
        
        if(selectedStates.count == 0)
        {
            rightCustomButton.hidden = YES;
        }
    }
    else
    {
        if(self.navigationItem.rightBarButtonItem == nil)
        {
            if(selectedStates.count > 0)
            {
                UIBarButtonItem *rightBtnItem =[[UIBarButtonItem alloc]initWithCustomView:rightCustomButton];
                
                self.navigationItem.rightBarButtonItem = rightBtnItem;
                
            }
        }
        
        if(selectedStates.count == 0)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
       if(alertView.tag == 202)
        {
            if (buttonIndex == 0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    
}

-(void)sendMessage:(id)sender
{
       MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
  
    
    [mixPanel track:@"Mobile sharing send button clicked"];
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    else if([MFMessageComposeViewController canSendText])
    {
    
    NSArray *recipents = selectedStates;
   
    NSString *message = [NSString stringWithFormat:@"Get a website in minutes using the NowFloats Boost App on iOS & Android. Download it today: http://bit.ly/nowfloatsboost"];
    
 
   
    messageController.messageComposeDelegate = self;
   
    [messageController setRecipients:recipents];
  
    [messageController setBody:message];
   
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
    
    }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
