//
//  DatastatsTouchedView.m
//  flashapp
//
//  Created by 李 电森 on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DatasaveDialView.h"
#import "AppDelegate.h"
#import "QuartzUtils.h"
#import "StringUtil.h"
#import "UIDevice-Reachability.h"

@interface DatasaveDialView (private)
    - (void) refreshCapacity;
@end


@implementation DatasaveDialView

@synthesize totalStats;
@synthesize monthStats;

#pragma mark - init & destroy
- (void) checkConnection 
{
    ConnectionType type = [UIDevice connectionType]; 
    NSString* desc = nil;
    
    switch (type) {
        case UNKNOWN:
            desc = @"UNKNOWN";
            break;
        case CELL_2G:
            desc = @"CELL";
            break;
        case CELL_3G:
            desc = @"CELL";
            break;
        case CELL_4G:
            desc = @"CELL";
            break;
        case WIFI:
            desc = @"WIFI";
            break;
        case NONE:
            desc = @"NONE";
            break;
        case ETHERNET:
            desc = @"ETHERNET";
            break;
        default:
            desc = @"";
            break;
    }
    
    connectTypeLabel.text = desc;
}


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dial_bg.png"]];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7,6,147,137)];
        imageView.image = [UIImage imageNamed:@"dial.png"];
        [self addSubview:imageView];
        [imageView release];
        
        startAngle = 2 * PIE / 3;
        
        CGFloat width = 28;
        CGFloat height = 16;
        CGFloat pos[][2] = { 
            {38,120},
            {19,100},
            {8,70},
            {16,42},
            {37,21},
            {66,12},
            {98,20},
            {118,42},
            {126,70},
            {118,100},
            {96,118}
        };

        CGFloat w = width;
        for ( int i=0; i<11; i++ ) {
            if ( i == 10 ) w = 35;
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake( pos[i][0], pos[i][1], w, height)];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = UITextAlignmentCenter;
            label.tag = 100 + i;
            [self addSubview:label];
            [label release];
        }
        
        //节省
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(66,46,30,18)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        NSString* saveText = NSLocalizedString(@"dial.save.lable.text", nil);
        label.text = saveText;
        [self addSubview:label];
        [label release];
        
        
        //累计 
        label = [[UILabel alloc] initWithFrame:CGRectMake(60,85,42,21)];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        NSString* adjectiveText = NSLocalizedString(@"dial.adjective.lable.text", nil);
        label.text = adjectiveText;
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        [label release];

        // 0.00
        compressLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,60,58,32)];
        compressLabel.font = [UIFont systemFontOfSize:23];
        compressLabel.textColor = [UIColor colorWithRed:85.0f/255.0f green:238.0f/255.0f blue:95.0f/255.0f alpha:1.0f];
        compressLabel.backgroundColor = [UIColor clearColor];
        compressLabel.text = @"";
        [self addSubview:compressLabel];

        //节省多少   MB    的呢个label
        compressUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(99,69,24,21)];
        compressUnitLabel.font = [UIFont systemFontOfSize:12];
        compressUnitLabel.textColor = [UIColor whiteColor];
        compressUnitLabel.backgroundColor = [UIColor clearColor];
        compressUnitLabel.text = @"";
        [self addSubview:compressUnitLabel];

        
        //累计多少  数字  的呢个label
        totalCompressLabel = [[UILabel alloc] initWithFrame:CGRectMake(58,98,33,17)];
        totalCompressLabel.font = [UIFont systemFontOfSize:11];
        totalCompressLabel.textColor = [UIColor whiteColor];
        totalCompressLabel.backgroundColor = [UIColor clearColor];
        totalCompressLabel.text = @"";
        [self addSubview:totalCompressLabel];

        //累计多少   MB   的呢个label 
        totalCompressUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(91,97,42,21)];
        totalCompressUnitLabel.font = [UIFont systemFontOfSize:8];
        totalCompressUnitLabel.textColor = [UIColor whiteColor];
        totalCompressUnitLabel.backgroundColor = [UIColor clearColor];
        totalCompressUnitLabel.text = @"";
        [self addSubview:totalCompressUnitLabel];

        [self refreshCapacity];
        
        //网络段的 label
        connectTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(59,122,42,21)];
        connectTypeLabel.textColor = [UIColor whiteColor];
        connectTypeLabel.backgroundColor = [UIColor clearColor];
        connectTypeLabel.font = [UIFont systemFontOfSize:10];
        connectTypeLabel.textAlignment = UITextAlignmentCenter;
        connectTypeLabel.text = @"CELL";
        [self addSubview:connectTypeLabel];
        
        //节省详情的 BUTTON
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"blueButton.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(52,140,56,24);
        NSString* saveDetailText = NSLocalizedString(@"dial.saved.detail.lable.text", nil);
        [button setTitle:saveDetailText forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.titleLabel.textColor = [UIColor whiteColor];
        [button addTarget:self.delegate action:@selector(showDatastats) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self checkConnection];
    }
    
    return self;
}


- (void) dealloc
{
    [compressLabel release];
    [compressUnitLabel release];
    [totalCompressLabel release];
    [totalCompressUnitLabel release];
    [connectTypeLabel release];
    [totalStats release];
    [monthStats release];
    [super dealloc];
}


#pragma mark - drawRect & layout

- (void) refreshCapacity
{
    float quantity = [AppDelegate getAppDelegate].user.capacity; //
    int dialNumber = quantity / 10;
    UILabel* label;
    for ( int i=1; i<=9; i++ ) {
        int tag = 100 + i;
        label = (UILabel*) [self viewWithTag:tag];
        label.text = [NSString stringWithFormat:@"%d", dialNumber * i];
    }
    
    label = (UILabel*) [self viewWithTag:100];
    label.text = @"0M";
    
    label = (UILabel*) [self viewWithTag:110];
    if ( floor(quantity) == quantity ) { //返回小于或者等于指定表达式的最大整数 用 法
        label.text = [NSString stringWithFormat:@"%dM", (int)quantity];
    }
    else {
        label.text = [NSString stringWithFormat:@"%.1fM", quantity];
    }
}

- (void) setTotalStats:(StageStats *)st
{
    [totalStats release];
    totalStats = [st retain];
    
    NSString* data = @"0";
    NSString* unit = @"MB";
    if ( totalStats ) {
        long total = totalStats.bytesBefore - totalStats.bytesAfter;
        float f = [NSString bytesNumberByUnit:total unit:unit];
        data = [NSString stringWithFormat:@"%.2f", f];
    }
    
    CGSize size1 = [data sizeWithFont:[UIFont systemFontOfSize:11]];
    CGSize size2 = [unit sizeWithFont:[UIFont systemFontOfSize:8]];
    
    CGFloat x = 80 - (size1.width + size2.width) / 2;
    totalCompressLabel.frame = CGRectMake( x, totalCompressLabel.frame.origin.y, size1.width, totalCompressLabel.frame.size.height);
    totalCompressLabel.text = data;
    
    totalCompressUnitLabel.frame = CGRectMake( x + size1.width, totalCompressUnitLabel.frame.origin.y, totalCompressUnitLabel.frame.size.width, totalCompressUnitLabel.frame.size.height);
    totalCompressUnitLabel.text = unit;
}


- (void) setMonthStats:(StageStats *)st
{
    [monthStats release];
    monthStats = [st retain];
    
    NSString* data = @"0";
    NSString* unit = @"MB";
    if ( monthStats ) {
        long monthCompressBytes = monthStats.bytesBefore - monthStats.bytesAfter;
        float f = [NSString bytesNumberByUnit:monthCompressBytes unit:unit];
        data = [NSString stringWithFormat:@"%.2f", f];
    }
    
    CGSize size1 = [data sizeWithFont:[UIFont systemFontOfSize:23]];
    CGSize size2 = [unit sizeWithFont:[UIFont systemFontOfSize:12]];
    
    CGFloat x = 80 - (size1.width + size2.width) / 2;
    compressLabel.frame = CGRectMake( x, compressLabel.frame.origin.y, size1.width, compressLabel.frame.size.height);
    compressLabel.text = data;
    
    compressUnitLabel.frame = CGRectMake( x + size1.width, compressUnitLabel.frame.origin.y, size2.width, compressUnitLabel.frame.size.height);
    compressUnitLabel.text = unit;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ( monthStats ) {
        long bytes = monthStats.bytesBefore - monthStats.bytesAfter;
        if ( bytes > 0 ) {
            float quantity = [AppDelegate getAppDelegate].user.capacity;
            float total = quantity * 1024.0f * 1024.0f;
            
            float angle = (bytes / total) * 300;
            angle = angle / 360 * 2 * PIE;
            float endAngle = startAngle + angle;
            
            CGFloat centerX = 6 + 75;
            CGFloat centerY = 4 + 75;
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //endAngle = 2 * PIE + PIE / 3;
            endAngle = MIN( endAngle, 2 * PIE + PIE / 3 - PIE / 180);
            drawArc( context, 23, [[UIColor colorWithRed:104.0f/255.0f green:246.0f/255.0f blue:113.0f/255.0f alpha:1.0f] CGColor], CGPointMake(centerX, centerY), 58, startAngle, endAngle );
        }
    }
}

@end
