//
//  DatastatsTouchedView.h
//  flashapp
//
//  Created by 李 电森 on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TouchedView.h"
#import "StageStats.h"

@interface DatasaveDialView : TouchedView
{
    CGFloat startAngle;
    
    UILabel* compressLabel;
    UILabel* compressUnitLabel;
    UILabel* totalCompressLabel;
    UILabel* totalCompressUnitLabel;
    UILabel* connectTypeLabel;

    StageStats* totalStats;
    StageStats* monthStats;
}

@property (nonatomic, retain) StageStats* totalStats;
@property (nonatomic, retain) StageStats* monthStats;


- (void) refreshCapacity;

@end
