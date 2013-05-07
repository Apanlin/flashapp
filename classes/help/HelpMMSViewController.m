//
//  HelpMMSViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-22.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "HelpMMSViewController.h"
#import "AppDelegate.h"

#define TAG_BACKGROUND_IMAGEVIEW 101

@interface HelpMMSViewController ()

@end

@implementation HelpMMSViewController

@synthesize scrollview;


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
    // Do any additional setup after loading the view from its nib.
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:NO];
    
    UIImageView* imageView = (UIImageView*) [self.view viewWithTag:TAG_BACKGROUND_IMAGEVIEW];
    imageView.image = [[UIImage imageNamed:@"help_triangle_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:20];
    
    self.navigationItem.title = @"诊断与帮助";
    scrollview.contentSize = CGSizeMake(320, 1100);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
