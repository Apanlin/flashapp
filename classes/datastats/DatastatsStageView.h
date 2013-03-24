//
//  DatastatsStageView.h
//  flashapp
//
//  Created by 李 电森 on 12-1-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageStats.h"

@interface DatastatsStageView : UIView 
{
    StageStats* stats;
    
    UILabel* timeLabel;
    UILabel* dataLabel;
    UIImageView* arrowView;
    UIImageView* line;
    BOOL showLine;
}


@property (nonatomic, retain) StageStats* stats;
@property (nonatomic, assign) BOOL showLine;

+ (NSString*) getDateStageString:(long)startTime endTime:(long)endTime;

@end
