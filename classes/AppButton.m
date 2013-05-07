//
//  AppButton.m
//  flashapp
//
//  Created by 朱广涛 on 13-5-2.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "AppButton.h"

@implementation AppButton
@synthesize appID;
@synthesize appLink;
@synthesize appOprice;

-(void)dealloc
{
    [appID release];
    [appLink release];
    [appOprice release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
