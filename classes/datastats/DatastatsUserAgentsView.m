//
//  DatastatsUserAgentsView.m
//  flashapp
//
//  Created by 李 电森 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsUserAgentsView.h"
#import "DatastatsUserAgentBarView.h"
#import "UserAgentLockDAO.h"
#import "UserAgentLock.h"
#import "StatsDetail.h"

@implementation DatastatsUserAgentsView

@synthesize userAgentStats;
@synthesize userAgentColors;
@synthesize startTime;
@synthesize endTime;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        backgroundImageView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
        [self addSubview:backgroundImageView];
    }
    return self;
}


- (void) dealloc
{
    [userAgentStats release];
    [userAgentColors release];
    [backgroundImageView release];
    [super dealloc];
}


- (void) refreshAppLockedStatus
{
    if ( !userAgentStats || [userAgentStats count] == 0 ) return;
    
    NSDictionary* lockDic = [UserAgentLockDAO getAllLockedApps];
    
    for ( UIView* v in self.subviews ) {
        if ( [v isKindOfClass:[DatastatsUserAgentBarView class]] ) {
            DatastatsUserAgentBarView* barView = (DatastatsUserAgentBarView*)v;
            StatsDetail* stats = barView.stats;
            UserAgentLock* lock = [lockDic objectForKey:stats.userAgent];
            if ( lock && lock.isLock ) {
                barView.locked = YES;
            }
            else {
                barView.locked = NO;
            }
        }
    }
}


- (void) setUserAgentStats:(NSArray *)userAgents
{
    [userAgentStats release];
    userAgentStats = [userAgents retain];
    
    NSArray* views = [self subviews];
    for ( UIView* v in views ) {
        if ( v != backgroundImageView ) {
            [v removeFromSuperview];
        }
    }
    
    if ( [userAgentStats count] > 0 ) {
        NSDictionary* lockDic = [UserAgentLockDAO getAllLockedApps];
        
        CGFloat y = 2;
        int count = 0;
        for ( StatsDetail* stats in userAgentStats ) {
            DatastatsUserAgentBarView* barView = [[DatastatsUserAgentBarView alloc] initWithFrame:CGRectMake(2, y, 310 - 4, 66)];
            barView.stats = stats;
            barView.color = [userAgentColors objectAtIndex:(count%[userAgentColors count])];
            barView.startTime = startTime;
            barView.endTime = endTime;
            
            UserAgentLock* lock = [lockDic objectForKey:stats.userAgent];
            if ( lock && lock.isLock ) {
                barView.locked = YES;
            }
            else {
                barView.locked = NO;
            }
            
            [self addSubview:barView];
            [barView release];
            y += 66;
            count++;
        }
    }
    else {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 280, 20)];
        label.text = NSLocalizedString(@"stats.month.notSaved", nil);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        [label release];
    }
}


- (CGFloat) getHeight
{
    CGFloat height = 0;
    if ( [userAgentStats count] > 0 ) {
        height = 66 * [userAgentStats count];
    }
    else {
        height = 150;
    }
    return height;
}


- (void) layoutSubviews
{
    backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
