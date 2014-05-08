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

@interface MobileShareController ()<MFMessageComposeViewControllerDelegate>
{
    float viewHeight;
    UINavigationBar *navBar;
    UILabel *headLabel;
    UIButton *leftCustomButton, *rightCustomButton;
    NSMutableArray *allNames;
    NSMutableArray *contactsArray;
    NSMutableArray *selectedStates;
    NSMutableArray *allMobileNumbers;
    ABAddressBookRef addressBk;
}

@end

@implementation MobileShareController

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
    
    version = [[UIDevice currentDevice] systemVersion];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    allNames = [[NSMutableArray alloc] init];
    
    allMobileNumbers = [[NSMutableArray alloc] init];
    
    contactsArray = [[NSMutableArray alloc]init];
    
    selectedStates = [[NSMutableArray alloc]init];
    
    
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
    
    
    if(version.floatValue < 7.0)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        mobileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, width, viewHeight) style:UITableViewStylePlain];
        
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
        
        mobileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, viewHeight) style:UITableViewStylePlain];
        
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Message";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        
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
    
    mobileTableView.allowsMultipleSelection = YES;

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
        
        
        mobileTableView.multipleTouchEnabled = YES;
        [mobileTableView reloadData];
    }
    @catch (NSException *exception) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    

}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allMobileNumbers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (!cell)
    {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }

    
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 240, 30)];
    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 240, 20)];
    
    UIView *displayImage = [[UIView alloc] initWithFrame:CGRectMake(35, 5, 50, 50)];
    displayImage.clipsToBounds = YES;
    displayImage.layer.cornerRadius = displayImage.frame.size.height/2;
    
    
    UIImageView *displayPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    labelOne.text = [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    labelOne.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    labelTwo.text = [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobile"];
    labelTwo.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    labelTwo.textColor = [UIColor colorWithHexString:@"#5a5a5a"];
    
    [displayPic setImage:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    displayPic.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    displayImage.contentMode = UIViewContentModeScaleAspectFill;
    displayPic.contentMode = UIViewContentModeScaleAspectFill;
    
//    /displayImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    displayPic.layer.cornerRadius = displayPic.frame.size.height/2;
    displayPic.layer.masksToBounds = YES;
    displayPic.layer.borderWidth = 0;
    
    [cell.imageView setFrame:CGRectMake(0, 5, 25, 25)];
    
    if([selectedStates containsObject:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobile"]])
    {
        cell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"Unchecked1.png"];
    }
    
    
    [displayImage addSubview:displayPic];
    
    [cell.contentView addSubview:displayImage];
    [cell.contentView addSubview:labelOne];
    [cell.contentView addSubview:labelTwo];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    

    
    return cell;
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *theSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(theSelectedCell.imageView.image == [UIImage imageNamed:@"Unchecked1.png"])
    {
        NSString *selEmails = [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobile"];
        theSelectedCell.imageView.image = [UIImage imageNamed:@"Checked1.png"];
        [selectedStates addObject:selEmails];
    }
    else
    {
        NSString *unselEmails = [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobile"];
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

-(void)sendMessage:(id)sender
{
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    [mixPanel track:@"Mobile sharing send button clicked"];
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = selectedStates;
    NSString *message = [NSString stringWithFormat:@"Just sent the file to your email. Please check!"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
