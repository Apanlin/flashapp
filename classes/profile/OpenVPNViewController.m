//
//  OpenVPNViewController.m
//  flashapp
//
//  Created by Zhao Qi on 13-4-12.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "OpenVPNViewController.h"
#import "AppDelegate.h"

@interface OpenVPNViewController ()

@end

@implementation OpenVPNViewController

@synthesize scrollView;
@synthesize button;


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
    [button release];
    [scrollView release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"开启服务";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    
    [button setBackgroundImage:[[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8] forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(installAPNProfile) forControlEvents:UIControlEventTouchUpInside];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    scrollView.contentSize = CGSizeMake( 320, 600 );
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    self.button = nil;
    self.scrollView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) installAPNProfile
{
    
    NSString *inchk = [[NSUserDefaults standardUserDefaults] objectForKey:@"inchk"];
//    NSString *inchk = 0 ;
    if ([inchk isEqualToString:@"1"]) {
        [AppDelegate installProfileForServiceType:@"apn" nextPage:@"datasave" apn:nil idc:nil interfable:@"1"];
    }else{
        [AppDelegate installProfileForServiceType:@"apn" nextPage:@"datasave" apn:nil idc:nil interfable:@"0"];
    }
    
}


- (void) close
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
