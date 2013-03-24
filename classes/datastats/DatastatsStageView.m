//
//  DatastatsStageView.m
//  flashapp
//
//  Created by 李 电森 on 12-1-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsStageView.h"
#import "DatastatsViewController.h"
#import "AppDelegate.h"
#import "DateUtils.h"
#import "StringUtil.h"

@implementation DatastatsStageView

@synthesize stats;
@synthesize showLine;


#pragma mark - init & destroy methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(282, 12, 18, 28)];
        arrowView.image = [UIImage imageNamed:@"stats_arrow.png"];
        [self addSubview:arrowView];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 275, 16)];
        timeLabel.font = [UIFont systemFontOfSize:16];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
        
        dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 28, 275, 13)];
        dataLabel.font = [UIFont systemFontOfSize:14];
        dataLabel.textColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f];
        dataLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dataLabel];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 46, 306, 4)];
        line.image = [[UIImage imageNamed:@"grayLine.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        [self addSubview:line];
    }
    return self;
}


- (void) dealloc
{
    [stats release];
    [timeLabel release];
    [dataLabel release];
    [arrowView release];
    [line release];
    [super dealloc];
}


#pragma mark - setter

+ (NSString*) getDateStageString:(long)startTime endTime:(long)endTime
{
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
        endTimeString = NSLocalizedString(@"stats.today", nil);
    }
    else {
        if ( [[endTimeString substringToIndex:4] compare:year] == NSOrderedSame ) {
            endTimeString = [endTimeString substringFromIndex:5];
        }
    }
    
    NSString* s = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
    return s;
}

- (void) setStats:(StageStats *)st
{
    [stats release];
    stats = [st retain];
    if ( stats ) {
        long startTime = st.startTime;
        long endTime = st.endTime;
        long beforeBytes = st.bytesBefore;
        long afterBytes = st.bytesAfter;
        
        timeLabel.text = [DatastatsStageView getDateStageString:startTime endTime:endTime];
        
        if ( beforeBytes > 0 ) {
            NSString* compressBytesString = [NSString stringForByteNumber:(beforeBytes - afterBytes)];
            float percent = ((float)beforeBytes - afterBytes) / beforeBytes * 100.0f;
            NSString *dataText = NSLocalizedString(@"stats.saved", nil);
            dataLabel.text = [NSString stringWithFormat:@"%@%@(%.2f%%)", dataText,compressBytesString, percent ];
        }
        else {
            dataLabel.text = NSLocalizedString(@"stats.notSaved", nil);
        }
        
        if ( beforeBytes > 0 ) {
            arrowView.hidden = NO;
        }
        else {
            arrowView.hidden = YES;
        }
    }
}


- (void) setShowLine:(BOOL)b
{
    showLine = b;
    if ( showLine ) {
        line.hidden = NO;
    }
    else {
        line.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - touch actions

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( stats.bytesBefore > 0 ) {
        [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.5f blue:1.0f alpha:0.8f]];
        [self performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.5];
        
        DatastatsViewController* controller = [[DatastatsViewController alloc] init];
        controller.isMonth = NO;
        controller.showHelp = NO;
        controller.startTime = stats.startTime;
        controller.endTime = stats.endTime;
        [[[AppDelegate getAppDelegate] currentNavigationController] pushViewController:controller animated:YES];
        [controller release];
    }
}

@end
