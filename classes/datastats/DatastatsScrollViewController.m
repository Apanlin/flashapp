//
//  DatastatsScrollViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsScrollViewController.h"
#import "ShareToSNSViewController.h"
#import "SettingViewController.h"
#import "HelpListViewController.h"
#import "AppDelegate.h"
#import "StatsMonthDAO.h"
#import "StatsDayDAO.h"
#import "DateUtils.h"
#import "StringUtil.h"
#import "UIImageUtil.h"
#import "JSON.h"
#import "OpenUDID.h"
#import "TCUtils.h"

#define BG_COLOR [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f]

@interface DatastatsScrollViewController ()

@end

@implementation DatastatsScrollViewController

@synthesize startTime;
@synthesize endTime;
@synthesize currentStats;
@synthesize prevMonthStats;
@synthesize nextMonthStats;
@synthesize scrollView;

#pragma mark - init & destroy

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self ) {
        //self.tabBarItem.title = @"流量统计";
        //self.tabBarItem.image = [UIImage imageNamed:@"icon_report.png"];
        
        NSString* title = NSLocalizedString(@"stats.tabBarItem.title", nil);
        NSString* imageName = NSLocalizedString(@"stats.tabBarItem.iamge", nil);
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] tag:0];
        self.tabBarItem = item;
        [item release];
    }
    return self;
}


- (void) dealloc
{
    [currentStats release];
    [prevMonthStats release];
    [nextMonthStats release];
    
    [userAgentStats release];
    
    [scrollView release];
    [contentView release];
    [_refreshHeaderView release];
    [dialogView release];
    
    [super dealloc];
}


#pragma mark - view lifecircle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"stats.navItem.title", nil);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"setName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showSetting)] autorelease];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40, 32);
    [rightButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 32);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"diagnose.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showDiagnose) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    self.view.backgroundColor = BG_COLOR;
    scrollView.backgroundColor = BG_COLOR;
    
    //下拉刷新
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - scrollView.bounds.size.height, self.view.frame.size.width, scrollView.bounds.size.height)];
    view.delegate = self;
    [scrollView addSubview:view];
    _refreshHeaderView = view;
    
    //整个页面的view
    contentView = [[DatastatsView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = BG_COLOR;
    contentView.viewcontroller = self;
    [scrollView addSubview:contentView];
    
    //点击分享后弹出的 view
    dialogView = [[ShareView alloc] initWithFrame:CGRectMake( 30, 60, 260, 300 )];
    [self.view addSubview:dialogView];
    [dialogView close];

    userAgentStats = [[NSMutableArray alloc] init];
    
    twitterClient = nil;
    refreshing = NO;

    [self loadData];
    [self show];
    
    //接收刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndShowData) name:RefreshNotification object: nil];

    //接收套餐数据修改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tcChanged) name:TCChangedNotification object: nil];
    
    //接收锁网通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAppLockedStatus) name:RefreshAppLockedNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [contentView release];
    contentView = nil;
    
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
    
    [dialogView release];
    dialogView = nil;
    
    self.scrollView = nil;
    
    [userAgentStats release];
    userAgentStats = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - load data

- (void) loadData
{
    [userAgentStats removeAllObjects];
    
    //本月/上月/下月节省的流量
    self.currentStats = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
    
    time_t firstDay = [StatsDayDAO getfirstDay];
    time_t now;
    time( &now );
    
    time_t prevPeroid[2];
    [TCUtils getPeriodOfTcMonth:prevPeroid time:startTime - 1];
    if ( prevPeroid[1] < firstDay ) {
        self.prevMonthStats = nil;
    }
    else {
        self.prevMonthStats = [StatsMonthDAO statForPeriod:prevPeroid[0] endTime:prevPeroid[1]];
        if ( !prevMonthStats ) {
            prevMonthStats = [[StageStats alloc] init];
            prevMonthStats.startTime = prevPeroid[0];
            prevMonthStats.endTime = prevPeroid[1];
        }
    }
    
    time_t nextPeroid[2];
    [TCUtils getPeriodOfTcMonth:nextPeroid time:endTime + 1];
    if ( nextPeroid[0] <= now ) {
        self.nextMonthStats = [StatsMonthDAO statForPeriod:nextPeroid[0] endTime:nextPeroid[1]];
        if ( !nextMonthStats ) {
            nextMonthStats = [[StageStats alloc] init];
            nextMonthStats.startTime = nextPeroid[0];
            nextMonthStats.endTime = nextPeroid[1];
        }
    }
    else {
        self.nextMonthStats = nil;
    }
    
    //本月流量详情
    if ( currentStats.bytesBefore > 0 ) {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
        [userAgentStats addObjectsFromArray:tempArr];
    }
}


- (void) show
{
    contentView.startTime = startTime;
    contentView.endTime = endTime;
    contentView.currentStats = currentStats;
    contentView.userAgentStats = userAgentStats;
    
    CGFloat height = [contentView getHeight];
    contentView.frame = CGRectMake(0, 0, 320, height);
    
    if ( height <= scrollView.frame.size.height ) {
        height = scrollView.frame.size.height + 2;
    }
    
    scrollView.contentSize = CGSizeMake( 320, height );
    
    [contentView show];
}


- (void) getAccessData
{
    [TCUtils readIfData:-1];
    
    if ( twitterClient ) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }
    
    AppDelegate* app = [AppDelegate getAppDelegate];
    if ( [app.networkReachablity currentReachabilityStatus] == NotReachable ) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }
    
    if ( ![[AppDelegate getAppDelegate].refreshingLock tryLock] ) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetAccessData:obj:)];
    [twitterClient getAccessData];
}


- (void) didGetAccessData:(TwitterClient*)client obj:(NSObject*)obj
{
    twitterClient = nil;
    
    if ( client.hasError ) {
        [[AppDelegate getAppDelegate].refreshingLock unlock];
        [self doneLoadingTableViewData];
        [AppDelegate showAlert:client.errorMessage];
        return;
    }
    
    long long lastDayLong = [AppDelegate getLastAccessLogTime];
    BOOL hasData = [TwitterClient procecssAccessData:obj time:lastDayLong];
    [[AppDelegate getAppDelegate].refreshingLock unlock];
    if ( hasData ) {
        //从数据库中加载数据
        [self loadData];
        
        //显示数据
        [self show];
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.ifLastTime == 0 ) {
        [TCUtils readIfData:self.currentStats.bytesAfter];
    }
    
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [_refreshHeaderView refreshLastUpdatedDate];
    [self doneLoadingTableViewData];
}


- (void) loadAndShowData
{
    //从数据库中加载数据
    [self loadData];
    
    //显示数据
    [self show];
}


- (void) tcChanged
{
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:startTime];
    self.startTime = peroid[0];
    self.endTime = peroid[1];
    
    //从数据库中加载数据
    [self loadData];
    
    //显示数据
    [self show];
}


- (void) showSetting
{
    SettingViewController* controller = [[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void) showDiagnose
{
    HelpListViewController* controller = [[HelpListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void) refreshAppLockedStatus
{
    [contentView refreshAppLockedStatus];
}

#pragma mark - share methods

- (void) showShare
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    //dialogView.frame = CGRectMake( 30, 60, 260, 240 );
    //[dialogView setNeedsDisplay];
    //[dialogView setNeedsLayout];
    [dialogView open];
    [UIView commitAnimations];
}


//微博 和人人分享
- (void) shareToSNS:(NSString*)sns
{
    if ( !currentStats || !userAgentStats || [userAgentStats count] == 0 ) return;
    StatsDetail* topStats = [userAgentStats objectAtIndex:0];
    //StatsDetail* topStats = [[StatsDetail alloc] init];
    
    NSString* deviceId = [OpenUDID value];
    NSString* date = [DateUtils stringWithDateFormat:startTime format:@"yyyy-MM"];
    NSString* content = [NSString stringWithFormat:@"#%@用飞速省流量#我正在使用@飞速流量压缩仪，本月已经节省了%@，实际使用%@，压缩总比例为%.1f%%，其中%@压缩比例高达%.1f%%，飞速流量，省钱，快速。 下载地址：http://%@/social/%@.html", date,
                         [NSString stringForByteNumber:(currentStats.bytesBefore - currentStats.bytesAfter)], 
                         [NSString stringForByteNumber:currentStats.bytesAfter],
                         ((float) (currentStats.bytesBefore - currentStats.bytesAfter)) / currentStats.bytesBefore * 100,
                         [topStats.userAgent compare:@"未知"] == NSOrderedSame ? @"最高" : topStats.userAgent,
                         ((float)(topStats.before - topStats.after)) / topStats.before * 100,
                         P_HOST, deviceId];
    //content = @"Very Good!";
    
    NSData* image = [self captureScreen];
    
    ShareToSNSViewController* controller = [[ShareToSNSViewController alloc] init];
    controller.sns = sns;
    controller.content = content;
    controller.image = image;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    [[[AppDelegate getAppDelegate] currentNavigationController] presentModalViewController:nav animated:YES];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}



- (void) sendWeixinImage
{
    if ( [WXApi isWXAppInstalled]) {
        //发送内容给微信
        UIImage* image = [self captureScreenImage];
        UIImage* thumbImage = [[image getSubImage:CGRectMake(0, 0, 320, 416)] scaleImage:0.3];
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:thumbImage]; //设置消息缩略图的方法 ，大小不能超过 32K
    
        WXImageObject *ext = [WXImageObject object];
        NSData* imageData = UIImageJPEGRepresentation( image, 0.6 );
        ext.imageData = imageData;
    
        message.mediaObject = ext;
    
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        enum WXScene scene = WXSceneSession;
        req.scene = scene;
    
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
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)。
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
    
    //以png格式返回指定图片的数据    NSData格式
    NSData* imageData = UIImageJPEGRepresentation( aImage, 0.8 );
    return imageData;
    
}


#pragma mark - UIScrollViewDelegate & EGORefreshTableHeaderDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView1];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView1];
	
}


- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [_refreshHeaderView refreshLastUpdatedDate];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
	
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self getAccessData];
	_reloading = YES;
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark - MonthSlider Delegate

- (NSNumber*) hasPrevMonth
{
    if ( prevMonthStats ) {
        return [NSNumber numberWithInt:1];
    }
    else {
        return [NSNumber numberWithInt:0];
    }
}


- (NSNumber*) hasNextMonth
{
    if ( nextMonthStats ) {
        return [NSNumber numberWithInt:1];
    }
    else {
        return [NSNumber numberWithInt:0];
    }
}


- (void) monthSliderPrev
{
    [dialogView close];
    if ( prevMonthStats ) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;

        self.startTime = prevMonthStats.startTime;
        self.endTime = prevMonthStats.endTime;
        [self loadData];
        [self show];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        
        [self.scrollView.layer addAnimation:animation forKey:@"prevAnimation"];
    }
}


- (void) monthSliderNext
{
    [dialogView close];
    if ( nextMonthStats ) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;

        self.startTime = nextMonthStats.startTime;
        self.endTime = nextMonthStats.endTime;
        [self loadData];
        [self show];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];

        [self.scrollView.layer addAnimation:animation forKey:@"nextAnimation"];
    }
}


- (void) monthSliderNow
{
    [dialogView close];

    time_t now;
    time( &now );
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    
    self.startTime = peroid[0];
    self.endTime = peroid[1];
    [self loadData];
    [self show];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}



@end
