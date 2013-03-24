//
//  MonthStageCell.m
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MonthStageCell.h"
#import "DateUtils.h"
#import "StringUtil.h"

@implementation MonthStageCell

@synthesize startTime;
@synthesize endTime;
@synthesize beforeBytes;
@synthesize afterBytes;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dateLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:dateLabel];
        
        bytesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bytesLabel.font = [UIFont systemFontOfSize:12];
        bytesLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:bytesLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setStartTime:(time_t)st endTime:(time_t)et beforeBytes:(long)bb afterBytes:(long)ab
{
    startTime = st;
    endTime = et;
    beforeBytes = bb;
    afterBytes = ab;
    
    NSString* startTimeString = [DateUtils stringWithDateFormat:startTime format:@"YYYY年M月d日"];
    NSString* endTimeString = [DateUtils stringWithDateFormat:endTime format:@"YYYY年M月d日"];
    
    time_t now;
    time( &now );
    NSString* nowString = [DateUtils stringWithDateFormat:now format:@"YYYY年M月d日"];
    
    NSString* year = [nowString substringToIndex:4];
    if ( [[startTimeString substringToIndex:4] compare:year] == NSOrderedSame ) {
        startTimeString = [startTimeString substringFromIndex:5];
    }
    
    if ( [nowString compare:endTimeString] == NSOrderedSame ) {
        endTimeString = @"今天";
    }
    else {
        if ( [[endTimeString substringToIndex:4] compare:year] == NSOrderedSame ) {
            endTimeString = [endTimeString substringFromIndex:5];
        }
    }
    
    dateLabel.text = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
    
    if ( beforeBytes > 0 ) {
        NSString* beforeBytesString = [NSString stringForByteNumber:beforeBytes];
        NSString* compressBytesString = [NSString stringForByteNumber:(beforeBytes - afterBytes)];
        float percent = ((float)beforeBytes - afterBytes) / beforeBytes * 100.0f;
        bytesLabel.text = [NSString stringWithFormat:@"已节约%@ --- 原%@(%.2f%%)", compressBytesString, beforeBytesString, percent ];
    }
    else {
        bytesLabel.text = @"没有统计数据";
    }
    
    if ( beforeBytes > 0 ) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }

    [self setNeedsLayout];
}


- (void) layoutSubviews
{
    float left = 20;
    dateLabel.frame = CGRectMake(left, 10, 260, 20);
    bytesLabel.frame = CGRectMake(left, 30, 260, 15);
    [super layoutSubviews];
}

@end
