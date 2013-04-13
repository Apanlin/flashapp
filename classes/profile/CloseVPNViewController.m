//
//  OpenVPNViewController.m
//  flashapp
//
//  Created by Zhao Qi on 13-4-12.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "CloseVPNViewController.h"
#import "AppDelegate.h"

@interface CloseVPNViewController ()

@end

@implementation CloseVPNViewController

@synthesize scrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [scrollView release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"关闭服务";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    scrollView.contentSize = CGSizeMake( 320, 550 );
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) close
{
    [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
}

@end
