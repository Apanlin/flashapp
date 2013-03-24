//
//  DetailStatsAppViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-9-1.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailStatsAppLineChart.h"
#import "LoadingView.h"
#import "ShareView.h"
#import "TwitterClient.h"
#import "UserAgentLock.h"

@interface DetailStatsAppViewController : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate>
{
    time_t startTime;
    time_t endTime;
    NSString* userAgent;
    NSString* uaStr;
    
    NSArray* userAgentData;
    NSMutableArray* recommendApps;
    UserAgentLock* agentLock;
    
    time_t prevMonthTimes[2];
    time_t nextMonthTimes[2];

    UIView* graphView;
    UIView* chartHostingView;
    DetailStatsAppLineChart* chart;
    UIScrollView* appsScrollview;
    UIPageControl* pageControl;
    LoadingView* loadingView;
    ShareView* shareView;
    
    BOOL isTouchSV;
    CGPoint startPoint;
    NSInteger appIndex;
    
    TwitterClient* client;
}

@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, retain) NSString* userAgent;
@property (nonatomic, retain) NSString* uaStr;

@property (nonatomic, retain) NSArray* userAgentData;
@property (nonatomic, retain) UserAgentLock* agentLock;

@property (nonatomic, retain) IBOutlet UIScrollView* appsScrollview;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

@end
