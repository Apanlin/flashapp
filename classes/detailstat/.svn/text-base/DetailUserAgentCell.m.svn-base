//
//  DetailUserAgentCell.m
//  flashapp
//
//  Created by 李 电森 on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailUserAgentCell.h"
#import "StringUtil.h"
#import "SectionBarItem.h"

@implementation DetailUserAgentCell

@synthesize stats;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flashget.png"]];
        [self.contentView addSubview:iconImage];
        
        UIColor* color = [UIColor darkGrayColor];
        
        userAgentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        userAgentLabel.font = [UIFont systemFontOfSize:14];
        userAgentLabel.textColor = color;
        [self.contentView addSubview:userAgentLabel];
        
        percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        percentLabel.font = [UIFont systemFontOfSize:12];
        percentLabel.textColor = color;
        [self.contentView addSubview:percentLabel];
        
        dataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dataLabel.font = [UIFont systemFontOfSize:11];
        dataLabel.textColor = color;
        [self.contentView addSubview:dataLabel];
        
        barView = [[SectionBarView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:barView];
    }
    return self;
}


- (void) dealloc
{
    [stats release];
    [iconImage release];
    [percentLabel release];
    [userAgentLabel release];
    [dataLabel release];
    [barView release];
    [super dealloc];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void) setStats:(StatsDetail *)st
{
    if ( stats ) [stats release];
    stats = [st retain];
    
    userAgentLabel.text = st.userAgent;
    
    float beforeBytes = st.before;
    float compressBytes = st.before - st.after;
    float percent = compressBytes / beforeBytes;
    
    NSString* beforeBytesString = [NSString stringForByteNumber:beforeBytes];
    NSString* compressBytesString = [NSString stringForByteNumber:compressBytes];
    
    percentLabel.text = [NSString stringWithFormat:@"(节省%.1f%%)", percent * 100];
    dataLabel.text = [NSString stringWithFormat:@"节省%@(原%@)", compressBytesString, beforeBytesString];
    
    SectionBarItem* item1 = [[SectionBarItem alloc] init];
    item1.color = [UIColor colorWithRed:121.0/255 green:193.0/255 blue:103.0/255 alpha:1.0];
    item1.percent = percent;
    
    SectionBarItem* item2 = [[SectionBarItem alloc] init];
    item2.color = [UIColor blackColor];
    item2.percent = 1 - percent;
    
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    barView.sections = array;
    [item1 release];
    [item2 release];
    
    [self layoutSubviews];
}


- (void) layoutSubviews
{
    float left = 10;
    
    CGRect rect = CGRectMake(left, 7, 16, 16);
    iconImage.frame = rect;
    
    rect = CGRectMake(left+20, 5, 230, 20);
    userAgentLabel.frame = rect;
    
    rect = CGRectMake(230, 5, 120, 15);
    percentLabel.frame = rect;
    
    rect = CGRectMake(left, 25, 300, 20);
    dataLabel.frame = rect;
    
    rect = CGRectMake(left, 45, 100, 8);
    barView.frame = rect;
    [barView setNeedsDisplay];
    
    [super layoutSubviews];
}

@end
