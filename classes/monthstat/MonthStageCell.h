//
//  MonthStageCell.h
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthStageCell : UITableViewCell
{
    UILabel* dateLabel;
    UILabel* bytesLabel;
    
    time_t startTime;
    time_t endTime;
    long beforeBytes;
    long afterBytes;
}

@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, assign) long beforeBytes;
@property (nonatomic, assign) long afterBytes;


- (void) setStartTime:(time_t)st endTime:(time_t)et beforeBytes:(long)bb afterBytes:(long)ab;

@end
