//
//  MonthUserAgentStatView.m
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MonthUserAgentStatView.h"
#import "TotalStats.h"
#import "SectionBarItem.h"
#import "QuartzUtils.h"
#import "StringUtil.h"


@implementation MonthUserAgentStatView

@synthesize userAgentStatsArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        barView = [[SectionBarView alloc] initWithFrame:CGRectMake(10, 10, 300, 70)];
        [self addSubview:barView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void) dealloc
{
    [barView release];
    [userAgentStatsArray release];
    [super dealloc];
}


- (UIColor*) sectionBarColor:(NSInteger)index
{
    int i = index % 6;
    UIColor* color = nil;
    switch (i) {
        case 0:
            color = [UIColor colorWithRed:114.0/255 green:184.0/255 blue:99.0/255 alpha:1.0];
            break;
        case 1:
            color = [UIColor colorWithRed:157.0/255 green:214.0/255 blue:238.0/255 alpha:1.0];
            break;
        case 2:
            color = [UIColor colorWithRed:71.0/255 green:140.0/255 blue:192.0/255 alpha:1.0];
            break;
        case 3:
            color = [UIColor colorWithRed:138.0/255 green:94.0/255 blue:159.0/255 alpha:1.0];
            break;
        case 4:
            color = [UIColor colorWithRed:230.0/255 green:97.0/255 blue:100.0/255 alpha:1.0];
            break;
        case 5:
            color = [UIColor colorWithRed:250.0/255 green:158.0/255 blue:108.0/255 alpha:1.0];
            break;
        default:
            break;
    }
    return color;
}


- (void) setUserAgentStatsArray:(NSArray *)array
{
    if ( userAgentStatsArray ) [userAgentStatsArray release];
    userAgentStatsArray = [array retain];
    
    NSMutableArray* sections = [NSMutableArray array];
    float total = 0;
    
    for ( TotalStats* stats in userAgentStatsArray ) {
        total += stats.totalbefore;
    }
    
    int count = 0;
    for ( TotalStats* stats in userAgentStatsArray ) {
        SectionBarItem* barItem = [[SectionBarItem alloc] init];
        barItem.percent = stats.totalbefore / total;
        barItem.color = [self sectionBarColor:count];
        [sections addObject:barItem];
        [barItem release];
        count++;
    }
    
    [barView setSections:sections];
    [barView setNeedsDisplay];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float left = 10;
    float x = 0;
    float y = 95;
    int count = 0;
    UIFont* font = [UIFont systemFontOfSize:11];
    
    UIColor* fontColor = [UIColor darkGrayColor];
    [fontColor set];
    
    UIColor* lineColor = [UIColor lightGrayColor];
    
    for ( TotalStats* stats in userAgentStatsArray ) {
        //画矩形
        CGRect rect = CGRectMake(left, y+2, 10, 10);
        UIColor* color = [self sectionBarColor:count];
        drawRectangle( context, 1.0, color.CGColor, color.CGColor, rect );
        
        [[UIColor darkGrayColor] set];

        //写节省的数据
        NSString* text = [NSString stringForByteNumber:stats.totalbefore];
        CGSize size = [text sizeWithFont:font];
        rect = CGRectMake(300 - size.width, y, size.width, 15);
        [text drawInRect:rect withFont:font];
        
        //写userAgent
        x = left + 10 + 8;
        rect = CGRectMake(x, y, 300 - x - size.width, 15);
        [stats.userAgent drawInRect:rect withFont:font];
        
        //画线
        drawLine( context, 0.5, lineColor.CGColor, CGPointMake(left, y+18), CGPointMake(300, y+18));
        
        y += 25;
        count++;
    }
}


@end
