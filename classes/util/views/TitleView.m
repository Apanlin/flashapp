//
//  TitleView.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor whiteColor];
        imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"title_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    imageView.frame = self.bounds;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //UIImage* image = [[UIImage imageNamed:@"title_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    //[image drawInRect:rect];
}


@end
