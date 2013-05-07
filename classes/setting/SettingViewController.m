//
//  SettingViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SettingViewController.h"
#import "LoginNewViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "WeiboViewController.h"
#import "AccountViewController.h"
#import "HelpViewController.h"
#import "SetupViewController.h"
#import "APNViewController.h"
#import "IDCPickerViewController.h"
#import "ImageCompressRadioViewController.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "IFDataViewController.h"
#import "UsedLogViewController.h"
#import "IFDataLogViewController.h"
#import "UserAgentLockDAO.h"
#import "AppDelegate.h"
#import "LeveyTabBarController.h"
#import "RecommendViewController.h"

#define TAG_PROFILE_SWITCH 200
#define TAG_LOCATION_SWITCH 201
#define TAG_ALERT_PROFILE 300
#define TAG_ALERT_IDC 301
#define TAG_ALERT_UNLOCK 302

#define CELL_BGCOLOR [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:1.0f];

@interface SettingViewController ()


@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [client release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor* bgColor = [UIColor colorWithRed:46.0f/255.0f green:47.0f/255.0f blue:47.0f/255.0f alpha:1.0f];
    //self.view.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.tableView.backgroundView = nil;

    self.navigationItem.title = NSLocalizedString(@"setName", nil);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 32);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"newApp.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showNewsAppBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    UIImageView *newAppShow = [[UIImageView alloc] initWithFrame:CGRectMake(28, 10, 12, 12)];
    newAppShow.tag = 12345;
    newAppShow.image = [UIImage imageNamed:@"redDot.png"];
    newAppShow.hidden = YES;
    [self.navigationController.navigationBar addSubview:newAppShow];
    
//    //有新应用的时候的通知，通知显示小红点
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAppDian) name:ShowAppRedDianNotification object:nil];
//    //当点击按钮的时候 ， 取消显示的小红点
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenAppDian) name:HiddenAppRedDianNotification object:nil];
        
    self.tableView.separatorColor = [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0f];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadData];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [client cancel];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:NO];
    
    BOOL xsmf = [[NSUserDefaults standardUserDefaults] boolForKey:XSMF_APP];
    BOOL rmyx = [[NSUserDefaults standardUserDefaults] boolForKey:RMYX_APP];
    
    if ( xsmf||rmyx) {
        [self showAppDian];
    }else{
        [self hiddenAppDian];
    }
}

#pragma mark --------- left Btn or notification method
-(void)showAppDian
{
    UIImageView *imgView = (UIImageView *)[self.navigationController.navigationBar viewWithTag:12345];
    imgView.hidden = NO;
}

-(void)hiddenAppDian
{
    UIImageView *imgView = (UIImageView *)[self.navigationController.navigationBar viewWithTag:12345];
    imgView.hidden = YES;
}

-(void)showNewsAppBtn
{
    RecommendViewController *controller = [RecommendViewController getRecommendViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.tintColor =  RGB(48,48,50);
    [[AppDelegate getAppDelegate].leveyTabBarController presentModalViewController:nav animated:YES];
    [nav release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UIDevice* device = [UIDevice currentDevice];
    float version = [device.systemVersion floatValue];
    NSString* stype = [AppDelegate getAppDelegate].user.stype;
    
    if ( section == 0 ) {
        return 1;
    }
     else if ( section == 1 ) {
         return 2;
     }
     else if ( section == 2 ) {
         int count = 0;
         if ( version >= 4.0 ) {
             if ( [@"vpn" isEqualToString:stype] ) {
                 //vpn下不显示“APN校对”和“删除描述文件”
                 count = 3;
             }
             else {
                 count = 5;
             }
         }
         else {
             count = 3;
         }
         if ( lockedAppCount > 0 ) count ++;
         return count;
     }
     else if ( section == 3 ) {
         return 1;
     }
     else if ( section == 4 ) {
#ifdef NETMETER_DEBUG         
         return 6;
#else
         return 3;
#endif
     }
     return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    UIDevice* device = [UIDevice currentDevice];
    float version = [device.systemVersion floatValue];
    NSString* stype = [AppDelegate getAppDelegate].user.stype;
    
    switch (section) {
        case 0:
            //帐号设置
            return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
            break;
            
        case 1:
            switch (row) {
                case 0:
                    //使用帮助
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    break;
                case 1:
                    //新手上路
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
            if ( version >= 4.0 ) {
                if ( row == 0 ) {
                    //网速优化
                    return [self tableView:tableView ChangeCellForRowAtIndexPath:indexPath];
                }
                else if ( row == 1 ) {
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                }
                else {
                    if ( lockedAppCount == 0 ) row ++;
                    if ( row == 2 ) {
                        //解锁
                        return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    }
                    else if ( row == 3 ) {
                        //服务状态
                        return [self tableView:tableView profileCellForRowAtIndexPath:indexPath];
                    }
                    else {
                        if ( [@"vpn" isEqualToString:stype] ) row++;
                        if ( row == 4 ) {
                            //APN校对
                            return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                        }
                        else if ( row == 5 ) {
                            //删除描述文件
                            return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                        }
                    }
                }
            }
            else {
                if ( row == 0 ) {
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                }
                else if ( row == 1 ) {
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                }
                else {
                    if ( lockedAppCount == 0 ) row ++;
                    if ( row == 2 ) {
                        //解锁
                        return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    }
                    else if ( row == 3 ) {
                        //删除描述文件
                        return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    }
                }
            }
            break;
        case 3:
            //官方微博
            return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
            break;
            
        case 4:
            switch (row) {
                case 0:
                    //软件评分
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    break;
                case 1:
                    //意见反馈
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    break;
                case 2:
                    //关于飞速
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                    break;
                case 3:
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                case 4:
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                case 5:
                    return [self tableView:tableView labelCellForRowAtIndexPath:indexPath];
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return nil;
}


- (UITableViewCell*) tableView:(UITableView *)tableView labelCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIDevice* device = [UIDevice currentDevice];
    float version = [device.systemVersion floatValue];
    NSString* stype = [AppDelegate getAppDelegate].user.stype;

    NSString* myIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        cell.backgroundColor = CELL_BGCOLOR;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_arrow.png"]] autorelease];
    }
    
    switch (section) {
        //section 0
        case 0:
            //帐号设置
            cell.textLabel.text = NSLocalizedString(@"set.userAccount.set", nil);
            break;
        
        //section 1
        case 1:
            switch (row) {
                case 0:
                    //使用帮助
                    cell.textLabel.text = NSLocalizedString(@"set.used.help", nil);
                    break;
                case 1:
                    //新手上路
                    cell.textLabel.text = NSLocalizedString(@"set.newUser.help", nil);
                    break;
                default:
                    break;
            }
            break;
            
        //section 2
        case 2:
            if ( version >= 4.0 ) {
                if ( row == 0 ) {
                    //网速优化
                    //不会出现在这里
//                    NSString* s = NSLocalizedString(@"set.speed.optimization", nil);
                }
                else if ( row == 1 ) {
                    //图片压缩质量
                    cell.textLabel.text = NSLocalizedString(@"set.image.radio", nil);
                }
                else {
                    if ( lockedAppCount == 0 ) row ++;
                    if ( row == 2 ) {
                        //解锁
                        cell.textLabel.text = NSLocalizedString(@"set.lockedapp.all_unlock", nil);
                    }
                    else if ( row == 3 ) {
                        //服务状态
                        //不会出现在这儿
                    }
                    else {
                        if ( [@"vpn" isEqualToString:stype] ) row++;
                        if ( row == 4 ) {
                            //APN校对
                            cell.textLabel.text = NSLocalizedString(@"set.APN.adjust", nil);
                        }
                        else if ( row == 5 ) {
                            //删除描述文件
                            cell.textLabel.text = NSLocalizedString(@"set.profile.delete", nil);
                        }
                    }
                }
            }
            else {
                if ( row == 0 ) {
                    //网速优化
                    cell.textLabel.text = NSLocalizedString(@"set.speed.optimization", nil);
                }
                else if ( row == 1 ) {
                    //图片压缩质量
                    cell.textLabel.text = NSLocalizedString(@"set.image.radio", nil);
                }
                else {
                    if ( lockedAppCount == 0 ) row ++;
                    if ( row == 2 ) {
                        //解锁
                        cell.textLabel.text = NSLocalizedString(@"set.lockedapp.all_unlock", nil);
                    }
                    else if ( row == 3 ) {
                        //删除描述文件
                        cell.textLabel.text = NSLocalizedString(@"set.profile.delete", nil);
                    }
                }
            }
            break;
        
        //section 3
        case 3:
            //官方微博
            cell.textLabel.text = NSLocalizedString(@"set.offical.weibo", nil);
            break;
        
        //section 4
        case 4:
            switch (row) {
                case 0:
                    //软件评分
                    cell.textLabel.text = NSLocalizedString(@"set.software.mark", nil);
                    break;
                case 1:
                    //意见反馈
                    cell.textLabel.text = NSLocalizedString(@"set.feedBack", nil);
                    break;
                case 2:
                    //关于飞速
                    cell.textLabel.text = NSLocalizedString(@"set.about.flashApp", nil);
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"set.network.interface.test", nil);
                    break;
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"set.traffic.used.log.test", nil);
                    break;
                case 5:
                    cell.textLabel.text = NSLocalizedString(@"set.network.interface.log.test", nil);
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (UITableViewCell*) tableView:(UITableView *)tableView profileCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* myIdentifier = @"setProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        cell.backgroundColor = CELL_BGCOLOR;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        UISwitch* profileSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 40, 20)];
        profileSwitch.tag = TAG_PROFILE_SWITCH;
        [profileSwitch addTarget:self action:@selector(profileSetting:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:profileSwitch];
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* stype = user.stype;
    UISwitch* switcher = (UISwitch*) [cell.contentView viewWithTag:TAG_PROFILE_SWITCH];
    
    if ( [@"vpn" isEqualToString:stype] ) {
        cell.textLabel.text = @"自动模式(已关闭)";
    }
    else {
        if ( user.proxyFlag == INSTALL_FLAG_NO ) {
            cell.textLabel.text = NSLocalizedString(@"set.service.status.closed", nil);
            switcher.on = NO;
        }
        else if ( user.proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
            cell.textLabel.text = NSLocalizedString(@"set.service.status.closed", nil);
            switcher.on = NO;
        }
        else {
            cell.textLabel.text = NSLocalizedString(@"set.service.status.opened", nil);
            switcher.on = YES;
        }
    }
    
    return cell;
}

/*! @brief 设置第三列的第一行cell
 *
 * 根据服务状态的不同来设置第三列的第一个cell，服务状态开启的时候cell显示‘网速优化’，服务状态关闭的时候，cell显示的‘服务状态（已关闭）’
 * @param 操作的tableView
 * @param 表格的列号和行号
 * @return cell
 */
- (UITableViewCell*) tableView:(UITableView *)tableView ChangeCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* myIdentifier = @"changeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        cell.backgroundColor = CELL_BGCOLOR;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    IDCInfo* idc = [user currentIDC];
    if ( idc ) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"set.speed.optimization", nil), idc.name];
    }
    else {
        cell.textLabel.text = NSLocalizedString(@"set.speed.optimization", nil);
    }
    
    return cell;
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
    int section = indexPath.section;
    int row = indexPath.row;
    
    if ( section == 2 ) {
        UIDevice* device = [UIDevice currentDevice];
        float version = [device.systemVersion floatValue];
        if ( version >= 4.0 && section == 2 ) {
            if ( lockedAppCount == 0 ) {
                if ( row == 2 ) return nil;
            }
            else {
                if ( row == 3 ) return nil;
            }
        }
    }
    
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    UIDevice* device = [UIDevice currentDevice];
    float version = [device.systemVersion floatValue];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (section) {
        case 0: {
            //帐号设置
            if ( user.username && user.username.length > 0 ) {
                AccountViewController* controller = [[AccountViewController alloc] init];
                [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else {
                LoginNewViewController* controller = [[LoginNewViewController alloc] init];
                [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            break;
        }
        case 1: {
            if ( row == 0 ) {
                HelpViewController* controller = [[HelpViewController alloc] init];
                controller.showCloseButton = NO;
                [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else {
                SetupViewController* controller = [[SetupViewController alloc] init];
                [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                controller.hidesBottomBarWhenPushed = YES;
                controller.isSetup = NO;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            break;
        }
        case 2: {
            if ( version >= 4.0 ) {
                if ( row == 0 ) {
                    //机房选择
                    [self.tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
                    [self alertIDCMessage];
                }
                else if ( row == 1 ) {
                    //图片质量
                    ImageCompressRadioViewController* controller = [[ImageCompressRadioViewController alloc] init];
                    [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                }
                else {
                    if ( lockedAppCount == 0 ) row ++;
                    if ( row == 2 ) {
                        //解锁
                        [self unlockButtonClick];
                    }
                    else if ( row == 3 ) {
                        //服务状态
                        //不可能执行到这儿
                    }
                    else {
                        if ( [@"vpn" isEqualToString:user.stype] ) row++;
                        if ( row == 4 ) {
                            //APN校对
                            APNViewController* controller = [[APNViewController alloc] init];
                            [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                            controller.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:controller animated:YES];
                            [controller release];
                        }
                        else if ( row == 5 ) {
                            //删除描述文件
                            HelpViewController* controller = [[HelpViewController alloc] init];
                            controller.showCloseButton = NO;
                            if ( [@"vpn" compare:user.stype] == NSOrderedSame ) {
                                controller.page = @"vpn/CLO";
                            }
                            else {
                                controller.page = @"profile/YDD";
                            }
                            [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                            controller.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:controller animated:YES];
                            [controller release];
                        }
                    }
                }
            }
            else {
                if ( row == 0 ) {
                    //机房选择
                    [self.tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
                    [self alertIDCMessage];
                }
                else if ( row == 1 ) {
                    //图片质量
                    ImageCompressRadioViewController* controller = [[ImageCompressRadioViewController alloc] init];
                    [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                }
                else {
                    if ( lockedAppCount == 0 ) row ++;
                    if ( row == 2 ) {
                        //解锁
                        [self unlockButtonClick];
                    }
                    else if ( row == 3 ) {
                        //删除描述文件
                        HelpViewController* controller = [[HelpViewController alloc] init];
                        controller.showCloseButton = NO;
                        controller.page = @"profile/YDD";
                        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                        controller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:controller animated:YES];
                        [controller release];
                    }
                }
            }
            break;
        }
        case 3: {
            //官方微博
            WeiboViewController* controller = [[WeiboViewController alloc] init];
            [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            break;
        }
        case 4: {
            if ( row == 0 ) {
                [AppDelegate showUserReviews];
            }
            else if ( row == 1 ) {
                //建议反馈
                FeedbackViewController* controller = [[FeedbackViewController alloc] init];
                [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else if ( row == 2 ) {
                //关于飞速
                AboutViewController* controller = [[AboutViewController alloc] init];
                [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else if ( row == 3 ) {
                IFDataViewController* controller = [[IFDataViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else if ( row == 4 ) {
                UsedLogViewController* controller = [[UsedLogViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else if ( row == 5 ) {
                IFDataLogViewController* controller = [[IFDataLogViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
        }
        default:
            break;
    }
}


-(void)alertIDCMessage{
    ConnectionType type = [UIDevice connectionType]; 
    NSString* desc = nil;
    //type = CELL_3G;
    NSString* title = NSLocalizedString(@"set.alertIDCMessage.title", nil);
    NSString* closeButtonTitle = NSLocalizedString(@"closeName", nil);
    NSString *cancelText = NSLocalizedString(@"cancleName", nil);
    NSString *continueText = NSLocalizedString(@"continueName", nil);
    
    switch (type) {
        case UNKNOWN:
        case NONE:
        case WIFI:
            desc = NSLocalizedString(@"set.alertIDCMessage.wifi", nil);
            UIAlertView* alertWifiView = [[UIAlertView alloc] initWithTitle:title message:desc delegate:self cancelButtonTitle:closeButtonTitle otherButtonTitles:nil, nil];
            [alertWifiView show];
            [alertWifiView release];
            break;
        default:
            desc = NSLocalizedString(@"set.alertIDCMessage.default", nil);
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:desc delegate:self cancelButtonTitle:cancelText otherButtonTitles:continueText, nil];
            [alertView show];
            [alertView release];
            alertView.tag = TAG_ALERT_IDC;
            break;
    }
}

#pragma mark - tool methods

- (void) installAPNProfile
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
        [AppDelegate installProfile:@"current" idc:user.idcCode];
    }
    else {
        [AppDelegate installProfile:@"current"];
    }
}


- (void) removeProfile
{
    [AppDelegate uninstallProfile:@"current"];
}


- (void) profileSetting:(id)sender
{
    NSString* stype = [AppDelegate getAppDelegate].user.stype;
    UISwitch* switcher = (UISwitch*)sender;
    
    if ( switcher.on ) {
        if ( [@"vpn" isEqualToString:stype] ) {
            [AppDelegate installProfileForServiceType:@"apn" nextPage:@"current" apn:nil idc:nil];
        }
        else {
            [self installAPNProfile];
        }
    }
    else {
        profileSwitcher = switcher;
        NSString *promptText = NSLocalizedString(@"promptName", nil);
        NSString *cancelText = NSLocalizedString(@"cancleName", nil);
        NSString *defineText = NSLocalizedString(@"defineName", nil);
        NSString *messageText = NSLocalizedString(@"set.service.close.prompt", nil);
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:promptText message:messageText delegate:self cancelButtonTitle:cancelText otherButtonTitles:defineText, nil];
        [alertView show];
        [alertView release];
        alertView.tag = TAG_ALERT_PROFILE;
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(alertView.tag == TAG_ALERT_PROFILE){
        if ( buttonIndex == 1 ) {
            [self removeProfile];
        }
        else {
            if ( profileSwitcher ) {
                profileSwitcher.on = YES;
            }
        }
    }
    else if(alertView.tag == TAG_ALERT_IDC && buttonIndex == 1){
        IDCPickerViewController* controller = [[IDCPickerViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if ( alertView.tag == TAG_ALERT_UNLOCK ) {
        if ( buttonIndex == 1 ) {
            [self unlockAllApps];
        }
    }
}


- (void) showProfileStatusCell
{
    //fwzt：服务状态;
    UITableViewCell* cell_fwzt = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
    if ( !cell_fwzt ) return;
    
    UISwitch* switcher = (UISwitch*) [cell_fwzt.contentView viewWithTag:TAG_PROFILE_SWITCH];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_NO || user.proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
        if ( [@"vpn" isEqualToString:user.stype] ) {
            cell_fwzt.textLabel.text = @"自动模式(已关闭)";
        }
        else {
            cell_fwzt.textLabel.text = NSLocalizedString(@"set.service.status.closed", nil);
        }
        if ( switcher ) switcher.on = NO;
    }
    else {
        cell_fwzt.textLabel.text = NSLocalizedString(@"set.service.status.opened", nil);
        if ( switcher ) switcher.on = YES;
    }
    
}


#pragma mark - unlock apps

- (void) unlockButtonClick
{
    if ( client ) return;
    
    NSDictionary* dic = [UserAgentLockDAO getAllLockedApps];
    if ( [dic count] == 0 ) {
        [AppDelegate showAlert:@"当前没有已经锁网的应用！"];
        return;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"您已经锁网了%d个应用。确定要将这些应用解锁吗？", [dic count]]
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = TAG_ALERT_UNLOCK;
    [alertView show];
    [alertView release];
}


- (void) unlockAllApps
{
    if ( client ) return;
    
    if ( ![AppDelegate networkReachable] ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败!"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?host=%@&port=%d",
                     API_BASE, API_SETTING_RESETUA,
                     user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didUnlockAllApps:obj:)];
    [client get:url];
}


- (void) didUnlockAllApps:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败"];
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    if ( [dic objectForKey:@"code"] && [dic objectForKey:@"code"] != [NSNull null] ) {
        int code = [[dic objectForKey:@"code"] intValue];
        if ( code == 200 ) {
            [UserAgentLockDAO deleteAll];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
            [AppDelegate showAlert:@"应用已经解锁！"];
            return;
        }
    }
    
    [AppDelegate showAlert:@"抱歉，操作失败!"];
}



#pragma mark - load Data

- (void) refresh
{
    [self.tableView reloadData];
}


- (void) loadData
{
    NSDictionary* dic = [UserAgentLockDAO getAllLockedApps];
    lockedAppCount = [dic count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
