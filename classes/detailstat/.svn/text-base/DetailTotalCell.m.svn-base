//
//  DetailTotalCell.m
//  flashapp
//
//  Created by 李 电森 on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailTotalCell.h"
#import "StringUtil.h"
#import "SectionBarItem.h"

@implementation DetailTotalCell

@synthesize stat;


- (UIFont*) fontForCompressData
{
    return [UIFont fontWithName:@"STHeitiSC-Medium" size:40];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.text = @"本阶段已节约流量：";
        headerLabel.font = [UIFont systemFontOfSize:13];
        headerLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:headerLabel];
        
        compressDataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        compressDataLabel.font = [self fontForCompressData];
        [self.contentView addSubview:compressDataLabel];
        
        compressUnitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        compressUnitLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
        [self.contentView addSubview:compressUnitLabel];
        
        originDataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        originDataLabel.font = [UIFont systemFontOfSize:13];
        originDataLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:originDataLabel];
        
        barView = [[SectionBarView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:barView];
    }
    return self;
}


- (void) dealloc 
{
    [stat release];
    [headerLabel release];
    [compressDataLabel release];
    [compressUnitLabel release];
    [originDataLabel release];
    [barView release];
    [super dealloc];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void) layoutSubviews
{
    CGFloat left = 10;
    CGRect rect = CGRectMake( left, 10, 260, 15 );
    headerLabel.frame = rect;
    
    UIFont* font = [self fontForCompressData];
    NSString* s = compressDataLabel.text;
    CGSize size = [s sizeWithFont:font];
    rect = CGRectMake( left, 25, size.width, 50 );
    compressDataLabel.frame = rect;
    
    rect = CGRectMake( left + size.width, 43, 320 - left - size.width, 25);
    compressUnitLabel.frame = rect;
    
    rect = CGRectMake( left, 75, 260, 20 );
    originDataLabel.frame = rect;
    
    rect = CGRectMake( left, 100, 300, 20 );
    barView.frame = rect;
    [barView setNeedsDisplay];
}


- (void) setStat:(TotalStats *)st
{
    if ( stat ) [stat release];
    stat = [st retain];
    
    float compressByte = stat.totalbefore - stat.totalafter;
    NSArray* array = [NSString bytesAndUnitString:compressByte];
    compressDataLabel.text = [array objectAtIndex:0];
    compressUnitLabel.text = [array objectAtIndex:1];
    
    NSString* originByte = [NSString stringForByteNumber:stat.totalbefore];
    originDataLabel.text = [NSString stringWithFormat:@"原流量为%@",originByte];
    
    SectionBarItem* item1 = [[SectionBarItem alloc] init];
    item1.percent = compressByte / stat.totalbefore;
    item1.color = [UIColor colorWithRed:121.0/255 green:193.0/255 blue:103.0/255 alpha:1.0];
    item1.text = [NSString stringWithFormat:@"%.1f%%", item1.percent * 100];

    SectionBarItem* item2 = [[SectionBarItem alloc] init];
    item2.percent = 1 - item1.percent;
    item2.color = [UIColor blackColor];
    
    NSArray* items = [NSArray arrayWithObjects:item1, item2, nil];
    [item1 release];
    [item2 release];
    
    barView.sections = items;
    [barView setNeedsDisplay];
    
    [self layoutSubviews];
}


@end
