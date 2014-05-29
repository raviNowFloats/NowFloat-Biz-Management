//
//  LatestVisitorDetails.m
//  NowFloats Biz Management
//
//  Created by jitu keshri on 5/13/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "LatestVisitorDetails.h"

@interface LatestVisitorDetails ()

@end

@implementation LatestVisitorDetails

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
    
    @try
    {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        msgData=[[NSMutableData alloc]init];
        
        visitorCount=[[NSString alloc]init];
        
        NSString  *visitorCountUrlString=[NSString stringWithFormat:@"%@/%@/visitorCount?clientId=%@",appDelegate.apiWithFloatsUri,[appDelegate.storeDetailDictionary objectForKey:@"Tag"],appDelegate.clientId];
        
        NSURL *visitorCountUrl=[NSURL URLWithString:visitorCountUrlString];
        
        NSMutableURLRequest *getFloatDetailsRequest = [NSMutableURLRequest requestWithURL:visitorCountUrl];
        
        NSURLConnection *theConnection;
        
        theConnection =[[NSURLConnection alloc] initWithRequest:getFloatDetailsRequest delegate:self];
    }
    
    @catch (NSException *e) {
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
