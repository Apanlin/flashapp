//
//  InputAlertView.m
//  flashapp
//
//  Created by 李 电森 on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InputAlertView.h"

@implementation InputAlertView

@synthesize textField;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        textField = [[UITextField alloc] init];
        [self addSubview:textField];
    }
    return self;
}


- (void) dealloc
{
    [textField release];
    [super dealloc];
}


- (void) layoutSubviews
{
    for (UIView* v in self.subviews ) {
        if ( [v isKindOfClass:[UIButton class]] ) {
            CGRect rect = v.frame;
            rect.origin.y = self.bounds.size.height - rect.size.height - 15;
            v.frame = rect;
        }
        else if ( [v isKindOfClass:[UITextField class]] ) {
            v.frame = CGRectMake(3, 40, 50, 30);
            [self bringSubviewToFront:v];
        }
    }
    
    [super layoutSubviews];
}


- (void) show
{
    [super show];

    CGRect rect = self.bounds;
    rect.size.height += 35;
    self.bounds = rect;
    [self setNeedsLayout];
    [self setNeedsDisplay];
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
