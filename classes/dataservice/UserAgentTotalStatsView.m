//
//  UserAgentTotalStatsView.m
//  flashapp
//
//  Created by 李 电森 on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserAgentTotalStatsView.h"
#import "MonthStatViewController.h"
#import "StatsDayDAO.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "DateUtils.h"

@implementation UserAgentTotalStatsView

@synthesize stats;


- (UIFont*) percentLabelFont
{
    UIFont* font = [UIFont systemFontOfSize:25];
    return font;
}


- (void) viewInit
{
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImageView.image = [UIImage imageNamed:@"flashget.png"];
    [self addSubview:iconImageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.userInteractionEnabled = NO;
    [self addSubview:titleLabel];
    
    percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    percentLabel.font = [self percentLabelFont];
    percentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:percentLabel];
    
    descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.text = @"(节省)";
    descLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:descLabel];
    
    detailButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [detailButton setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showMonthStat) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailButton];
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self viewInit];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}


- (void) dealloc
{
    [iconImageView release];
    [titleLabel release];
    [percentLabel release];
    [descLabel release];
    [detailButton release];
    [super dealloc];
}


- (void) layoutSubviews
{
    float left = 10;
    iconImageView.frame = CGRectMake(left, 20, 15, 15);
    titleLabel.frame = CGRectMake(left + 20, 20, 270 - 20, 15);
    
    UIFont* font = [self percentLabelFont];
    CGSize size = [percentLabel.text sizeWithFont:font];
    percentLabel.frame = CGRectMake( left, 35, size.width, 40);
    
    font = [UIFont systemFontOfSize:12];
    CGSize size2 = [descLabel.text sizeWithFont:font];
    descLabel.frame = CGRectMake( left + size.width + 10, 52, size2.width, 15);
    
    detailButton.frame = CGRectMake( 270, (self.frame.size.height - 23)/2, 12, 23);

    [super layoutSubviews];
}


- (void) setStats:(StatsDetail *)st
{
    if ( stats ) [stats release];
    stats = [st retain];
    
    percentLabel.text = [NSString stringWithFormat:@"%.2f%%", ((float) stats.before - stats.after) / stats.before * 100];
    titleLabel.text = st.userAgent;
    [self setNeedsLayout];
}


- (void) showMonthStat
{
    time_t now;
    time(&now);
    time_t firstDayOfMonth = [DateUtils getFirstDayOfMonth:now];
    MonthStatViewController *monthStatsController = [[MonthStatViewController alloc] init];
    monthStatsController.month = firstDayOfMonth;
    [[[AppDelegate getAppDelegate] currentNavigationController] pushViewController:monthStatsController animated:YES];
    [monthStatsController release];
}


- (void) touchInView
{
    [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.5f blue:1.0f alpha:0.8f]];
    [self performSelector:@selector(setBackgroundColor:) withObject:[UIColor whiteColor] afterDelay:0.5];
    
    //time_t now;
    //time(&now);
    time_t lastDayLong = [StatsDayDAO getLastDay];
    time_t firstDayOfMonth = [DateUtils getFirstDayOfMonth:lastDayLong];
    
    MonthStatViewController *monthStatsController = [[MonthStatViewController alloc] init];
    monthStatsController.month = firstDayOfMonth;
    [[[AppDelegate getAppDelegate] currentNavigationController] pushViewController:monthStatsController animated:YES];
    [monthStatsController release];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchInView];
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
