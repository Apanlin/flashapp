//
//  DatastatsView.h
//  flashapp
//
//  Created by 李 电森 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatastatsMonthSliderView.h"
#import "DatastatsTotalView.h"
#import "DatastatsUserAgentsView.h"
#import "DatastatsPieView.h"
#import "StageStats.h"


@interface DatastatsView : UIView
{
    UIViewController* viewcontroller;
    
    DatastatsMonthSliderView* sliderView;
    DatastatsTotalView* totalView;
    DatastatsUserAgentsView* userAgentsView;
    DatastatsPieView* pieView;
    UILabel* pieLabel;
    
    UIButton* underProxyButton;
    UIView* underProxyView;
    UIView* disableLayerView;

    long startTime;
    long endTime;
    StageStats* currentStats;
    NSArray* userAgentStats;
    
    NSArray* userAgentColors;
}

@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;
@property (nonatomic, retain) StageStats* currentStats;
@property (nonatomic, retain) NSArray* userAgentStats;
@property (nonatomic, retain) UIViewController* viewcontroller;

- (CGFloat) getHeight;
- (void) show;
- (void) refreshAppLockedStatus;


@end
