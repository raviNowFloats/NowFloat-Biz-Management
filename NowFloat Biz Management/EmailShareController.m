//
//  EmailShareController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 3/24/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//
#import "EmailShareController.h"
#import "AddressBook/AddressBook.h"
#import "BizMessageViewController.h"
#import "UIColor+HexaString.h"
#import "FileManagerHelper.h"
#import "AppDelegate.h"
#import "Mixpanel.h"
#import "QuartzCore/QuartzCore.h"


@interface EmailShareController (){
    NSMutableArray *allEmails;
    float viewHeight;
    NSMutableArray *selectedStates;
    UIBarButtonItem *navButton, *deselectAll, *selectAll, *cancelView;
    IBOutlet UITableView *tableview;
    ABAddressBookRef addressBk;
    UINavigationItem *navItem;
    AppDelegate *appDelegate;
    NSMutableArray *allNames;
    NSMutableArray *contactsArray;
    UINavigationBar *navBar;
    UILabel *headLabel;
    UIButton *leftCustomButton, *rightCustomButton;
   
    NSMutableArray *filteredArray;
    NSMutableArray *sectionHeading;
     NSMutableDictionary *sections;
    BOOL isSearch;
    
    
}

@end



@implementation EmailShareController
@synthesize loadActivity,filter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
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
    
    tableview.hidden = YES;
    
    allNames = [[NSMutableArray alloc] init];
    
    allEmails = [[NSMutableArray alloc] init];
    
    contactsArray = [[NSMutableArray alloc]init];
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    selectedStates = [[NSMutableArray alloc]init];
    
    filteredArray = [[NSMutableArray alloc]init];
    
    sectionHeading = [[NSMutableArray alloc]init];

    loadActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadActivity.backgroundColor = [UIColor lightGrayColor];
    loadActivity.frame = CGRectMake(120, 170, 80, 80);
    loadActivity.color = [UIColor whiteColor];
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
    filter.delegate = self;
    
    if(version.floatValue < 7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        filter.frame = CGRectMake(0,44, 320, 60);
        
        [self.view addSubview:filter];
        
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, 320, viewHeight) style:UITableViewStylePlain];
        
        headLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 13, 140, 20)];
        
        headLabel.text=@"Email";
        
        headLabel.backgroundColor=[UIColor clearColor];
        
        headLabel.textAlignment=NSTextAlignmentCenter;
        
        headLabel.font=[UIFont fontWithName:@"Helvetica" size:18.0];
        
        headLabel.textColor=[UIColor  colorWithHexString:@"464646"];
        
        [navBar addSubview:headLabel];
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,9,32,26)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"back-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
        
        rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(250,7,56,28)];
        
        [rightCustomButton setTitle:@"Invite" forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:rightCustomButton];
        
        [rightCustomButton setHidden:YES];
        
        
    }
    else{
        
        filter.frame = CGRectMake(0,60, 320, 60);
        
        [self.view addSubview:filter];
        
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, 320, viewHeight) style:UITableViewStylePlain];
        
        
//        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, viewHeight) style:UITableViewStylePlain];
        
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Email";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        
        rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(260,7,56,26)];
        
        [rightCustomButton setTitle:@"Invite" forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    
    tableview.delegate = self;
    
    tableview.dataSource = self;
    
    tableview.multipleTouchEnabled = YES;
    
    tableview.allowsMultipleSelection = YES;
    
    [self.view addSubview:tableview];

    if (version.floatValue > 6.0)
    {
        addressBk = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBk, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                NSLog(@"User has given access to contacts for first time");
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
            NSLog(@"User has denied access to contacts");
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
 
}

-(void)accessContacts
{    
    @try {
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBk);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBk);
        
        
            for( CFIndex emailIndex = 0; emailIndex < nPeople; emailIndex++ )
            {
                ABRecordRef person = CFArrayGetValueAtIndex( allPeople, emailIndex );
                ABMutableMultiValueRef emailRef= ABRecordCopyValue(person, kABPersonEmailProperty);
                int emailCount = ABMultiValueGetCount(emailRef);
                if(!emailCount)
                {
                    CFErrorRef error = nil;
                    ABAddressBookRemoveRecord(addressBk, person, &error);
                    if (error) NSLog(@"Error: %@", error);
                }
                else {
                    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                    
                    for(CFIndex j= 0; j< ABMultiValueGetCount(emails);j++)
                    {
                        NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                        [allEmails addObject:email];
                        
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
                                                                email, @"email",
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
        
        

        
            if(allEmails.count == 0)
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                                    message:@"You have no Email contacts to share"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                alertView.tag = 210;
                [alertView show];
            }
            else
            {
                tableview.hidden = NO;
                tableview.multipleTouchEnabled = NO;
                [tableview reloadData];
            }
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
    
    [tableview reloadData];
    
    
    
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (!cell)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
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
        labelTwo.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"email"];
        [displayPic setImage:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    }
    else
    {
        
        NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        labelOne.text = [book objectForKey:@"name"];
        labelTwo.text = [book objectForKey:@"email"];
        [displayPic setImage:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
        [loadActivity stopAnimating];
        
    }

    
       labelOne.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
   
    labelTwo.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    labelTwo.textColor = [UIColor colorWithHexString:@"#5a5a5a"];
    
    displayPic.autoresizingMask = UIViewAutoresizingNone;
    displayImage.contentMode = UIViewContentModeScaleAspectFill;
    displayPic.contentMode = UIViewContentModeScaleAspectFill;
   
    
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
        
        if([selectedStates containsObject:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobile"]])
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

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:indexPath];
    
    if(!isSearch)
    {
        if(theSelectedCell.imageView.image == [UIImage imageNamed:@"Unchecked1.png"])
        {
            
            NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
            NSString *selEmails  = [book objectForKey:@"email"];
            
            theSelectedCell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
            theSelectedCell.selectionStyle = UITableViewCellSelectionStyleGray;
            [selectedStates addObject:selEmails];
        }
        else
        {
            NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
            
            NSString *unselEmails = [book objectForKey:@"email"];
            theSelectedCell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
            [selectedStates removeObject:unselEmails];
        }
    }
    else
    {
        if(theSelectedCell.imageView.image == [UIImage imageNamed:@"Unchecked1.png"])
        {
            
            NSString *selEmails  = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"email"];            theSelectedCell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
            theSelectedCell.selectionStyle = UITableViewCellSelectionStyleGray;
            [selectedStates addObject:selEmails];
        }
        else
        {
            NSString *unselEmails = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"email"];
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
     UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:indexPath];
    
    if(theSelectedCell.imageView.image == [UIImage imageNamed:@"Unchecked1.png"])
    {
        NSString *selEmails = [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"email"];
        theSelectedCell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
        theSelectedCell.selectionStyle = UITableViewCellSelectionStyleGray;
        [selectedStates addObject:selEmails];
    }
    else
    {
        NSString *unselEmails = [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"email"];
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

-(void)selectAll:(id)sender
{
    @try
    {
        for (NSInteger s = 0; s < tableview.numberOfSections; s++)
        {
            for (NSInteger r = 0; r < [tableview numberOfRowsInSection:s]; r++)
            {
                UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
                
                if ( theSelectedCell.accessoryType == UITableViewCellAccessoryNone )
                {
                    theSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }

        [selectedStates removeAllObjects];
        
        [selectedStates addObjectsFromArray:allEmails];
        
        self.navigationItem.rightBarButtonItem = navButton;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception:%@",exception.description);
    }
}

-(void)DeselectAll:(id)sender
{
    @try
    {
        for (NSInteger s = 0; s < tableview.numberOfSections; s++)
        {
            for (NSInteger r = 0; r < [tableview numberOfRowsInSection:s]; r++)
            {
                UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
                if ( theSelectedCell.accessoryType != UITableViewCellAccessoryNone )
                {
                    theSelectedCell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
        [selectedStates removeAllObjects];
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception.description);
    }
}
-(void)sendMail:(id)sender{
    mailComposer = [[MFMailComposeViewController alloc]init];
    if([MFMailComposeViewController canSendMail])
    {
        mailComposer.mailComposeDelegate = self;
        
        NSString *fisrtParagraph = @"I just downloaded the NowFloats Boost App on my iPhone. It helps you build, update & manage your website on the go! Most importantly it ensures your business is highly discoverable online and helps you get more customers.";
        
        NSString *secondParagraph = @"For more information, go to http://nowfloats.com/boost and click here http://j.mp/NFBoostiPhone to download the app for iPhone and click here http://j.mp/NFBoostAndroid to download app for android.";
        
        NSString* shareText = [NSString stringWithFormat:@"Hey, \n %@ \n \n %@",fisrtParagraph,secondParagraph];
        
        [mailComposer setSubject:@"NowFloats Boost"];
        [mailComposer setMessageBody:shareText isHTML:NO];
        NSMutableArray *toContact = [[NSMutableArray alloc] init];
        [toContact addObject:[selectedStates objectAtIndex:0]];
        [mailComposer setToRecipients:toContact];
         NSMutableArray *bccContacts = [[NSMutableArray alloc] init];
        [bccContacts addObjectsFromArray:selectedStates];
        [bccContacts removeObjectAtIndex:0];
        [mailComposer setBccRecipients:bccContacts];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                message:@"You have to configure your email account on your phone first before sharing your website"
               delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil];
        alertView.tag = 204;
        [alertView show];
    }
}

-(void)cancelView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent)
    {
        
        Mixpanel *mixPanel = [Mixpanel sharedInstance];
        
        [mixPanel track:@"EmailShare complete"];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Email sent successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        alertView.tag = 202;
        [alertView show];
        self.navigationItem.rightBarButtonItem = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        Mixpanel *mixPanel = [Mixpanel sharedInstance];
        
        [mixPanel track:@"EmailShare cancelled"];

        
        [selectedStates removeAllObjects];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        for (NSInteger s = 0; s < tableview.numberOfSections; s++)
        {
            for (NSInteger r = 0; r < [tableview numberOfRowsInSection:s]; r++)
            {
                UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
                
                [tableview deselectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] animated:YES];
                
                if ( theSelectedCell.imageView.image == [UIImage imageNamed:@"Checked1.png"])
                {
                    theSelectedCell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
                }
            }
        }
    
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0 )
    {
        if(alertView.tag == 202)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (alertView.tag == 210)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
