//
//  MonthStatViewController.h
//  flashapp
//
//  Created by 李 电森 on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsDay.h"
#import "StageStats.h"

@interface MonthStatViewController : UITableViewController {
    
    time_t month;
    
    StatsDay* monthStats;
    StatsDay* prevMonthStats;
    StatsDay* nextMonthStats;
    
    NSArray* userAgentStatsArray;

    StageStats* stageStats1;    //前半月统计
    StageStats* stageStats2;    //后半月统计
}


@property (nonatomic, assign) time_t month;
@property (nonatomic, retain) StatsDay* monthStats;
@property (nonatomic, retain) StatsDay* prevMonthStats;
@property (nonatomic, retain) StatsDay* nextMonthStats;
@property (nonatomic, retain) NSArray* userAgentStatsArray;
@property (nonatomic, retain) StageStats* stageStats1;    //前半月统计
@property (nonatomic, retain) StageStats* stageStats2;    //后半月统计



@end
