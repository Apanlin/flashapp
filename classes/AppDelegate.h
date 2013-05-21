//
//  AppDelegate.h
//  flashapp
//
//  Created by 李 电森 on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import "TCLocationManager.h"
#import "UIDevice-Reachability.h"
#import "Reachability.h"
#import "UserSettings.h"
#import "TwitterClient.h"
#import "WXApi.h"
#import "LeveyTabBarController.h"

//#define NETMETER_DEBUG
//#define MJOY_91_APPID 6631
//#define MJOY_91_APPKEY @"9a8b45a2694115c99b501a01aa38022e"
#define MJOY_91_APPID 9623
#define MJOY_91_APPKEY @"aac8eda4394d8be2a4b8767e1af2d556"

#define P_HOST @"p.flashapp.cn"
#define P_IDC_CODE @"bj_1"
#define API_BASE @"http://p.flashapp.cn/api"
//#define P_HOST @"27.flashget.com"
//#define API_BASE @"http://27.flashget.com/api"
//#define P_HOST @"192.168.11.5"
//#define API_BASE @"http://192.168.11.5/api"

#define API_LOG_LOG_MEM @"accesslog/getAccessLogAndMember"
#define API_LOG_LOG @"accesslog/getAccesslog"
#define API_LOG_GETDEVICE @"accesslog/getDevice"
#define API_LOG_MEMBERINFO @"accesslog/getMemberInfo"   
#define API_LOG_VERIFY @"accesslog/verified"
#define API_USER_GETCODE @"users/getCode"
#define API_USER_REGISTER @"users/regist"
#define API_USER_VERIFY @"users/verify"
#define API_USER_LOGIN @"users/login"
#define API_USER_MODIFY @"users/modefyInfo"
#define API_USER_MODIFY_PASSWD @"users/modefyPwd"
#define API_USER_RESET_PASSWD @"users/forgetPwd"
#define API_USER_91_INCRLIMIT @"users/addlmt"
#define API_FEEDBACK_FEEDBACK @"feedback/feedback"
#define API_COMBO_COMBOINFO @"combo/getComboInfo"
#define API_COMBO_CARRIERINFO @ "combo/getCarrierInfo"
#define API_IDC_ZLIST @"server/zlist"
#define API_IDC_SPEED @"server/speedtest"
#define API_APP_APPS @"apps/apps"
#define API_APP_APPS_3DES @"apps/apps2"
#define API_SETTING_DISABLEUA @"settngs/disableua"
#define API_SETTING_RESETUA @"settngs/resetua"
#define API_SETTING_UA_IS_ENABLED @"settngs/uastatus"
#define API_SETTING_IMAGE_QUALITY @"settngs/imgquality"

#define URL_SHARE @"/loginsns/share/device.jsp"

#define APP_ID 1
#define API_KEY @"30efb1a621c4bd711652ecafb7cbd3673a062b3f"
#define API_VER @"1.5.5"


#define RefreshNotification @"refreshNotification"
#define TCChangedNotification @"TCChangedNotification"
#define RefreshAppLockedNotification @"refreshAppLockedNotification"
#define ShowAppRedDianNotification @"showNewsAppDian"
#define HiddenAppRedDianNotification @"hiddenNewsAppDian"

//add guangtao
#define NEWS_APP @"shownewapp"
#define JPTJ_APP @"jptjnewapp"
#define XSMF_APP @"xsmfnewapp"
#define RMYX_APP @"rmyxnewapp"


#define CHANNEL @"appstore"

//#define CHANNEL @"flashapp_market"

//#define CHANNEL @"PP helper_market"


//#define CHANNEL @"91_market"
//#define CHANNEL @"weifeng_market"
//#define CHANNEL @"tongbutui_market"
//#define CHANNEL @"163_market"
//#define CHANNEL @"baidu_market"
//#define CHANNEL @"tx_market"
//#define CHANNEL @"souhu_market"
//#define CHANNEL @"pp_market"
//#define CHANNEL @"kuaiyong_market"
//#define CHANNEL @"xianmian_market"
//#define CHANNEL @"gaoqu_market"
//#define CHANNEL @"liqu_market"



//#define CHANNEL @"flashapp_91_market"

#define DES_KEY @"flashapp12345678ppahsalf"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define UD_LOCATION_ENABLED @"locationEnabled"

#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


//联通免流量
//#define DFTraffic

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, WXApiDelegate ,UINavigationControllerDelegate> {
    NSObject* dbWriteLock;
    NSObject* timerTaskLock;
    NSLock* refreshingLock;
    BOOL timerTaskDoing;
    
    ConnectionType connType;
    Reachability* networkReachablity;//Reachablity to P_Host
    Reachability* internetReachablity;//Reachablity to internet
    
    UserSettings* user;
    CTCarrier* carrier;
    
    //NSTimer* timer;
    NSThread* refreshThread;
    
    //线程队列
    NSOperationQueue* operationQueue;
    
    //定位
    TCLocationManager* locationManager;
    
    TwitterClient* client;
    BOOL proxySlow;
    
    BOOL refreshDatasave;
    BOOL refreshDatastats;
    
    //发送流量查询短信成功后，设置为true。用于提示发送短信成功
    BOOL adjustSMSSend;

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeveyTabBarController *leveyTabBarController;
@property (nonatomic ,retain) UINavigationController *rootNav;

@property (nonatomic, retain) NSObject* dbWriteLock;
@property (nonatomic, retain) UserSettings* user;
@property (nonatomic, assign) BOOL refreshDatasave;
@property (nonatomic, assign) BOOL refreshDatastats;
@property (nonatomic, assign) BOOL adjustSMSSend;
@property (nonatomic, assign) BOOL proxySlow;
@property (nonatomic, retain) CTCarrier* carrier;
@property (nonatomic, retain) Reachability* networkReachablity;
@property (nonatomic, readonly) NSLock* refreshingLock;

+ (AppDelegate*)getAppDelegate;
+ (BOOL) networkReachable;
+ (void) showAlert:(NSString*)title message:(NSString*)message;
+ (void) showAlert:(NSString*)message;
- (void) showDatasaveView:(BOOL)justInstallProfile;
- (void) showProfileView;
+ (void) showHelp;
- (void) showProfileHelp;
+ (void) showUserReviews;
+ (void) installProfile:(NSString*)nextPage;
+ (void) installProfile:(NSString *)nextPage apn:(NSString*)apn;
+ (void) installProfile:(NSString *)nextPage idc:(NSString*)idcCode;
+ (void) installProfileForServiceType:(NSString*)serviceType nextPage:(NSString*)nextPage apn:(NSString*)apn idc:(NSString*)idcCode interfable:(NSString *)inter;
+ (void) uninstallProfile:(NSString*)nextPage;
+ (NSString*) getInstallURLForServiceType:(NSString*)serviceType nextPage:(NSString*)nextPage install:(BOOL)isInstall apn:(NSString*)apn idc:(NSString*)idcCode interfable:(NSString *)inter;

- (UINavigationController*) currentNavigationController;
- (UIViewController*) currentViewController;
- (void) switchUser;
+ (long long) getLastAccessLogTime;

- (void) startLocationManager;
- (void) stopLocationManager;


@end
