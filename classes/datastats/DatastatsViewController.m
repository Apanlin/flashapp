//
//  DatastatsViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsViewController.h"
#import "AppDelegate.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "DatastatsMonthSliderView.h"
#import "DatastatsTotalView.h"
#import "DatastatsUserAgentBarView.h"
#import "DatastatsPieView.h"
#import "CLMView.h"
#import "DatastatsStageView.h"
#import "StatsMonthDAO.h"
#import "StatsDayDAO.h"
#import "OpenUDID.h"
#import "StatsDayService.h"
#import "TotalStats.h"
#import "StatsDetail.h"
#import "DateUtils.h"
#import "StringUtil.h"
#import "JSON.h"


@interface DatastatsViewController(private)
- (void) setLastUpdateDate;
- (void) loadData;
- (void) doneLoadingTableViewData;
+ (NSString*) getDateStageString:(long)startTime endTime:(long)endTime;
- (void) getAccessData:(BOOL)dropdownRefresh;
@end


@implementation DatastatsViewController

@synthesize isMonth;
@synthesize showHelp;
@synthesize startTime;
@synthesize endTime;
@synthesize currentStats;
@synthesize firstHalfStats;
@synthesize lastHalfStats;
@synthesize prevMonthStats;
@synthesize nextMonthStats;
@synthesize userAgentStats;
@synthesize userAgentColors;

#pragma mark - init & destroy methods


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self ) {
        self.tabBarItem.title = @"流量统计";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_report.png"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void) dealloc
{
    [currentStats release];
    [firstHalfStats release];
    [lastHalfStats release];
    [prevMonthStats release];
    [nextMonthStats release];
    [userAgentStats release];
    [userAgentColors release];
    [dialogView release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( isMonth ) {
        self.navigationItem.title = @"流量统计";
    }
    else {
        self.navigationItem.title = @"阶段流量统计";
    }
    
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(openTeleDemo)] autorelease];
    //if ( showHelp ) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(showSetting)] autorelease];
    //}
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = BG_COLOR;
    self.tableView.backgroundColor = BG_COLOR;
    
    dialogView = [[ShareView alloc] initWithFrame:CGRectMake( 30, 60, 260, 240 )];
    [dialogView close];
    
    [self.tableView addSubview:dialogView];
    
	//if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	//	[view release];
	//}
	
    self.userAgentStats = [NSMutableArray array];
    self.userAgentColors = [NSArray arrayWithObjects:
                            [UIColor colorWithRed:254.0f/255.0f green:227.0f/255.0f blue:4.0f/255.0f alpha:1.0f],
                            [UIColor colorWithRed:237.0f/255.0f green:121.0f/255.0f blue:124.0f/255.0f alpha:1.0f],
                            [UIColor colorWithRed:182.0f/255.0f green:140.0f/255.0f blue:197.0f/255.0f alpha:1.0f],
                            [UIColor colorWithRed:136.0f/255.0f green:236.0f/255.0f blue:216.0f/255.0f alpha:1.0f],
                            [UIColor colorWithRed:249.0f/255.0f green:183.0f/255.0f blue:212.0f/255.0f alpha:1.0f],
                            [UIColor colorWithRed:125.0f/255.0f green:195.0f/255.0f blue:233.0f/255.0f alpha:1.0f],
                            nil];
    
    twitterClient = nil;
    refreshing = NO;
    [self loadData];

    //接收刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndShowData) name:RefreshNotification object: nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.currentStats = nil;
    self.firstHalfStats = nil;
    self.lastHalfStats = nil;
    self.prevMonthStats = nil;
    self.nextMonthStats = nil;
    self.userAgentStats = nil;
    self.userAgentColors = nil;
    
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
    
    [dialogView release];
    dialogView = nil;

    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setLastUpdateDate];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate* appDelegate = [AppDelegate getAppDelegate];
    if ( appDelegate.refreshDatastats ) {
        [self getAccessData:NO];
        appDelegate.refreshDatastats = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [dialogView close];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( isMonth ) {
        if ( [userAgentStats count] > 0 ) {
            return 3;
        }
        else {
            return 2;
        }
    }
    else {
        return 3;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    }
    else if ( section == 1 ) {
        return 1;
    }
    else if ( section == 2 ) {
        return 1;
    }
    return 0;
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        UIView* v = nil;
        
        if ( refreshing ) {
            v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)] autorelease];
        }
        else {
            v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)] autorelease];
        }
        
        CGFloat y = 0;
        if ( refreshing ) {
            MessageView* messageView = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            messageView.message = @"正在获取您的统计数据，请稍候...";
            messageView.backgroundColor = [UIColor clearColor];
            [v addSubview:messageView];
            y += 30;
            [messageView release];
        }
        
        DatastatsMonthSliderView* sliderView = [[DatastatsMonthSliderView alloc] initWithFrame:CGRectMake(0, y, 320, 38)];
        if ( isMonth ) {
            sliderView.text = [DateUtils stringWithDateFormat:startTime format:@"YYYY年M月"];
            sliderView.delegate = self;
        }
        else {
            sliderView.text = [DatastatsViewController getDateStageString:startTime endTime:endTime];
        }
        [v addSubview:sliderView];
        [sliderView release];
        [v setNeedsLayout];
        
        return v;
    }
    else if ( section == 1 ) {
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
        label.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
        label.text = @" 应用流量统计";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        return label;
    }
    else if ( section == 2 ) {
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 30)] autorelease];
        label.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
        label.text = @" 流量使用比例图";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        return label;
    }
    return nil;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if ( refreshing ) return 68;
        else return 38;
    }
    else if ( section == 1 ) {
        return 30;
    }
    else if ( section == 2 ) {
        return 40;
    }
    
    return 0;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if ( section == 0 ) {
        return 149;
    }
    else if ( section == 1 ) {
        CGFloat height = 66 * [userAgentStats count];
        return height;
    }
    else if ( section == 2 ) {
        return 160;
    }
    return 0;
}


- (UITableViewCell*) tableView:(UITableView *)tableView totalStatsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TotalStatsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = BG_COLOR;
    }
    
    for ( UIView* v in cell.contentView.subviews ) {
        [v removeFromSuperview];
    }
    
    DatastatsTotalView* totalView = [[DatastatsTotalView alloc] initWithFrame:CGRectMake(0, 0, 320, 149)];
    totalView.stats = currentStats;
    [totalView.shareButton addTarget:self action:@selector(showShare) forControlEvents:UIControlEventTouchUpInside];
    //if ( currentStats && userAgentStats && [userAgentStats count] > 0 ) {
        totalView.shareButton.hidden = NO;
    //}
    //else {
    //    totalView.shareButton.hidden = YES;
    //}
    [cell.contentView addSubview:totalView];
    [totalView release];
    
    return cell;
}


- (UITableViewCell*) tableView:(UITableView *)tableView userAgentCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserAgentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = BG_COLOR;
    }
    
    for ( UIView* v in cell.contentView.subviews ) {
        [v removeFromSuperview];
    }
    
    if ( [userAgentStats count] > 0 ) {
        CGFloat height = 66 * [userAgentStats count];
        UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, height)];
        //bgView.image = [[UIImage imageNamed:@"grayPannel.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
        bgView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
        [cell.contentView addSubview:bgView];
        [bgView release];
        
        CGFloat y = 2;
        int count = 0;
        for ( StatsDetail* stats in userAgentStats ) {
            DatastatsUserAgentBarView* barView = [[DatastatsUserAgentBarView alloc] initWithFrame:CGRectMake(7, y, 306, 66)];
            barView.stats = stats;
            barView.color = [userAgentColors objectAtIndex:(count%[userAgentColors count])];
            [cell.contentView addSubview:barView];
            [barView release];
            y += 66;
            count++;
        }
    }
    else {
        CGFloat height = 150;
        UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, height)];
        //bgView.image = [[UIImage imageNamed:@"grayPannel.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
        bgView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
        [cell.contentView addSubview:bgView];
        [bgView release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 280, 20)];
        label.text = @"本月暂无流量统计。";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
    }
    
    return cell;
}


- (UITableViewCell*) tableView:(UITableView *)tableView pieCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PieCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = BG_COLOR;
    }
    
    for ( UIView* v in cell.contentView.subviews ) {
        [v removeFromSuperview];
    }
    
    if ( [userAgentStats count] > 0 ) {
        DatastatsPieView* pieView = [[DatastatsPieView alloc] initWithFrame:CGRectMake(5, 0, 310, 160)];
        pieView.userAgents = userAgentStats;
        [cell.contentView addSubview:pieView];
    }
    
    return cell;
}


- (UITableViewCell*) tableView:(UITableView *)tableView stageStatsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StageStatsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = BG_COLOR;
    }
    
    for ( UIView* v in cell.contentView.subviews ) {
        [v removeFromSuperview];
    }
    
    CGFloat height = 0;
    if ( lastHalfStats ) {
        height = 106;
    }
    else {
        height = 56;
    }
    
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, height)];
    bgView.image = [[UIImage imageNamed:@"grayPannel.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
    [cell.contentView addSubview:bgView];
    [bgView release];
    
    CGFloat y = 3;
    if ( lastHalfStats ) {
        DatastatsStageView* stageView = [[DatastatsStageView alloc] initWithFrame:CGRectMake(7, y, 306, 50)];
        stageView.stats = lastHalfStats;
        [cell.contentView addSubview:stageView];
        [stageView release];
        y += 50;
    }
    
    DatastatsStageView* stageView = [[DatastatsStageView alloc] initWithFrame:CGRectMake(7, y, 306, 50)];
    stageView.stats = firstHalfStats;
    stageView.showLine = NO;
    [cell.contentView addSubview:stageView];
    [stageView release];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    int section = indexPath.section;
    if ( section == 0 ) {
        cell = [self tableView:tableView totalStatsCellForRowAtIndexPath:indexPath];
    }
    else if ( section == 1 ) {
        cell = [self tableView:tableView userAgentCellForRowAtIndexPath:indexPath];
    }
    else if ( section == 2 ) {
        //cell = [self tableView:tableView stageStatsCellForRowAtIndexPath:indexPath];
        cell = [self tableView:tableView pieCellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark - loadData


- (void) showMessage:(NSString*)message
{
    if ( refreshing ) return;
    refreshing = YES;
    [self.tableView reloadData];
}


- (void) hiddenMessage
{
    refreshing = NO;
    [self.tableView reloadData];
}


- (void) setLastUpdateDate
{
    NSString* refreshDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
    if ( refreshDate && _refreshHeaderView ) {
        [_refreshHeaderView setLastUpdatedDate:refreshDate];
    }
}


- (void) loadData
{
    [userAgentStats removeAllObjects];
    
    if ( isMonth ) {
        //本月/上月/下月节省的流量
        StatsDay* monthStats = [StatsMonthDAO getStatsMonth:startTime];
        if ( monthStats ) {
            self.currentStats = [[[StageStats alloc] init] autorelease];
            currentStats.startTime = startTime;
            currentStats.endTime = endTime;
            currentStats.bytesBefore = monthStats.totalBefore;
            currentStats.bytesAfter = monthStats.totalAfter;
        }
        
        time_t firstMonth = [StatsMonthDAO getFirstStatsMonth];
        time_t now;
        time( &now );
        
        time_t prevMonth = [DateUtils getFirstDayOfMonth:startTime - 1];
        if ( prevMonth >= firstMonth ) {
            self.prevMonthStats = [StatsMonthDAO getStatsMonth:prevMonth];
            if ( !prevMonthStats ) {
                prevMonthStats = [[StatsDay alloc] init];
                prevMonthStats.accessDay = prevMonth;
            }
        }
        else {
            self.prevMonthStats = nil;
        }
        
        time_t nextMonth = [DateUtils getLastDayOfMonth:startTime] + 1;
        if ( nextMonth <= now ) {
            self.nextMonthStats = [StatsMonthDAO getStatsMonth:nextMonth];
            if ( !nextMonthStats ) {
                nextMonthStats = [[StatsDay alloc] init];
                nextMonthStats.accessDay = nextMonth;
            }
        }
        else {
            self.nextMonthStats = nil;
        }

        //本月流量详情
        if ( currentStats.bytesBefore > 0 ) {
            NSArray* arr = [StatsMonthDAO getDetailStatsMonth:startTime limit:0];
            
            StatsDetail* detail;
            NSMutableArray* tempArr = [NSMutableArray array];
            for ( TotalStats* st in arr ) {
                detail = [[StatsDetail alloc] init];
                detail.userAgent = st.userAgent;
                detail.before = st.totalbefore;
                detail.after = st.totalafter;
                [tempArr addObject:detail];
                [detail release];
            }
            
            //NSArray* tempArr2 = [tempArr sortedArrayUsingSelector:@selector(compareByPercent:)];
            [tempArr sortUsingSelector:@selector(compareByPercent:)];
            [userAgentStats addObjectsFromArray:tempArr];
        }
        
        //分阶段的流量情况
        NSString* s = [DateUtils stringWithDateFormat:now format:@"yyyy-MM-dd"];
        NSArray* ss = [s componentsSeparatedByString:@"-"];
        int yearNow = [[ss objectAtIndex:0] intValue];
        int monthNow = [[ss objectAtIndex:1] intValue];
        
        s = [DateUtils stringWithDateFormat:startTime format:@"yyyy-MM-dd"];
        ss = [s componentsSeparatedByString:@"-"];
        int yearDate = [[ss objectAtIndex:0] intValue];
        int monthDate = [[ss objectAtIndex:1] intValue];
        
        if ( yearDate == yearNow && monthDate == monthNow ) {
            //当前月的统计
            //取前半月的流量统计
            s = [NSString stringWithFormat:@"%d-%02d-15 23:59:59", yearDate, monthDate];
            time_t t = [DateUtils timeWithDateFormat:s format:@"yyyy-MM-dd HH:mm:ss"];
            if ( t > now ) {
                t = now;
                self.firstHalfStats = [StatsMonthDAO statForPeriod:startTime endTime:t];
                self.lastHalfStats = nil;
            }
            else {
                self.firstHalfStats = [StatsMonthDAO statForPeriod:startTime endTime:t];
                
                t ++;
                self.lastHalfStats = [StatsMonthDAO statForPeriod:t endTime:now];
            }
        }
        else {
            //过去月的统计
            //取前半月的流量统计
            s = [NSString stringWithFormat:@"%d-%02d-15 23:59:59", yearDate, monthDate];
            time_t t = [DateUtils timeWithDateFormat:s format:@"yyyy-MM-dd HH:mm:ss"];
            self.firstHalfStats = [StatsMonthDAO statForPeriod:startTime endTime:t];
            
            //取后半月的流量统计
            t ++;
            time_t t2 = [DateUtils getLastDayOfMonth:startTime];
            self.lastHalfStats = [StatsMonthDAO statForPeriod:t endTime:t2];
        }
    }
    else {
        self.currentStats = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
        self.prevMonthStats = nil;
        self.nextMonthStats = nil;
        
        //流量详情
        if ( currentStats.bytesAfter > 0 ) {
            self.userAgentStats = (NSMutableArray*) [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:@"totalBefore" limit:5];
        }
    }
}


- (void) getAccessData:(BOOL)dropdownRefresh
{
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

    if ( !dropdownRefresh ) [self showMessage:@"正在统计您的流量数据，请稍候..."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetAccessData:obj:)];
    twitterClient.context = [NSNumber numberWithBool:dropdownRefresh];
    [twitterClient getAccessData];
}


- (void) getAccessData
{
    [self getAccessData:NO];
}


- (void) didGetAccessData:(TwitterClient*)client obj:(NSObject*)obj
{
    twitterClient = nil;
    
    long long lastDayLong = [AppDelegate getLastAccessLogTime];
    BOOL ddRefresh = [(NSNumber*)client.context boolValue];
    
    if ( client.hasError ) {
        [[AppDelegate getAppDelegate].refreshingLock unlock];
        [self doneLoadingTableViewData];
        [AppDelegate showAlert:client.errorMessage];
        return;
    }

    BOOL hasData = [TwitterClient procecssAccessData:obj time:lastDayLong];
    [[AppDelegate getAppDelegate].refreshingLock unlock];
    
    if ( hasData ) {
        //从数据库中加载数据
        [self loadData];
        
        //显示数据
        [self.tableView reloadData];
    }
    
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self hiddenMessage];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    if ( ddRefresh ) [self doneLoadingTableViewData];
}


- (void) loadAndShowData
{
    //从数据库中加载数据
    [self loadData];
    
    //显示数据
    [self.tableView reloadData];
}



+ (NSString*) getDateStageString:(long)startTime endTime:(long)endTime
{
    NSString* startTimeString = [DateUtils stringWithDateFormat:startTime format:@"YYYY年M月d日"];
    NSString* endTimeString = [DateUtils stringWithDateFormat:endTime format:@"YYYY年M月d日"];
    
    time_t now;
    time( &now );
    NSString* nowString = [DateUtils stringWithDateFormat:now format:@"YYYY年M月d日"];
    
    NSString* year = [nowString substringToIndex:4];
    if ( [[startTimeString substringToIndex:4] compare:year] == NSOrderedSame ) {
        startTimeString = [startTimeString substringFromIndex:5];
    }
    
    if ( [nowString compare:endTimeString] == NSOrderedSame ) {
        endTimeString = @"今天";
    }
    else {
        if ( [[endTimeString substringToIndex:4] compare:year] == NSOrderedSame ) {
            endTimeString = [endTimeString substringFromIndex:5];
        }
        else {
            endTimeString = [DateUtils stringWithDateFormat:endTime format:@"d日"];
        }
    }
    
    NSString* s = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
    return s;
}


- (void) openHelp
{
    HelpViewController* controller = [[HelpViewController alloc] init];
    controller.showCloseButton = YES;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}

#pragma mark -  methods for share

- (NSData*) captureScreen
{
    UIGraphicsBeginImageContext( self.view.bounds.size );    
    
    //renderInContext 呈现接受者及其子范围到指定的上下文    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];    
    
    //返回一个基于当前图形上下文的图片    
    UIImage *aImage =UIGraphicsGetImageFromCurrentImageContext();    
    
    //移除栈顶的基于当前位图的图形上下文    
    UIGraphicsEndImageContext();    
    
    //以png格式返回指定图片的数据    
    NSData* imageData = UIImageJPEGRepresentation( aImage, 0.8 );
    return imageData;
    
}


- (void) showShare
{
    [self.view bringSubviewToFront:dialogView];

    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    dialogView.frame = CGRectMake( 30, 60, 260, 240 );
    [dialogView setNeedsDisplay];
    [dialogView setNeedsLayout];
    [dialogView open];
    [UIView commitAnimations];
}


- (void) shareToSNS:(NSString*)sns
{
    if (picClient) return;
    
    if ( !currentStats || !userAgentStats || [userAgentStats count] == 0 ) return;
    StatsDetail* topStats = [userAgentStats objectAtIndex:0];

    NSString* deviceId = [OpenUDID value];
    NSString* title = @"我正在用飞速流量压缩仪flashapp节省流量呢";
    
    NSString* date = [DateUtils stringWithDateFormat:startTime format:@"yyyy-MM"];
    NSString* content = [NSString stringWithFormat:@"#%@用飞速省流量#我正在使用@飞速流量压缩仪，本月已经节省了%@，实际使用%@，压缩总比例为%.1f%%，其中%@压缩比例高达%.1f%%，飞速流量，省钱，快速。 下载地址：http://%@/social/%@.html", date,
                         [NSString stringForByteNumber:(currentStats.bytesBefore - currentStats.bytesAfter)], 
                         [NSString stringForByteNumber:currentStats.bytesAfter],
                         ((float) (currentStats.bytesBefore - currentStats.bytesAfter)) / currentStats.bytesBefore * 100,
                         [topStats.userAgent compare:@"未知"] == NSOrderedSame ? @"最高" : topStats.userAgent,
                         ((float)(topStats.before - topStats.after)) / topStats.before * 100,
                         P_HOST, deviceId];
    
    NSData* image = [self captureScreen];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceId forKey:@"deviceId"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:sns forKey:@"sns"];
    
    NSString* url = [NSString stringWithFormat:@"http://%@/loginsns/share/device.jsp", P_HOST];
    picClient = [[TwitPicClient alloc] initWithDelegate:self];
    [picClient upload:url image:image name:@"file" params:dic];
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
        self.isMonth = YES;
        self.startTime = prevMonthStats.accessDay;
        self.endTime = [DateUtils getLastDayOfMonth:prevMonthStats.accessDay];
        [self loadData];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}


- (void) monthSliderNext
{
    [dialogView close];
    if ( nextMonthStats ) {
        self.isMonth = YES;
        self.startTime = nextMonthStats.accessDay;
        self.endTime = [DateUtils getLastDayOfMonth:nextMonthStats.accessDay];
        [self loadData];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}


- (void) monthSliderNow
{
    [dialogView close];

    time_t now;
    time( &now );
    
    self.isMonth = YES;
    self.startTime = [DateUtils getFirstDayOfMonth:now];
    self.endTime = [DateUtils getLastDayOfMonth:now];
    [self loadData];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
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
    [_refreshHeaderView refreshLastUpdatedDate];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [dialogView close];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
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


#pragma mark - TwitPicClient Delegate

- (void)twitPicClientDidFail:(TwitPicClient*)sender error:(NSString*)error detail:(NSString*)detail
{
    picClient =nil;
    [AppDelegate showAlert:error];
}


- (void)twitPicClientDidDone:(TwitPicClient*)sender content:(NSString*)content
{
    picClient = nil;
    if ( !content ) return;
    
    NSObject* obj = [content JSONValue];
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    NSString* errorCode = [dic objectForKey:@"error_code"];
    if ( errorCode ) {
        [AppDelegate showAlert:@"抱歉，分享失败。"];
        return;
    }
    
    NSString* url = [dic objectForKey:@"redirect"];
    if ( !url ) return;
    
    //给用户增加限额
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    time_t now;
    time( &now );
    NSString* month = [DateUtils stringWithDateFormat:now format:@"MM"];
    
    BOOL flag = YES;
    if ( user.month ) {
        if ( [month compare:user.month] == NSOrderedSame ) {
            if ( user.monthCapacity < QUANTITY_MONTH_SHARE_LIMIT ) {
                user.monthCapacity += 1;
                user.monthCapacityDelta += 1;
                user.capacity += QUANTITY_PER_SHARE;
            }
            else {
                flag = NO;
            }
        }
        else {
            user.month = month;
            user.monthCapacity = 1;
            user.monthCapacityDelta = 1;
            user.capacity += QUANTITY_PER_SHARE;
        }
    }
    else {
        user.month = month;
        user.monthCapacity = 1;
        user.monthCapacityDelta = 1;
        user.capacity += QUANTITY_PER_SHARE;
    }
    
    if ( flag ) {
        [UserSettings saveUserSettings:user];
        //刷新Datasave页面
        [AppDelegate getAppDelegate].refreshDatasave = YES;
        //[self getAccessData];
    }
    
    
    HelpViewController* controller = [[HelpViewController alloc] init];
    controller.page = url;
    controller.showCloseButton = YES;
    controller.navigationItem.title = @"分享";
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [[[AppDelegate getAppDelegate] currentNavigationController] presentModalViewController:nav animated:YES];
}


@end
