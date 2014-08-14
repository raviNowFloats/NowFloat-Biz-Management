//
//  PreSignupViewController.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 8/12/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "PreSignupViewController.h"
#import "SuggestBusinessDomain.h"
#import "SignupFBController.h"
#import "BookDomainnController.h"
#import "RIATipsController.h"
#import "SignUpViewController.h"

BOOL *isFBSignup;
NSString *countryName;

NSString *userName;
NSString *BusinessName;
NSString *city;
NSString *phono;
NSString *emailID;
NSString *category;
NSString *country;
NSString *pinCode;
NSString *primaryImagURL;
NSString *pageDescription;
NSString *website;
NSString *fbPageName;
NSString *longtitude,*lattitude;
NSString *addressValue;

BOOL isAdded;
BOOL isForFBPageAdmin;
NSMutableArray *token_id;
NSMutableDictionary *page_det;

@interface PreSignupViewController ()

@end

@implementation PreSignupViewController
@synthesize facebookLogin;
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
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    facebookLogin.delegate = self;
    
    facebookLogin = [[FBLoginView alloc]initWithFrame:CGRectMake(10, 280, 300, 150)];
    facebookLogin.delegate = self;
    

    token_id = [[NSMutableArray alloc]init];
    page_det = [[NSMutableDictionary alloc]init];

        
    for (id obj in facebookLogin.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            
            UIImage *loginImage = [UIImage imageNamed:@"SignupV2-fb-asset.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            loginButton.frame = CGRectMake(0, 0, 269, 60);
                      
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 6, 200, 30);
            loginLabel.textColor = [UIColor clearColor];
            [loginLabel setFont:[UIFont systemFontOfSize:15]];
        }
    }
    
    
    [self.view addSubview:facebookLogin];
    
    UIImageView *temp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SignupV2-fb-asset.png"]];
    temp.frame = CGRectMake(10, 280, 300, 58);
    [self.view addSubview:temp];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    [FBRequestConnection startWithGraphPath:@"me/"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              
                              userName = [result objectForKey:@"name"];
                              emailID   = [result objectForKey:@"email"];
                              
                              
                          }];
    
    
    
    [FBRequestConnection startWithGraphPath:@"me/accounts"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              [self pageDetails:result];
                              
                              
                          }];
    
    if ([FBSession activeSession].isOpen)
    {
        [self connectAsFbPageAdmin];
    }
    
}

-(void)pageDetails:(NSMutableDictionary*)pages
{
    
    NSMutableArray *fbPage = [[NSMutableArray alloc]initWithObjects:[pages objectForKey:@"data"], nil];
    NSMutableArray *page_name = [[NSMutableArray alloc]init];
    
    token_id  =[[fbPage valueForKey:@"id"]objectAtIndex:0];
    page_name  =[[fbPage valueForKey:@"name"]objectAtIndex:0];
    
    
    
    UIActionSheet *actionSheet;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(int i=0; i <[page_name count]; i++)
    {
        
        
        [page_det setValue:[NSString stringWithFormat:@"%@",[token_id objectAtIndex:i]] forKey:[page_name objectAtIndex:i]];
        [array addObject:[page_name objectAtIndex:i]];
        
        
        
        
    }
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Your Business Page"
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    // ObjC Fast Enumeration
    for (NSString *title in array) {
        [actionSheet addButtonWithTitle:title];
    }
    
    if(!isAdded)
    {
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = [array count];
        [actionSheet showInView:self.view];
        isAdded = YES;
    }
    
    
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BusinessName = [actionSheet buttonTitleAtIndex:buttonIndex];
    category = @"General";
    
    NSString *token = [page_det objectForKey:[NSString stringWithFormat:@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]]];
    
    if(buttonIndex==[page_det count])
    {
        
    }
    else
    {
        
        NSArray *a1=[NSArray arrayWithObject:[appDelegate.fbUserAdminArray objectAtIndex:buttonIndex]];
        
        NSArray *a2=[NSArray arrayWithObject:[appDelegate.fbUserAdminAccessTokenArray objectAtIndex:buttonIndex]];
        
        NSArray *a3=[NSArray arrayWithObject:[appDelegate.fbUserAdminIdArray objectAtIndex:buttonIndex]];
        
        [appDelegate.socialNetworkNameArray addObjectsFromArray:a1];
        [appDelegate.socialNetworkAccessTokenArray addObjectsFromArray:a2];
        [appDelegate.socialNetworkIdArray addObjectsFromArray:a3];
        
        
        [userDefaults setObject:a1 forKey:@"FBUserPageAdminName"];
        [userDefaults setObject:a2 forKey:@"FBUserPageAdminAccessToken"];
        [userDefaults setObject:a3 forKey:@"FBUserPageAdminId"];
        
        [userDefaults synchronize];

        
        __block id pageDetails;
        
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/",token]
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  
                                  pageDetails = result;
                                  
                                  [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/photos",token]
                                                               parameters:nil
                                                               HTTPMethod:@"GET"
                                                        completionHandler:^(
                                                                            FBRequestConnection *connection,
                                                                            id result,
                                                                            NSError *error
                                                                            ) {
                                                            
                                [self FBsignup:pageDetails image:result];
                                                            
                                                        }];
                                  
                              }];
        
    }
    
    
    
}

-(void)FBsignup:(NSMutableDictionary*)details image:(NSMutableDictionary*)profileImage
{
    
    city = [[details objectForKey:@"location"]valueForKey:@"city"];
    pinCode = [[details objectForKey:@"location"]valueForKey:@"zip"];
    phono = [details objectForKey:@"phone"];
    country = [[details objectForKey:@"location"]valueForKey:@"country"];
    website = [details objectForKey:@"website"];
    addressValue = [[details objectForKey:@"location"]valueForKey:@"street"];
    longtitude = [[details objectForKey:@"location"]valueForKey:@"longitude"];
    lattitude  = [[details objectForKey:@"location"]valueForKey:@"latitude"];
    fbPageName = [details objectForKey:@"link"];
    
    
    if([[profileImage objectForKey:@"data"] count]==0)
    {
        primaryImagURL = @"";
    }
    else
    {
        primaryImagURL = [[[[[profileImage objectForKey:@"data"]valueForKey:@"images"]objectAtIndex:0]valueForKey:@"source"]objectAtIndex:0];
    }
    pageDescription = [details objectForKey:@"about"];
    
    if([city isEqualToString:@""] || city == nil)
    {
        city=@"";
    }
    if([phono isEqualToString:@""] || phono == nil)
    {
        phono = @"";
    }
    if([emailID isEqualToString:@""] || emailID == nil)
    {
        emailID =@"";
    }
    if([country isEqualToString:@""] || country == nil)
    {
        country = @"";
    }
    
    NSDictionary *uploadDictionary = [[NSDictionary alloc]init];
    
    if(![BusinessName isEqualToString:@""] && ![userName isEqualToString:@""] && ![phono isEqualToString:@""] && ![category isEqualToString:@""] && ![emailID isEqualToString:@""] && ![city isEqualToString:@""])
    {
        uploadDictionary=@{@"name":BusinessName,@"city":city,@"country":country,@"category":category,@"clientId":appDelegate.clientId};
        SuggestBusinessDomain *suggestController=[[SuggestBusinessDomain alloc]init];
        suggestController.delegate=self;
        [suggestController suggestBusinessDomainWith:uploadDictionary];
        suggestController =nil;
        isFBSignup = YES;
        
    }
    else
    {
        SignupFBController *fbsign = [[SignupFBController alloc]initWithNibName:@"SignupFBController" bundle:nil];
        fbsign.city = city;
        fbsign.emailID = emailID;
        fbsign.phono = phono;
        fbsign.country = country;
        fbsign.BusinessName=BusinessName;
        fbsign.category=category;
        fbsign.userName=userName;
        fbsign.primaryImageURL = primaryImagURL;
        fbsign.pageDescription = pageDescription;
        fbsign.fbPagename      = fbPageName;
        [self.navigationController pushViewController:fbsign animated:YES];
        
    }
    
}


-(void)suggestBusinessDomainDidComplete:(NSString *)suggestedDomainString
{
        BookDomainnController *domaincheck = [[BookDomainnController alloc]initWithNibName:@"BookDomainnController" bundle:nil];
        domaincheck.city = city;
        domaincheck.emailID =emailID;
        domaincheck.phono = phono;
        domaincheck.country = country;
        domaincheck.BusinessName=BusinessName;
        domaincheck.userName=userName;
        domaincheck.pincode = pinCode;
        domaincheck.suggestedURL = suggestedDomainString;
        domaincheck.category = category;
        domaincheck.latt = lattitude;
        domaincheck.longt = longtitude;
        domaincheck.primaryImageURL = primaryImagURL;
        domaincheck.pageDescription = pageDescription;
        domaincheck.fbpageName = fbPageName;
        addressValue = [addressValue stringByAppendingString:[NSString stringWithFormat:@",%@,%@",city,country]];
        domaincheck.addressValue = addressValue;
        [self.navigationController pushViewController:domaincheck animated:YES];
  
    
    if (suggestedDomainString.length==0)
    {
        UIAlertView *emptyAlertView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"We could not suggest a domain for you.Why dont you give it a try ?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        emptyAlertView.tag=102;
        [emptyAlertView show];
    }
    
    
     
}



- (void)openSession:(BOOL)isAdmin
{
    
    isForFBPageAdmin=isAdmin;
    
    NSString  *version = [[UIDevice currentDevice] systemVersion];
    
    if ([version floatValue]<7.0)
    {
        
        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
         {
             [self sessionStateChanged:session state:state error:error];
             
         }];
    }
    
    
    else
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_birthday",@"user_hometown",@"user_location",@"email",@"basic_info", nil];
        
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             [self sessionStateChanged:session state:status error:error];
         }];
    }
    
    
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    
    
    
    switch (state)
    {
        case FBSessionStateOpen:
        {
            NSArray *permissions =  [NSArray arrayWithObjects:@"publish_stream", @"manage_pages",@"publish_actions",nil];
            
            if ([FBSession.activeSession.permissions
                 indexOfObject:@"publish_actions"] == NSNotFound)
            {
                
                [[FBSession activeSession] requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
                 {
                     
                     if (isForFBPageAdmin)
                     {
                         [self connectAsFbPageAdmin];
                     }
                     
                     else
                     {
                         [self populateUserDetails];
                     }
                     
                     
                 }];
            }
            
            else
            {
                if (isForFBPageAdmin)
                {
                    [self connectAsFbPageAdmin];
                }
                
                else
                {
                    [self populateUserDetails];
                }
                
                
            }
            
        }
            
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
        default:
            break;
    }
}




-(void)populateUserDetails
{
    
    
    NSString * accessToken =  [[FBSession activeSession] accessTokenData].accessToken;
    
    [userDefaults setObject:accessToken forKey:@"NFManageFBAccessToken"];
    
    NSLog(@"accessToken:%@",accessToken);
    
    [userDefaults synchronize];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (!error)
         {
             [userDefaults setObject:[user objectForKey:@"id"] forKey:@"NFManageFBUserId"];
             [userDefaults setObject:[user objectForKey:@"name"] forKey:@"NFFacebookName"];
             [userDefaults synchronize];
             
             
         }
         
         
         else
             
         {
             UIAlertView *fbFailedAlert=[[UIAlertView alloc]initWithTitle:@"Oops" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
             
             [fbFailedAlert show];
             
             fbFailedAlert=nil;
         }
     }
     ];
    
    
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
}



-(void)connectAsFbPageAdmin
{
    [[FBRequest requestForGraphPath:@"me/accounts"]
     startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (!error)
         {
             if ([[user objectForKey:@"data"] count]>0)
             {
                 [appDelegate.socialNetworkNameArray removeAllObjects];
                 [appDelegate.fbUserAdminArray removeAllObjects];
                 [appDelegate.fbUserAdminIdArray removeAllObjects];
                 [appDelegate.fbUserAdminAccessTokenArray removeAllObjects];
                 
                 NSMutableArray *userAdminInfo=[[NSMutableArray alloc]init];
                 
                 [userAdminInfo addObjectsFromArray:[user objectForKey:@"data"]];
                 
                 [self assignFbDetails:[user objectForKey:@"data"]];
                 
                 for (int i=0; i<[userAdminInfo count]; i++)
                 {
                     [appDelegate.fbUserAdminArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"name" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminAccessTokenArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"access_token" ] atIndex:i];
                     
                     [appDelegate.fbUserAdminIdArray insertObject:[[userAdminInfo objectAtIndex:i]objectForKey:@"id" ] atIndex:i];
                 }
                 
             }
             
             else
             {
                 UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"You do not have pages to manage" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 
                 [alerView show];
                 
                 alerView=nil;
                 
                 [FBSession.activeSession closeAndClearTokenInformation];
                 
                 
             }
         }
         else
         {
             [self openSession:YES];
         }
     }
     ];
    
    [self populateUserDetails];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                    NSLog(@"error in resync:%@",[error localizedDescription]);
                }
            }];
        }
        
        
    }
}


-(void)assignFbDetails:(NSArray*)sender
{
    
    [userDefaults setObject:sender forKey:@"NFManageUserFBAdminDetails"];
    
    [userDefaults synchronize];
    
}



#pragma mark - FBLoginView delegate




- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    if (error.fberrorShouldNotifyUser)
    {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    }
    
    else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
    {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    
    else if (error.fberrorCategory == FBErrorCategoryUserCancelled)
    {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    }
    
    else
    {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
}


- (IBAction)mailRegisteration:(id)sender {
    
    SignUpViewController *ria = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    
    [self presentViewController:ria animated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
