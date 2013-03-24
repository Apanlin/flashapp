//
//  ShareView.m
//  flashapp
//
//  Created by 李 电森 on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareView.h"
#import "AppDelegate.h"
#import "StatsDayDAO.h"
#import "UserSettings.h"
#import "DateUtils.h"
#import "OpenUDID.h"
#import "TwitPicClient.h"
#import "JSON.h"

@implementation ShareView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.scrollEnabled = NO;
        [self addSubview:tableView];
    }
    return self;
}


- (void) dealloc
{
    [tableView release];
    [super dealloc];
}


- (void) reloadData
{
    [tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if ( row == 0 ) return 30;
    else return 50;
}


- (UITableViewCell*) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    NSString* cellId = @"shareTableViewCell";
    UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:cellId];
    if ( cell ) {
        for ( UIView* v in cell.contentView.subviews ) {
            [v removeFromSuperview];
        }
    }
    else {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    
    CGFloat width = self.frame.size.width - 37;
    UIFont* font = [UIFont systemFontOfSize:17];
    
    if ( row == 0 ) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, width, 20)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.text = NSLocalizedString(@"stats.share.text", nil);
        [cell.contentView addSubview:label];
        [label release];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 29, width, 1)];
        imageView.image = [UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    else if ( row == 1 ) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 27, 27)];
        imageView.image = [UIImage imageNamed:@"sina_weibo.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, width - 50, 20)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.text = NSLocalizedString(@"stats.share.toSina", nil);
        [cell.contentView addSubview:label];
        [label release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 49, width, 1)];
        imageView.image = [UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    else if ( row == 2 ) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 27, 27)];
        imageView.image = [UIImage imageNamed:@"qq_weibo.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, width, 20)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.text = @"分享到腾讯微博";
        [cell.contentView addSubview:label];
        [label release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 49, width, 1)];
        imageView.image = [UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    else if ( row == 3 ) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 27, 27)];
        imageView.image = [UIImage imageNamed:@"renren.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, width, 20)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.text = NSLocalizedString(@"stats.share.toRenRen", nil);
        [cell.contentView addSubview:label];
        [label release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 49, width, 1)];
        imageView.image = [UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    else if ( row == 4 ) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 27, 27)];
        imageView.image = [UIImage imageNamed:@"weixin.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, width, 20)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.text = NSLocalizedString(@"stats.share.toWeixinFriend", nil);
        [cell.contentView addSubview:label];
        [label release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 49, width, 1)];
        imageView.image = [UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    
    return cell;
}


- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        return nil;
    }
    else {
        return indexPath;
    }
}


- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self close];
    
    NSInteger row = indexPath.row;
    
    NSString* sns = nil;
    UIViewController* controller = [[AppDelegate getAppDelegate] currentViewController];
    
    if ( row == 4 ) {
        //微信分享
        if ( [controller respondsToSelector:@selector(sendWeixinImage)]) { //判断是否实现了sendWeixinImage函数
            [controller performSelector:@selector(sendWeixinImage) withObject:nil afterDelay:0.3f];
        }
    }
    else {
        if ( row == 1 ) {
            //新浪微博
            sns = @"sinaWeibo";
        }
        else if ( row == 2 ) {
            //腾讯微博
            sns = @"QQWeibo";
        }
        else if ( row == 3 ) {
            //renren
            sns = @"renren";
        }
        if ( [controller respondsToSelector:@selector(shareToSNS:)]) {
            [controller performSelector:@selector(shareToSNS:) withObject:sns afterDelay:0.3f];
        }
    }
}



- (void) layoutSubviews
{
    tableView.frame = CGRectMake( 15, 27, self.frame.size.width - 42, self.frame.size.height - 37);
    [super layoutSubviews];
    NSLog(@"self.frame.size.width = %f",self.frame.size.width);
    NSLog(@"self.frame.size.height = %f",self.frame.size.height);
}


- (void) open
{
    self.hidden = NO;
    self.alpha = 1.0f;
}


- (void) close
{
    self.hidden = YES;
    self.alpha = 0.0f;
}



@end
