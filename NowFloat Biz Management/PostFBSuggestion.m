//
//  PostFBSuggestion.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 7/1/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "PostFBSuggestion.h"
#import "UIColor+HexaString.h"
#import "PostFBCell.h"
#import "PostToFBSuggestion.h"
#import "FBImageOpen.h"
#import "CreatePictureDeal.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PostFBSuggestion ()<pictureDealDelegate>
{
    
    float viewHeight;
    
    UIBarButtonItem *navButton;
    
    UINavigationItem *navItem;
    UINavigationBar *navBar;
    UILabel *headLabel;
    UIButton *leftCustomButton, *rightCustomButton;
    NSString *version;
    NSMutableArray *fbb;
    NSMutableArray *fbb1,*message,*picture,*postid;
    
    NSIndexPath *deleteIndex;
    CGPoint locate ;
    NSIndexPath *index;
    FBImageOpen *Image;
    NSMutableArray *storeDeletedPost;
    NSMutableDictionary *feedDict;
    
    
}
@property(nonatomic,strong)FBImageOpen *Image;
@end

@implementation PostFBSuggestion
@synthesize FBpostTable,Image;

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
    msgData = [[NSMutableData alloc]init];
    
    message = [[NSMutableArray alloc]init];
    picture = [[NSMutableArray alloc]init];
    postid = [[NSMutableArray alloc]init];
    deleteIndex = [[NSIndexPath alloc]init];
    storeDeletedPost = [[NSMutableArray alloc]init];
    feedDict = [[NSMutableDictionary alloc]init];
    
    [super viewDidLoad];
    
    Image=[[FBImageOpen alloc]init];
    // Do any additional setup after loading the view from its nib.
    
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
    
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    [self LoadFeed];
}

-(void)LoadFeed
{
    NSMutableDictionary *fbFeed = [[NSMutableDictionary alloc]init];
    
    fbFeed = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[appdelegate.feedFacebook objectForKey:@"data"] valueForKey:@"message"],@"Message",[[appdelegate.feedFacebook objectForKey:@"data"] valueForKey:@"picture"],@"Picture",[[appdelegate.feedFacebook objectForKey:@"data"] valueForKey:@"id"],@"postid", nil];
    
    
    
    
    NSMutableArray *feedArray = [[NSMutableArray alloc]init];
    
    
    
    
    for(int i = 0 ; i < [[fbFeed objectForKey:@"Message"]count] ; i ++)
    {
        
        
        [feedArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[fbFeed objectForKey:@"Message"]objectAtIndex:i],@"message",[[fbFeed objectForKey:@"Picture"]objectAtIndex:i],@"Pic",[[fbFeed objectForKey:@"postid"]objectAtIndex:i],@"post", nil]];
        
        [feedDict setValue:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"Feed%d",i]];
        
        
    }
    
    
    NSMutableArray *archivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"FEED10"]] ;
    
    
    for(int i =0; i < [feedArray count]; i++)
    {
        for(int j =0 ; j < [archivedArray count]; j ++)
        {
            NSString *feed = [[feedArray valueForKey:@"post"]objectAtIndex:i];
            
            NSString *feed1 = [archivedArray objectAtIndex:j];
            
            if([feed isEqualToString:feed1])
            {
                [feedDict removeObjectForKey:[NSString stringWithFormat:@"Feed%d",i]];
            }
            
            
        }
    }
    
    
    int feedNo = 0;
    
    for (NSDictionary *contacts in feedArray)
    {
        
        
        
        if([feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]] !=NULL)
        {
            
            [[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]] addObject:contacts];
            
            [message addObject:[[[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]]valueForKey:@"message"] objectAtIndex:0]];
            
            
            [picture addObject:[[[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]]valueForKey:@"Pic"] objectAtIndex:0]];
            
            
            [postid addObject:[[[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]]valueForKey:@"post"] objectAtIndex:0]];
            
            
            
        }
        else
        {
            
        }
        
        if(feedNo==4)
        {
            break;
        }
        
        if(feedNo< [feedArray count])
        {
            feedNo++;
        }
    }
    
    [FBpostTable reloadData];
}

-(void)cancelView
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    
    [msgData appendData:data1];
    
}

-(void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert= [[UIAlertView alloc] initWithTitle: [error localizedDescription] message: [error localizedFailureReason] delegate:nil                  cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [errorAlert show];
    
    NSLog (@"Connection Failed in getting GETBIZFLOAT :%@",[error localizedFailureReason]);
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error;
    NSMutableDictionary* json = [NSJSONSerialization
                                 JSONObjectWithData:msgData //1
                                 options:kNilOptions
                                 error:&error];
    
    
    
    
    NSMutableArray *fbPage = [[NSMutableArray alloc]initWithObjects:[json objectForKey:@"data"], nil];
    
    
    NSArray *token_id = [[NSArray alloc]initWithArray:[fbPage valueForKey:@"id"]];
    
    
    NSArray *temp = [[NSArray alloc]initWithArray:[token_id objectAtIndex:0]];
    
    
    NSString *token =[NSString stringWithFormat:@"/%@",[temp objectAtIndex:0]];
    
    if(![token isEqualToString:@""])
    {
        PostToFBSuggestion *post = [[PostToFBSuggestion alloc]init];
        post.delegate = self;
        [post getLatestFeedFB:token];
    }
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int j = 0;
    for(int i = 0; i < [message count]; i++)
    {
        NSString *data2 = [message objectAtIndex:i];
        NSString *data3 = [picture objectAtIndex:i];
        if([data2 isEqual: [NSNull null]])
        {
            if([data3 isEqual: [NSNull null]])
            {
                j++;
            }
            
        }
    }
    
    return [message count] -j;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostFBCell *cell =[tableView dequeueReusableCellWithIdentifier:@"postfb"];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostFBCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSString *mess_str = [message objectAtIndex:indexPath.row];
    
    NSString *pic_str = [picture objectAtIndex:indexPath.row];
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteIndex:)];
    
    
    [cell.dismiss addGestureRecognizer:tap];
    
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired =1;
    
    UITapGestureRecognizer *post = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postBoost:)];
    
    
    [cell.post addGestureRecognizer:post];
    
    post.numberOfTapsRequired = 1;
    post.numberOfTouchesRequired =1;
    
    
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImage:)];
    tapImage.numberOfTapsRequired =1;
    tapImage.numberOfTouchesRequired=1;
    
    cell.imagePost.userInteractionEnabled=YES;
    [cell.imagePost addGestureRecognizer:tapImage];
    
    
    if([mess_str isEqual: [NSNull null]])
    {
        cell.messgaeLabel.text = @"";
        
        if([pic_str isEqual: [NSNull null]])
        {
            cell.imagePost.image = NULL;
        }
        else
        {
            pic_str = [pic_str stringByReplacingOccurrencesOfString:@"s130x130"
                                                         withString:@"n130x130"];
            
            pic_str = [pic_str stringByReplacingOccurrencesOfString:@"_s"
                                                         withString:@"_n"];
            
            pic_str = [pic_str stringByReplacingOccurrencesOfString:@"p100x100"
                                                         withString:@"n100x100"];
            
            
            
            UIImage *tmpImage =nil;
            
            [cell.imagePost setImageWithURL:[NSURL URLWithString:pic_str]
                           placeholderImage:tmpImage];
            
            
            
        }
        
    }
    else
    {
        cell.messgaeLabel.text = mess_str;
        if([pic_str isEqual: [NSNull null]])
        {
            cell.imagePost.image = NULL;
            
        }
        else
        {
            pic_str = [pic_str stringByReplacingOccurrencesOfString:@"s130x130"
                                                         withString:@"n130x130"];
            
            pic_str = [pic_str stringByReplacingOccurrencesOfString:@"_s"
                                                         withString:@"_n"];
            
            pic_str = [pic_str stringByReplacingOccurrencesOfString:@"p100x100"
                                                         withString:@"n100x100"];
            
            
            
            UIImage *tmpImage =nil;
            
            [cell.imagePost setImageWithURL:[NSURL URLWithString:pic_str]
                           placeholderImage:tmpImage];
            
            
            
        }
        
    }
    
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteIndex = indexPath;
    
}

//-(void)posttoFBSuggestion:(NSMutableDictionary *)fb;
//{
//
//    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    NSMutableDictionary *fbFeed = [[NSMutableDictionary alloc]init];
//
//    fbFeed = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[fb objectForKey:@"data"] valueForKey:@"message"],@"Message",[[fb objectForKey:@"data"] valueForKey:@"picture"],@"Picture",[[fb objectForKey:@"data"] valueForKey:@"id"],@"postid", nil];
//
//
//
//
//    NSMutableArray *feedArray = [[NSMutableArray alloc]init];
//
//
//
//
//    for(int i = 0 ; i < [[fbFeed objectForKey:@"Message"]count] ; i ++)
//    {
//
//
//[feedArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[fbFeed objectForKey:@"Message"]objectAtIndex:i],@"message",[[fbFeed objectForKey:@"Picture"]objectAtIndex:i],@"Pic",[[fbFeed objectForKey:@"postid"]objectAtIndex:i],@"post", nil]];
//
//        [feedDict setValue:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"Feed%d",i]];
//
//
//
//    }
//
//
//NSMutableArray *archivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"FEED10"]] ;
//
//
//    for(int i =0; i < [feedArray count]; i++)
//    {
//        for(int j =0 ; j < [archivedArray count]; j ++)
//        {
//            NSString *feed = [[feedArray valueForKey:@"post"]objectAtIndex:i];
//
//            NSString *feed1 = [archivedArray objectAtIndex:j];
//
//        if([feed isEqualToString:feed1])
//            {
//                [feedDict removeObjectForKey:[NSString stringWithFormat:@"Feed%d",i]];
//            }
//
//
//        }
//    }
//
//
//     int feedNo = 0;
//
//    for (NSDictionary *contacts in feedArray)
//    {
//
//
//
//       if([feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]] !=NULL)
//       {
//
//         [[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]] addObject:contacts];
//
//      [message addObject:[[[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]]valueForKey:@"message"] objectAtIndex:0]];
//
//
//        [picture addObject:[[[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]]valueForKey:@"Pic"] objectAtIndex:0]];
//
//
//        [postid addObject:[[[feedDict objectForKey:[NSString stringWithFormat:@"Feed%d",feedNo]]valueForKey:@"post"] objectAtIndex:0]];
//
//       }
//        else
//        {
//
//        }
//
//        if(feedNo==4)
//        {
//            break;
//        }
//
//        if(feedNo< [feedArray count])
//        {
//            feedNo++;
//        }
//    }
//
//
//
//    [FBpostTable reloadData];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)postBoost:(UITapGestureRecognizer *)sender
{
    
    
    
    locate  =   [sender locationInView:self.FBpostTable];
    index=   [self.FBpostTable indexPathForRowAtPoint:locate];
    
    
    int selectedPosition    =   (int)index.row;
    
    NSString *post = [message objectAtIndex:selectedPosition];
    
    NSString *pict = [picture objectAtIndex:selectedPosition];
    
    pict = [pict stringByReplacingOccurrencesOfString:@"s130x130"
                                           withString:@"n130x130"];
    
    pict = [pict stringByReplacingOccurrencesOfString:@"_s"
                                           withString:@"_n"];
    
    pict = [pict stringByReplacingOccurrencesOfString:@"p100x100"
                                           withString:@"n100x100"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",pict]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];

    
   
    
    CreatePictureDeal *postBoost = [[CreatePictureDeal alloc]init];
    postBoost.dealUploadDelegate = self;
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           post,@"message",
                                           [NSNumber numberWithBool:0],@"sendToSubscribers",
                                           [appdelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",
                                           appdelegate.clientId,@"clientId",tmpImage,@"pictureMessage",nil];
    
    postBoost.offerDetailDictionary=[[NSMutableDictionary alloc]init];
    
    [postBoost createDeal:uploadDictionary postToTwitter:NO postToFB:NO postToFbPage:NO];
    
    [storeDeletedPost addObject:[postid objectAtIndex:selectedPosition]];
    
    //    [message removeObjectAtIndex:selectedPosition];
    //    [picture removeObjectAtIndex:selectedPosition];
    //    [postid removeObjectAtIndex:selectedPosition];
    
    
    
    
    NSMutableArray *deletedPost = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"FEED10"]] ;
    
    if(deletedPost !=NULL)
    {
        for(int i=0; i < [deletedPost count];i++)
        {
            [storeDeletedPost addObject:[deletedPost objectAtIndex:i]];
        }
        
        
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:storeDeletedPost] forKey:@"FEED10"];
    
    [FBpostTable reloadData];
    
}

-(void)updateMessageSucceed
{
    
    int selectedPosition    =   (int)index.row;
    
    [message removeObjectAtIndex:selectedPosition];
    [picture removeObjectAtIndex:selectedPosition];
    [postid removeObjectAtIndex:selectedPosition];
    [FBpostTable reloadData];
    
    
}

-(void)openImage:(UITapGestureRecognizer *)sender
{
    
    
    
    locate  =   [sender locationInView:self.FBpostTable];
    index=   [self.FBpostTable indexPathForRowAtPoint:locate];
    
    
    int selectedPosition    =   (int)index.row;
    
    if([[picture objectAtIndex:selectedPosition]isEqual: [NSNull null]])
    {
        
    }
    else
    {
        Image=[[FBImageOpen alloc]init];
        Image.ImageUrl =[picture objectAtIndex:selectedPosition];
        Image.view.frame = CGRectMake(0, 0, 320, 640);
        Image.view.userInteractionEnabled = YES;
        [self.view addSubview:Image.view];
        
    }
    
    
}

@end
