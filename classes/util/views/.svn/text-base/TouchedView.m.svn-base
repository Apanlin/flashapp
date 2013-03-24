//
//  TouchedLabel.m
//  flashapp
//
//  Created by 李 电森 on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TouchedView.h"

@implementation TouchedView

@synthesize delegate;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( delegate && [delegate respondsToSelector:@selector(viewTouchesBegan:)] ) {
        [delegate performSelector:@selector(viewTouchesBegan:) withObject:self ];
    }
    
    UITouch* touch = [touches anyObject];
    guestureStartPoint = [touch locationInView:self];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGFloat deltaX = fabsf( guestureStartPoint.x - currentPoint.x );
    CGFloat deltaY = fabsf( guestureStartPoint.y - currentPoint.y );
    
    if ( deltaX < 25 && deltaY < 25 ) {
        //tap
        if ( delegate && [delegate respondsToSelector:@selector(viewTouchTap:)] ) {
            [delegate performSelector:@selector(viewTouchTap:) withObject:self ];
        }
    }
    else {
        //swipe
        if ( currentPoint.x > guestureStartPoint.x ) {
            //right swipe
            if ( delegate && [delegate respondsToSelector:@selector(viewTouchRightSwipe:)] ) {
                [delegate performSelector:@selector(viewTouchRightSwipe:) withObject:self ];
            }
        }
        else if ( currentPoint.x < guestureStartPoint.x ) {
            //left swipe
            if ( delegate && [delegate respondsToSelector:@selector(viewTouchLeftSwipe:)] ) {
                [delegate performSelector:@selector(viewTouchLeftSwipe:) withObject:self ];
            }
        }
    }
}


- (void) dealloc
{
    [delegate release];
    [super dealloc];
}

@end
