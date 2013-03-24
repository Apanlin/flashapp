//
//  DatastatsViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "TwitterClient.h"
#import "TwitPicClient.h"
#import "StageStats.h"
#import "StatsDay.h"
#import "MessageView.h"
#import "ShareView.h"

#define BG_COLOR [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f]

@interface DatastatsViewController : UITableViewController <EGORefreshTableHeaderDelegate>
{
    long startTime;
    long endTime;
    
    BOOL isMonth;
    BOOL showHelp;
    BOOL refreshing;
    
    StageStats* currentStats;
    StageStats* firstHalfStats;
    StageStats* lastHalfStats;
    
    StatsDay* prevMonthStats;
    StatsDay* nextMonthStats;
    
    NSMutableArray* userAgentStats;
    NSArray* userAgentColors;

    TwitterClient* twitterClient;
    TwitPicClient* picClient;

	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    ShareView* dialogView;
}


@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;
@property (nonatomic, assign) BOOL isMonth;
@property (nonatomic, assign) BOOL showHelp;

@property (nonatomic, retain) StageStats* currentStats;
@property (nonatomic, retain) StageStats* firstHalfStats;
@property (nonatomic, retain) StageStats* lastHalfStats;
@property (nonatomic, retain) StatsDay* prevMonthStats;
@property (nonatomic, retain) StatsDay* nextMonthStats;
@property (nonatomic, retain) NSMutableArray* userAgentStats;
@property (nonatomic, retain) NSArray* userAgentColors;

- (void) loadAndShowData;
- (void) monthSliderNow;

@end
