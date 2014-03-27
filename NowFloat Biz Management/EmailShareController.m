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

@interface EmailShareController (){
    NSMutableArray *allEmails;
    float viewHeight;
    NSMutableArray *selectedStates;
    UINavigationBar *bottomNav;
    UIBarButtonItem *navButton, *deselectAll, *selectAll, *cancelView;
    IBOutlet UITableView *tableview;
    ABAddressBookRef addressBk;
    UINavigationItem *navItem;
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
    tableview.hidden = YES;
    version = [[UIDevice currentDevice] systemVersion];
    
    cancelView = [[UIBarButtonItem alloc]
                  initWithTitle:@"Cancel"
                  style:UIBarButtonItemStyleBordered
                  target:self
                  action:@selector(cancelView:)];
    self.navigationItem.leftBarButtonItem = cancelView;
    self.navigationItem.title = @"Contacts";
    tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            viewHeight=480;
            NSLog(@"%f", self.view.frame.size.height);
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 440, self.view.frame.size.width, 44.0)];
        }
        
        else
        {
            viewHeight=568;
             bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,  self.view.frame.size.height + 20, self.view.frame.size.width, 44.0)];
        }
    }
    
   
    
    navButton = [[UIBarButtonItem alloc]
                 initWithTitle:@"Done"
                 style:UIBarButtonItemStyleBordered
                 target:self
                 action:@selector(sendMail:)];
    
    navItem = [[UINavigationItem alloc] init];
    
    deselectAll = [[UIBarButtonItem alloc]
                   initWithTitle:@"Deselect all"
                   style:UIBarButtonItemStyleBordered
                   target:self
                   action:@selector(DeselectAll:)];
    
    selectAll = [[UIBarButtonItem alloc]
                 initWithTitle:@"Select all"
                 style:UIBarButtonItemStyleBordered
                 target:self
                 action:@selector(selectAll:)];
    
    
    if(version.floatValue < 7.0)
    {
        bottomNav.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBarHidden = NO;
       [self.navigationItem setHidesBackButton:YES animated:YES];
        
    }
    else{
      
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        bottomNav.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        bottomNav.translucent = NO;
        bottomNav.tintColor = [UIColor whiteColor];
        
    }
    bottomNav.hidden = YES;
    if (version.floatValue > 6.0) {
        addressBk = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBk, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                NSLog(@"User has given access to contacts for first time");
                if(granted)
                {
                    //tableview.hidden = NO;
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
            //tableview.hidden = NO;
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

-(void)accessContacts{
    @try {
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBk);
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
        tableview.hidden = NO;
        tableview.multipleTouchEnabled = YES;
        selectedStates = [[NSMutableArray alloc]init];
        [tableview reloadData];
    }
    @catch (NSException *exception) {
       [self dismissModalViewControllerAnimated:YES];
    }
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            
           self.navigationItem.rightBarButtonItem = navButton;
            
           if(bottomNav.hidden)
           {
               bottomNav.hidden = NO;
           }
            
            navItem.leftBarButtonItem = deselectAll;
            
           
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
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Test Mail"
                                                            message:@"You have to configure your email account on your phone first before sharing your website"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        alertView.tag = 204;
        [alertView show];
        NSLog(@"Please configure email account before sending email");
    }
}
-(void)cancelView:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSString *alertMessage = [[NSString alloc]init];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alertMessage = @"Email composition cancelled";
            mailReportStatus = @"fail";
            break;
        case MFMailComposeResultSaved:
            alertMessage = @"Your e-mail has been saved successfully";
            mailReportStatus = @"fail";
            break;
        case MFMailComposeResultSent:
            alertMessage = @"Your email has been sent successfully";
             mailReportStatus = @"success";
            break;
        case MFMailComposeResultFailed:
            alertMessage = @"Failed to send email";
            mailReportStatus = @"fail";
            break;
        default:
            alertMessage = @"Email Not Sent";
            mailReportStatus = @"fail";
            break;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Test Mail" message:alertMessage delegate:self cancelButtonTitle:@"OK"      otherButtonTitles:nil];
    alertView.tag = 202;
    [alertView show];
    [bottomNav removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0 ) {
        if(alertView.tag == 203){
            [self dismissModalViewControllerAnimated:YES];
        }
        else if(alertView.tag == 202)
        {
            if([mailReportStatus  isEqual: @"success"])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                for (NSInteger s = 0; s < tableview.numberOfSections; s++) {
                    for (NSInteger r = 0; r < [tableview numberOfRowsInSection:s]; r++) {
                        UITableViewCell *theSelectedCell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
                        if ( theSelectedCell.accessoryType == UITableViewCellAccessoryCheckmark ) {
                            theSelectedCell.accessoryType = UITableViewCellAccessoryNone;
                            NSString *selEmails = theSelectedCell.textLabel.text;
                            [selectedStates removeObject:selEmails];
                        }
                    }
                }
            }
        }
        else if(alertView.tag == 204)
        {
            [self dismissModalViewControllerAnimated:YES];
        }
        
    }
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
