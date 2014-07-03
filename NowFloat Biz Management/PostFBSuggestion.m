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
#import "CreateStoreDeal.h"
@interface PostFBSuggestion ()
{
   
    float viewHeight;
 
    UIBarButtonItem *navButton;
   
    UINavigationItem *navItem;
    UINavigationBar *navBar;
    UILabel *headLabel;
    UIButton *leftCustomButton, *rightCustomButton;
    NSString *version;
    NSMutableArray *fbb;
    NSMutableArray *fbb1,*dummy,*dummy1,*dummy2;
    
    NSIndexPath *deleteIndex;
    CGPoint locate ;
    NSIndexPath *index;
    FBImageOpen *Image;
    NSMutableArray *array1;
    NSMutableDictionary *contactsArray1;
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
    
    dummy = [[NSMutableArray alloc]init];
    dummy1 = [[NSMutableArray alloc]init];
    dummy2 = [[NSMutableArray alloc]init];
    deleteIndex = [[NSIndexPath alloc]init];
    array1 = [[NSMutableArray alloc]init];
    contactsArray1 = [[NSMutableDictionary alloc]init];
    
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
    
    
    
    msgData=[[NSMutableData alloc]init];
   
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString  *urlString=[NSString stringWithFormat:@"https://graph.facebook.com/%@/accounts?access_token=%@",[userDefaults objectForKey:@"NFManageFBUserId"],[userDefaults objectForKey:@"NFManageFBAccessToken"]];
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    
    
    
    NSURLConnection *theConnection;
    
    theConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    for(int i = 0; i < [dummy count]; i++)
    {
         NSString *data2 = [dummy objectAtIndex:i];
         NSString *data3 = [dummy1 objectAtIndex:i];
        if([data2 isEqual: [NSNull null]])
        {
            if([data3 isEqual: [NSNull null]])
            {
              j++;
            }
            
        }
    }
    
    return [dummy count] -j;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostFBCell *cell =[tableView dequeueReusableCellWithIdentifier:@"postfb"];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostFBCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSString *data2 = [dummy objectAtIndex:indexPath.row];
    
    NSString *data3 = [dummy1 objectAtIndex:indexPath.row];
    
    
    
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
    
    
    if([data2 isEqual: [NSNull null]])
    {
        cell.messgaeLabel.text = @"";
    
        if([data3 isEqual: [NSNull null]])
        {
            cell.imagePost.image = NULL;
        }
        else
        {
            data3 = [data3 stringByReplacingOccurrencesOfString:@"s130x130"
                                                     withString:@"n130x130"];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data3]];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
            
            cell.imagePost.image = tmpImage;
            
            
            
        }

    }
    else
    {
        cell.messgaeLabel.text = data2;
         if([data3 isEqual: [NSNull null]])
         {
             cell.imagePost.image = NULL;
             
         }
        else
        {
            data3 = [data3 stringByReplacingOccurrencesOfString:@"s130x130"
                                                     withString:@"n130x130"];
            
            data3 = [data3 stringByReplacingOccurrencesOfString:@"_s"
                                                     withString:@"_n"];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data3]];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
            
            cell.imagePost.image = tmpImage;
            
            
            
        }
     
    }
    
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteIndex = indexPath;
    
}

-(void)posttoFBSuggestion:(NSMutableDictionary *)fb;
{
    
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [appdelegate.feedFacebook addEntriesFromDictionary:fb];
    
    NSMutableArray *fb1 = [[NSMutableArray alloc]initWithObjects:[appdelegate.feedFacebook objectForKey:@"data"], nil];
    
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc]init];
    
    
    NSMutableDictionary *final = [[NSMutableDictionary alloc]init];
    
    
    
    data1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[fb1 valueForKey:@"message"],@"Message",[fb1 valueForKey:@"picture"],@"Picture",[fb1 valueForKey:@"id"],@"postid", nil];
    
    
    int hhh = [[[data1 objectForKey:@"Message"]objectAtIndex:0]count];
    
    NSMutableArray *contactsArray = [[NSMutableArray alloc]init];
    
     NSString *post1;
    
    
    for(int i = 0 ; i < hhh ; i ++)
    {
        NSString *msg1 = [[[data1 objectForKey:@"Message"]objectAtIndex:0]objectAtIndex:i];
        NSString *pic1 = [[[data1 objectForKey:@"Picture"]objectAtIndex:0]objectAtIndex:i];
       
        post1 = [[[data1 objectForKey:@"postid"]objectAtIndex:0]objectAtIndex:i];
        
        final = [NSMutableDictionary dictionaryWithObjectsAndKeys:msg1,@"message",pic1,@"Pic",post1,@"post", nil];
        

        
        [contactsArray addObject:final];
        
        [contactsArray1 setValue:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"%@",post1]];
        
        
        
        
    }

   
    
    
    
    for (NSDictionary *contacts in contactsArray)
    {
        
        NSString *post = [contacts objectForKey:@"post"];
        
       [[contactsArray1 objectForKey:[NSString stringWithFormat:@"%@",post]] addObject:contacts];
        
        
        
    }
    
    
    
//NSArray *dattt =  [[contactsArray1 allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    
    
    
    

    
NSMutableArray *archivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"annotationKey1"]] ;
    
    
    for(int i =0; i < [[contactsArray valueForKey:@"post"]count]; i++)
    {
        for(int j =0 ; j < [archivedArray count]; j ++)
        {
        if([[[contactsArray valueForKey:@"post"]objectAtIndex:i] isEqualToString:[archivedArray objectAtIndex:j]])
            {
                [contactsArray1 removeObjectForKey:[[contactsArray valueForKey:@"post"]objectAtIndex:i]];
            }
            
           
        }
    }
    
  
    
    
        
        
    

    
    
    
       NSLog(@"----?%@",contactsArray1);
    
    NSMutableArray *fbb2 = [[NSMutableArray alloc]init];;
    

   
    
    
    fbb = [[NSMutableArray alloc]initWithObjects:[data1 objectForKey:@"Message"], nil];
    
    fbb1 = [[NSMutableArray alloc]initWithObjects:[data1 objectForKey:@"Picture"], nil];
    
    fbb2 = [[NSMutableArray alloc]initWithObjects:[data1 objectForKey:@"postid"], nil];
    
  
  
    
    for(int i = 0; i < [[[fbb objectAtIndex:0]objectAtIndex:0]count];i++)
    {
        
//           NSMutableArray *archivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"annotationKey1"]] ;
//        
//        NSLog(@"user default : %@",archivedArray);
//        
//        NSString *str = [[[fbb2 objectAtIndex:0] objectAtIndex:0] objectAtIndex:i];
//        
//        NSString *str1  = [archivedArray objectAtIndex:i];
//        
//        if([str1 isEqualToString:str])
//        {
//            
//        }
//        else
//        {
        
        [dummy2 addObject:[[[fbb2 objectAtIndex:0] objectAtIndex:0] objectAtIndex:i]];
        
        [dummy addObject:[[[fbb objectAtIndex:0] objectAtIndex:0] objectAtIndex:i]];
        NSString *imgURL =[[[fbb1 objectAtIndex:0] objectAtIndex:0] objectAtIndex:i];
        
        if([imgURL isEqual: [NSNull null]])
        {
                        
        }
        else
        {
            imgURL = [imgURL stringByReplacingOccurrencesOfString:@"s130x130"
                                                       withString:@"n130x130"];
            
            imgURL = [imgURL stringByReplacingOccurrencesOfString:@"_s"
                                                       withString:@"_n"];
            
        }
        
        
         [dummy1 addObject:imgURL];
       // }
    }
    
    
    NSLog(@"array : %@",dummy);
    
    [FBpostTable reloadData];
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if([self setHieght])
//    {
//        return 80;
//    }
//    else
//    {
//        return 200;
//    }
// 
//}


-(BOOL)setHieght
{
    for(int i = 0; i < [dummy1 count]; i++)
    {
        NSString *data2 = [dummy1 objectAtIndex:i];
        if([data2 isEqual: [NSNull null]])
        {
            return TRUE;
        }
        else
        {
            return false;
        }
    }

    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deleteIndex:(UITapGestureRecognizer *)sender
{
    
   
            locate  =   [sender locationInView:self.FBpostTable];
            index=   [self.FBpostTable indexPathForRowAtPoint:locate];
    
        
        int selectedPosition    =   (int)index.row;
    
    [dummy removeObjectAtIndex:selectedPosition];
    [dummy1 removeObjectAtIndex:selectedPosition];
    [dummy2 removeObjectAtIndex:selectedPosition];
    
    NSMutableArray *array = [dummy2 objectAtIndex:selectedPosition];
    
    
    
    [array1 addObject:array];
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:array1] forKey:@"annotationKey1"];
    
    [FBpostTable reloadData];
    
}

-(void)postBoost:(UITapGestureRecognizer *)sender
{
    
    
    
    locate  =   [sender locationInView:self.FBpostTable];
    index=   [self.FBpostTable indexPathForRowAtPoint:locate];
    
    
    int selectedPosition    =   (int)index.row;
    
    NSString *post = [dummy objectAtIndex:selectedPosition];
    
    CreateStoreDeal *postBoost = [[CreateStoreDeal alloc]init];
    postBoost.delegate = self;
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *uploadDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           post,@"message",
                                           [NSNumber numberWithBool:0],@"sendToSubscribers",
                                           [appdelegate.storeDetailDictionary  objectForKey:@"_id"],@"merchantId",
                                           appdelegate.clientId,@"clientId",nil];
    
    postBoost.offerDetailDictionary=[[NSMutableDictionary alloc]init];
    
    [postBoost createDeal:uploadDictionary isFbShare:NO isFbPageShare:NO isTwitterShare:NO];
    
}

-(void)updateMessageSucceed
{
    
    int selectedPosition    =   (int)index.row;
    
    [dummy removeObjectAtIndex:selectedPosition];
    [dummy1 removeObjectAtIndex:selectedPosition];
    
    
    [FBpostTable reloadData];


}

-(void)openImage:(UITapGestureRecognizer *)sender
{
    
    
    
    locate  =   [sender locationInView:self.FBpostTable];
    index=   [self.FBpostTable indexPathForRowAtPoint:locate];
    
    
    int selectedPosition    =   (int)index.row;
    
    if([[dummy1 objectAtIndex:selectedPosition]isEqual: [NSNull null]])
    {
        
    }
    else
    {
        Image=[[FBImageOpen alloc]init];
        Image.ImageUrl =[dummy1 objectAtIndex:selectedPosition];
        Image.view.frame = CGRectMake(0, 0, 320, 640);
        Image.view.userInteractionEnabled = YES;
        [self.view addSubview:Image.view];
        
    }
    
    
}

@end
