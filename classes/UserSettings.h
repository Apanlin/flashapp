//
//  UserSettings.h
//  flashapp
//
//  Created by 李 电森 on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCInfo.h"

#define QUANTITY_INIT 50.0
#define QUANTITY_DAY_LIMIT 1
#define QUANTITY_PER_OPEN 0.5
#define QUANTITY_PER_SHARE 2
#define QUANTITY_MONTH_SHARE_LIMIT 5

#define TC_TOTAL 30

typedef enum {
    LEVEL_0,    //
    LEVEL_1,    //自行车
    LEVEL_2,    //摩托车
    LEVEL_3,    //卡车
    LEVEL_4,    //公共汽车 
    LEVEL_5,    //轿车 
    LEVEL_6,    //火车 
    LEVEL_7     //飞机
} UserLevel;

typedef enum {
    INSTALL_FLAG_UNKNOWN,
    INSTALL_FLAG_YES,
    INSTALL_FLAG_NO,
    INSTALL_FLAG_CHAOSED    //用户当前机房与profile不一致
} InstallFlag;


typedef enum {
    STATUS_NEW,
    STATUS_INSTALLED,
    STATUS_REGISTERED,
    STATUS_REGISTERED_ACTIVE
} accountStatus;


typedef enum {
    PIC_QS_MIDDLE,
    PIC_QS_HIGH,
    PIC_QS_NOCOMPRESS,
    PIC_QS_LOW
}
PictureQsLevel;


@interface UserSettings : NSObject
{
    int userId;
    NSString* username;
    NSString* nickname;
    NSString* password;
    NSString* snsDomain;
    int status;
    
    float capacity;
    float oldCapacity;  //用于显示容量增加
    int level;
    
    int proxyFlag;
    NSString* proxyServer;
    int proxyPort;
    NSString* idcCode;
    NSString* idcServer;
    
    NSString* day;
    float dayCapacity;
    float dayCapacityDelta;
    
    NSString* month;
    float monthCapacity;
    float monthCapacityDelta;
    
    NSString* ctTotal;//单位MB
    NSString* ctUsed;//单位B
    NSString* ctDay;//结算日
    long ifLastBytesNum; //上次读取流量数据，单位B
    long ifLastTime;      //上次读取流量数据的时间
    
    NSString* areaCode; //手机号所属地区
    NSString* carrierCode; //移动运营商编码
    NSString* carrierType;  //SIM卡类型
    NSString* carrierSmsnum;    //移动运营商特服号
    NSString* carrierSmstext;   //查询短信内容
    NSString* phone;            //查询短信时输入的手机号
    
    NSString* idcList;          //idc list
    
    PictureQsLevel pictureQsLevel; 
}

@property (nonatomic, assign) int userId;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* nickname;
@property (nonatomic, retain) NSString* snsDomain;
@property (nonatomic, assign) float capacity;
@property (nonatomic, assign) float oldCapacity;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int proxyFlag;
@property (nonatomic, retain) NSString* proxyServer;
@property (nonatomic, assign) int proxyPort;
@property (nonatomic, retain) NSString* day;
@property (nonatomic, assign) float dayCapacity;
@property (nonatomic, assign) float dayCapacityDelta;
@property (nonatomic, retain) NSString* month;
@property (nonatomic, assign) float monthCapacity;
@property (nonatomic, assign) float monthCapacityDelta;

@property (nonatomic, retain) NSString* ctTotal;
@property (nonatomic, retain) NSString* ctUsed;
@property (nonatomic, retain) NSString* ctDay;
@property (nonatomic, assign) long ifLastBytesNum;
@property (nonatomic, assign) long ifLastTime;

@property (nonatomic, retain) NSString* areaCode;
@property (nonatomic, retain) NSString* carrierCode;
@property (nonatomic, retain) NSString* carrierType;
@property (nonatomic, retain) NSString* carrierSmsnum; 
@property (nonatomic, retain) NSString* carrierSmstext; 
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSString* idcCode;
@property (nonatomic, retain) NSString* idcServer;
@property (nonatomic, retain) NSString* idcList;

@property (nonatomic, assign) PictureQsLevel pictureQsLevel; 


+ (float) currentCapacity;
+ (UserSettings*) currentUserSettings;
+ (void) saveUserSettings:(UserSettings*)settings;
+ (void) saveCapacity:(float)capacity status:(int)status;
+ (void) saveCapacity:(float)capacity status:(int)status proxyFlag:(int)proxyFlag;
+ (void) saveProxyFlag:(int)proxyFlag;
+ (void) saveNickname:(NSString*)nickname;
+ (void) savePassword:(NSString*)password;
+ (void) saveDay:(NSString*)day capacity:(float)capacity;
+ (void) saveMonth:(NSString*)month capacity:(float)capacity capacityDelta:(float)delta;
+ (void) saveProxyServer:(NSString*)server proxyPort:(int)port;
+ (void) saveOldCapacity:(float)oldCapacity;
+ (void) saveTaocanTotal:(NSString*)total used:(NSString*)used day:(NSString*)day;
+ (void) saveCarrier:(NSString*)code carrierType:(NSString*)type area:(NSString*)area;
+ (void) saveCarrier:(NSString*)code carrierType:(NSString*)type area:(NSString*)area snsnum:(NSString*)snsnum snstext:(NSString*)snstext;
+ (void) savePictureQsLevel:(PictureQsLevel)level;

- (float) getTcTotal;
- (float) getTcUsed;
- (int) getTcDay;

- (NSArray*) idcArray;
- (IDCInfo*) currentIDC;

@end
