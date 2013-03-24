//
//  DatastatsUserAgentsView.h
//  flashapp
//
//  Created by 李 电森 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatastatsUserAgentsView : UIView
{
    UIImageView* backgroundImageView;

    NSArray* userAgentStats;
    NSArray* userAgentColors;
    time_t startTime;
    time_t endTime;
}


@property (nonatomic, retain) NSArray* userAgentStats;
@property (nonatomic, retain) NSArray* userAgentColors;
@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;

- (CGFloat) getHeight;
- (void) refreshAppLockedStatus;

@end
