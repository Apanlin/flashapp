//
//  MonthUserAgentStatView.h
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionBarView.h"

@interface MonthUserAgentStatView : UIView
{
    SectionBarView* barView;
    NSArray* userAgentStatsArray;
}

@property (nonatomic, retain) NSArray* userAgentStatsArray;

@end
