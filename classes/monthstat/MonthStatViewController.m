//
//  MonthStatViewController.m
//  flashapp
//
//  Created by 李 电森 on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MonthStatViewController.h"
#import "LableView.h"
#import "StringUtil.h"
#import "DateUtils.h"
#import "StatsMonthDAO.h"
#import "MonthTotalCell.h"
#import "MonthUserAgentCell.h"
#import "MonthStageCell.h"
#import "MonthSliderView.h"
#import "StatsDayService.h"

@implementation MonthStatViewController

@synthesize month;
@synthesize monthStats;
@synthesize prevMonthStats;
@synthesize nextMonthStats;
@synthesize userAgentStatsArray;
@synthesize stageStats1;
@synthesize stageStats2;

#pragma mark - init & destroy

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"流量统计";
        self.tabBarItem.title = @"流量统计";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_report.png"];
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
    [monthStats release];
    [prevMonthStats release];
    [nextMonthStats release];
    [userAgentStatsArray release];
    [stageStats1 release];
    [stageStats2 release];
    [super dealloc];
}


#pragma mark - loadData

- (void) loadData
{
    //本月/上月/下月节省的流量
    self.monthStats = [StatsMonthDAO getStatsMonth:month];
    self.prevMonthStats = [StatsMonthDAO getStatsMonth:month option:@"prev"];
    self.nextMonthStats = [StatsMonthDAO getStatsMonth:month option:@"next"];
    
    //本月流量详情
    self.userAgentStatsArray = [StatsMonthDAO getDetailStatsMonth:month limit:5];
    
    //分阶段的流量情况
    time_t now;
    now = time(&now);
    NSString* s = [DateUtils stringWithDateFormat:now format:@"yyyy-MM-dd"];
    NSArray* ss = [s componentsSeparatedByString:@"-"];
    int yearNow = [[ss objectAtIndex:0] intValue];
    int monthNow = [[ss objectAtIndex:1] intValue];
    
    s = [DateUtils stringWithDateFormat:month format:@"yyyy-MM-dd"];
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
            self.stageStats1 = [StatsMonthDAO statForPeriod:month endTime:t];
            self.stageStats2 = nil;
        }
        else {
            self.stageStats1 = [StatsMonthDAO statForPeriod:month endTime:t];

            t ++;
            self.stageStats2 = [StatsMonthDAO statForPeriod:t endTime:now];
        }
    }
    else {
        //过去月的统计
        //取前半月的流量统计
        s = [NSString stringWithFormat:@"%d-%02d-15 23:59:59", yearDate, monthDate];
        time_t t = [DateUtils timeWithDateFormat:s format:@"yyyy-MM-dd HH:mm:ss"];
        self.stageStats1 = [StatsMonthDAO statForPeriod:month endTime:t];
        
        //取后半月的流量统计
        t ++;
        time_t t2 = [DateUtils getLastDayOfMonth:month];
        self.stageStats2 = [StatsMonthDAO statForPeriod:t endTime:t2];
    }
}


- (void) refresh
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [StatsDayService explainURL];
    [self loadData];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"流量统计";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] autorelease];
    
    //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"new" style:UIBarButtonItemStyleBordered target:self action:@selector(showNew)] autorelease];

    [self loadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.userAgentStatsArray = nil;
    self.stageStats1 = nil;
    self.stageStats2 = nil;
    self.monthStats = nil;
    self.prevMonthStats = nil;
    self.nextMonthStats = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    int count = 2;
    if ( stageStats1.bytesBefore > 0 || stageStats2.bytesBefore > 0 ) count++;
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    }
    else if ( section == 1 ) {
        if ( !userAgentStatsArray || [userAgentStatsArray count] == 0 ) {
            return 0;
        }
        else {
            return 1;
        }
    }
    else {
        if ( stageStats1 && stageStats2 ) {
            return 2;
        }
        else if ( stageStats1 || stageStats2 ) {
            return 1;
        }
        else {
            return 0;
        }
    }
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LableView* view = nil;
    NSString* text;
    
    if ( section == 0 ) {
        view = [[MonthSliderView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        ((MonthSliderView*) view).delegate = self;
        text = [DateUtils stringWithDateFormat:month format:@"YYYY年M月"];
    }
    else if ( section == 1 ) {
        view = [[LableView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        if ( !userAgentStatsArray || [userAgentStatsArray count] == 0 ) {
            text = @"本月尚无统计数据";
        }
        else {
            text = @"本月份使用情况";
        }
    }
    else {
        view = [[LableView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        text = @"分阶段查看";
    }
    
    view.text = text;
    view.font = [UIFont systemFontOfSize:15];
    return view;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 40;
    }
    else {
        return 30;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if ( section == 0 ) {
        return 80;
    }
    else if ( section == 1 ) {
        return [MonthUserAgentCell cellHeight:userAgentStatsArray];
    }
    else {
        
        return 55;
    }
}


- (MonthTotalCell*) tableView:(UITableView*)tableView monthTotalCellForIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"MonthTotalCell";
    
    MonthTotalCell *cell = (MonthTotalCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MonthTotalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.compressBytes = monthStats.totalStats;
    }
    else {
        cell.compressBytes = monthStats.totalStats;
    }
    
    return cell;
}


- (MonthUserAgentCell*) tableView:(UITableView*)tableView monthUserAgentCellForIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"MonthUserAgentCell";
    
    MonthUserAgentCell *cell = (MonthUserAgentCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MonthUserAgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.userAgentStatsArray = self.userAgentStatsArray;
    }
    else {
        cell.userAgentStatsArray = self.userAgentStatsArray;
    }
    
    return cell;
}


- (MonthStageCell*) tableView:(UITableView*)tableView monthStageCellForIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"MonthStageCell";
    
    StageStats* stats = nil;
    int row = indexPath.row;
    if ( row == 0 ) {
        stats = stageStats2;
        if ( stats == nil ) stats = stageStats1;
    }
    else {
        stats = stageStats1;
    }
    
    MonthStageCell *cell = (MonthStageCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MonthStageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setStartTime:stats.startTime endTime:stats.endTime beforeBytes:stats.bytesBefore afterBytes:stats.bytesAfter];
    }
    else {
        [cell setStartTime:stats.startTime endTime:stats.endTime beforeBytes:stats.bytesBefore afterBytes:stats.bytesAfter];
    }
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    UITableViewCell* cell = nil;
    
    if ( section == 0 ) {
        cell = [self tableView:tableView monthTotalCellForIndexPath:indexPath];
    }
    else if ( section == 1 ) {
        cell = [self tableView:tableView monthUserAgentCellForIndexPath:indexPath];
    }
    else {
        cell = [self tableView:tableView monthStageCellForIndexPath:indexPath];
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
    int section = indexPath.section;
    int row = indexPath.row;
    
    if ( section == 2 ) {
        if ( row == 0 && stageStats1.bytesBefore > 0 ) {
            return indexPath;
        }
        else if ( row == 1 && stageStats2.bytesBefore > 0 ) {
            return indexPath;
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    StageStats* stats = nil;
    if ( row == 0 ) {
        if ( stageStats1 ) stats = stageStats1;
        else stats = stageStats2;
    }
    else {
        stats = stageStats2;
    }
    
    if ( stats ) {
        //DetailStateViewController* controller = [[DetailStateViewController alloc] init];
        //controller.stats = stats;
        //controller.topCount = 5;
        //[self.navigationController pushViewController:controller animated:YES];
        //[controller release];
    }
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
    if ( prevMonthStats ) {
        self.month = prevMonthStats.accessDay;
        [self loadData];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}


- (void) monthSliderNext
{
    if ( nextMonthStats ) {
        self.month =  nextMonthStats.accessDay;
        [self loadData];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}

@end
