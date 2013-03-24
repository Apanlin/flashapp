//
//  DatastatsTotalView.m
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "DatastatsTotalView.h"
#import "DatastatsBarItem.h"
#import "QuartzUtils.h"

#define PERCENT_FONT [UIFont systemFontOfSize:50]

@implementation DatastatsTotalView

@synthesize stats;
@synthesize shareButton;


#pragma mark - init & destroy methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //分享按钮
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(0, 20, 92, 38);
        NSString *iamgeName = NSLocalizedString(@"stats.share.image", nil);
        [shareButton setBackgroundImage:[UIImage imageNamed:iamgeName] forState:UIControlStateNormal];
        shareButton.hidden = YES;
        [self addSubview:shareButton];
        
        //大字的 节省
        jieshengLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        jieshengLabel.text = NSLocalizedString(@"stats.save", nil);
        jieshengLabel.font = [UIFont systemFontOfSize:20];
        jieshengLabel.textColor = [UIColor whiteColor];
        jieshengLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:jieshengLabel];
        
        //百分比
        percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        percentLabel.textColor = [UIColor colorWithRed:46.0f/255.0 green:219.0f/255.0 blue:57.0f/255.0 alpha:1.0f];
        percentLabel.backgroundColor = [UIColor clearColor];
        percentLabel.font = PERCENT_FONT;
        [self addSubview:percentLabel];
        
        //百分号
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake( 270, 20, 30, 30)];
        label.textColor = percentLabel.textColor;
        label.backgroundColor = [UIColor clearColor];
        label.text = @"%";
        label.font = [UIFont systemFontOfSize:25];
        [self addSubview:label];
        [label release];
        
        //节省详细的 横条
        barView = [[DatastatsTotalBarView alloc] initWithFrame:CGRectMake(10, 60, 300, 89)];
        [self addSubview:barView];
    }
    return self;
}


- (void) dealloc
{
    [percentLabel release];
    [barView release];
    [jieshengLabel release];
    [stats release];
    [super dealloc];
}


#pragma mark - setters

- (void) setStats:(StageStats *)st
{
    [stats release];
    stats = [st retain];
    
    long bytesBefore = 0;
    long bytesAfter = 0;
    float percent = 0;
    
    if ( stats ) {
        if ( stats.bytesBefore != 0 ) {
            percent = (float) (stats.bytesBefore - stats.bytesAfter) / (float) stats.bytesBefore;
        }
        bytesAfter = stats.bytesAfter;
        bytesBefore = stats.bytesBefore;
    }
    
    percentLabel.text = [NSString stringWithFormat:@"%.1f", percent * 100.0f];
    CGSize size = [percentLabel.text sizeWithFont:PERCENT_FONT];
    percentLabel.frame = CGRectMake( 270 - size.width, 10, size.width, 50);
    jieshengLabel.frame = CGRectMake( 270 - size.width - 50, 33, 50, 22);
    
    DatastatsBarItem* item1 = [[DatastatsBarItem alloc] init];
    item1.description = NSLocalizedString(@"stats.compressed", nil);
    item1.number = bytesAfter;
    
    DatastatsBarItem* item2 = [[DatastatsBarItem alloc] init];
    item2.description =NSLocalizedString(@"stats.save", nil);
    item2.number = bytesBefore - bytesAfter;
    
    barView.item1 = item1;
    barView.item2 = item2;
    [item1 release];
    [item2 release];
    [barView setNeedsLayout];
}




@end
