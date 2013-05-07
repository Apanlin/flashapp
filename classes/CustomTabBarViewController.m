////
////  CustomTabBarViewController.m
////  flashapp
////
////  Created by 朱广涛 on 13-4-17.
////  Copyright (c) 2013年 Home. All rights reserved.
////
//
//#import "CustomTabBarViewController.h"
//#import "AppDelegate.h"
//#import "TCUtils.h"
//#import "DatasaveViewController.h"
//#import "DatastatsScrollViewController.h"
//#import "HelpListViewController.h"
//#import "SettingViewController.h"
//
//
//@interface CustomTabBarViewController ()
//
//@property (nonatomic ,retain) NSMutableArray *btnArray;
//
//
//@end
//
//@implementation CustomTabBarViewController
//@synthesize btnArray;
//@synthesize currentSelectedIndex;
//@synthesize btnHidden;
// 
//static BOOL selfInstallProfile;
//
//-(void)dealloc
//{
//
//    [btnArray release];
//    [super dealloc];
//}
//
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//
//+(id)CustomTabBar:(BOOL)justinstallProfile
//{
//    static CustomTabBarViewController *customTabBar;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        customTabBar = [[CustomTabBarViewController alloc] init];
//    });
//    
//    selfInstallProfile = justinstallProfile;
//    
//    return customTabBar;
//}
//
//- (void) setNavigationBar:(UINavigationBar *)_navigationBar {
//    if ([_navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
//        [_navigationBar setBackgroundImage:[[UIImage imageNamed:@"nav_bg.png"]
//          stretchableImageWithLeftCapWidth:1 topCapHeight:0] forBarMetrics:UIBarMetricsDefault];
//    }
//}
//
//-(void)initController
//{
//    DatasaveViewController *dataserviceViewController = nil;
//    if ( iPhone5 ) {
//        dataserviceViewController = [[[DatasaveViewController alloc] initWithNibName:@"DatasaveViewController-5" bundle:nil] autorelease];
//    }
//    else {
//        dataserviceViewController = [[[DatasaveViewController alloc] initWithNibName:@"DatasaveViewController" bundle:nil] autorelease];
//    }
//    
//    dataserviceViewController.installingProfile = selfInstallProfile;
////    UINavigationController* firstNav = [[UINavigationController alloc] initWithRootViewController:dataserviceViewController];
////    [self setNavigationBar:firstNav.navigationBar];
//    
//    //    功 能: 获取当前的系统时间，返回的结果是一个time_t类型（即int64类型），其实就是一个大整数，其值表示从CUT（Coordinated Universal Time）时间1970年1月1日00:00:00（称为UNIX系统的Epoch时间）到当前时刻的秒数。
//    time_t now;
//    time(&now);
//    time_t peroid[2];
//    [TCUtils getPeriodOfTcMonth:peroid time:now];
//    DatastatsScrollViewController* monthStatsController = [[[DatastatsScrollViewController alloc] init] autorelease];
//    monthStatsController.startTime = peroid[0];
//    monthStatsController.endTime = peroid[1];
////    UINavigationController* secondNav = [[UINavigationController alloc] initWithRootViewController:monthStatsController];
////    [self setNavigationBar:secondNav.navigationBar];
//    
//    
//    HelpListViewController* helpController = [[[HelpListViewController alloc] init] autorelease];
////    UINavigationController* thirdNav = [[UINavigationController alloc] initWithRootViewController:helpController];
////    [self setNavigationBar:thirdNav.navigationBar];
//    
//    SettingViewController* settingcontroller = [[[SettingViewController alloc]initWithStyle:UITableViewStyleGrouped] autorelease];
////    UINavigationController* forthNav = [[UINavigationController alloc] initWithRootViewController:settingcontroller];
////    [self setNavigationBar:forthNav.navigationBar];
//
//    NSArray *controllerArray = [NSArray arrayWithObjects:dataserviceViewController,monthStatsController,helpController,settingcontroller, nil];
//    
////    [firstNav release];
////    [secondNav release];
////    [thirdNav release];
////    [forthNav release];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    
//    self.tabBar.hidden = YES;
//    
//    [self initController];
//    
//    currentSelectedIndex = 0 ;
//    
//    //创建按钮
//    
//    int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
//    
//    double _width = 320 / viewCount;
//    
//    double _height = self.tabBar.frame.size.height;
//    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setImage:[UIImage imageNamed:@"tab_service.png"] forState:UIControlStateNormal];
//    [btn1 setImage:[UIImage imageNamed:@"tab_service.png"] forState:UIControlStateHighlighted];
//    
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setImage:[UIImage imageNamed:@"tab_report.png"] forState:UIControlStateNormal];
//    [btn2 setImage:[UIImage imageNamed:@"tab_report.png"] forState:UIControlStateHighlighted];
//    
//    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn3 setImage:[UIImage imageNamed:@"tab_help.png"] forState:UIControlStateNormal];
//    [btn3 setImage:[UIImage imageNamed:@"tab_help.png"] forState:UIControlStateHighlighted];
//    
//    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn4 setImage:[UIImage imageNamed:@"tab_set.png"] forState:UIControlStateNormal];
//    [btn4 setImage:[UIImage imageNamed:@"tab_set.png"] forState:UIControlStateHighlighted];
//    
//    self.btnArray = [[NSMutableArray alloc] initWithObjects:btn1,btn2,btn3,btn4,nil];
//    
//    for (int i = 0 ; i < viewCount; i ++) {
//       UIButton *btn = [btnArray objectAtIndex:i];
//        btn.frame = CGRectMake(_width * i, [[UIScreen mainScreen] bounds].size.height - 44-49-20, _width, _height);
//        btn.tag = i ;
//        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//    }
//    
//    [self btnPressed:[btnArray objectAtIndex:0]];
//    
//}
//
//-(void)selectJumeViewPage:(int)jumpViewPage
//{
//    [self btnPressed:[btnArray objectAtIndex:jumpViewPage]];
//}
//
//-(void)btnPressed:(UIButton *)btn
//{
//    UIButton *btns = [btnArray objectAtIndex:currentSelectedIndex];
//    
//    switch (btns.tag) {
//        case 0:
//            [btns setImage:[UIImage imageNamed:@"tab_service.png"] forState:UIControlStateNormal];
//            break;
//        case 1:
//             [btns setImage:[UIImage imageNamed:@"tab_report.png"] forState:UIControlStateNormal];
//            break;
//        case 2:
//             [btns setImage:[UIImage imageNamed:@"tab_help.png"] forState:UIControlStateNormal];
//            break;
//        case 3:
//             [btns setImage:[UIImage imageNamed:@"tab_set.png"] forState:UIControlStateNormal];
//            break;
//        default:
//            break;
//    }
//    
//    switch (btn.tag) {
//        case 0:
//            [btn setImage:[UIImage imageNamed:@"tab_service_select.png"] forState:UIControlStateNormal];
//            break;
//        case 1:
//            [btn setImage:[UIImage imageNamed:@"tab_report_select.png"] forState:UIControlStateNormal];
//            break;
//        case 2:
//            [btn setImage:[UIImage imageNamed:@"tab_help_select.png"] forState:UIControlStateNormal];
//            break;
//        case 3:
//            [btn setImage:[UIImage imageNamed:@"tab_set_select.png"] forState:UIControlStateNormal];
//            break;
//        default:
//            break;
//    }
//    
//    currentSelectedIndex = btn.tag;
//    self.selectedViewController = [self.viewControllers objectAtIndex:btn.tag];
//    
//}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//@end
