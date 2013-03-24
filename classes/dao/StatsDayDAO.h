//
//  StatsDayDAO.h
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsDay.h"
#import "TotalStats.h"

@interface StatsDayDAO : NSObject{
    
}

+ (void) deleteStatsDay : (long long)accessDay;
+ (void) addStatsDay : (StatsDay *)statsDay;
+ (void) incrStatsDay:(StatsDay*)statsDay;
+ (StatsDay*) getStatsDay:(time_t)day;

+ (time_t) getfirstDay;
+ (time_t) getLastDay;

+(int)getCount;
+(void)getMaxStats:(StatsDay *)statsDay nowDayLong:(time_t)nowDayLong nowMinMonthLong:(time_t)nowMinMonthLong;
+(void)getThirdUserAgent:(NSMutableArray *)array;
+ (NSArray*) getUserAgentData:(NSString*)userAgent start:(time_t)start end:(time_t)end;
@end
