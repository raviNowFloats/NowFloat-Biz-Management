//
//  HomeFbFeed.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/4/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "HomeFbFeed.h"
#import "UIColor+HexaString.h"
#import "PostToFBSuggestion.h"
#import "PostFBSuggestion.h"



@interface HomeFbFeed ()
{
    float viewHeight;
    
    UIBarButtonItem *navButton;
    
    UINavigationItem *navItem;
    UINavigationBar *navBar;
    UILabel *headLabel;
    UIButton *leftCustomButton, *rightCustomButton;
    NSString *version;
    AppDelegate *appDelegate;
    
    FBLoginView *fblogin;
    NSMutableArray *token_id;
    NSMutableDictionary *page_det;
    UIButton *overView;
    BOOL isAdded;
    
}
@end

@implementation HomeFbFeed

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
    
    page_det = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
    version = [[UIDevice currentDevice] systemVersion];
    
    token_id = [[NSMutableArray alloc]init];
    
    isAdded = NO;
    
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
        
        
        
        
        headLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 13, 140, 20)];
        
        headLabel.text=@"Suggested Updates";
        
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
        
        [leftCustomButton setTitle:@"Back" forState:UIControlStateNormal];
        
        rightCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightCustomButton setFrame:CGRectMake(250,7,56,28)];
        
        [rightCustomButton setTitle:@"Invite" forState:UIControlStateNormal];
        
        [rightCustomButton addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:rightCustomButton];
        
        [rightCustomButton setHidden:YES];
        
        
    }
    else{
        
        // self.navigationController.navigationBarHidden=YES;
        
        CGFloat width = self.view.frame.size.width;
        
        navBar = [[UINavigationBar alloc] initWithFrame:
                  CGRectMake(0,0,width,44)];
        
        [self.view addSubview:navBar];
        
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Suggested Updates";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        leftCustomButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftCustomButton setFrame:CGRectMake(5,9,32,26)];
        
        [leftCustomButton setImage:[UIImage imageNamed:@"back-btn.png"] forState:UIControlStateNormal];
        
        [leftCustomButton addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
        
        [navBar addSubview:leftCustomButton];
        
        [leftCustomButton setTitle:@"Back" forState:UIControlStateNormal];
        
    }
    
    //    msgData=[[NSMutableData alloc]init];
    //
    //
    //    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //
    //    NSString  *urlString=[NSString stringWithFormat:@"https://graph.facebook.com/%@/accounts?access_token=%@",[userDefaults objectForKey:@"NFManageFBUserId"],[userDefaults objectForKey:@"NFManageFBAccessToken"]];
    //
    //
    //
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //
    //
    //    [request setURL:[NSURL URLWithString:urlString]];
    //    [request setHTTPMethod:@"GET"];
    //
    //
    //
    //
    //    NSURLConnection *theConnection;
    //
    //    theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    fblogin = [[FBLoginView alloc]initWithFrame:CGRectMake(20, 200, 280, 60)];
    
    fblogin.delegate = self;
    
    [self.view addSubview:fblogin];
    
    
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    NSString * accessToken =  [[FBSession activeSession] accessTokenData].accessToken;
    
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
    
    
    
    
    
}



-(void)cancelView
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
//{
//
//    [msgData appendData:data1];
//
//}
//
//-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
//{
//    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
//    [errorAlert show];
//
//    NSLog (@"Connection Failed in getting GETBIZFLOAT :%@",[error localizedFailureReason]);
//
//}


//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//
//    NSError *error;
//    NSMutableDictionary* json = [NSJSONSerialization
//                                 JSONObjectWithData:msgData //1
//                                 options:kNilOptions
//                                 error:&error];
//
//
//
//
//    NSMutableArray *fbPage = [[NSMutableArray alloc]initWithObjects:[json objectForKey:@"data"], nil];
//
//
//    NSArray *token_id = [[NSArray alloc]initWithArray:[fbPage valueForKey:@"id"]];
//
//
//    NSArray *temp = [[NSArray alloc]initWithArray:[token_id objectAtIndex:0]];
//
//
//    NSString *token =[NSString stringWithFormat:@"/%@",[temp objectAtIndex:0]];
//
//    if(![token isEqualToString:@""])
//    {
//        PostToFBSuggestion *post = [[PostToFBSuggestion alloc]init];
//        post.delegate = self;
//        [post getLatestFeedFB:token];
//    }
//
//}
//
//
//- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//
//    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//
//
//
//}


-(void)pageDetails:(NSMutableDictionary*)pages
{
    
    NSMutableArray *fbPage = [[NSMutableArray alloc]initWithObjects:[pages objectForKey:@"data"], nil];
    NSMutableArray *page_name = [[NSMutableArray alloc]init];
    
    token_id  =[[fbPage valueForKey:@"id"]objectAtIndex:0];
    page_name  =[[fbPage valueForKey:@"name"]objectAtIndex:0];
    
    
    
    UIActionSheet *actionSheet;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(int i=0; i <[token_id count]; i++)
    {
        
        
        [page_det setValue:[NSString stringWithFormat:@"%@",[token_id objectAtIndex:i]] forKey:[page_name objectAtIndex:i]];
        [array addObject:[page_name objectAtIndex:i]];
        
        [fblogin removeFromSuperview];
        
        
    }
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Your Page"
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
    
    
    NSString *token = [page_det objectForKey:[NSString stringWithFormat:@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]]];
    
    
    
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed",token]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              
                              [self posttoFB:result];
                          }];
    
    
}



-(void)posttoFB:(NSMutableDictionary *)fb;
{
    
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate.feedFacebook addEntriesFromDictionary:fb];
    
    NSMutableDictionary *dict = [fb objectForKey:@"data"];
    
    NSString *message = [[dict valueForKey:@"message"]objectAtIndex:0];
    NSString *pict = [[dict valueForKey:@"picture"]objectAtIndex:0];
    
    UIView *overView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 50, 300, 200)];
    
    overView1.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:overView1];
    
    UILabel *message_lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 60)];
    message_lab.numberOfLines = 3;
    
    message_lab.backgroundColor = [UIColor clearColor];
    message_lab.text = message;
    message_lab.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    [overView1 addSubview:message_lab];
    
    if([pict isEqual: [NSNull null]])
    {
        
        
    }
    else
    {
        
        pict = [pict stringByReplacingOccurrencesOfString:@"s130x130"
                                               withString:@"n130x130"];
        
        pict = [pict stringByReplacingOccurrencesOfString:@"_s"
                                               withString:@"_n"];
        
        pict = [pict stringByReplacingOccurrencesOfString:@"p100x100"
                                               withString:@"n100x100"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",pict]];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        
        UIImage *tmpImage = [[UIImage alloc] initWithData:data];
        
        UIImageView *picture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 280, 80)];
        
        picture.image = tmpImage;
        picture.contentMode = UIViewContentModeScaleAspectFill;
        
        picture.clipsToBounds = YES;
        
        [overView1 addSubview:picture];
    }
    
    UIButton * seeMore = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 280, 40)];
    
    [seeMore setTitle:@"See More" forState:UIControlStateNormal];
    
    seeMore.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:seeMore];
    
    [seeMore addTarget:self action:@selector(seeMorePage:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (IBAction)seeMorePage:(id)sender {
    
    PostFBSuggestion *webViewController=[[PostFBSuggestion alloc]initWithNibName:@"PostFBSuggestion" bundle:nil];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:webViewController animated:NO completion:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
