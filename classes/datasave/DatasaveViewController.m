//
//  DatasaveViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DatasaveViewController.h"
#import "ShareToSNSViewController.h"
#import "DatastatsScrollViewController.h"
#import "InstallProfileViewController.h"
#import "SettingViewController.h"
#import "HelpViewController.h"
#import "LoginNewViewController.h"
#import "ImageViewController.h"
#import "LevelViewController.h"
#import "TCAdjustViewController.h"
#import "HelpListViewController.h"
#import "AppDelegate.h"
#import "DBConnection.h"
#import "IFDataService.h"
#import "StatsDayService.h"
#import "StatsMonthDAO.h"
#import "StatsDayDAO.h"
#import "SystemVariablesDAO.h"
#import "DateUtils.h"
#import "StringUtil.h"
#import "UIImageUtil.h"
#import "OpenUDID.h"
#import "UIDevice-Reachability.h"
#import "TCUtils.h"
#import "TitleView.h"
#import "GetAddress.h"

#define MESSAGE_HEIGHT 28
#define NICKNAME_FONT [UIFont systemFontOfSize:12]
#define TAOCAN_AXIS_FONT [UIFont systemFontOfSize:11]

#define CA_CENTERX 160
#define CA_CENTERY 129
#define CA_WIDTH 150
#define CA_HEIGHT 50

#define TAG_ALERT_INVITE 100
#define TAG_ALERT_TAOCAN 101

typedef enum {
    MT_REFRESH,
    MT_WIFI,
    MT_PROFILE,
    MT_PROXY_SLOW,
    MT_VPN
} MessageType;


@implementation DatasaveViewController

@synthesize scrollView;
@synthesize contentView;
@synthesize inviteBgView;
@synthesize dataBgView;
@synthesize taocanBgView;
@synthesize capacityLabel;
@synthesize capacityUnitLabel;
@synthesize balanceLabel;
@synthesize balanceUnitLabel;
@synthesize dialView;
@synthesize totalStats;
@synthesize monthStats;
@synthesize userAgentStatsList;
@synthesize levelImageView;
@synthesize levelImageButton;
@synthesize levelLabel;
@synthesize nicknameView;
@synthesize nicknameLabel;
@synthesize regButton;
@synthesize caView;
@synthesize taocanLabel;
@synthesize taocanLabel2;
@synthesize taocanButton;
@synthesize taocanAdjectButton;
@synthesize taocanLeftLabel;
@synthesize taocanUnitLabel;
@synthesize taocanUsedLabel;
@synthesize taocanUsedUnitLabel;
@synthesize taocanBarBgImageView;
@synthesize taocanUsedBarImageView;
@synthesize taocanExceedBarImageView;
@synthesize taocanBarTriangleImageView;
@synthesize installingProfile;
@synthesize inviteUpButton;
@synthesize inviteDownButton;


#pragma mark - init & destroy methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = NSLocalizedString(@"service.tabBarItem.title",nil);
        self.tabBarItem.image = [UIImage imageNamed:@"icon_service.png"];
        self.installingProfile = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void) dealloc {
    [scrollView release];
    [contentView release];
    [inviteBgView release];
    [dataBgView release];
    [taocanBgView release];
    [capacityLabel release];
    [capacityUnitLabel release];
    [balanceLabel release];
    [balanceUnitLabel release];
    [levelLabel release];
    [levelImageView release];
    [levelImageButton release];
    [dialView release];
    [messageView release];
    [totalStats release];
    [monthStats release];
    [stepStats release];
    [userAgentStatsList release];
    [nicknameView release];
    [nicknameLabel release];
    [regButton release];
    [caView release];
    [taocanButton release];
    [taocanAdjectButton release];
    [taocanLabel release];
    [taocanLabel2 release];
    [taocanLeftLabel release];
    [taocanUnitLabel release];
    [taocanUsedLabel release];
    [taocanUsedUnitLabel release];
    [taocanBarBgImageView release];
    [taocanUsedBarImageView release];
    [taocanExceedBarImageView release];
    [taocanBarTriangleImageView release];
    [inviteDownButton release];
    [inviteUpButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     NSString* regButtonimageName =  NSLocalizedString(@"regButton.iamge",nil);
    [regButton setImage: [UIImage imageNamed:regButtonimageName] forState:UIControlStateNormal];

    
    NSString* inviteDownButtonTitle =  NSLocalizedString(@"inviteDownButton.title",nil);
    [inviteDownButton setTitle:inviteDownButtonTitle forState:UIControlStateNormal];

    NSString* inviteUpButtonimageName =  NSLocalizedString(@"inviteUpButton.image",nil);
    [inviteUpButton setImage: [UIImage imageNamed:inviteUpButtonimageName] forState:UIControlStateNormal];

    
    NSString* serviceNavTilte =  NSLocalizedString(@"service.navItem.title",nil);
    NSString* backName = NSLocalizedString(@"backName",nil);
    self.navigationItem.title = serviceNavTilte;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backName style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationController.navigationBar.translucent = NO;

    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 32);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"diagnose.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showDiagnose) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40, 32);
    [rightButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIColor* color = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    self.view.backgroundColor = color;
    scrollView.backgroundColor = color;
    contentView.backgroundColor = color;
    
    dataBgView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    inviteBgView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    
    if ( iPhone5 ) {
        taocanBgView.image = [[UIImage imageNamed:@"ds_tc_bg.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:37];
        taocanBarBgImageView.image = [[UIImage imageNamed:@"ds_tc_bar_bg.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:5];
        
        taocanAxisLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(18, 285, 25, 20)];
        taocanAxisLabel1.backgroundColor = [UIColor clearColor];
        taocanAxisLabel1.textColor = [UIColor whiteColor];
        taocanAxisLabel1.font = TAOCAN_AXIS_FONT;
        taocanAxisLabel1.textAlignment = UITextAlignmentCenter;
        taocanAxisLabel1.text = @"0M";
        [contentView addSubview:taocanAxisLabel1];
        [taocanAxisLabel1 release];

        taocanAxisLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        taocanAxisLabel2.backgroundColor = [UIColor clearColor];
        taocanAxisLabel2.textColor = [UIColor whiteColor];
        taocanAxisLabel2.font = TAOCAN_AXIS_FONT;
        taocanAxisLabel2.textAlignment = UITextAlignmentCenter;
        [contentView addSubview:taocanAxisLabel2];
        [taocanAxisLabel2 release];

        taocanAxisLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
        taocanAxisLabel3.backgroundColor = [UIColor clearColor];
        taocanAxisLabel3.textColor = [UIColor whiteColor];
        taocanAxisLabel3.font = TAOCAN_AXIS_FONT;
        taocanAxisLabel3.textAlignment = UITextAlignmentCenter;
        [contentView addSubview:taocanAxisLabel3];
        [taocanAxisLabel3 release];
        
        taocanAxisLabel4 = [[UILabel alloc] initWithFrame:CGRectZero];
        taocanAxisLabel4.backgroundColor = [UIColor clearColor];
        taocanAxisLabel4.textColor = [UIColor whiteColor];
        taocanAxisLabel4.font = TAOCAN_AXIS_FONT;
        taocanAxisLabel4.textAlignment = UITextAlignmentCenter;
        [contentView addSubview:taocanAxisLabel4];
        [taocanAxisLabel4 release];
        
        taocanAxisLabel5 = [[UILabel alloc] initWithFrame:CGRectZero];
        taocanAxisLabel5.backgroundColor = [UIColor clearColor];
        taocanAxisLabel5.textColor = [UIColor whiteColor];
        taocanAxisLabel5.font = TAOCAN_AXIS_FONT;
        taocanAxisLabel5.textAlignment = UITextAlignmentCenter;
        [contentView addSubview:taocanAxisLabel5];
        [taocanAxisLabel5 release];
        
        taocanAxisUsedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        taocanAxisUsedLabel.backgroundColor = [UIColor clearColor];
        taocanAxisUsedLabel.textColor = [UIColor whiteColor];
        taocanAxisUsedLabel.font = TAOCAN_AXIS_FONT;
        taocanAxisUsedLabel.textAlignment = UITextAlignmentCenter;
        [contentView addSubview:taocanAxisUsedLabel];
        [taocanAxisUsedLabel release];
    }
    else {
        taocanBgView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    }
    
    if ( iPhone5 ) {
        dialView = [[DatasaveDialView alloc] initWithFrame:CGRectMake(25, 32, 160, 170)];
    }
    else {
        dialView = [[DatasaveDialView alloc] initWithFrame:CGRectMake(25, 22, 160, 170)];
    }
    
    [contentView addSubview:dialView]; //添加仪表盘
    [dialView setNeedsDisplay];
    
    messageView = [[ProfileTipView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
    messageView.hidden = YES;
    [scrollView addSubview:messageView];
    
    nicknameView.image = [[UIImage imageNamed:@"bg_nickname.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    nicknameLabel.font = NICKNAME_FONT;
    nicknameLabel.textColor = [UIColor lightGrayColor];
    
    [contentView bringSubviewToFront:caView];
    
	//if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - scrollView.bounds.size.height, self.view.frame.size.width, scrollView.bounds.size.height)];
		view.delegate = self;
		[self.scrollView addSubview:view];
		_refreshHeaderView = view;
		//[view release];
	//}
    
    //刷新菊花
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 150, 130, 100)];
    loadingView.message = NSLocalizedString(@"set.accountView.loading.message", nil);
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
    
    scrollView.delegate = self;

    refreshLock = [[NSLock alloc] init];
    
    self.dialView.delegate = self;
    
    //封装的流量的类
    stepStats = [[StageStats alloc] init];
    stepStats.bytesBefore = 0;
    stepStats.bytesAfter = 0;
    
    twitterClient = nil;
    [self renderDB];
    
    justLoaded = YES;
    
    //接收刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndShowData) name:RefreshNotification object: nil];
    
    //接收套餐数据修改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndShowData) name:TCChangedNotification object: nil];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self checkConnection];
    [self setLastUpdateDate];
    
    //[TCUtils readIfData:-1];
    //[self showTCData];
    
    if ( justLoaded ) {
        //justLoaded = NO;
    }
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( justLoaded ) {  //如果就是刚刚开启
        [self performSelector:@selector(getAccessData) withObject:nil afterDelay:0.5];

        stepStats.bytesBefore = 0;
        
        if ( timer ) {
            [timer invalidate];
            timer = nil;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressShowDial) userInfo:nil repeats:YES];
        
        justLoaded = NO;
    }
    else {
        AppDelegate* appDelegate = [AppDelegate getAppDelegate];
        if ( appDelegate.refreshDatasave ) {
            [self performSelector:@selector(getAccessData) withObject:nil afterDelay:0.5];
            appDelegate.refreshDatasave = NO;
        }
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.username && user.username.length > 0 && user.nickname && user.nickname.length > 0 ) {
        nicknameView.hidden = NO;
        nicknameLabel.hidden = NO;
        regButton.hidden = YES;
        
        UIFont* font = [UIFont systemFontOfSize:12];
        CGSize size = [user.nickname sizeWithFont:font];
        nicknameLabel.frame = CGRectMake( 300 - size.width - 10, 17, size.width, size.height );
        nicknameView.frame = CGRectMake( 300 - size.width - 20, 15, size.width + 20, 20 );
        
        nicknameLabel.text = user.nickname;
    }
    else {
        nicknameView.hidden = YES;
        nicknameLabel.hidden = YES;
        regButton.hidden = NO;
    }
    
    if ( [@"vpn" isEqualToString:user.stype] ) {
        [self checkVPN];
    }
    else {
        [self checkAPN];
    }
}


- (void) scaleCapacityView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(moveCapacityView)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.caView.frame = CGRectMake( CA_CENTERX - CA_WIDTH, CA_CENTERY - CA_HEIGHT, CA_WIDTH * 2, CA_HEIGHT * 2);
    [UIView commitAnimations];
}


- (void) moveCapacityView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    self.caView.frame = CGRectMake(250, 100, 0, 0);
    [UIView commitAnimations];
}


- (void) viewWillDisappear:(BOOL)animated
{
    //if ( timer ) {
    //    [timer invalidate];
    //    timer = nil;
    //}
    [super viewWillDisappear:animated];
}


- (void) progressShowDial
{
    float quantity = [AppDelegate getAppDelegate].user.capacity;
    float unit = quantity * 1024.0f * 1024.0f / 300;
    
    long compressed = monthStats.bytesBefore - monthStats.bytesAfter;
    
    stepStats.bytesBefore += unit;
    if ( stepStats.bytesBefore < compressed ) {
        dialView.monthStats = stepStats;
        [dialView setNeedsDisplay];
    }
    else {
        dialView.monthStats = monthStats;
        [dialView setNeedsDisplay];
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.contentView = nil;
    self.inviteBgView = nil;
    self.dataBgView = nil;
    self.taocanBgView = nil;
    self.capacityLabel = nil;
    self.capacityUnitLabel = nil;
    self.balanceLabel = nil;
    self.balanceUnitLabel = nil;
    self.dialView = nil;
    self.totalStats = nil;
    self.monthStats = nil;
    self.userAgentStatsList = nil;
    self.levelLabel = nil;
    self.levelImageView = nil;
    self.levelImageButton = nil;
    self.nicknameLabel = nil;
    self.nicknameView = nil;
    self.regButton = nil;
    self.caView = nil;
    self.taocanButton = nil;
    self.taocanAdjectButton = nil;
    self.taocanLabel = nil;
    self.taocanLabel2 = nil;
    self.taocanUnitLabel = nil;
    self.taocanLeftLabel = nil;
    self.taocanUsedLabel = nil;
    self.taocanUsedUnitLabel = nil;
    self.taocanBarBgImageView = nil;
    self.taocanUsedBarImageView = nil;
    self.taocanExceedBarImageView = nil;
    self.taocanBarTriangleImageView = nil;
    
    [stepStats release];
    stepStats = nil;
    
    [messageView release];
    messageView = nil;
    
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
    
    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - check connection and apn/vpn profiles

/*
- (void) checkConnection
{
    ConnectionType type = [UIDevice connectionType];
    NSString* desc = nil;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    switch (type) {
        case UNKNOWN:
        case NONE:
            desc =  NSLocalizedString(@"Connection.type.NONE",nil);
            [self showMessage:desc type:MT_WIFI];
            [self performSelector:@selector(hiddenMessage) withObject:nil afterDelay:5.0f];
            break;
        case WIFI:
            if ( [@"apn" isEqualToString:user.stype] ) {
                desc = NSLocalizedString(@"Connection.type.WIFI",nil);
                [self showMessage:desc type:MT_WIFI];
                [self performSelector:@selector(hiddenMessage) withObject:nil afterDelay:2.0f];
            }
            break;
        default:
            break;
    }
}
*/

- (void) checkVPN
{
    ConnectionType type = [UIDevice connectionType];
    BOOL vpnStarted = [UIDevice isVPNEnabled];
    NSString* desc = nil;
    
    switch (type) {
        case WIFI:
            if ( vpnStarted ) {
                desc = @"WIFI下请暂停服务  ";
                [self showMessage:desc andType:MT_VPN andBtnTitle:@"暂停服务" andBtnSel:@selector(showStopVPNHelp)];
                //[self performSelector:@selector(hiddenVPNMessage) withObject:nil afterDelay:2.0f];
            }
            else {
                [self hiddenMessage:MT_VPN];
            }
            break;
        case CELL_2G:
        case CELL_3G:
        case CELL_4G:
            if ( !vpnStarted ) {
                desc = @"您的加速服务被暂停  ";
                [self showMessage:desc andType:MT_VPN andBtnTitle:@"开启服务" andBtnSel:@selector(showStartVPNHelp)];
                //[self performSelector:@selector(hiddenVPNMessage) withObject:nil afterDelay:2.0f];
            }
            else {
                [self hiddenMessage:MT_VPN];
            }
        default:
            break;
    }
}


- (void) checkAPN
{
    //提示安装profile文件
    InstallFlag proxyFlag = [AppDelegate getAppDelegate].user.proxyFlag;
    ConnectionType type = [UIDevice connectionType];
    
    if ( type == WIFI ) {
        NSString* desc = NSLocalizedString(@"Connection.type.WIFI",nil);
        [self showMessage:desc type:MT_WIFI];
        [self performSelector:@selector(hiddenMessage) withObject:nil afterDelay:2.0f];
    }
    else if ( type == CELL_2G || type == CELL_3G || type == CELL_4G ) {
        if ( proxyFlag == INSTALL_FLAG_NO || proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
            [self showAPNMessage];
        }
        else {
            [self hiddenAPNMessage];
        }
    }
}


- (void) checkProxySpeed
{
    InstallFlag flag = [AppDelegate getAppDelegate].user.proxyFlag;
    ConnectionType type = [UIDevice connectionType];
    BOOL isVPNStart = [UIDevice isVPNEnabled];
    
    BOOL slow = [AppDelegate getAppDelegate].proxySlow;
    BOOL shouldShow = NO;
    if ( slow ) {
        if ( isVPNStart ) {
            shouldShow = YES;
        }
        else if ( type == CELL_2G || type == CELL_3G || type == CELL_4G ) {
            if ( flag == INSTALL_FLAG_APN_RIGHT_IDC ) {
                shouldShow = YES;
            }
        }
    }
    else {
        shouldShow = NO;
    }
    
    if ( shouldShow ) {
        [self showProxySlowMessage];
    }
    else {
        [self hiddenProxySlowMessage];
    }
}



#pragma mark - show&hidden message methods

- (void) showAfterInstallProfile
{
    NSString* message =  NSLocalizedString(@"afterInstallProfile.message",nil);
    NSString* cancleButtonTitle =  NSLocalizedString(@"afterInstallProfile.cancleButton.title",nil);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:cancleButtonTitle otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}


- (void) showProxySlowMessage
{
    if ( !messageView.hidden ) return;
    
    CGSize s = scrollView.contentSize;
    s.height += MESSAGE_HEIGHT;
    scrollView.contentSize = s;
    
    CGRect r = contentView.frame;
    r.origin.y = MESSAGE_HEIGHT - 3;
    contentView.frame = r;

    NSString* message =  NSLocalizedString(@"showProxySlow.message",nil);
    NSString* buttonTitle =  NSLocalizedString(@"showProxySlow.button.title",nil);

    
    [messageView setMessage:message button:buttonTitle];
    messageView.type = MT_PROXY_SLOW;
    messageView.hidden = NO;

    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( [@"vpn" isEqualToString:user.stype] ) {
        [messageView.button addTarget:self action:@selector(showStopVPNHelp) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [messageView.button addTarget:self action:@selector(showUninstallAPNProfile) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void) hiddenProxySlowMessage
{
    if ( messageView.hidden || messageView.type != MT_PROXY_SLOW ) return;
    messageView.hidden = YES;
    
    CGRect rect = contentView.frame;
    rect.origin.y = 0;
    contentView.frame = rect;
    
    CGSize s = scrollView.contentSize;
    s.height -= MESSAGE_HEIGHT;
    scrollView.contentSize = s;
}



- (void) showAPNMessage
{
    if ( !messageView.hidden && messageView.type == MT_PROFILE ) return;

    if ( messageView.hidden ) {
        CGSize s = scrollView.contentSize;
        s.height += MESSAGE_HEIGHT;
        scrollView.contentSize = s;
        
        CGRect r = contentView.frame;
        r.origin.y = MESSAGE_HEIGHT - 3;
        contentView.frame = r;
    }
    
    NSString* message =  nil;
    NSString* buttonTitle = nil;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_NO ) {
        message = NSLocalizedString(@"showProfile.message",nil);
        buttonTitle =  NSLocalizedString(@"showProfile.button.title",nil);
    }
    else if ( user.proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
        message = NSLocalizedString(@"showProfile.message.choased",nil);
        buttonTitle =  NSLocalizedString(@"showProfile.button.title.choased",nil);
    }
    
    [messageView setMessage:message button:buttonTitle];
    messageView.type = MT_PROFILE;
    [messageView.button addTarget:self action:@selector(installAPNProfile) forControlEvents:UIControlEventTouchUpInside];
    messageView.hidden = NO;
}


- (void) showVPNMessage:(BOOL)shouldOpen
{
    NSString* message = nil;
    NSString* buttonTitle = nil;
    SEL sel = nil;
    
    if ( shouldOpen ) {
        message = @"请打开VPN";
        buttonTitle = @"开启VPN";
    }
    else {
        message = @"请关闭VPN";
        buttonTitle = @"关拨VPN";
    }
    [self showMessage:message andType:MT_VPN andBtnTitle:buttonTitle andBtnSel:sel];
}


- (void) showMessage:(NSString*)message andType:(MessageType)type andBtnTitle:(NSString*)title andBtnSel:(SEL)sel
{
    if ( !messageView.hidden && messageView.type == type ) return;
    
    if ( messageView.hidden ) {
        CGSize s = scrollView.contentSize;
        s.height += MESSAGE_HEIGHT;
        scrollView.contentSize = s;
        
        CGRect r = contentView.frame;
        r.origin.y = MESSAGE_HEIGHT - 3;
        contentView.frame = r;
    }
    
    [messageView setMessage:message button:title];
    messageView.type = type;
    [messageView.button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    messageView.hidden = NO;
}



- (void) hiddenAPNMessage
{
    if ( messageView.hidden || messageView.type != MT_PROFILE ) return;
    messageView.hidden = YES;
    
    CGRect rect = contentView.frame;
    rect.origin.y = 0;
    contentView.frame = rect;
    
    CGSize s = scrollView.contentSize;
    s.height -= MESSAGE_HEIGHT;
    scrollView.contentSize = s;
}


- (BOOL) showMessage:(NSString*)msg type:(MessageType)mt
{
    if ( !messageView.hidden ) return false;
    
    [messageView setMessage:msg button:nil];
    messageView.type = mt;
    messageView.hidden = NO;
    
    CGRect r = contentView.frame;
    r.origin.y = MESSAGE_HEIGHT - 3;
    contentView.frame = r;
    
    CGSize s = scrollView.contentSize;
    s.height += MESSAGE_HEIGHT;
    scrollView.contentSize = s;
    
    return true;
}


- (void) hiddenMessage:(MessageType)mt
{
    if ( messageView.hidden || messageView.type != mt ) return;
    
    messageView.hidden = YES;

    CGRect r = contentView.frame;
    r.origin.y = 0;
    contentView.frame = r;
    
    CGSize s = scrollView.contentSize;
    s.height -= MESSAGE_HEIGHT;
    scrollView.contentSize = s;
}


- (void) hiddenMessage
{
    [self hiddenMessage:MT_WIFI];
}


- (void) hiddenVPNMessage
{
    [self hiddenMessage:MT_VPN];
}

- (void) showHelp
{
    HelpViewController* controller = [[HelpViewController alloc] init];
    controller.showCloseButton = YES;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) showStartVPNHelp
{
    [[AppDelegate getAppDelegate] showProfileHelp];
}


- (void) showStopVPNHelp
{
    
}


- (void) showDiagnose
{
    HelpListViewController* controller = [[HelpListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void) showUninstallAPNProfile
{
    HelpViewController* controller = [[HelpViewController alloc] init];
    controller.showCloseButton = YES;
    controller.page = @"profile/YDD";
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}



#pragma mark - load Data and show Data methods

- (void) renderDB
{
    [self loadDataFromDB];
    
    StageStats* oldStats = [self.monthStats retain];
    [self displayAfterLoad:oldStats];
    [oldStats release];
}


- (void) loadDataFromDB
{
    [DBConnection beginTransaction];
    //得到节省流量的总数
    self.totalStats = [StatsMonthDAO statForPeriod:0 endTime:0];
    
    if ( totalStats ) {
        //得到本月节省的流量
        time_t now;
        time( &now );
        //now = now - 10L * 24 * 3600;
        
        time_t peroid[2];
        [TCUtils getPeriodOfTcMonth:peroid time:now];
        self.monthStats = [StatsMonthDAO statForPeriod:peroid[0] endTime:peroid[1]];
    }
    
    [DBConnection commitTransaction];
}


- (void) getAccessData
{
    [self getAccessData:NO];
}


- (void) getAccessData:(BOOL)dropdownRefresh
{
    //读已用流量
    [TCUtils readIfData:-1];
    
    if ( twitterClient ) {
        if ( dropdownRefresh ) {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        }
        return;
    }
    
    AppDelegate* app = [AppDelegate getAppDelegate];
    if ( [app.networkReachablity currentReachabilityStatus] == NotReachable ) {
        if ( dropdownRefresh ) {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        }
        return;
    }
    
    if ( ![[AppDelegate getAppDelegate].refreshingLock tryLock] ) {
        if ( dropdownRefresh ) {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        }
        return;
    }
    
    NSString* message =  NSLocalizedString(@"dropdownRefresh.message",nil);
    if ( !dropdownRefresh ) [self showMessage:message type:MT_REFRESH];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetAccessData:obj:)];
    twitterClient.context = [NSNumber numberWithBool:dropdownRefresh];
    [twitterClient getAccessData];
}


- (void) didGetAccessData:(TwitterClient*)client obj:(NSObject*)obj
{
    twitterClient = nil;
    
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self hiddenMessage:MT_REFRESH];
    
    if ( client.hasError ) {
        [[AppDelegate getAppDelegate].refreshingLock unlock];
        [self doneLoadingTableViewData];
        [AppDelegate showAlert:client.errorMessage];
        return;
    }
    
    [[AppDelegate getAppDelegate].refreshingLock unlock];

    long long lastDayLong = [AppDelegate getLastAccessLogTime];
    NSNumber* number = client.context;
    BOOL ddRefresh = [number boolValue];
    
    StageStats* mstats = [monthStats retain];
    
    //处理返回的数据
    BOOL hasData = [TwitterClient procecssAccessData:obj time:lastDayLong];
    if ( hasData ) {
        //从数据库中加载数据
        [self loadDataFromDB];
    }
    
    //读已用流量
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.ifLastTime == 0 ) {
        [TCUtils readIfData:self.monthStats.bytesAfter];
    }
    
    //显示数据
    [self displayAfterLoad:mstats];
    [mstats release];
    
    if ( [@"vpn" isEqualToString:user.stype] ) {
        [self checkVPN];
    }
    else {
        //显示profile是否安装
        [self checkAPN];
    }
    
    //显示网速测试结果
    [self checkProxySpeed];
    
    //处理下拉刷新
    [_refreshHeaderView refreshLastUpdatedDate];
    if ( ddRefresh ) [self doneLoadingTableViewData];
}


- (void) loadAndShowData
{
    StageStats* mstats = [monthStats retain];
    
    UserSettings *user = [UserSettings currentUserSettings];
    
    //从数据库中加载数据
    [self loadDataFromDB];
    
    //显示数据
    [self displayAfterLoad:mstats];
    [mstats release];
    
    if ( [@"vpn" isEqualToString:user.stype]) {
        //显示VPN是否开启
        [self checkVPN];
    }
    else {
        //显示profile是否安装
        [self checkAPN];
    }

    //显示网速测试结果
    [self checkProxySpeed];
}


- (void) displayAfterLoad:(StageStats*)oldMonthStats
{
    [self viewShowData];
    
    if ( !oldMonthStats || oldMonthStats.bytesBefore == 0 ) {
        if ( timer ) {
            [timer invalidate];
            timer = nil;
        }
        
        stepStats.bytesBefore = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressShowDial) userInfo:nil repeats:YES];
    }
    
    dialView.monthStats = monthStats;
    [dialView setNeedsDisplay];
}


- (void) viewShowData
{
    float quantity = [AppDelegate getAppDelegate].user.capacity;
    NSString* s1 = [NSString stringWithFormat:@"%.2f", quantity];
    CGSize size = [s1 sizeWithFont:[UIFont boldSystemFontOfSize:12]];
    CGRect r = capacityLabel.frame;
    r.size.width = size.width;
    capacityLabel.frame = r;
    capacityLabel.text = s1;
    
    CGRect r2 = capacityUnitLabel.frame;
    r2.origin.x = r.origin.x + size.width;
    capacityUnitLabel.frame = r2;
    
    long bytes = monthStats.bytesBefore - monthStats.bytesAfter;
    float mbytes = bytes / (1024.0f * 1024.0f);
    NSString *s2 = [NSString stringWithFormat:@"%.2f", quantity - mbytes ];
    size = [s2 sizeWithFont:[UIFont boldSystemFontOfSize:12]];
    r = balanceLabel.frame;
    r.size.width = size.width;
    balanceLabel.frame = r;
    balanceLabel.text = s2;
    
    r2 = balanceUnitLabel.frame;
    r2.origin.x = r.origin.x + size.width;
    balanceUnitLabel.frame = r2;
    
    int level = [AppDelegate getAppDelegate].user.level;
    levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%d.png", level]];
    
    NSString* levelName =  NSLocalizedString(@"levelName1",nil);
    switch (level) {
        case 1:
            levelName = NSLocalizedString(@"levelName1",nil);
            break;
        case 2:
            levelName = NSLocalizedString(@"levelName2",nil); 
            break;
        case 3:
            levelName = NSLocalizedString(@"levelName3",nil);
            break;
        case 4:
            levelName = NSLocalizedString(@"levelName4",nil);
            break;
        case 5:
            levelName = NSLocalizedString(@"levelName5",nil);
            break;
        case 6:
            levelName = NSLocalizedString(@"levelName6",nil); 
            break;
        case 7:
            levelName = NSLocalizedString(@"levelName7",nil);
            break;
        default:
            break;
    }
    levelLabel.text = levelName;
    
    //刷新刻度盘
    [dialView refreshCapacity];
    dialView.totalStats = totalStats;
    
    //如果容量有增加，显示动画
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.oldCapacity < user.capacity ) {
        float f = user.capacity - user.oldCapacity;
        [caView setCapacity:f];

        user.oldCapacity = user.capacity;
        [UserSettings saveOldCapacity:user.capacity];
        
        caView.hidden = NO;
        caView.frame = CGRectMake( CA_CENTERX - CA_WIDTH / 2, CA_CENTERY - CA_HEIGHT / 2, CA_WIDTH, CA_HEIGHT);
        [self performSelector:@selector(scaleCapacityView) withObject:nil afterDelay:0.5];
    }
    else {
        caView.hidden = YES;
    }
    
    //显示套餐数据
    if ( iPhone5 ) {
        [self showTCDataForIPhone5];
    }
    else {
        [self showTCData];
    }
}


#pragma mark - taocan methods

//流量校准按钮
- (void) openTaocanSetting
{
    TCAdjustViewController* controller = [[TCAdjustViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) showTCData
{
    UIFont* font = [UIFont systemFontOfSize:13];

    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* tcTotal = user.ctTotal;
    NSString* tcDay = user.ctDay;

    if ( !tcTotal || tcTotal.length==0 || !tcDay || tcDay.length==0 ) {
        NSString* taocanText=  NSLocalizedString(@"taocan.label.text",nil);
        taocanLabel.text = taocanText;
        taocanLeftLabel.hidden = YES;
        taocanUnitLabel.hidden = YES;
        
        CGSize size = [taocanLabel.text sizeWithFont:font];
        CGRect rect = taocanLabel.frame;
        rect.origin.x = (320 - size.width) / 2;
        rect.size.width = size.width;
        taocanLabel.frame = rect;
        return;
    }
    
    taocanLeftLabel.hidden = NO;
    taocanUnitLabel.hidden = NO;
    
    float used = [user getTcUsed] / 1024.0f / 1024.0f;
    float total = [tcTotal floatValue];
    if ( total > 0 ) {
        float percent = used / total;
        if ( percent >= 0.9 ) {
            taocanLeftLabel.textColor = [UIColor redColor];
        }
        else if ( percent >= 0.8 ) {
            taocanLeftLabel.textColor = [UIColor yellowColor];
        }
        else {
            taocanLeftLabel.textColor = [UIColor greenColor];
        }
    }
    
    //NSString* totalstr = [NSString stringWithFloatTrim:total decimal:1];
    NSString* usedstr = [NSString stringWithFloatTrim:used decimal:2];
    
    NSString* taocanText1=  NSLocalizedString(@"taocan.label.text1",nil);
    NSString* taocanText2=  NSLocalizedString(@"taocan.label.text2",nil);
    NSString* text1 = [NSString stringWithFormat:@"%@%@M，%@", taocanText1,usedstr,taocanText2 ];
    taocanLabel.text = text1;
    
    NSString* text2 = [NSString stringWithFormat:@"%.2f", total - used];
    taocanLeftLabel.text = text2;
    
    CGFloat width1 = [text1 sizeWithFont:font].width;
    CGFloat width2 = [text2 sizeWithFont:font].width;
    CGFloat width3 = [@"M" sizeWithFont:font].width;
    
    CGFloat x = (290 - (width1 + width2 + width3 )) / 2;
    CGRect rect = taocanLabel.frame;
    rect.origin.x = x;
    rect.size.width = width1;
    taocanLabel.frame = rect;
    
    rect.origin.x = x + width1;
    rect.size.width = width2;
    taocanLeftLabel.frame = rect;
    
    rect.origin.x = x + width1 + width2;
    rect.size.width = width3;
    taocanUnitLabel.frame = rect;
}


- (void) showTCDataForIPhone5
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* tcTotal = user.ctTotal;
    NSString* tcDay = user.ctDay;
    
    if ( !tcTotal || tcTotal.length==0 || !tcDay || tcDay.length==0 ) {
        taocanLabel.hidden = YES;
        taocanLabel2.hidden = YES;
        taocanLeftLabel.hidden = YES;
        taocanUnitLabel.hidden = YES;
        taocanUsedLabel.hidden = YES;
        taocanUsedUnitLabel.hidden = YES;
        taocanAdjectButton.hidden = YES;
        taocanBarBgImageView.hidden = YES;
        taocanBarTriangleImageView.hidden = YES;
        taocanUsedBarImageView.hidden = YES;
        taocanExceedBarImageView.hidden = YES;
        taocanAxisLabel1.hidden = YES;
        taocanAxisLabel2.hidden = YES;
        taocanAxisLabel3.hidden = YES;
        taocanAxisLabel4.hidden = YES;
        taocanAxisLabel5.hidden = YES;
        taocanAxisUsedLabel.hidden = YES;
        taocanButton.hidden = NO;
    }
    else {
        taocanLabel.hidden = NO;
        taocanLabel2.hidden = NO;
        taocanLeftLabel.hidden = NO;
        taocanUnitLabel.hidden = NO;
        taocanUsedLabel.hidden = NO;
        taocanUsedUnitLabel.hidden = NO;
        taocanAdjectButton.hidden = NO;
        taocanButton.hidden = YES;
        
        taocanBarBgImageView.hidden = NO;
        taocanUsedBarImageView.hidden = NO;
        taocanAxisLabel1.hidden = NO;
        taocanAxisLabel2.hidden = NO;
        taocanAxisLabel3.hidden = NO;
        taocanAxisLabel4.hidden = NO;
        taocanAxisLabel5.hidden = NO;
        taocanAxisUsedLabel.hidden = NO;
        
        float used = [user getTcUsed] / 1024.0f / 1024.0f;
        float total = [tcTotal floatValue];
        float left = total - used;
        
        UIFont* font = [UIFont boldSystemFontOfSize:17];
        NSString* usedstr = [NSString stringWithFloatTrim:used decimal:2];
        NSString* leftstr = [NSString stringWithFloatTrim:left decimal:2];
        CGFloat usedWidth = [usedstr sizeWithFont:font].width;
        CGFloat leftWidth = [leftstr sizeWithFont:font].width;
        
        taocanUsedLabel.text = usedstr;
        taocanLeftLabel.text = leftstr;
        
        CGRect frame = taocanUsedLabel.frame;
        frame.size.width = usedWidth;
        taocanUsedLabel.frame = frame;
        
        frame = taocanUsedUnitLabel.frame;
        frame.origin.x = taocanUsedLabel.frame.origin.x + taocanUsedLabel.frame.size.width + 1;
        taocanUsedUnitLabel.frame = frame;
        
        frame = taocanLabel2.frame;
        frame.origin.x = taocanUsedUnitLabel.frame.origin.x + taocanUnitLabel.frame.size.width + 5;
        taocanLabel2.frame = frame;
        
        frame = taocanLeftLabel.frame;
        frame.origin.x = taocanLabel2.frame.origin.x + taocanLabel2.frame.size.width;
        frame.size.width = leftWidth;
        taocanLeftLabel.frame = frame;
        
        frame = taocanUnitLabel.frame;
        frame.origin.x = taocanLeftLabel.frame.origin.x + taocanLeftLabel.frame.size.width + 1;
        taocanUnitLabel.frame = frame;
        
        float totalWidth = 278;
        
        if ( used < total ) {
            taocanBarTriangleImageView.hidden = YES;
            taocanExceedBarImageView.hidden = YES;
            
            float percent = used / total;
            if ( percent >= 0.9 ) {
                taocanLeftLabel.textColor = [UIColor redColor];
                taocanUsedBarImageView.image = [[UIImage imageNamed:@"ds_tc_bar_red.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:4];
            }
            else if ( percent >= 0.8 ) {
                taocanLeftLabel.textColor = [UIColor yellowColor];
                taocanUsedBarImageView.image = [[UIImage imageNamed:@"ds_tc_bar_oringe.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:4];
            }
            else {
                taocanLeftLabel.textColor = [UIColor greenColor];
                taocanUsedBarImageView.image = [[UIImage imageNamed:@"ds_tc_bar_green.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:4];
            }
            
            frame = taocanBarBgImageView.frame;
            frame.origin.x++;
            frame.origin.y++;
            frame.size.height = frame.size.height - 2;
            frame.size.width = totalWidth * percent;
            taocanUsedBarImageView.frame = frame;
            
            taocanAxisUsedLabel.text = [NSString stringWithFormat:@"%@M", [NSString stringWithFloatTrim:used decimal:2]];
        }
        else {
            taocanBarTriangleImageView.hidden = NO;
            taocanExceedBarImageView.hidden = NO;
            
            float limit = total;
            total = used;
            float percent = limit / total;
            
            taocanUsedBarImageView.image = [[UIImage imageNamed:@"ds_tc_bar_green2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:4];
            frame = taocanBarBgImageView.frame;
            frame.origin.x++;
            frame.origin.y++;
            frame.size.height = frame.size.height - 2;
            frame.size.width = totalWidth * percent;
            if ( frame.size.width > 270 ) frame.size.width = 270;
            taocanUsedBarImageView.frame = frame;
            
            taocanExceedBarImageView.image = [[UIImage imageNamed:@"ds_tc_bar_red2.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
            frame.origin.x = frame.origin.x + frame.size.width;
            frame.size.width = totalWidth - frame.size.width;
            taocanExceedBarImageView.frame = frame;
            
            frame.origin.x = frame.origin.x - 2;
            frame.origin.y = frame.origin.y - 3;
            frame.size.width = 5;
            frame.size.height = 4;
            taocanBarTriangleImageView.frame = frame;

            taocanAxisUsedLabel.text = [NSString stringWithFormat:@"%@M", [NSString stringWithFloatTrim:limit decimal:2]];
        }
        
        CGSize size = [taocanAxisUsedLabel.text sizeWithFont:TAOCAN_AXIS_FONT];
        frame = taocanAxisLabel1.frame;
        frame.size.width = size.width;
        frame.origin.x = taocanUsedBarImageView.frame.origin.x + taocanUsedBarImageView.frame.size.width - size.width / 2;
        taocanAxisUsedLabel.frame = frame;

        for ( int i=0; i<5; i++ ) {
            [self layoutTaocanAxisLabel:i total:total];
        }
    }
    
}


- (void) layoutTaocanAxisLabel:(int)count total:(float)total
{
    NSString* s = nil;
    if ( count == 4 ) {
        s = [NSString stringWithFormat:@"%dM", (int)total];
    }
    else {
        float f = (total / 4) * count;
        s = [NSString stringWithFormat:@"%dM", (int)f];
    }

    CGSize size = [s sizeWithFont:TAOCAN_AXIS_FONT];
    CGRect frame = taocanAxisLabel1.frame;
    frame.size.width = size.width;
    frame.origin.x = taocanBarBgImageView.frame.origin.x + (taocanBarBgImageView.frame.size.width / 4) * count - size.width / 2;
    UILabel* label = nil;
    
    switch (count) {
        case 0:
            label = taocanAxisLabel1;
            break;
        case 1:
            ;
            label = taocanAxisLabel2;
            label.frame = frame;
            label.text = s;
            break;
        case 2:
            ;
            label = taocanAxisLabel3;
            label.frame = frame;
            label.text = s;
            break;
        case 3:
            ;
            label = taocanAxisLabel4;
            label.frame = frame;
            label.text = s;
            break;
        case 4:
            ;
            label = taocanAxisLabel5;
            frame.origin.x = 305 - frame.size.width;
            label.frame = frame;
            label.text = s;
            break;
        default:
            break;
    }
    
    CGRect usedFrame = taocanAxisUsedLabel.frame;
    if ( [self overlayXRect:frame with:usedFrame] ) {
        label.hidden = YES;
    }
    else {
        label.hidden = NO;
    }
}


- (BOOL) overlayXRect:(CGRect)rect1 with:(CGRect)rect2
{
    float s1 = rect1.origin.x;
    float e1 = rect1.origin.x + rect1.size.width;
    float s2 = rect2.origin.x;
    float e2 = rect2.origin.x + rect2.size.width;
    BOOL b = (e2 >= s1) && (s2 < e1);
    return b;
}

#pragma mark - operation methods

- (void) showLevelDesc
{
    LevelViewController* controller = [[LevelViewController alloc] init];
    controller.showCloseButton = YES;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [nav release];
    [controller release];
}


- (void) installAPNProfile
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_NO ) {
        InstallProfileViewController* controller = [[InstallProfileViewController alloc] init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentModalViewController:nav animated:YES];
        
        NSString* title =  NSLocalizedString(@"installProfile.title",nil);
        controller.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:controller action:@selector(closeModal)] autorelease];
        [controller release];
        [nav release];
    }
    else if ( user.proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
        //安装当前机房的profile
        NSString* code = user.idcCode;
        [AppDelegate installProfile:@"current" idc:code];
    }
}


- (IBAction) inviteFriend
{
    NSString* title =  NSLocalizedString(@"inviteFriend.title",nil);
    NSString* cancleButtonTitle =  NSLocalizedString(@"inviteFriend.cancle.title",nil);
    NSString* sendMailButtonTitle =  NSLocalizedString(@"sendMail.title",nil);
    NSString* sendSMSButtonTitle =  NSLocalizedString(@"sendSMS.title",nil);
    NSString* sendWeiboButtonTitle =  NSLocalizedString(@"sendWeibo.title",nil);
    NSString* sendRenRenButtonTitle =  NSLocalizedString(@"sendRenRen.title",nil);
    NSString* sendWeixinGroupButtonTitle =  NSLocalizedString(@"sendWeixinGroup.title",nil);
    NSString* sendWeixinFriendButtonTitle =  NSLocalizedString(@"sendWeixinFriend.title",nil);
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles:sendMailButtonTitle,sendSMSButtonTitle,sendWeiboButtonTitle,sendRenRenButtonTitle,
//        sendWeixinFriendButtonTitle, sendWeixinGroupButtonTitle, nil];
//
//    CGRect rect = CGRectMake(10, 10, 300, 460);
//    alertView.frame = rect;
//    
//    alertView.tag = TAG_ALERT_INVITE;
//    [alertView show];
//    [alertView release];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self
            cancelButtonTitle:cancleButtonTitle destructiveButtonTitle:nil
            otherButtonTitles:sendMailButtonTitle,sendSMSButtonTitle,sendWeiboButtonTitle,sendRenRenButtonTitle,
                sendWeixinFriendButtonTitle, sendWeixinGroupButtonTitle, nil];
    actionSheet.tag = TAG_ALERT_INVITE;
    [actionSheet showInView:self.tabBarController.view];
}

#pragma mark -------------------------注册按钮
- (IBAction) registerPhone
{
    LoginNewViewController* controller = [[LoginNewViewController alloc] init];
    NSString* title =  NSLocalizedString(@"cancleName",nil);
    controller.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:controller action:@selector(close)] autorelease];

    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) showSetting
{
    SettingViewController* controller = [[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void) showDatastats1
{
    DatastatsScrollViewController* controller = [[DatastatsScrollViewController alloc] init];

    time_t now;
    time( &now );
    
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];

    controller.startTime = peroid[0];
    controller.endTime = peroid[1];
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UIAlertView Delegate


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( actionSheet.tag == TAG_ALERT_INVITE ) {
        NSString* subject =  NSLocalizedString(@"sendMail.subject",nil);
        NSString* text =  nil;
        
        if ( buttonIndex == 4 || buttonIndex == 5 ) {
            //微信
            text = [NSString stringWithFormat:@"%@http://%@/%@/%@.html %@",
                    NSLocalizedString(@"sendMail.text.weixin1",nil), 
                    P_HOST, @"sns", [OpenUDID value],
                    NSLocalizedString(@"sendMail.text.weixin2",nil)];
        }
        else {
            text = [NSString stringWithFormat:@"%@http://%@/%@/%@.html",
                              NSLocalizedString(@"sendMail.text",nil), 
                              P_HOST, buttonIndex==0 ? @"email" : @"sms",
                              [OpenUDID value]];
        }
        
        NSString* sns = @"sinaWeibo";
        if ( buttonIndex == 0 ) {
            [self sendMail:subject body:text];
        }
        else if ( buttonIndex == 1 ) {
            [self sendSMS:text];
        }
        else if(buttonIndex == 2){
            [self sendSNS:sns];
        }
        else if(buttonIndex == 3){
            sns = @"renren";
            [self sendSNS:sns];
        }
        else if ( buttonIndex == 4 ) {
            [self sendWeixin:WXSceneSession text:text];
        }
        else if ( buttonIndex == 5 ) {
            [self sendWeixin:WXSceneTimeline text:text];
        }
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == TAG_ALERT_TAOCAN ) {
        
    }
}


- (void)willPresentAlertView:(UIAlertView *)alertView
{
    CGRect frame = alertView.frame;
    if( alertView.tag == TAG_ALERT_TAOCAN ) {
        frame.origin.y = 90;
        frame.size.height = 200;
        alertView.frame = frame;
        
        for( UIView * view in alertView.subviews ) {
            if( [view isKindOfClass:[UIButton class]] ) {
                CGRect btnFrame = view.frame;
                btnFrame.origin.y += 110;
                view.frame = btnFrame;
            }
        }
        
        CGFloat y = 30;
        UILabel* label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"flow.all",nil);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentRight;
        label.frame = CGRectMake( 20, y, 120, 30);
        label.backgroundColor = [UIColor clearColor];
        [alertView addSubview:label];
        
        UITextField* textField = [[[UITextField alloc] init] autorelease];//这里创建一个UITextField对象
        textField.frame = CGRectMake( 150, y, frame.size.width - 170, 30 );
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [alertView addSubview:textField];

        y = 80;
        label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"flow.used",nil);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentRight;
        label.frame = CGRectMake( 20, y, 120, 30);
        label.backgroundColor = [UIColor clearColor];
        [alertView addSubview:label];
        
        textField = [[[UITextField alloc] init] autorelease];//这里创建一个UITextField对象
        textField.frame = CGRectMake( 150, y, frame.size.width - 170, 30 );
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [alertView addSubview:textField];
    }
}


#pragma mark - touched view Delegate

- (void) showDatastats
{
    UINavigationController* nav = [[AppDelegate getAppDelegate].tabBarController.viewControllers objectAtIndex:1];
    for ( UIViewController* c in nav.viewControllers ) {
        if ( [c isKindOfClass:[DatastatsScrollViewController class]] ) {
            DatastatsScrollViewController* controller = (DatastatsScrollViewController*)c;
            [controller monthSliderNow]; 
            [AppDelegate getAppDelegate].tabBarController.selectedIndex = 1;
        }
    }
}


- (void) viewTouchesBegan:(UIView*)v
{
    if ( [v isKindOfClass:[DatasaveDialView class]] ) {
        UIColor* color = v.backgroundColor;
        [v setBackgroundColor:[UIColor colorWithRed:0.0 green:0.5f blue:1.0f alpha:0.8f]];
        [v performSelector:@selector(setBackgroundColor:) withObject:color afterDelay:0.3];
        [self performSelector:@selector(showDatastats) withObject:color afterDelay:0.1];
        //[self showDatastats];
    }
}


#pragma mark - sms methods

- (void) sendSMS:(NSString*)body
{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet:body];
		}
		else {
            NSString* content= NSLocalizedString(@"device.sendSMS.invalid.content",nil);
            NSString* message= NSLocalizedString(@"device.sendSMS.invalid.message",nil);
            [AppDelegate showAlert:content message:message];
		}
	}
	else {
        NSString* content= NSLocalizedString(@"ios.sendSMS.invalid.content",nil);
        NSString* message= NSLocalizedString(@"ios.sendSMS.invalid.message",nil);
        [AppDelegate showAlert:content message:message];
	}
}


- (void) displaySMSComposerSheet:(NSString*)body
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.body = body;
    NSString* title = NSLocalizedString(@"sms.picker.title",nil);
    picker.title = title;
    
    [self.navigationController presentModalViewController:picker animated:YES];
	[picker release];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)messageComposeViewController
				 didFinishWithResult:(MessageComposeResult)result {
	switch (result)
	{
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
            [AppDelegate showAlert: NSLocalizedString(@"sms.send.success", nil)];
			break;
		case MessageComposeResultFailed:
            [AppDelegate showAlert:NSLocalizedString(@"sms.send.fail", nil)];
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - email

- (void) sendMail:(NSString*)subject body:(NSString*)body
{
    NSString *mailTo = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@",
                        [subject encodeAsURIComponent],
                        [body encodeAsURIComponent]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailTo]];
}

-(void)sendSNS:(NSString*)sns
{
   
    UIViewController* controller = [[AppDelegate getAppDelegate] currentViewController];
    if ( [controller respondsToSelector:@selector(shareToSNS:)]) {
        [controller performSelector:@selector(shareToSNS:) withObject:sns afterDelay:0.3f];
    }
}


- (void) shareToSNS:(NSString*)sns
{
    
    NSString* deviceId = [OpenUDID value];
    NSString* snsText =  NSLocalizedString(@"sendMail.text",nil);
    NSString* content = [NSString stringWithFormat:@"%@ http://%@/social/%@.html",snsText, P_HOST, deviceId];
    
    NSData* image = [self captureScreen];
    
    ShareToSNSViewController* controller = [[ShareToSNSViewController alloc] init];
    controller.sns = sns;
    controller.content = content;
    controller.image = image;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [[[AppDelegate getAppDelegate] currentNavigationController] presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) sendWeixin:(enum WXScene)scene text:(NSString*)text
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = text;
    req.scene = scene;
    NSLog(@"text = %@",text);
    if ([WXApi isWXAppInstalled]) {
         [WXApi sendReq:req];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:@"您的设备没有安装微信哦，请选择其他方式共享给朋友吧！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
   
}


- (UIImage*) captureScreenImage
{
    UIGraphicsBeginImageContext( contentView.bounds.size );
    
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *aImage =UIGraphicsGetImageFromCurrentImageContext();

    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    return aImage;
}


- (NSData*) captureScreen
{
    UIImage* aImage = [self captureScreenImage];
    
    //以png格式返回指定图片的数据
    NSData* imageData = UIImageJPEGRepresentation( aImage, 0.6 );
    return imageData;
    
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self getAccessData:YES];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)v{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:v];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)v willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:v];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


- (void) setLastUpdateDate
{
    NSString* refreshDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
    if ( refreshDate && _refreshHeaderView ) {
        [_refreshHeaderView setLastUpdatedDate:refreshDate];
    }
}


@end
