//
//  MessageView.m
//  flashapp
//
//  Created by 李 电森 on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MessageView.h"


@implementation MessageView

@synthesize message;
@synthesize messageType;
@synthesize messageLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:0.8f];
        backgroudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:backgroudImageView];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont systemFontOfSize:14];
        messageLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:messageLabel];
    }
    return self;
}


- (void) dealloc
{
    [backgroudImageView release];
    [messageLabel release];
    [super dealloc];
}


- (void) setMessage:(NSString *)m
{
    messageLabel.text = m;
}


- (void) setBackgroundImage:(UIImage*)image
{
    backgroudImageView.image = image;
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
