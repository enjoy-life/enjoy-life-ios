//
//  ViewController.m
//  Seaport
//
//  Created by ltebean on 14-5-14.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "ViewController.h"
#import "Seaport.h"
#import "SeaportHttp.h"
#import "SeaportWebViewBridge.h"
#define barColor [UIColor colorWithRed:253/255.0f green:100/255.0f blue:84/255.0f alpha:1.0f ]

@interface ViewController  () <UIWebViewDelegate,SeaportDelegate>
@property (nonatomic,strong) Seaport* seaport ;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property(strong,nonatomic) SeaportWebViewBridge *bridge;
@property BOOL loaded;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loaded=NO;
    
    self.seaport = [Seaport sharedInstance];
    self.seaport.deletage=self;
    self.bridge = [SeaportWebViewBridge bridgeForWebView:self.webView param:@{@"city":@"shanghai",@"name": @"ltebean"} dataHandler:^(id data) {
        NSLog(@"receive data: %@",data);
        [self performSegueWithIdentifier:@"category" sender:data];
    }];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;

    self.searchBar = [[UISearchBar alloc] initWithFrame:self.view.bounds];
    [self.searchBar sizeToFit];
    self.searchBar.barTintColor=barColor;
    self.navigationItem.titleView = self.searchBar;

}


-(void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    if(!self.loaded){
        [self refresh:nil];
        self.loaded=YES;
    }

    
}
- (IBAction)refresh:(id)sender {
    
    NSString *rootPath = [self.seaport packagePath:@"all"];
    if(rootPath){
        NSString *filePath = [rootPath stringByAppendingPathComponent:@"index.html"];
        NSURL *localURL=[NSURL fileURLWithPath:filePath];
        
        NSURL *debugURL=[NSURL URLWithString:@"http://localhost:8080/index.html"];
        
        NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
        [self.webView loadRequest:request];
    }
}


- (IBAction)check:(id)sender {
    [self.seaport checkUpdate];
    [self.bridge sendData:@"btn-check clicked"];

}

-(void)seaport:(Seaport*)seaport didStartDownloadPackage:(NSString*) packageName version:(NSString*) version
{
    NSLog(@"start download package: %@@%@",packageName,version);
}

-(void)seaport:(Seaport*)seaport didFinishDownloadPackage:(NSString*) packageName version:(NSString*) version
{
    NSLog(@"finish download package: %@@%@",packageName,version);
}

-(void)seaport:(Seaport*)seaport didFailDownloadPackage:(NSString*) packageName version:(NSString*) version withError:(NSError*) error
{
    NSLog(@"faild download package: %@@%@",packageName,version);
}

-(void)seaport:(Seaport*)seaport didFinishUpdatePackage:(NSString*) packageName version:(NSString*) version
{
    NSLog(@"update local package: %@@%@",packageName,version);
}



@end
