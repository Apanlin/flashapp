//
//  DatastatsScrollViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatastatsView.h"
#import "EGORefreshTableHeaderView.h"
#import "ShareView.h"
#import "StageStats.h"
#import "TwitPicClient.h"
#import "TwitterClient.h"

@interface DatastatsScrollViewController : UIViewController 
                <EGORefreshTableHeaderDelegate, UIScrollViewDelegate>
{
    long startTime;
    long endTime;
    
    BOOL showHelp;
    BOOL refreshing;
    
    StageStats* currentStats;
    StageStats* prevMonthStats;
    StageStats* nextMonthStats;
    
    NSMutableArray* userAgentStats;
    NSArray* userAgentColors;
    
    TwitterClient* twitterClient;
    TwitPicClient* picClient;
    
    UIScrollView* scrollView;
    DatastatsView* contentView;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;

    ShareView* dialogView;
}

@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;
@property (nonatomic, retain) StageStats* currentStats;
@property (nonatomic, retain) StageStats* prevMonthStats;
@property (nonatomic, retain) StageStats* nextMonthStats;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

- (void) monthSliderNow;

@end
