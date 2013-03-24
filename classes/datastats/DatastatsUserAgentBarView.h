//
//  DatastatsUserAgentBarView.h
//  flashapp
//
//  Created by 李 电森 on 12-1-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsDetail.h"
#import "DatastatsBarView.h"

@interface DatastatsUserAgentBarView : UIView
{
    StatsDetail* stats;
    BOOL locked;
    time_t startTime;
    time_t endTime;
    
    UIColor* color;
    
    UILabel* userAgentLabel;
    UILabel* afterLabel;
    UILabel* compressLabel;
    DatastatsBarView* barView;
    
    UIButton* layerButton;
}


@property (nonatomic, retain) StatsDetail* stats;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, retain) UIColor* color;
@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;

@end
