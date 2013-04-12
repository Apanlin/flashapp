//
//  HelpNetBadViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "HelpNetBadViewController.h"
#import "HelpViewController.h"
#import "FeedbackViewController.h"
#import "IDCPickerViewController.h"
#import "HelpItemView.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "Reachability.h"
#import "TFConnection.h"

#define TAG_RESULT_VIEW 101

#define FONT_RESULT_TEXT [UIFont systemFontOfSize:15]

@interface HelpNetBadViewController ()

@end

@implementation HelpNetBadViewController

@synthesize checkType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) loadView
{
    UIView* myView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)] autorelease];
    myView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
    
    self.navigationItem.title = @"诊断与帮助";
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 12, 12)];
    imageView.image = [UIImage imageNamed:@"help_prismatic.png"];
    [myView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 260, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    if ( checkType == CONN_CHECK_BAD ) {
        label.text = @"无法使用网络?";
    }
    else {
        label.text = @"网速慢?";
    }
    [myView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 300, 100)];
    imageView.image = [[UIImage imageNamed:@"help_triangle_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:20];
    [myView addSubview:imageView];
    [imageView release];

    cellItem = [[HelpItemView alloc] initWithFrame:CGRectMake(10, 65, 300, 30)];
    cellItem.icon = HELP_CELL_ICON_WAIT;
    [myView addSubview:cellItem];
    [cellItem release];
    
    flashappItem = [[HelpItemView alloc] initWithFrame:CGRectMake(10, 95, 300, 30)];
    flashappItem.icon = HELP_CELL_ICON_WAIT;
    [myView addSubview:flashappItem];
    [flashappItem release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 145, 300, 270)];
    imageView.image = [[UIImage imageNamed:@"help_result_bg.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:33];
    [myView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 153, 15, 9)];
    imageView.image = [UIImage imageNamed:@"help_key.png"];
    [myView addSubview:imageView];
    [imageView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(40, 147, 250, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"结果与建议";
    [myView addSubview:label];
    [label release];
    
    self.view = myView;
    
    if ( checkType == CONN_CHECK_BAD ) {
        cellItem.message = @"监测本机2G/3G网络连接";
        flashappItem.message = @"监测飞速压缩服务器";
    }
    else {
        self.navigationItem.title = @"网速慢?";
        cellItem.message = @"监测本机2G/3G网络网速";
        flashappItem.message = @"监测飞速压缩服务器网速";
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(check) withObject:nil afterDelay:0.3f];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - check methods


- (void) check
{
    cellItem.icon = HELP_CELL_ICON_DOING;
    [self createCheckcellDoningView];
    
    [self checkReachable];
}


- (void) checkReachable
{
    Reachability* reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    if (  status == NotReachable ) {
        cellItem.icon = HELP_CELL_ICON_WRONG;
        [self createNetworkDisableView];
        return;
    }
    
    [self checkCellNetwork];
}


- (void) checkCellNetwork
{
    NSOperationQueue* queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue setMaxConcurrentOperationCount:1];
    NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(connectToBaidu) object:nil];
    [queue addOperation:operation];
    [operation release];
}


- (void) connectToBaidu
{
    time_t startTime;
    time( &startTime );
    [TFConnection socketConnect:@"www.baidu.com" port:80];
    time_t endTime;
    time( &endTime );

    NSNumber* period = [NSNumber numberWithLong:(endTime - startTime)];
    [self performSelectorOnMainThread:@selector(checkCellNetworkCallback:) withObject:period waitUntilDone:NO];
}


- (void) checkCellNetworkCallback:(NSNumber*)period
{
    long l = [period longValue];
    if ( l > 5 ) {
        cellItem.icon = HELP_CELL_ICON_SLOW;
        [self createNetworkSlowView];
        return;
    }
    
    cellItem.icon = HELP_CELL_ICON_OK;
    flashappItem.icon = HELP_CELL_ICON_DOING;
    [self createFlashappDoningView];
    [self checkFlashappServer];
}


- (void) checkFlashappServer
{
    InstallFlag flag = [AppDelegate getAppDelegate].user.proxyFlag;
    if ( flag == INSTALL_FLAG_NO ) {
        flashappItem.icon = HELP_CELL_ICON_OK;
        [self createOKView];
        return;
    }

    NSOperationQueue* queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue setMaxConcurrentOperationCount:1];
    NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(connectFlashapp) object:nil];
    [queue addOperation:operation];
    [operation release];
}


- (void) connectFlashapp
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    time_t startTime;
    time( &startTime );
    [TFConnection httpGet2:user.idcServer port:80 location:@"/speed.txt"];
    time_t endTime;
    time( &endTime );
    
    NSNumber* period = [NSNumber numberWithLong:(endTime - startTime)];
    [self performSelectorOnMainThread:@selector(checkFlashappServerCallback:) withObject:period waitUntilDone:NO];
}


- (void) checkFlashappServerCallback:(NSNumber*)peroid
{
    long time = [peroid longValue];
    if ( time > 10 ) {
        //无法到达
        flashappItem.icon = HELP_CELL_ICON_WRONG;
        [self createflashAppDisableView];
    }
    else if ( time > 5 ) {
        //速度慢
        if ( checkType == CONN_CHECK_BAD ) {
            flashappItem.icon = HELP_CELL_ICON_SLOW;
            [self createflashAppSlowView];
        }
        else {
            //为用户选择机房
            flashappItem.icon = HELP_CELL_ICON_SLOW;
            [self createFlashappSelectIDCView];
        }
    }
    else {
        //正常速度
        flashappItem.icon = HELP_CELL_ICON_OK;
        [self createOKView];
    }
}


#pragma mark - create views


- (void) createOKView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 231)] autorelease];
    theView.tag = TAG_RESULT_VIEW;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"2G/3G网络连接正常";
    [theView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"飞速压缩服务器工作正常";
    [theView addSubview:label];
    [label release];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"我知道啦" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(60, 70, 160, 33);
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:button];

    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 186, 190, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    label.text = @"如果应用依然无法上网，请提交应用名称，我们会尽快处理。";
    [theView addSubview:label];
    [label release];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 200, 195, 80, 30);
    image = [[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"意见反馈" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:button];
    
    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}


- (void) createCheckcellDoningView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 108)] autorelease];
    theView.tag = TAG_RESULT_VIEW;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"正在检测本机2G/3G网速，请稍候...";
    [theView addSubview:label];
    [label release];
    
    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}


- (void) createFlashappDoningView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 108)] autorelease];
    theView.tag = TAG_RESULT_VIEW;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"本机2G/3G网络连接正常";
    [theView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"正在检测飞速服务器网速，请稍候...";
    [theView addSubview:label];
    [label release];

    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}


- (void) createNetworkDisableView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 108)] autorelease];
    theView.tag = TAG_RESULT_VIEW;

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"网络连接不可用";
    [theView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 38, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];

    UIFont* font = [UIFont systemFontOfSize:13];

    label = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 240, 35)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    label.text = @"进入“设置-通用-网络”，查看蜂窝数据是否打开（3G用户查看3G开关是否开启）;";
    [theView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 75, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];

    label = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 240, 15)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    label.text = @"联系运营商，确认网络服务是否正常;";
    [theView addSubview:label];
    [label release];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 95, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 240, 15)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    label.text = @"发送邮件给我们：contact@flashapp.cn;";
    [theView addSubview:label];
    [label release];
    
    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}



- (void) createNetworkSlowView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 108)] autorelease];
    theView.tag = TAG_RESULT_VIEW;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 50)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"您目前的2G/3G网速非常慢，请检查网络设置，或咨询当地运营商^.^";
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    [theView addSubview:label];
    [label release];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"稍后再试" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(60, 70, 160, 33);
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:button];

    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}


- (void) createflashAppDisableView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 108)] autorelease];
    theView.tag = TAG_RESULT_VIEW;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"2G/3G网络连接正常";
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    [theView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 50)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"无法到达飞速代理服务器，建议移除描述文件，暂停压缩服务。";
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    [theView addSubview:label];
    [label release];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"移除描述文件" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.frame = CGRectMake(52, 90, 160, 33);
    [button addTarget:self action:@selector(removeProfile) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:button];

    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}


- (void) createflashAppSlowView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 108)] autorelease];
    theView.tag = TAG_RESULT_VIEW;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"2G/3G网络连接正常";
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    [theView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 50)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"到达飞速代理服务器时间过长，建议暂停压缩服务。";
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    [theView addSubview:label];
    [label release];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"暂停压缩服务" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(52, 90, 160, 33);
    [button addTarget:self action:@selector(pauseFlashAppService) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:button];

    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}


- (void) createFlashappSelectIDCView
{
    UIView* theView = [[[UIView alloc] initWithFrame:CGRectMake(15, 175, 290, 108)] autorelease];
    theView.tag = TAG_RESULT_VIEW;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"2G/3G网络连接正常";
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    [theView addSubview:label];
    [label release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 4, 4)];
    imageView.image = [UIImage imageNamed:@"help_whitedot.png"];
    [theView addSubview:imageView];
    [imageView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 50)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_RESULT_TEXT;
    label.text = @"到达飞速代理服务器网速过慢，建议优化网速，选择最快的压缩服务器。";
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.numberOfLines = 10;
    [theView addSubview:label];
    [label release];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"网速优化" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(52, 90, 160, 33);
    [button addTarget:self action:@selector(selectIDC) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:button];
    
    UIView* v = [self.view viewWithTag:TAG_RESULT_VIEW];
    if ( v ) [v removeFromSuperview];
    [self.view addSubview:theView];
}


- (void) refreshProfileStatus
{
    /*
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_NO ) {
        //profile已经被卸载或暂停
        UIView* view = [self.view viewWithTag:TAG_FLASHAPP_SLOW_VIEW];
        if ( view ) {
            [view removeFromSuperview];
        }
        
        flashappItem.icon = HELP_CELL_ICON_OK;
        flashappItem.message = @"压缩服务已经暂停";
    }
    else {
        UISwitch* switcher = (UISwitch*) [self.view viewWithTag:TAG_PROFILE_SWITCHER];
        if ( switcher ) {
            switcher.on = YES;
        }
    }*/
}


#pragma mark - operation methods

- (void) openSettingNetwork
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
}


- (void) removeProfile
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    HelpViewController* controller = [[HelpViewController alloc] init];
    controller.showCloseButton = YES;
    if ( [@"vpn" isEqualToString:user.stype] ) {
        controller.page = @"profile/YDD";
    }
    else {
        controller.page = @"profile/YDD";
    }
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) pauseFlashAppService
{
    [AppDelegate uninstallProfile:@"datasave"];
}


- (void) selectIDC
{
    IDCPickerViewController* controller = [[IDCPickerViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
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


- (void) close
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
