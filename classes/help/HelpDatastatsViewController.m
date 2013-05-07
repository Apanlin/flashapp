//
//  HelpListViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "HelpDatastatsViewController.h"
#import "HelpTextViewController.h"
#import "HelpNoDataViewController.h"
#import "AppDelegate.h"

#define TAG_CELL_LABEL 101


@interface HelpDatastatsViewController ()

@end

@implementation HelpDatastatsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"诊断与帮助";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if ( row == 0 ) {
        return 39;
    }
    else if ( row == 3 ) {
        return 50;
    }
    else if ( row == 4 ) {
        return 44;
    }
    else {
        return 40;
    }
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = self.tableView.backgroundColor;
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 290, (height - 14)/2, 10, 14)];
        imageView.image = [UIImage imageNamed:@"left_arrow2.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 12, 12)];
        imageView.image = [UIImage imageNamed:@"help_prismatic.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];

        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(42, 10, 260, 20)];
        label.tag = TAG_CELL_LABEL;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 3;
        label.lineBreakMode = UILineBreakModeCharacterWrap;
        [cell.contentView addSubview:label];
        [label release];
    }
    
    cell.backgroundView = [self tableView:tableView viewForCellBackground:indexPath];
    cell.selectedBackgroundView = [self tableView:tableView viewForCellSelectedBackground:indexPath];
    
    int row = indexPath.row;
    UILabel * label = (UILabel*) [cell.contentView viewWithTag:TAG_CELL_LABEL];
    if ( row == 3 ) {
        label.frame = CGRectMake(42, 5, 240, 40);
    }
    else {
        label.frame = CGRectMake(42, 10, 240, 20);
    }
    label.font = [UIFont systemFontOfSize:15];
    
    switch (row) {
        case 0:
            label.text = @"为什么没有流量统计数据？";
            break;
        case 1:
            label.text = @"节省统计数据为什么会有滞后？";
            break;
        case 2:
            label.text = @"什么是节省流量？如何计算出来的？";
            break;
        case 3:
            label.text = @"软件内的50m流量限额或者注册赠送的30m流量是运营商的套餐流量吗？";
            break;
        case 4:
            label.text = @"为什么套餐流量有时不准确？";
            break;
        default:
            break;
    }
    
    return cell;
}


- (UIView*) tableView:(UITableView *)tableView viewForCellBackground:(NSIndexPath*)indexPath
{
    int row = indexPath.row;
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)] autorelease];
    
    UIImageView* imageView;
    if ( row == 0 ) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
        imageView.image = [[UIImage imageNamed:@"help_cell_bg_top.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    }
    else if ( row == 4 ) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
        imageView.image = [[UIImage imageNamed:@"help_cell_bg_bottom.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    }
    else {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
        imageView.image = [[UIImage imageNamed:@"help_cell_bg_middle.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:4];
    }
    
    [view addSubview:imageView];
    [imageView release];
    
    return view;
}



- (UIView*) tableView:(UITableView *)tableView viewForCellSelectedBackground:(NSIndexPath*)indexPath
{
    int row = indexPath.row;
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)] autorelease];
    
    UIImageView* imageView;
    if ( row == 0 ) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
        imageView.image = [[UIImage imageNamed:@"help_cell_bg_top_h.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    }
    else if ( row == 4 ) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
        imageView.image = [[UIImage imageNamed:@"help_cell_bg_bottom_h.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    }
    else {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
        imageView.image = [[UIImage imageNamed:@"help_cell_bg_middle_h.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:4];
    }
    
    [view addSubview:imageView];
    [imageView release];
    
    return view;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
     AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ( row == 0 ) {
        HelpNoDataViewController* controller = [[HelpNoDataViewController alloc] init];
        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if ( row == 1 ) {
        HelpTextViewController* controller = [[HelpTextViewController alloc] init];
        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
        controller.hidesBottomBarWhenPushed = YES;
        controller.titleText = @"节省统计数据为什么会有滞后？";
        controller.answerText = @"统计系统每隔5分钟汇总统计用户节省流量的情况。如果没有看到数据，请5分钟之后再刷新查看。";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if ( row == 2 ) {
        HelpTextViewController* controller = [[HelpTextViewController alloc] init];
        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
        controller.hidesBottomBarWhenPushed = YES;
        controller.titleText = @"什么是节省流量？如何计算出来的？";
        controller.answerText = @"飞速流量压缩仪将您的访问请求结果压缩后再发送到手机上，压缩后节省的数据量就是节省量。";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if ( row == 3 ) {
        HelpTextViewController* controller = [[HelpTextViewController alloc] init];
        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
        controller.hidesBottomBarWhenPushed = YES;
        controller.titleText = @"软件内的50MB流量限额或者注册赠送的30MB是赠送的套餐流量吗？";
        controller.answerText = @"流量限额是飞速流量压缩仪本月可以为您节省的量，并不是您套餐的流量。您可以通过邀请好友或者微博分享的方式增加流量限额，以便让飞速更好的为您工作。";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    }
    else if ( row == 4 ) {
        HelpTextViewController* controller = [[HelpTextViewController alloc] init];
        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
        controller.hidesBottomBarWhenPushed = YES;
        controller.titleText = @"压缩后流量是什么含义？为什么和移动运营商计费数据不同？";
        controller.answerText = @"压缩后流量是指通过飞速软件处理后，实际发生的网络流量。但是由于飞速软件不压缩上行数据，或由于用户部分时间未使用飞速软件，导致计费数据和压缩后流量不一致。 为了保证用户上传内容的完整性，且不影响上传用途，本软件不压缩上传的内容，这部分流量也不会计算着压缩后的流量中。";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


@end
