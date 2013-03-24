//
//  SectionBarView.m
//  flashapp
//
//  Created by 李 电森 on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SectionBarView.h"
#import "SectionBarItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionBarView

@synthesize sections;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void) dealloc
{
    [sections release];
    [super dealloc];
}



- (void) drawSection:(SectionBarItem*)barItem inRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth( context, 1.0 );
    CGContextSetStrokeColorWithColor( context, barItem.color.CGColor );
    CGContextSetFillColorWithColor( context, barItem.color.CGColor );
    CGContextAddRect( context, rect );
    CGContextDrawPath( context, kCGPathFillStroke );
    
    NSString* text = barItem.text;
    if ( text && [text length] > 0 ) {
        UIFont* font = barItem.font;
        if ( !font ) font = [UIFont systemFontOfSize:12];
        
        CGSize size = [text sizeWithFont:font];
        [[UIColor blackColor] set];
        float x = rect.origin.x + (rect.size.width - size.width) / 2;
        float y = rect.origin.y + (rect.size.height - size.height) / 2;
        [text drawInRect:CGRectMake(x, y, size.width, size.height) withFont:font];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat x = 0;
    CGFloat w = 0;
    CGFloat totalW = rect.size.width;
    CGFloat h = rect.size.height;
    
    for ( SectionBarItem* bar in sections ) {
        w = totalW * bar.percent;
        CGRect rect = CGRectMake(x, 0, w, h);
        [self drawSection:bar inRect:rect];
        x = x + w;
    }
}


@end
