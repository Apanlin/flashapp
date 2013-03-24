//
//  MonthTotalCell.m
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MonthTotalCell.h"
#import "StringUtil.h"

@implementation MonthTotalCell


@synthesize compressBytes;


- (UIFont*) dataFont
{
    return [UIFont systemFontOfSize:40];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.textColor = [UIColor lightGrayColor];
        headerLabel.font = [UIFont systemFontOfSize:13];
        headerLabel.text = @"本月节省的流量为：";
        [self.contentView addSubview:headerLabel];
        
        dataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dataLabel.font = [self dataFont];
        [self.contentView addSubview:dataLabel];
        
        unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        unitLabel.font = [UIFont systemFontOfSize:22];
        [self.contentView addSubview:unitLabel];
    }
    return self;
}


- (void) dealloc
{
    [headerLabel release];
    [dataLabel release];
    [unitLabel release];
    [super dealloc];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setCompressBytes:(long)bytes
{
    compressBytes = bytes;
    NSArray* arr = [NSString bytesAndUnitString:compressBytes];
    dataLabel.text = [arr objectAtIndex:0];
    unitLabel.text = [arr objectAtIndex:1];
    [self setNeedsLayout];
}


- (void) layoutSubviews
{
    float left = 10;
    
    CGRect rect = CGRectMake(left, 5, 300, 20);
    headerLabel.frame = rect;
    
    UIFont* font = [self dataFont];
    CGSize size = [dataLabel.text sizeWithFont:font];
    rect = CGRectMake(left, 30, size.width, 40);
    dataLabel.frame = rect;
    
    rect = CGRectMake(left + size.width, 42, 300 - size.width, 25);
    unitLabel.frame = rect;
    
    [super layoutSubviews];
}

@end
