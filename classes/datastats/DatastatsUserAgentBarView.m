//
//  DatastatsUserAgentBarView.m
//  flashapp
//
//  Created by 李 电森 on 12-1-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsUserAgentBarView.h"
#import "DetailStatsAppViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "DatastatsBarItem.h"
#import "QuartzUtils.h"
#import "DateUtils.h"

#define TAG_ICON 5501

@implementation DatastatsUserAgentBarView

@synthesize color;
@synthesize stats;
@synthesize startTime;
@synthesize endTime;
@synthesize locked;


#pragma mark - init & destroy methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 8, 9, 12, 9)];
        imageView.tag = TAG_ICON;
        imageView.image = [UIImage imageNamed:@"diamond.png"];
        [self addSubview:imageView];
        [imageView release];
        
        userAgentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 6, 275, 15)];
        userAgentLabel.textColor = [UIColor whiteColor];
        userAgentLabel.font = [UIFont systemFontOfSize:16];
        userAgentLabel.textAlignment = UITextAlignmentLeft;
        userAgentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:userAgentLabel];
        
        afterLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 62, 24)];
        afterLabel.textColor = [UIColor colorWithRed:149.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f];
        afterLabel.font = [UIFont systemFontOfSize:14];
        afterLabel.textAlignment = UITextAlignmentRight;
        afterLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:afterLabel];
        
        compressLabel = [[UILabel alloc] initWithFrame:CGRectMake(237, 30, 58, 24)];
        compressLabel.textColor = [UIColor colorWithRed:46.0f/255.0f green:218.0f/255.0f blue:56.0f/255.0f alpha:1.0f];
        compressLabel.font = [UIFont systemFontOfSize:14];
        compressLabel.textAlignment = UITextAlignmentLeft;
        compressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:compressLabel];

        barView = [[DatastatsBarView alloc] initWithFrame:CGRectMake( 67, 28, 170, 26)];
        [self addSubview:barView];
        
        UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(2, 62, 302, 4)];
        line.image = [[UIImage imageNamed:@"grayLine.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        [self addSubview:line];
        [line release];
        
        layerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [layerButton addTarget:self action:@selector(layerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        layerButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:layerButton];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(295, (frame.size.height - 14)/2, 10, 14)];
        imageView.image = [UIImage imageNamed:@"left_arrow2.png"];
        [self addSubview:imageView];
        [imageView release];
    }
    return self;
}


- (void) layerButtonClicked
{
    layerButton.backgroundColor = [UIColor blackColor];
    layerButton.alpha = 0.5f;
    [self performSelector:@selector(showAppDetailView:) withObject:layerButton afterDelay:0.3f];
}


- (void) showAppDetailView:(UIButton*)button
{
    button.backgroundColor = [UIColor clearColor];
    
    time_t today = [DateUtils getLastTimeOfToday];
    DetailStatsAppViewController* controller = [[DetailStatsAppViewController alloc] init];
    controller.startTime = startTime;
    controller.endTime = (endTime > today ? today : endTime);
    controller.userAgent = stats.userAgent;
    controller.uaStr = stats.uaStr;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.tintColor = [UIColor blackColor];
    [[AppDelegate getAppDelegate].leveyTabBarController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) dealloc
{
    [userAgentLabel release];
    [afterLabel release];
    [compressLabel release];
    [barView release];
    [super dealloc];
}


#pragma mark - setter

- (void) setStats:(StatsDetail *)st
{
    [stats release];
    stats = [st retain];
    
    if ( stats ) {
        afterLabel.text = [NSString stringForByteNumber:stats.after decimal:1];
        compressLabel.text = [NSString stringForByteNumber:(stats.before - stats.after) decimal:1];
        userAgentLabel.text = st.userAgent;
        
        DatastatsBarItem* item1 = [[DatastatsBarItem alloc] init];
        item1.number = stats.after;
        item1.showPercent = NO;
        item1.showNumber = NO;
        item1.showDesc = NO;
        barView.item1 = item1;
        [item1 release];

        DatastatsBarItem* item2 = [[DatastatsBarItem alloc] init];
        item2.number = stats.before - stats.after;
        item2.showPercent = YES;
        item2.showNumber = NO;
        item2.showDesc = NO;
        barView.item2 = item2;
        [item2 release];
        barView.userInteractionEnabled = NO;
        
        [barView setNeedsLayout];
    }
}


- (void) setLocked:(BOOL)b
{
    UIImageView* imageView = (UIImageView*) [self viewWithTag:TAG_ICON];
    if ( b ) {
        imageView.image = [UIImage imageNamed:@"lock.png"];
    }
    else {
        imageView.image = [UIImage imageNamed:@"diamond.png"];
    }
    [imageView setNeedsDisplay];
}


#pragma mark - drawRect

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef color1 = [UIColor blackColor].CGColor;
    CGPoint start = CGPointMake(0, self.frame.size.height - 2);
    CGPoint end = CGPointMake(self.frame.size.width, self.frame.size.height - 2);
    drawLine( context, 1, color1, start, end);

    CGColorRef color2 = [UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1.0f].CGColor;
    start = CGPointMake(0, self.frame.size.height - 1);
    end = CGPointMake(self.frame.size.width, self.frame.size.height - 1);
    drawLine( context, 1, color2, start, end);
}


#pragma mark - touch events

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    beTouched = YES;
//    UITouch* touch = [[event allTouches] anyObject];
//    startPoint = [touch locationInView:self];
//    NSLog(@"touch me!");
//}


//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ( !beTouched ) return;
//    beTouched = NO;
//    
//    UITouch* touch = [[event allTouches] anyObject];
//    CGPoint endPoint = [touch locationInView:self];
//    
//    float deltaX = endPoint.x - startPoint.x;
//    float deltaY = endPoint.y - startPoint.y;
//    if ( deltaX < 50 && deltaY < 50 ) {
//        DetailStatsAppViewController* controller = [[DetailStatsAppViewController alloc] init];
//        [[[AppDelegate getAppDelegate] currentNavigationController] pushViewController:controller animated:YES];
//        [controller release];
//    }
//}

@end
