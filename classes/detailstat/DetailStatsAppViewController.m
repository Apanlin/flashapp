//
//  DetailStatsAppViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-9-1.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "DetailStatsAppViewController.h"
#import "AppDelegate.h"
#import "StatsDayDAO.h"
#import "StatsDetailDAO.h"
#import "UserAgentLockDAO.h"
#import "StatsDetail.h"
#import "userAgentLock.h"
#import "AppInfo.h"
#import "TCUtils.h"
#import "StringUtil.h"
#import "DateUtils.h"


#define TAG_FAVORITE_BG_IMAGEVIEW 101

#define TAG_PREV_MONTH_BUTTON 101
#define TAG_NEXT_MONTH_BUTTON 102
#define TAG_MONTH_LABEL 103
#define TAG_DETAIL_BG_IMAGEVIEW 104
#define TAG_SHARE_BUTTON 105
#define TAG_DISABLE_NETWORK_BUTTON 107
#define TAG_LINECHART_BG_IMAGEVIEW 108
#define TAG_BYTE_UNIT_LABEL   109
#define TAG_PERCENT_LABEL 110
#define TAG_TOTAL_LABEL 111


@interface DetailStatsAppViewController ()

@end

@implementation DetailStatsAppViewController

@synthesize startTime;
@synthesize endTime;
@synthesize userAgent;
@synthesize uaStr;
@synthesize userAgentData;
@synthesize agentLock;
@synthesize appsScrollview;
@synthesize pageControl;


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
    [userAgent release];
    [uaStr release];
    [userAgentData release];
    [recommendApps release];
    [UserAgentLock release];

    [chart release];
    [appsScrollview release];
    [pageControl release];
    [super dealloc];
}


- (void) loadView
{
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(close)] autorelease];
    self.navigationItem.title = self.userAgent;
    
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"DetailStatsAppViewController" owner:self options:nil];
    UIView* myView = [array objectAtIndex:0];
    UIImageView* imageView = (UIImageView*) [myView viewWithTag:TAG_FAVORITE_BG_IMAGEVIEW];
    imageView.image = [[UIImage imageNamed:@"help_ok_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
    
    self.view = myView;
    
    
    array = [[NSBundle mainBundle] loadNibNamed:@"DetailStatsAppGraph" owner:self options:nil];
    graphView = [array objectAtIndex:0];
    graphView.frame = CGRectMake(10, 0, 300, 270);
    [self.view addSubview:graphView];
    
    imageView = (UIImageView*) [graphView viewWithTag:TAG_DETAIL_BG_IMAGEVIEW];
    imageView.image = [[UIImage imageNamed:@"help_ok_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];

    //imageView = (UIImageView*) [graphView viewWithTag:TAG_LINECHART_BG_IMAGEVIEW];
    //imageView.image = [[UIImage imageNamed:@"appdetail_grid.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:3];
    
    UIButton* button = (UIButton*) [graphView viewWithTag:TAG_PREV_MONTH_BUTTON];
    [button addTarget:self action:@selector(slidePrevMonth) forControlEvents:UIControlEventTouchUpInside];
    
    button = (UIButton*) [graphView viewWithTag:TAG_NEXT_MONTH_BUTTON];
    [button addTarget:self action:@selector(slideNextMonth) forControlEvents:UIControlEventTouchUpInside];
    
    button = (UIButton*) [graphView viewWithTag:TAG_DISABLE_NETWORK_BUTTON];
    [button addTarget:self action:@selector(clickUserAgentNetworkButton) forControlEvents:UIControlEventTouchUpInside];
    if ([self.userAgent isEqualToString:@"网页"]) {
        
        button.hidden = YES;
    }else
    {
        button.hidden = NO;
    }
    
    
    chartHostingView = [[UIView alloc] initWithFrame:CGRectMake(3, 130, 294, 200)];
    chartHostingView.backgroundColor = [UIColor clearColor];
    [graphView addSubview:chartHostingView];
    [chartHostingView release];
    
    chart = [[DetailStatsAppLineChart alloc] init];
    chart.userAgent = self.userAgent;

    recommendApps = [[NSMutableArray alloc] init];
    for ( int i=0; i<10; i++ ) {
        AppInfo* app = [[AppInfo alloc] init];
        app.displayName = [NSString stringWithFormat:@"app-%d", i];
        [recommendApps addObject:app];
        [app release];
    }
    
    [self loadData];

    [self showMonthData];
    [self showRecommendApps];
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 150, 130, 100)];
    loadingView.message = NSLocalizedString(@"set.accountView.loading.message", nil);
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];

    button = (UIButton*) [graphView viewWithTag:TAG_SHARE_BUTTON];
    [button addTarget:self action:@selector(clickUserAgentNetworkButton) forControlEvents:UIControlEventTouchUpInside];
    [graphView bringSubviewToFront:button];
    button.userInteractionEnabled = YES;
    button.enabled = YES;
}


- (void) viewWillDisappear:(BOOL)animated
{
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [chart release];
    chart = nil;
    
    self.appsScrollview = nil;
    self.pageControl = nil;
    
    [recommendApps release];
    recommendApps = nil;
    
    self.agentLock = nil;
    self.userAgentData = nil;
    
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) close
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - show & line chart

- (void) showMonthData
{
    UILabel* monthLabel = (UILabel*) [graphView viewWithTag:TAG_MONTH_LABEL];
    monthLabel.text = [TCUtils monthDescForStartTime:startTime endTime:endTime];
    
    chart.userAgentData = userAgentData;
    [chart renderInView:chartHostingView withTheme:nil];

    long long maxBytes = 0;
    for ( StatsDetail* stats in userAgentData ) {
        maxBytes = MAX( maxBytes, stats.before );
    }
    
    NSArray* arr = [NSString bytesAndUnitString:maxBytes];
    NSString* byteUnit = [[arr objectAtIndex:1] retain];
    UILabel* label = (UILabel*) [graphView viewWithTag:TAG_BYTE_UNIT_LABEL];
    label.text = byteUnit;
    
    UILabel* percentLabel = (UILabel*) [graphView viewWithTag:TAG_PERCENT_LABEL];
    UILabel* totalLabel = (UILabel*) [graphView viewWithTag:TAG_TOTAL_LABEL];
    
    long long totalBefore = 0;
    long long totalAfter = 0;
    for ( StatsDetail* stats in userAgentData ) {
        totalBefore += stats.before;
        totalAfter += stats.after;
    }
    
    if ( totalBefore > 0 ) {
        percentLabel.text = [NSString stringWithFormat:@"%.0f%%", ( 1 - (double)totalAfter / totalBefore) * 100];
    }
    else {
        percentLabel.text = @"0%";
    }

    if ( totalAfter > 0 ) {
        NSArray* arr = [NSString bytesAndUnitString:totalAfter decimal:1];
        totalLabel.text = [NSString stringWithFormat:@"压缩后%@%@", 
                           [arr objectAtIndex:0], [arr objectAtIndex:1]];
    }
    else {
        totalLabel.text = @"压缩后0M";
    }
    
    //显示是否被暂停网络链接
    [self showLockStatus];
}


- (void) showLockStatus
{
    UIButton* button = (UIButton*) [graphView viewWithTag:TAG_DISABLE_NETWORK_BUTTON];
    if ( !uaStr || [uaStr length] == 0 ) button.hidden = YES;

    //显示是否被暂停网络链接
    UserAgentLockStatus status = [agentLock lockStatus];
    
    if ( status == LOCK_STATUS_YES ) {
        [button setImage:[UIImage imageNamed:@"appdetail_resume.png"] forState:UIControlStateNormal];
    }
    else if ( status == LOCK_STATUS_EXPIRED ) {
        [button setImage:[UIImage imageNamed:@"appdetail_stop.png"] forState:UIControlStateNormal];
    }
    else {
        [button setImage:[UIImage imageNamed:@"appdetail_stop.png"] forState:UIControlStateNormal];
    }
}


- (void) showShare
{
    if ( !shareView ) {
        shareView = [[ShareView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:shareView];
        [shareView release];
    }
    
    [self.view bringSubviewToFront:shareView];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    shareView.frame = CGRectMake( 30, 60, 260, 240 );
    [shareView setNeedsDisplay];
    [shareView setNeedsLayout];
    [shareView open];
    [UIView commitAnimations];
}

- (void) showRecommendApps
{
    int count = 0;
    for ( AppInfo* app in recommendApps ) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( count * 70 + (70 - 50)/2, 15, 50, 50);
        
        NSString* icon = app.icon;
        if ( !icon ) icon = @"appdetail_icon.png";
        [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [appsScrollview addSubview:button];
        
        UILabel* label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.frame = CGRectMake( count*70, 65, 70, 16);
        label.text = [NSString stringWithFormat:@"新浪微博%d", count];
        [appsScrollview addSubview:label];
        [label release];
        
        count ++;
    }
    
    appsScrollview.contentSize = CGSizeMake( 75 * [recommendApps count], 108);
    //appsScrollview.userInteractionEnabled = NO;
    appsScrollview.pagingEnabled = YES;
    
    int total = [recommendApps count];
    if ( total % 4 == 0 ) {
        pageControl.numberOfPages = total / 4;
    }
    else {
        pageControl.numberOfPages = total / 4 + 1;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    CGPoint point = scrollView.contentOffset;
    int x = point.x;
    int page = 0;
    if ( x % 280 == 0 ) {
        page = x / 280;
    }
    else {
        page = x / 280 + 1;
    }
    NSLog(@"x=%d, page=%d", x, page );
    pageControl.currentPage = page;
}


#pragma mark - load Data

- (void) loadData
{
    self.userAgentData = [StatsDayDAO getUserAgentData:userAgent start:startTime end:endTime];
    NSMutableArray* arr = (NSMutableArray*) userAgentData;
    if ( [userAgentData count] > 0 ) {
        StatsDetail* firstStats = [userAgentData objectAtIndex:0];
        StatsDetail* lastStats = [userAgentData lastObject];
        if ( firstStats.accessDay != startTime ) {
            StatsDetail* startStats = [[StatsDetail alloc] init];
            startStats.accessDay = startTime;
            startStats.before = 0;
            startStats.after = 0;
            [arr insertObject:startStats atIndex:0];
            [startStats release];
        }
        
        if ( lastStats.accessDay != endTime ) {
            StatsDetail* endStats = [[StatsDetail alloc] init];
            endStats.accessDay = endTime;
            endStats.before = 0;
            endStats.after = 0;
            [arr addObject:endStats];
            [endStats release];
        }
    }

    StatsDetail* prevStats = [StatsDetailDAO getLastStatsDetailBefore:startTime userAgent:self.userAgent];
    StatsDetail* nextStats = [StatsDetailDAO getFirstStatsDetailAfter:endTime userAgent:self.userAgent];
    
    prevMonthTimes[0] = 0;
    prevMonthTimes[1] = 0;
    nextMonthTimes[0] = 0;
    nextMonthTimes[1] = 0;
    
    UIButton* prevButton = (UIButton*) [graphView viewWithTag:TAG_PREV_MONTH_BUTTON];
    UIButton* nextButton = (UIButton*) [graphView viewWithTag:TAG_NEXT_MONTH_BUTTON];

    if ( prevStats && prevStats.before > 0 ) {
        [TCUtils getPeriodOfTcMonth:prevMonthTimes time:prevStats.accessDay];
        prevButton.hidden = NO;
    }
    else {
        prevButton.hidden = YES;
    }
    
    if ( nextStats && nextStats.before > 0) {
        [TCUtils getPeriodOfTcMonth:nextMonthTimes time:nextStats.accessDay];
        time_t today = [DateUtils getLastTimeOfToday];
        if ( nextMonthTimes[1] > today ) {
            nextMonthTimes[1] = today;
        }
        nextButton.hidden = NO;
    }
    else {
        nextButton.hidden = YES;
    }
    
    //加载应用是否被暂停网络链接
    self.agentLock = [UserAgentLockDAO getUserAgentLock:userAgent];
    [self getUserAgentLock];
}


- (void) getUserAgentLock
{
    if ( client ) return;
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@", 
                     API_BASE, API_SETTING_UA_IS_ENABLED,
                     [uaStr encodeAsURIComponent]];
    
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetUserAgentLock:obj:)];
    url = [TwitterClient composeURLVerifyCode:url];
    [client get:url];
}


- (void) didGetUserAgentLock:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    
    //if ( tc.hasError ) {
    //    [AppDelegate showAlert:tc.errorMessage];
    //    return;
    //}
    
    if ( !obj && ![obj isKindOfClass:[NSDictionary class]] ) {
        return;
    }
    
    NSDictionary* dic = (NSDictionary*) obj;
    int lock = [[dic objectForKey:@"lk"] intValue];
    long timeLength = [[dic objectForKey:@"lkt"] intValue];
    
    if ( !agentLock ) {
        agentLock = [[UserAgentLock alloc] init];
        agentLock.userAgent = self.userAgent;
    }
    
    agentLock.isLock = lock;
    if ( lock ) {
        time_t now;
        time( &now );
        if ( timeLength == 0 ) {
            agentLock.timeLengh = 0;
        }
        else {
            agentLock.timeLengh = timeLength * 60;
        }
    }
    [self showLockStatus];
    [UserAgentLockDAO updateUserAgentLock:agentLock];
}


#pragma mark - slide methods

- (void) slidePrevMonth
{
    if ( prevMonthTimes[0] > 0 ) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        
        self.startTime = prevMonthTimes[0];
        self.endTime = prevMonthTimes[1];
        [self loadData];
        
        [self showMonthData];
        [graphView.layer addAnimation:animation forKey:@"prevAnimation"];
    }
}


- (void) slideNextMonth
{
    if ( nextMonthTimes[0] > 0 ) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        
        self.startTime = nextMonthTimes[0];
        self.endTime = nextMonthTimes[1];
        [self loadData];
        
        [self showMonthData];
        [graphView.layer addAnimation:animation forKey:@"nextAnimation"];
    }
}


#pragma mark - disable/enable network connect

//?
- (void) clickUserAgentNetworkButton
{
    UserAgentLockStatus status = [agentLock lockStatus];
    
//    CustomTabBarViewController *tabBarController = [CustomTabBarViewController CustomTabBar:NO];
    
    if ( status == LOCK_STATUS_YES ) {
        //解锁
        [self disableUserAgentNetwork:0 lockMinutes:0];
    }
    else {
        //加锁
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择暂停网络连接的时间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"2小时",@"8小时",@"当月",@"永久(手动开启)", nil];
        [sheet showInView:[AppDelegate getAppDelegate].leveyTabBarController.view ];
        [sheet release];
    }
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    time_t now;
    time_t end;
    time( &now );
    int minutes = -1;
    
    if ( buttonIndex == 0 ) {
        end = now + 2 * 3600;
        minutes = 120;
    }
    else if ( buttonIndex == 1 ) {
        end = now + 8 * 3600;
        minutes = 480;
    }
    else if ( buttonIndex == 2 ) {
        time_t period[2];
        [TCUtils getPeriodOfTcMonth:period time:now];
        end = period[1];
        minutes = (period[1] - now) / 60;
        if ( minutes == 0 ) minutes = 1;
    }
    else if ( buttonIndex == 3 ) {
        minutes = 0;
    }
    else {
        end = 0;
    }
    
    if ( minutes != -1 ) {
        [self disableUserAgentNetwork:1 lockMinutes:minutes];
    }
}


- (void) disableUserAgentNetwork:(int)isLock lockMinutes:(int)minutes
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@&lock=%d&locktime=%d&host=%@&port=%d", 
                     API_BASE, API_SETTING_DISABLEUA,
                     [uaStr encodeAsURIComponent], isLock, minutes, user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];

    NSHTTPURLResponse* response;
    NSError* error;
    
    loadingView.hidden = NO;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url response:&response error:&error];
    [self performSelector:@selector(hiddenLoadingView) withObject:nil afterDelay:0.3f];
    
    if ( response.statusCode == 200 ) {
        if ( !obj && ![obj isKindOfClass:[NSDictionary class]] ) {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
        
        NSDictionary* dic = (NSDictionary*) obj;
        NSNumber* number = (NSNumber*) [dic objectForKey:@"code"];
        int code = [number intValue];
        if ( code == 200 ) {
            time_t now;
            time( &now );
            if ( isLock ) {
                if ( !agentLock ) {
                    agentLock = [[UserAgentLock alloc] init];
                    agentLock.userAgent = userAgent;
                }
                agentLock.isLock = 1;
                agentLock.lockTime = now;
                agentLock.timeLengh = minutes * 60;
                [AppDelegate showAlert:@"已经暂时停止了该应用的网络链接。"];
            }
            else {
                if ( agentLock ) {
                    agentLock.isLock = 0;
                    agentLock.resumeTime = now;
                }
                [AppDelegate showAlert:@"已经恢复了该应用的网络链接。"];
            }
            if ( agentLock ) {
                [UserAgentLockDAO updateUserAgentLock:agentLock];
                [self showLockStatus];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
        }
        else {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
    }
    else {
        [AppDelegate showAlert:@"抱歉，操作失败"];
    }
}


- (void) hiddenLoadingView
{
    loadingView.hidden = YES;
}

@end
