//
//  DatastatsBarView.m
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsBarView.h"
#import "StringUtil.h"

#define DESC_FONT [UIFont systemFontOfSize:14]

@implementation DatastatsBarView

@synthesize item1;
@synthesize item2;

#pragma mark - init & destroy method

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        seperateView = [[UIView alloc] initWithFrame:CGRectZero];
        seperateView.backgroundColor = [UIColor whiteColor];
        [self addSubview:seperateView];
        
        imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView1.image = [[UIImage imageNamed:@"lightgrayBar2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [self addSubview:imageView1];
        
        imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView2.image = [[UIImage imageNamed:@"greenBar2.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        [self addSubview:imageView2];
        
        triangleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        triangleView.image = [UIImage imageNamed:@"oringeTriangle2.png"];
        [self addSubview:triangleView];
        
        descLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        descLabel1.textColor = [UIColor whiteColor];
        descLabel1.backgroundColor = [UIColor clearColor];
        descLabel1.textAlignment = UITextAlignmentCenter;
        descLabel1.font = DESC_FONT;
        [self addSubview:descLabel1];
        
        descLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        descLabel2.textColor = [UIColor whiteColor];
        descLabel2.backgroundColor = [UIColor clearColor];
        descLabel2.textAlignment = UITextAlignmentCenter;
        descLabel2.font = DESC_FONT;
        [self addSubview:descLabel2];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) dealloc
{
    [imageView1 release];
    [imageView2 release];
    [triangleView release];
    [descLabel1 release];
    [descLabel2 release];
    [item1 release];
    [item2 release];
    [seperateView release];
    [super dealloc];
}


#pragma mark - draw & layout methods

- (void) layoutSubviews
{
    long number1 = item1.number;
    long number2 = item2.number;
    float percent = (float)number1 / (float)(number1 + number2);

    CGFloat item1Width = (self.frame.size.width - 2) * percent;
    CGFloat item2Width = self.frame.size.width - 2 - item1Width;
    CGFloat height = self.frame.size.height - 2;
    
    NSString* item1Desc = nil;
    NSString* item2Desc = nil;
    
    if ( item1.showDesc ) {
        item1Desc = item1.description;
    }
    else if ( item1.showPercent ) {
        item1Desc = [NSString stringWithFormat:@"%.1f%%", percent * 100];
    }
    else if ( item1.showNumber ) {
        item1Desc = [NSString stringForByteNumber:item1.number];
    }
    
    if ( item2.showDesc ) {
        item2Desc = item2.description;
    }
    else if ( item2.showPercent ) {
        item2Desc = [NSString stringWithFormat:@"%.1f%%", (1 - percent) * 100];
    }
    else if ( item2.showNumber ) {
        item2Desc = [NSString stringForByteNumber:item2.number];
    }
    
    if ( item2Desc ) {
        CGSize s = [item2Desc sizeWithFont:DESC_FONT];
        CGFloat w = s.width;
        if ( w > item2Width ) {
            item2Width = w;
            item1Width = self.frame.size.width - 2 - item2Width;
        }
    }
    
    imageView1.frame = CGRectMake( 0, 2, item1Width, height );
    imageView2.frame = CGRectMake( item1Width + 2, 2, item2Width, height );
    seperateView.frame = CGRectMake( item1Width, 2, 2, height - 1 );
    triangleView.frame = CGRectMake( item1Width + 1 - 9 / 2, 0, 9, 9 );
    
    if ( item1.showDesc || item1.showNumber || item1.showPercent ) {
        descLabel1.frame = imageView1.frame;
        descLabel1.text = item1Desc;
        descLabel1.hidden = NO;
    }
    else {
        descLabel1.hidden = YES;
    }
    
    if ( item2.showDesc || item2.showNumber || item2.showPercent ) {
        descLabel2.frame = imageView2.frame;
        descLabel2.text = item2Desc;
        descLabel2.hidden = NO;
    }
    else {
        descLabel2.hidden = YES;
    }
    
    [super layoutSubviews];
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
