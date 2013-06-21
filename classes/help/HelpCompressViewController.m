//
//  HelpCompressViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-4.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "HelpCompressViewController.h"
#import "FeedbackViewController.h"
#import "OpenVPNViewController.h"
#import "AppDelegate.h"
#import "StatsDayDAO.h"
#import "Reachability.h"
#import "TCUtils.h"
#import "UIDevice-Reachability.h"
#import "SetSecondViewBackBtnInNav.h"

@interface HelpCompressViewController ()

@end

@implementation HelpCompressViewController

@synthesize iconImageView;
@synthesize indicatorView;
@synthesize resultLabel;
@synthesize openServiceButton;
@synthesize feedbackButton;
@synthesize checkBgImageView;
@synthesize resultBgImageView;


#pragma mark - init & destroy

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
    [iconImageView release];
    [indicatorView release];
    [resultLabel release];
    [openServiceButton release];
    [feedbackButton release];
    [checkBgImageView release];
    [resultBgImageView release];
    [_lianxiLabel release];
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [SetSecondViewBackBtnInNav setBackController:self anditemName:@"诊断与帮助"];
    
    checkBgImageView.image = [[UIImage imageNamed:@"help_triangle_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:20];
    resultBgImageView.image = [[UIImage imageNamed:@"help_result_bg.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:33];
    
    UIImage* image = [[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [openServiceButton setBackgroundImage:image forState:UIControlStateNormal];
    [openServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [feedbackButton setBackgroundImage:image forState:UIControlStateNormal];
    [feedbackButton setTitle:@"意见反馈" forState:UIControlStateNormal];
    [feedbackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feedbackButton addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhone5) {
        feedbackButton.frame = CGRectMake(213, 450, 85, 33);
        self.lianxiLabel.frame = CGRectMake(30, 450, 144, 34);
    }
    
    indicatorView.hidden = YES;
    openServiceButton.hidden = YES;
}

- (void)viewDidUnload
{
    [self setLianxiLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.iconImageView = nil;
    self.indicatorView = nil;
    self.resultLabel = nil;
    self.openServiceButton = nil;
    self.feedbackButton = nil;
    self.checkBgImageView = nil;
    self.resultBgImageView = nil;    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(check) withObject:nil afterDelay:0.3];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate getAppDelegate].customTabBar hiddenTabBar];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - check methods

- (void) check
{
    iconImageView.hidden = YES;
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
    resultLabel.text = @"正在检测压缩服务是否开启...";
    
    [self checkReachable];
}


- (void) checkReachable
{
    //检测网络
    Reachability* networkReachablity = [Reachability reachabilityWithHostName:P_HOST];    
    if ( [networkReachablity currentReachabilityStatus] == NotReachable ) {
        [self showResult:NO msg:@"连接不上飞速压缩服务器"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    ConnectionType connectionType = [UIDevice connectionType];
    
    if ( [@"vpn" isEqualToString:user.stype] ) {
        //检测是否开启了VPN
        if ( connectionType == CELL_2G || connectionType == CELL_3G || connectionType == CELL_4G ) {
            if ( ![UIDevice isVPNEnabled] ) {
                [self showResult:NO msg:@"您的压缩服务没有开启"];
                [openServiceButton setTitle:@"开启服务" forState:UIControlStateNormal];
                openServiceButton.hidden = NO;
                [openServiceButton addTarget:self action:@selector(showStartVPNHelp) forControlEvents:UIControlEventTouchUpInside];
                return;
            }
        }
    }
    else {
        //测试是否安装了profile
        [self checkProfile];
    }
}


- (void) checkProfile
{
    NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getAccesslog) object:nil];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [queue addOperation:operation];
    [queue release];
}


- (void) getAccesslog
{
    [TCUtils readIfData:-1];
    [TwitterClient getStatsData];
    [self performSelectorOnMainThread:@selector(finishCheck) withObject:nil waitUntilDone:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];
}


- (void) showResult:(BOOL)result msg:(NSString*)msg
{
    [indicatorView stopAnimating];
    indicatorView.hidden = YES;
    iconImageView.hidden = NO;
    if ( result ) {
        iconImageView.image = [UIImage imageNamed:@"icon_ok.png"];
    }
    else {
        iconImageView.image = [UIImage imageNamed:@"icon_!.png"];
    }
    
    resultLabel.text = msg;
}


- (void) finishCheck
{
    AppDelegate* appDelegate = [AppDelegate getAppDelegate];
    UserSettings* user = appDelegate.user;
    InstallFlag flag = user.proxyFlag;
    NSString* stype = user.stype;
    
    if ( flag == INSTALL_FLAG_NO ) {
        [self showResult:NO msg:@"您的压缩服务未启用"];
        [openServiceButton setTitle:@"启动压缩服务" forState:UIControlStateNormal];
        openServiceButton.hidden = NO;
        
        if ( [@"vpn" isEqualToString:stype] ) {
            [openServiceButton addTarget:self action:@selector(showStartVPNHelp) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [openServiceButton addTarget:self action:@selector(installProfile) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if ( flag == INSTALL_FLAG_APN_WRONG_IDC ) {
        [self showResult:NO msg:@"您的机房设置错误"];
        [openServiceButton setTitle:@"修复机房设置" forState:UIControlStateNormal];
        openServiceButton.hidden = NO;
        [openServiceButton addTarget:self action:@selector(installProfile) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self showResult:YES msg:@"压缩服务工作正常"];
        openServiceButton.hidden = YES;
    }
}


#pragma mark - helper methods


- (void) installProfile
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_NO ) {
        [AppDelegate installProfile:@"current"];
    }
    else if ( user.proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
        [AppDelegate installProfile:@"current" idc:user.idcCode];
    }
}


- (void) feedback
{
    FeedbackViewController* controller = [[FeedbackViewController alloc] init];
    controller.showClose = YES;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) showStartVPNHelp
{
    OpenVPNViewController* controller = [[OpenVPNViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}



@end
