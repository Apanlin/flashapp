//
//  DialogView.m
//  flashapp
//
//  Created by 李 电森 on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialogView.h"

@implementation DialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"close2.png"] forState:UIControlStateNormal];
        closeButton.frame = CGRectZero;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage* image = [[UIImage imageNamed:@"share_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [image drawInRect:CGRectMake(0, 12, self.frame.size.width - 12, self.frame.size.height - 12)];
}


- (void) layoutSubviews
{
    [super layoutSubviews];

    //UIImage* image = [[UIImage imageNamed:@"share_bg.png"] stretchableImageWithLeftCapWidth:48 topCapHeight:43];
    //[image drawInRect:CGRectMake(0, 17, self.frame.size.width - 17, self.frame.size.height - 17)];
    closeButton.frame = CGRectMake( self.frame.size.width -34, 0, 34, 34);
}


- (void) close
{
    self.hidden = YES;
}

@end
