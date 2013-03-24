//
//  MonthSliderView.m
//  flashapp
//
//  Created by 李 电森 on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MonthSliderView.h"

@implementation MonthSliderView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        leftButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        leftButton.frame = CGRectMake(5, frame.size.height / 2 - 12, 25, 25);
        [leftButton setImage:[UIImage imageNamed:@"right_triangle.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(pressLeftButton) forControlEvents:UIControlEventTouchUpInside];
        leftButton.hidden = YES;
        [self addSubview:leftButton];

        rightButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        rightButton.frame = CGRectMake( 285, frame.size.height / 2 - 12, 25, 25);
        [rightButton setImage:[UIImage imageNamed:@"left_triangle.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(pressRightButton) forControlEvents:UIControlEventTouchUpInside];
        rightButton.hidden = YES;
        [self addSubview:rightButton];
    }
    
    return self;
}


- (void) pressLeftButton
{
    if ( [delegate respondsToSelector:@selector(monthSliderPrev)] ) {
        [delegate performSelector:@selector(monthSliderPrev)];
    }
}


- (void) pressRightButton
{
    if ( [delegate respondsToSelector:@selector(monthSliderNext)] ) {
        [delegate performSelector:@selector(monthSliderNext)];
    }
}


- (void) setDelegate:(id)d
{
    if ( delegate ) [delegate release];
    delegate = [d retain];
    
    if ( [delegate respondsToSelector:@selector(hasPrevMonth)] ) {
        NSNumber* r = (NSNumber*) [delegate performSelector:@selector(hasPrevMonth)];
        int b = [r intValue];
        if ( b ) {
            leftButton.hidden = NO;
        }
        else {
            leftButton.hidden = YES;
        }
    }
    else {
        leftButton.hidden = YES;
    }
    
    if ( [delegate respondsToSelector:@selector(hasNextMonth)] ) {
        NSNumber* r = (NSNumber*) [delegate performSelector:@selector(hasNextMonth)];
        int b = [r intValue];
        if ( b ) {
            rightButton.hidden = NO;
        }
        else {
            rightButton.hidden = YES;
        }
    }
    else {
        rightButton.hidden = YES;
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

@end
