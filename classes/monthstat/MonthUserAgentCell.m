//
//  MonthUserAgentCell.m
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MonthUserAgentCell.h"

@implementation MonthUserAgentCell

@synthesize userAgentStatsArray;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        statView = [[MonthUserAgentStatView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:statView];
    }
    return self;
}


- (void) dealloc
{
    [userAgentStatsArray release];
    [statView release];
    [super dealloc];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (float) cellHeight:(NSArray*)array
{
    float height = 10 + 70 + 20 + [array count] * 25 + 5;
    return height;
}


- (void) setUserAgentStatsArray:(NSArray *)array
{
    if ( userAgentStatsArray ) [userAgentStatsArray release];
    userAgentStatsArray = [array retain];
    
    [statView setUserAgentStatsArray:array];
    [self setNeedsLayout];
}


- (void) layoutSubviews
{
    float height = [MonthUserAgentCell cellHeight:userAgentStatsArray];
    statView.frame = CGRectMake(0, 0, 320, height);
    [super layoutSubviews];
}


@end
