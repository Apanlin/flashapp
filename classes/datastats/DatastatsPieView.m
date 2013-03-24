//
//  DatastatsPieView.m
//  flashapp
//
//  Created by 李 电森 on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsPieView.h"
#import "CLMView.h"
#import "StatsDetail.h"
#import "QuartzUtils.h"

@implementation DatastatsPieView

@synthesize userAgents;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        colors = [[NSArray arrayWithObjects:
                                  [UIColor colorWithRed:254.0f/255.0f green:227.0f/255.0f blue:4.0f/255.0f alpha:1.0f],
                                  [UIColor colorWithRed:237.0f/255.0f green:121.0f/255.0f blue:124.0f/255.0f alpha:1.0f],
                                  [UIColor colorWithRed:182.0f/255.0f green:140.0f/255.0f blue:197.0f/255.0f alpha:1.0f],
                                  [UIColor colorWithRed:136.0f/255.0f green:236.0f/255.0f blue:216.0f/255.0f alpha:1.0f],
                                  [UIColor colorWithRed:249.0f/255.0f green:183.0f/255.0f blue:212.0f/255.0f alpha:1.0f],
                                  [UIColor colorWithRed:125.0f/255.0f green:195.0f/255.0f blue:233.0f/255.0f alpha:1.0f],
                                  nil] retain];

        self.backgroundColor = [UIColor clearColor];
        userAgents = nil;
    }
    return self;
}


- (void) dealloc
{
    [userAgents release];
    [colors release];
    [super dealloc];
}


- (void) setUserAgents:(NSArray *)agents
{
    [userAgents release];
    
    CLMView *cv = [[CLMView alloc] initWithFrame:CGRectMake(20, 30, 170, 170)];
    //cv.scaleY = 0.6;
    //cv.spaceHeight = 80;
    
    //cv.titleArr = [NSArray	arrayWithObjects:@"iphone", @"sybian", @"windowbile", @"mego",@"android",nil];
    NSMutableArray* valueArr = [NSMutableArray array];
    userAgents = [[NSMutableArray alloc] init];
    
    StatsDetail* other = [[StatsDetail alloc] init];
    other.userAgent  = NSLocalizedString(@"stats.other", nil);
    
    NSMutableArray* tempArr = [NSMutableArray array];
    [tempArr addObjectsFromArray:agents];
    [tempArr sortUsingSelector:@selector(compareByAfter:)];
    
    int count = 0;
    for ( StatsDetail* stats in tempArr ) {
        if ( count < 5 ) {
            [valueArr addObject:[NSNumber numberWithLong:stats.after]];
            [userAgents addObject:stats];
        }
        else {
            other.before += stats.before;
            other.after += stats.after;
        }
        count++;
    }
    
    if ( other.after > 0 ) {
        [valueArr addObject:[NSNumber numberWithLong:other.after]];
        [userAgents addObject:other];
    }
    [other release];
    
    cv.valueArr = valueArr;
    cv.colorArr = colors;
    cv.radius = 85;
    [self addSubview:cv];
    [cv release];
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //UIImage* image = [[UIImage imageNamed:@"grayPannel.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
    UIImage* image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    int count = 0;
    int y = 20;
    int height = 20;
    UIFont* textFont = [UIFont systemFontOfSize:14];
    
    for ( StatsDetail* stats in userAgents ) {
        //画矩形
        UIColor* color = [colors objectAtIndex:(count % [colors count])];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect r = CGRectMake( 210, y + (height - 11)/2, 11, 11);
        drawRectangle( context, 1.0, color.CGColor, color.CGColor, r );
        
        [[UIColor whiteColor] set];
        [stats.userAgent drawInRect:CGRectMake(225, y, 80, height) withFont:textFont lineBreakMode:UILineBreakModeClip];
        
        count++;
        y += height;
    }
    
}


@end
