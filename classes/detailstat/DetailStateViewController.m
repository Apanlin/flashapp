//
//  DetailStateViewController.m
//  flashapp
//
//  Created by 李 电森 on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailStateViewController.h"
#import "LableView.h"
#import "DateUtils.h"
#import "DetailTotalCell.h"
#import "StatsDayService.h"
#import "StatsMonthDAO.h"
#import "DetailUserAgentCell.h"
#import "StageStats.h"


@implementation DetailStateViewController

@synthesize stats;
@synthesize topCount;


#pragma mark - load data
- (void) loadData
{
    NSArray* array = [StatsMonthDAO userAgentStatsForPeriod:stats.startTime endTime:stats.endTime orderby:@"compress"];
    int count = 0;
    if ( appDatas ) {
        [appDatas removeAllObjects];
    }
    else {
        appDatas = [[NSMutableArray alloc] initWithCapacity:topCount+1];
    }
    
    long totalBeforeOther = 0;
    long totalAfterOther = 0;
    
    for ( StatsDetail* detailStats in array ) {
        if ( count < topCount ) {
            [appDatas addObject:detailStats];
        }
        else {
            totalBeforeOther += detailStats.before;
            totalAfterOther += detailStats.after;
        }
        count ++;
    }
    
    if ( totalBeforeOther > 0 ) {
        StatsDetail* detailStats = [[StatsDetail alloc] init];
        detailStats.userAgent = @"其他";
        detailStats.before = totalBeforeOther;
        detailStats.after = totalAfterOther;
        [appDatas addObject:detailStats];
        [detailStats release];
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

#pragma mark - init & destroy

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
    if ( appDatas ) {
        [appDatas release];
        appDatas = nil;
    }
    
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] autorelease];

    self.navigationItem.title = @"流量详情";
    [self loadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [appDatas release];
    appDatas = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    }
    else {
        return [appDatas count];
    }
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        LableView* lableView = [[[LableView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
        
        NSString* format = @"MM月dd日";
        NSString* begin = [DateUtils stringWithDateFormat:stats.startTime format:format];
        NSString* end = [DateUtils stringWithDateFormat:stats.endTime format:format];
        
        time_t now;
        time(&now);
        NSString* current = [DateUtils stringWithDateFormat:now format:format];
        
        NSString* text;
        if ( [current compare:end] == NSOrderedSame ) {
            text = [NSString stringWithFormat:@"%@ - 今天", begin];
        }
        else {
            text = [NSString stringWithFormat:@"%@ - %@", begin, end];
        }
        
        lableView.text = text;
        lableView.font = [UIFont systemFontOfSize:15];
        return lableView;
    }
    else {
        LableView* lableView = [[[LableView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
        lableView.text = @"按应用查看";
        lableView.font = [UIFont systemFontOfSize:15];
        return lableView;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 30;
    }
    else {
        return 40;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if ( section == 0 ) {
        return 130;
    }
    else {
        return 60;
    }
}


- (DetailTotalCell*) getTotalStatCell:(UITableView*)tableView 
{
    static NSString *CellIdentifier = @"DetailTotalCell";
    DetailTotalCell *cell = (DetailTotalCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DetailTotalCell alloc] init] autorelease];
        
        TotalStats* stat = [[TotalStats alloc] init];
        stat.totalbefore = stats.bytesBefore;
        stat.totalafter = stats.bytesAfter;
        cell.stat = stat;
        [stat release];
    }
    
    return cell;
}


- (DetailUserAgentCell*) tableView:(UITableView*)tableView userAgentCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailUserAgentCell";
    DetailUserAgentCell *cell = (DetailUserAgentCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DetailUserAgentCell alloc] init] autorelease];
    }
    
    int row = indexPath.row;
    StatsDetail* detailStats = [appDatas objectAtIndex:row];
    [cell setStats:detailStats];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell* cell;
    
    if ( section == 0 ) {
        cell = [self getTotalStatCell:tableView];
    }
    else {
        cell = [self tableView:tableView userAgentCellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
