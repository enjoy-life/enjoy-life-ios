//
//  BaseViewController.m
//  Coupon
//
//  Created by ltebean on 14-7-7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UISearchBarDelegate,SeaportDelegate>
@property(nonatomic,strong) UIToolbar* overlay;
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation BaseViewController

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
    if(!self.navBarTintColor){
        self.navBarTintColor=[UIColor colorWithRed:253/255.0f green:100/255.0f blue:84/255.0f alpha:1.0f ];
    }
    
    [self.navigationController.navigationBar setBarTintColor:self.navBarTintColor];
    
    self.seaport = [Seaport sharedInstance];
    self.seaport.deletage=self;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:self.view.bounds];
    [self.searchBar sizeToFit];
    self.searchBar.barTintColor=self.navBarTintColor;
    self.searchBar.delegate=self;
    self.navigationItem.titleView = self.searchBar;
    
    self.overlay = [[UIToolbar alloc] initWithFrame:self.view.bounds];
    [self.view addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayClicked:)]];
}

- (void)overlayClicked:(UITapGestureRecognizer *)recognizer {
    [self.overlay removeFromSuperview];
    [self.searchBar resignFirstResponder];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
    [self.view addSubview:self.overlay];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.overlay removeFromSuperview];
    [self.searchBar resignFirstResponder];
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
