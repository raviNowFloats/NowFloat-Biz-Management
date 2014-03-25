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

@interface EmailShareController (){
    NSMutableArray *allEmails;
    NSMutableArray *selectedStates;
    UINavigationBar *bottomNav;
    UIBarButtonItem *navButton, *deselectAll, *selectAll;
    IBOutlet UITableView *tableview;
}
@end

@implementation EmailShareController

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
    ABAddressBookRef addressBook;
    
    if (version.floatValue > 6.0) {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                NSLog(@"User has given access to contacts for first time");
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // The user has previously given access, add the contact
            NSLog(@"User has given access to contacts previously");
        }
        else {
            NSLog(@"User has denied access to contacts");
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Test Mail"
                                                                message:@"You have denied access to contacts, please change privacy settings in settings app"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    else{
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
   
    if(version.floatValue < 7.0)
    {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        self.navigationItem.title = @"Contacts";
    }
    else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
    for(CFIndex i = 0; i < CFArrayGetCount(people);i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people,i);
        ABMultiValueRef emails = ABRecordCopyValue(person,kABPersonEmailProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(emails); j++)
        {
            NSString *email = (__bridge NSString *) ABMultiValueCopyValueAtIndex(emails,j);
            [allEmails addObject:email];
        }
    }
    
    tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.multipleTouchEnabled = YES;
    selectedStates = [[NSMutableArray alloc]init];
    [self.view addSubview:tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allEmails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [allEmails objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:indexPath];
    if ( theSelectedCell.accessoryType == UITableViewCellAccessoryNone ) {
        theSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSString *selEmails = theSelectedCell.textLabel.text;
        [selectedStates addObject:selEmails];
    }
    else {
        theSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        NSString *unselEmails = theSelectedCell.textLabel.text;
        [selectedStates removeObject:unselEmails];
    }
    if(self.navigationItem.rightBarButtonItem == nil)
    {
        if(selectedStates.count > 0)
        {
            navButton = [[UIBarButtonItem alloc]
                         initWithTitle:@"Done"
                         style:UIBarButtonItemStyleBordered
                         target:self
                         action:@selector(sendMail:)];
            self.navigationItem.rightBarButtonItem = navButton;
            
            
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,  self.view.frame.size.height, self.view.frame.size.width, 44.0)];
            bottomNav.barStyle = UIBarStyleDefault;
            
            UINavigationItem *navItem = [[UINavigationItem alloc] init];
            deselectAll = [[UIBarButtonItem alloc]
                           initWithTitle:@"Deselect all"
                           style:UIBarButtonItemStyleBordered
                           target:self
                           action:@selector(DeselectAll:)];
            navItem.leftBarButtonItem = deselectAll;
            
            selectAll = [[UIBarButtonItem alloc]
                         initWithTitle:@"Select all"
                         style:UIBarButtonItemStyleBordered
                         target:self
                         action:@selector(selectAll:)];
            navItem.rightBarButtonItem = selectAll;
            bottomNav.items = [NSArray arrayWithObject:navItem];
            
            [self.parentViewController.view addSubview:bottomNav];
        }
        
    }
    if(selectedStates.count == 0)
    {
        self.navigationItem.rightBarButtonItem = nil;
        [bottomNav removeFromSuperview];
    }
    
}

-(void)selectAll:(id)sender{
    for (NSInteger s = 0; s < tableview.numberOfSections; s++) {
        for (NSInteger r = 0; r < [tableview numberOfRowsInSection:s]; r++) {
            UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
            if ( theSelectedCell.accessoryType == UITableViewCellAccessoryNone ) {
                theSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                NSString *selEmails = theSelectedCell.textLabel.text;
                [selectedStates addObject:selEmails];
            }
        }
    }
    self.navigationItem.rightBarButtonItem = navButton;
}

-(void)DeselectAll:(id)sender{
    for (NSInteger s = 0; s < tableview.numberOfSections; s++) {
        for (NSInteger r = 0; r < [tableview numberOfRowsInSection:s]; r++) {
            UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
            if ( theSelectedCell.accessoryType != UITableViewCellAccessoryNone ) {
                theSelectedCell.accessoryType = UITableViewCellAccessoryNone;
                NSString *unselEmails = theSelectedCell.textLabel.text;
                [selectedStates removeObject:unselEmails];
            }
        }
    }
    self.navigationItem.rightBarButtonItem = nil;
    [bottomNav removeFromSuperview];
}

-(void)sendMail:(id)sender{
    mailComposer = [[MFMailComposeViewController alloc]init];
    if([MFMailComposeViewController canSendMail]){
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"Test mail"];
        [mailComposer setMessageBody:@"Testing message for the test mail" isHTML:NO];
        [mailComposer setToRecipients:selectedStates];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Please configure email account before sending email");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"Mail composer started");
    NSString *alertMessage = [[NSString alloc]init];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alertMessage = @"Email composition cancelled";
            break;
        case MFMailComposeResultSaved:
            alertMessage = @"Your e-mail has been saved successfully";
            break;
        case MFMailComposeResultSent:
            alertMessage = @"Your email has been sent successfully";
            break;
        case MFMailComposeResultFailed:
            alertMessage = @"Failed to send email";
            break;
        default:
            alertMessage = @"Email Not Sent";
            break;
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Test Mail" message:alertMessage delegate:nil cancelButtonTitle:@"OK"      otherButtonTitles:nil];
    [alertView show];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    BizMessageViewController *frontController=[[BizMessageViewController alloc]initWithNibName:@"BizMessageViewController" bundle:nil];
    
    frontController.isLoadedFirstTime=YES;
    
    [self.navigationController pushViewController:frontController animated:YES];
    
    frontController=nil;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
