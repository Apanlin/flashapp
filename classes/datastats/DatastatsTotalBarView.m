//
//  DatastatsBarView.m
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsTotalBarView.h"
#import "StringUtil.h"

#define DESC_FONT [UIFont systemFontOfSize:14]
#define NUMBER_FONT [UIFont systemFontOfSize:16]
#define UNIT_FONT [UIFont systemFontOfSize:12]


@implementation DatastatsTotalBarView

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
        imageView1.image = [[UIImage imageNamed:@"lightgrayBar.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
        [self addSubview:imageView1];
        
        imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView2.image = [[UIImage imageNamed:@"greenBar.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        [self addSubview:imageView2];
        
        imageView1_d = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView1_d.image = [[UIImage imageNamed:@"lightgrayBar_d.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
        [self addSubview:imageView1_d];
        
        imageView2_d = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView2_d.image = [[UIImage imageNamed:@"greenBar_d.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        [self addSubview:imageView2_d];

        triangleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        triangleView.image = [UIImage imageNamed:@"oringeTriangle.png"];
        [self addSubview:triangleView];
        
        //label。text = 压缩后
        descLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        descLabel1.textColor = [UIColor whiteColor];
        descLabel1.backgroundColor = [UIColor clearColor];
        descLabel1.textAlignment = UITextAlignmentCenter;
        descLabel1.font = DESC_FONT;
        [self addSubview:descLabel1];
        
        //label。text = 节约
        descLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        descLabel2.textColor = [UIColor whiteColor];
        descLabel2.backgroundColor = [UIColor clearColor];
        descLabel2.textAlignment = UITextAlignmentCenter;
        descLabel2.font = DESC_FONT;
        [self addSubview:descLabel2];
        
        //压缩后 数字， 没有 ‘M’
        numberLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        numberLabel1.textColor = [UIColor whiteColor];
        numberLabel1.backgroundColor = [UIColor clearColor];
        numberLabel1.font = NUMBER_FONT;
        numberLabel1.textAlignment = UITextAlignmentRight;
        [self addSubview:numberLabel1];
        
        //节约 数字， 没有M
        numberLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        numberLabel2.textColor = [UIColor whiteColor];
        numberLabel2.backgroundColor = [UIColor clearColor];
        numberLabel2.font = NUMBER_FONT;
        numberLabel2.textAlignment = UITextAlignmentRight;
        [self addSubview:numberLabel2];
        
        //压缩后面的 字母  M
        unitLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        unitLabel1.textColor = [UIColor whiteColor];
        unitLabel1.backgroundColor = [UIColor clearColor];
        unitLabel1.font = UNIT_FONT;
        unitLabel1.textAlignment = UITextAlignmentLeft;
        [self addSubview:unitLabel1];
        
        //节约后面的 字母 M
        unitLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        unitLabel2.textColor = [UIColor whiteColor];
        unitLabel2.backgroundColor = [UIColor clearColor];
        unitLabel2.font = UNIT_FONT;
        unitLabel2.textAlignment = UITextAlignmentLeft;
        [self addSubview:unitLabel2];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) dealloc
{
    [imageView1 release];
    [imageView2 release];
    [imageView1_d release];
    [imageView2_d release];
    [triangleView release];
    [descLabel1 release];
    [descLabel2 release];
    [numberLabel1 release];
    [numberLabel2 release];
    [unitLabel1 release];
    [unitLabel2 release];
    [item1 release];
    [item2 release];
    [seperateView release];
    [super dealloc];
}


#pragma mark - setter

- (void) setItem1:(DatastatsBarItem *)item
{
    [item1 release];
    item1 = [item retain];
    
    if ( item1 ) {
        descLabel1.text = item1.description;
        
        float number = [NSString bytesNumberByUnit:item1.number unit:@"MB"];
        NSString* item1Number = [NSString stringWithFormat:@"%.2f", number];
        NSString* item1Unit = @"M";
        
        numberLabel1.text = item1Number;
        unitLabel1.text = item1Unit;
    }
}


- (void) setItem2:(DatastatsBarItem *)item
{
    [item2 release];
    item2 = [item retain];
    
    if ( item2 ) {
        descLabel2.text = item2.description;
        
        float number = [NSString bytesNumberByUnit:item2.number unit:@"MB"];
        NSString* item2Number = [NSString stringWithFormat:@"%.2f", number];
        NSString* item2Unit = @"M";
        
        numberLabel2.text = item2Number;
        unitLabel2.text = item2Unit;
    }
}

#pragma mark - draw & layout methods

- (void) layoutSubviews
{
    long number1 = item1.number;
    long number2 = item2.number;

    float percent = 1.0;
    if ( number1 + number2 > 0 ) {
        percent = (float)number1 / (float)(number1 + number2);
    }

    CGFloat item1Width = (self.frame.size.width - 2) * percent;
    CGFloat item2Width = self.frame.size.width - 2 - item1Width;
    CGFloat height = 57;
    
    float item1Bytes = [NSString bytesNumberByUnit:item1.number unit:@"MB"];
    NSString* item1Number = [NSString stringWithFormat:@"%.2f", item1Bytes];
    NSString* item1Unit = @"M";
    
    float item2Bytes = [NSString bytesNumberByUnit:item2.number unit:@"MB"];
    NSString* item2Number =  [NSString stringWithFormat:@"%.2f", item2Bytes];
    NSString* item2Unit = @"M";
    
    CGSize item1NumberSize = [item1Number sizeWithFont:NUMBER_FONT];
    CGSize item1UnitSize = [item1Unit sizeWithFont:UNIT_FONT];
    
    CGSize item2NumberSize = [item2Number sizeWithFont:NUMBER_FONT];
    CGSize item2UnitSize = [item2Unit sizeWithFont:UNIT_FONT];
    CGFloat w = item2NumberSize.width + item2UnitSize.width;
    
    if ( w > item2Width ) {
        item2Width = w + 4;
        item1Width = self.frame.size.width - 2 - item2Width;
    }
    
    if ( item2.description) {
        CGSize s = [item2.description sizeWithFont:DESC_FONT];
        if ( s.width > item2Width ) {
            item2Width = s.width + 4;
            item1Width = self.frame.size.width - 2 - item2Width;
        }
    }
    
    imageView1.frame = CGRectMake( 0, 3, item1Width, height );
    imageView2.frame = CGRectMake( item1Width + 2, 3, item2Width, height );
    imageView1_d.frame = CGRectMake( 0, height + 4, item1Width, 27 );
    imageView2_d.frame = CGRectMake( item1Width + 2, height + 4, item2Width, 27 );
    
    seperateView.frame = CGRectMake( item1Width, 3, 2, height - 1 );
    triangleView.frame = CGRectMake( item1Width + 1 - 7, 0, 14, 14 );
    
    descLabel1.frame = CGRectMake( 0, 10, imageView1.frame.size.width, imageView1.frame.size.height / 2 - 7 );
    descLabel1.hidden = NO;
    
    CGFloat x = (item1Width - (item1NumberSize.width + item1UnitSize.width)) / 2;
    numberLabel1.frame = CGRectMake( x, height / 2, item1NumberSize.width, height / 2 - 5 );
    unitLabel1.frame = CGRectMake( x + item1NumberSize.width, height / 2 + 2, item1UnitSize.width, height / 2 - 5);
    
    descLabel2.frame = CGRectMake( imageView2.frame.origin.x, 10, imageView2.frame.size.width, imageView2.frame.size.height / 2 - 7 );
    descLabel2.hidden = NO;
    
    x = imageView2.frame.origin.x + (item2Width - (item2NumberSize.width + item2UnitSize.width)) / 2;
    numberLabel2.frame = CGRectMake( x, height / 2, item2NumberSize.width, height / 2 - 5 );
    unitLabel2.frame = CGRectMake( x + item2NumberSize.width, height / 2 + 2, item2UnitSize.width, height / 2 - 5);
    
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
