//
//  ImageGallery.m
//  NowFloats Biz Management
//
//  Created by Ravindra Naik on 11/08/14.
//  Copyright (c) 2014 NowFloats Technologies. All rights reserved.
//

#import "ImageGallery.h"
#import "Mixpanel.h"
#import "SWRevealViewController.h"
#import "DownloadControl.h"
#import "AsyncDowloadImages.h"

@interface ImageGallery ()<SWRevealViewControllerDelegate,DownloadDelegate,AsyncDownloadDelegate>
{
     double viewHeight;
    
     Mixpanel *mixPanel;
    
    UIImageView *scrollImage;
    
    UIView *detailViewImage;
    
    UINavigationBar *bottomNav, *topNav;
    
    UINavigationItem *navItem, *topNavItem;
    
     UIScrollView *detailImageView;
    
    UIButton *backButton;
    
    UIBarButtonItem *leftNav, *rightNav, *deleteImage, *backNav;
    
}

@end

@implementation ImageGallery

@synthesize imageList,scrollGallery,myScrollImage;


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
    
    version=[UIDevice currentDevice].systemVersion;
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    mixPanel=[Mixpanel sharedInstance];
    
    mixPanel.showNotificationOnActive = NO;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    if (version.floatValue<7.0)
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Image Gallery";
        
        bottomNav.barStyle = UIBarStyleDefault;
        topNav.barStyle = UIBarStyleDefault;
        if(viewHeight == 480)
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,420, self.view.frame.size.width, 44.0)];
        }
        else
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,self.view.frame.size.height+44, self.view.frame.size.width, 44.0)];
        }
        
    }
    
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
        self.navigationItem.title=@"Image Gallery";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"ffb900"];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationController.navigationBar.translucent = NO;
        
        if(viewHeight == 480)
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,420, self.view.frame.size.width, 44.0)];
        }
        else
        {
            bottomNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 454, self.view.frame.size.width + 2, 50.0)];
            
        }
        bottomNav.barTintColor = [UIColor colorWithRed:255/255.0f green:185/255.0f blue:0/255.0f alpha:1.0f];
        bottomNav.translucent = NO;
        bottomNav.tintColor = [UIColor whiteColor];
        
        
    }
    
    if(viewHeight == 480)
    {
        detailViewImage = [[UIView alloc] initWithFrame: CGRectMake ( 0, 0, 320, 480)];
        detailImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
    }
    else{
        detailViewImage = [[UIView alloc] initWithFrame: CGRectMake ( 0, 0, 320, 568)];
        detailImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
    }
    
    
    navItem  = [[UINavigationItem alloc] init];
    
    topNavItem = [[UINavigationItem alloc] init];
    
    backNav = [[UIBarButtonItem alloc]
               initWithTitle:@"back"
               style:UIBarButtonItemStyleBordered
               target:self
               action:@selector(moveBack:)];
    
     backButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(moveLeft:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 32, 32)];
    
    leftNav = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    rightNav = [[UIBarButtonItem alloc]
                initWithTitle:@"right"
                style:UIBarButtonItemStyleBordered
                target:self
                action:@selector(moveRight:)];
    
    [self startLoadingImages];
}

-(void)startLoadingImages
{
    DownloadControl *downloadCntl =[[DownloadControl alloc]init];
    downloadCntl.delegate = self;
    [downloadCntl startDownload];
}

-(void)downloadDidSucceed:(NSDictionary *)imageDict
{
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    
    argsArray = [imageDict objectForKey:@"SecondaryTileImages"];
    
    NSMutableArray *newImages = [[NSMutableArray alloc] init];
    
    newImages = [imageDict objectForKey:@"SecondaryImages"];

    int height=80;
    imageList = [[NSMutableArray alloc] init];
    for(int i= 0; i < argsArray.count; i++)
    {
        
        NSString *urlstring = [NSString stringWithFormat:@"%@%@",appDelegate.apiUri,[newImages objectAtIndex:i]];
        UIImageView *subview = [[UIImageView alloc] init];
        CGRect frame;
        frame.origin.x = 100 * i + 10;
        frame.size.height = 75;
        frame.size.width = 90;
        
        if(frame.origin.x > 200.000000 )
        {
            int j = i % 3;
            frame.origin.x = 100 * j + 10;
            if( j == 0)
            {
                height +=80;
                frame.origin.y += 80;
            }
        }
        
        scrollGallery.pagingEnabled = YES;
        subview.tag = i;
        subview.frame = frame;
        [imageList addObject:urlstring];
        subview.userInteractionEnabled = YES;
        
        [scrollGallery addSubview:subview];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [subview addGestureRecognizer:tap];
        
        AsyncDowloadImages *downloadCntl = [[AsyncDowloadImages alloc] init];
        downloadCntl.delegate = self;
        
        [downloadCntl downloadImage:urlstring andIndex:[NSNumber numberWithInt:i]];
        
    }
    
    scrollGallery.contentSize =  CGSizeMake(scrollGallery.frame.size.width, height);
    
    [self.view addSubview:scrollGallery];
   
}

-(void)downloadDidFail
{
    NSLog(@"Delegate method failure block");
}

-(void) AsyncDownloadDidFinishWithImage:(UIImage *)downloadedImage atIndex:(NSNumber *)imageIndex
{
    for(UIImageView *view in scrollGallery.subviews)
    {
        if(view.tag == imageIndex.intValue)
        {
            [view setImage:downloadedImage];
            [scrollGallery addSubview:view];
        }
    }
}

-(void) AsyncDownloadDidFail:(NSNumber *) imageIndex{
    for(UIImageView *view in scrollGallery.subviews)
    {
        if(view.tag == imageIndex.intValue)
        {
            [view setImage:[UIImage imageNamed:@"notfound.jpg"]];
            [scrollGallery addSubview:view];
            [self.view addSubview:scrollGallery];
        }
    }
    
}

-(void)imageTapped:(UITapGestureRecognizer *)gesture
{
    UIImageView *imgView = (UIImageView *)gesture.view;
    // NSString *url = [imageList objectAtIndex:imgView.tag];
    NSInteger index = imgView.tag;
    // NSLog(@"Index of image clicked is : %@", url);
    [self performSelector:@selector(scrollableImage:) withObject:[NSNumber numberWithInt:index]];
}

-(void)scrollableImage:(NSNumber *) index
{
    NSString *url = [imageList objectAtIndex:index.intValue];
    NSURL *urlstring = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:urlstring];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if(viewHeight == 480)
    {
        scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320,392)];
    }
    else{
        scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,myScrollImage.frame.size.width,myScrollImage.frame.size.height)];
    }
    
    [scrollImage setImage:image];
    detailImageView.showsHorizontalScrollIndicator = YES;
    // myScrollImage.showsHorizontalScrollIndicator = YES;
    // [myScrollImage addSubview:scrollImage];
    [detailViewImage addSubview:scrollImage];
    detailImageView.contentSize = CGSizeMake(detailImage.frame.size.width, detailImage.frame.size.height);
    //myScrollImage.contentSize = CGSizeMake(myScrollImage.frame.size.width, myScrollImage.frame.size.height);
    [detailImage addSubview:detailImageView];
    //[scrollImageView addSubview:myScrollImage];
    
    topNavItem.leftBarButtonItem = backNav;
    topNav.items = [NSArray arrayWithObject:topNavItem];
    
    navItem.leftBarButtonItem = leftNav;
    leftNav.tag = index.intValue;
    rightNav.tag = index.intValue;
    navItem.rightBarButtonItem = rightNav;
    
    
    if(index.intValue == imageList.count-1)
    {
        rightNav.enabled = NO;
    }
    else{
        if(index.intValue == 0 )
        {
            leftNav.enabled = NO;
        }
        else{
            rightNav.enabled = YES;
            leftNav.enabled = YES;
        }
    }
    
    bottomNav.items = [NSArray arrayWithObject:navItem];
    [detailViewImage addSubview:bottomNav];
    [detailViewImage addSubview:topNav];
    [self.view addSubview:detailViewImage];

}


-(void)moveLeft:(id)sender{
    
    NSNumber *index = [NSNumber numberWithInt:leftNav.tag-1];
    
    [self performSelector:@selector(scrollableImage:) withObject:index];
    
}

-(void)moveRight:(id)sender{
    
    NSNumber *index = [NSNumber numberWithInt:rightNav.tag + 1];
    
    [self performSelector:@selector(scrollableImage:) withObject:index];
}

-(void)moveBack:(id)sender{
    
    [detailImage removeFromSuperview];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
