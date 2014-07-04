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

@interface ViewController  () <UIWebViewDelegate,SeaportDelegate>
@property (nonatomic,strong) Seaport* seaport ;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(strong,nonatomic) SeaportWebViewBridge *bridge;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.seaport = [Seaport sharedInstance];
    self.seaport.deletage=self;
    self.bridge = [SeaportWebViewBridge bridgeForWebView:self.webView param:@{@"city":@"shanghai",@"name": @"ltebean"} dataHandler:^(id data) {
        NSLog(@"receive data: %@",data);
    }];

}


-(void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self refresh:nil];

    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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