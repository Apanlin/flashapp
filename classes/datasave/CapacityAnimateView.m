//
//  CapacityAnimateView.m
//  flashapp
//
//  Created by 李 电森 on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CapacityAnimateView.h"
#import "StringUtil.h"

@implementation CapacityAnimateView

@synthesize capacity;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) setCapacity:(float)c
{
    capacity = c;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    
    UIFont* bigFont = [UIFont boldSystemFontOfSize:38];
    UIFont* smallFont = [UIFont systemFontOfSize:25];
    
    CGSize size1 = [@"+" sizeWithFont:smallFont];
    CGSize size2 = [@"MB" sizeWithFont:smallFont];

    NSString* message;
    if ( floor(capacity) == capacity ) {
        message = [NSString stringWithFormat:@"%d", (int)capacity];
    }
    else {
        message = [NSString stringWithFormat:@"%0.1f", capacity];
    }
    CGSize size = [message sizeWithFont:bigFont];
    
    [[UIColor greenColor] set];
    CGFloat y = (self.bounds.size.height - size.height) / 2;
    CGRect drawRect1 = CGRectMake( (self.bounds.size.width - (size1.width + size2.width + size.width))/2, 
                                  y + 10 ,
                                  size1.width, size1.height);
    [@"+" drawInRect:drawRect1 withFont:smallFont];
    
    [[UIColor greenColor] set];
    CGRect drawRect = CGRectMake( drawRect1.origin.x + drawRect1.size.width, y, size.width, size.height);
    [message drawInRect:drawRect withFont:bigFont];
    
    [[UIColor greenColor] set];
    CGRect drawRect2 = CGRectMake( drawRect.origin.x + drawRect.size.width, y + 10, size2.width, size2.height);
    [@"MB" drawInRect:drawRect2 withFont:smallFont];
}


@end
