//
//  UserSettings.m
//  flashapp
//
//  Created by 李 电森 on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserSettings.h"
#import "AppDelegate.h"
#import "IFData.h"
#import "IFDataService.h"
#import "IDCInfo.h"

@implementation UserSettings

@synthesize userId;
@synthesize username;
@synthesize nickname;
@synthesize password;
@synthesize snsDomain;
@synthesize capacity;
@synthesize oldCapacity;
@synthesize level;
@synthesize status;
@synthesize proxyFlag;
@synthesize proxyServer;
@synthesize proxyPort;
@synthesize day;
@synthesize dayCapacity;
@synthesize dayCapacityDelta; 
@synthesize month;
@synthesize monthCapacity;
@synthesize monthCapacityDelta;
@synthesize ctDay;
@synthesize ctUsed;
@synthesize ctTotal;
@synthesize ifLastBytesNum;
@synthesize ifLastTime;
@synthesize carrierCode;
@synthesize areaCode;
@synthesize carrierType;
@synthesize carrierSmsnum;
@synthesize carrierSmstext;
@synthesize phone;
@synthesize idcCode;
@synthesize idcServer;
@synthesize idcList;
@synthesize pictureQsLevel;

- (void) dealloc
{
    [username release];
    [nickname release];
    [password release];
    [snsDomain release];
    [day release];
    [month release];
    [proxyServer release];
    [ctDay release];
    [ctTotal release];
    [ctUsed release];
    [areaCode release];
    [carrierCode release];
    [carrierType release];
    [carrierSmsnum release];
    [carrierSmstext release];
    [phone release];
    [idcCode release];
    [idcServer release];
    [super dealloc];
}


+ (float) currentCapacity
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:@"capacity"];
}


+ (UserSettings*) currentUserSettings
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    UserSettings* settings = [[[UserSettings alloc] init] autorelease];
    settings.userId = [userDefaults integerForKey:@"userId"];
    settings.username = [userDefaults objectForKey:@"username"];
    settings.nickname = [userDefaults objectForKey:@"nickname"];
    settings.password = [userDefaults objectForKey:@"password"];
    settings.snsDomain = [userDefaults objectForKey:@"snsDomain"];

    settings.capacity = [userDefaults floatForKey:@"capacity"];
    if ( settings.capacity == 0 ) settings.capacity = QUANTITY_INIT;
    
    settings.oldCapacity = [userDefaults floatForKey:@"oldCapacity"];
    if ( settings.oldCapacity == 0 ) settings.oldCapacity = settings.capacity;
    
    settings.level = [userDefaults integerForKey:@"level"];
    if ( settings.level == 0 ) settings.level = LEVEL_1;
    
    settings.status = [userDefaults integerForKey:@"status"];
    settings.proxyFlag = [userDefaults integerForKey:@"proxyFlag"];
    settings.proxyServer = [userDefaults objectForKey:@"proxyServer"];
    settings.proxyPort = [userDefaults integerForKey:@"proxyPort"];
    
    settings.day = [userDefaults objectForKey:@"day"];
    settings.dayCapacity= [userDefaults floatForKey:@"dayCapacity"];
    settings.dayCapacityDelta = [userDefaults floatForKey:@"dayCapacityDelta"];

    settings.month = [userDefaults objectForKey:@"month"];
    settings.monthCapacity= [userDefaults floatForKey:@"monthCapacity"];
    settings.monthCapacityDelta = [userDefaults floatForKey:@"monthCapacityDelta"];
    
    settings.ctDay = [userDefaults objectForKey:@"ctDay"];
    settings.ctTotal = [userDefaults objectForKey:@"ctTotal"];
    settings.ctUsed = [userDefaults objectForKey:@"ctUsed"];
    
    NSString* s = [userDefaults objectForKey:@"ifLastTime"];
    if ( s && s.length > 0 ) {
        settings.ifLastTime = [s longLongValue];
    }
    else {
        settings.ifLastTime = 0;
    }
    
    s = [userDefaults objectForKey:@"ifLastBytesNum"];
    if ( s && s.length > 0 ) {
        settings.ifLastBytesNum = [s longLongValue];
    }
    else {
        settings.ifLastBytesNum = 0;
    }
    
    settings.carrierCode = [userDefaults objectForKey:@"carrierCode"];
    settings.carrierType = [userDefaults objectForKey:@"carrierType"];
    settings.areaCode = [userDefaults objectForKey:@"areaCode"];
    settings.carrierSmstext = [userDefaults objectForKey:@"carrierSmstext"];
    settings.carrierSmsnum = [userDefaults objectForKey:@"carrierSmsnum"];
    settings.phone = [userDefaults objectForKey:@"phone"];
    
    s = [userDefaults objectForKey:@"idcServer"];
    if ( s && s.length > 0 ) {
        settings.idcServer = s;
    }
    else {
        settings.idcServer = P_HOST;
    }
    
    s = [userDefaults objectForKey:@"idcCode"];
    if ( s && s.length > 0 ) {
        settings.idcCode = s;
    }
    else {
        settings.idcCode = P_IDC_CODE;
    }
    
    settings.idcList = [userDefaults objectForKey:@"idcList"];
    
    settings.pictureQsLevel = [userDefaults integerForKey:@"pictureQsLevel"];
    
    return settings;
}


+ (void) saveUserSettings:(UserSettings*)settings
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:settings.userId forKey:@"userId"];
    [userDefaults setObject:settings.username forKey:@"username"];
    [userDefaults setObject:settings.nickname forKey:@"nickname"];
    [userDefaults setObject:settings.password forKey:@"password"];
    [userDefaults setObject:settings.snsDomain forKey:@"snsDomain"];
    [userDefaults setFloat:settings.capacity forKey:@"capacity"];
    [userDefaults setFloat:settings.oldCapacity forKey:@"oldCapacity"];
    [userDefaults setInteger:settings.level forKey:@"level"];
    [userDefaults setInteger:settings.status forKey:@"status"];
    [userDefaults setInteger:settings.proxyFlag forKey:@"proxyFlag"];
    [userDefaults setObject:settings.proxyServer forKey:@"proxyServer"];
    [userDefaults setInteger:settings.proxyPort forKey:@"proxyPort"];
    [userDefaults setObject:settings.day forKey:@"day"];
    [userDefaults setFloat:settings.dayCapacity forKey:@"dayCapacity"];
    [userDefaults setFloat:settings.dayCapacityDelta forKey:@"dayCapacityDelta"];
    [userDefaults setObject:settings.month forKey:@"month"];
    [userDefaults setFloat:settings.monthCapacity forKey:@"monthCapacity"];
    [userDefaults setFloat:settings.monthCapacityDelta forKey:@"monthCapacityDelta"];
    [userDefaults setObject:settings.ctTotal forKey:@"ctTotal"];
    [userDefaults setObject:settings.ctUsed forKey:@"ctUsed"];
    [userDefaults setObject:settings.ctDay forKey:@"ctDay"];
    [userDefaults setObject:[NSString stringWithFormat:@"%ld", settings.ifLastBytesNum] forKey:@"ifLastBytesNum"];
    [userDefaults setObject:[NSString stringWithFormat:@"%ld", settings.ifLastTime] forKey:@"ifLastTime"];
    [userDefaults setObject:settings.areaCode forKey:@"areaCode"];
    [userDefaults setObject:settings.carrierCode forKey:@"carrierCode"];
    [userDefaults setObject:settings.carrierType forKey:@"carrierType"];
    [userDefaults setObject:settings.carrierSmsnum forKey:@"carrierSmsnum"];
    [userDefaults setObject:settings.carrierSmstext forKey:@"carrierSmstext"];
    [userDefaults setObject:settings.phone forKey:@"phone"];
    [userDefaults setObject:settings.idcCode forKey:@"idcCode"];
    [userDefaults setObject:settings.idcServer forKey:@"idcServer"];
    [userDefaults setObject:settings.idcList forKey:@"idcList"];
    [userDefaults setInteger:settings.pictureQsLevel forKey:@"pictureQsLevel"];
    [userDefaults synchronize];
}


+ (void) saveCapacity:(float)capacity status:(int)status
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:capacity forKey:@"capacity"];
    [userDefaults setInteger:status forKey:@"status"];
    [userDefaults synchronize];
}


+ (void) saveCapacity:(float)capacity status:(int)status proxyFlag:(int)proxyFlag
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:capacity forKey:@"capacity"];
    [userDefaults setInteger:status forKey:@"status"];
    [userDefaults setInteger:proxyFlag forKey:@"proxyFlag"];
    [userDefaults synchronize];
}


+ (void) saveProxyFlag:(int)proxyFlag
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:proxyFlag forKey:@"proxyFlag"];
    [userDefaults synchronize];
}


+ (void) saveNickname:(NSString*)nickname
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nickname forKey:@"nickname"];
    [userDefaults synchronize];
}


+ (void) savePassword:(NSString*)password
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:password forKey:@"password"];
    [userDefaults synchronize];
}


+ (void) saveDay:(NSString*)day capacity:(float)capacity
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:day forKey:@"day"];
    [userDefaults setFloat:capacity forKey:@"dayCapacity"];
    [userDefaults synchronize];
}


+ (void) saveMonth:(NSString*)month capacity:(float)capacity capacityDelta:(float)delta
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:month forKey:@"month"];
    [userDefaults setFloat:capacity forKey:@"monthCapacity"];
    [userDefaults setFloat:delta forKey:@"monthCapacityDelta"];
    [userDefaults synchronize];
}


+ (void) saveProxyServer:(NSString*)server proxyPort:(int)port
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:server forKey:@"proxyServer"];
    [userDefaults setInteger:port forKey:@"proxyPort"];
    [userDefaults synchronize];
}


+ (void) saveOldCapacity:(float)oldCapacity
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:oldCapacity forKey:@"oldCapacity"];
    [userDefaults synchronize];
}


+ (void) saveTaocanTotal:(NSString*)total used:(NSString*)used day:(NSString*)day
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:total forKey:@"ctTotal"];
    [userDefault setObject:used forKey:@"ctUsed"];
    [userDefault setObject:day forKey:@"ctDay"];
    [userDefault synchronize];
}


+ (void) saveCarrier:(NSString*)code carrierType:(NSString*)type area:(NSString*)area
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:area forKey:@"areaCode"];
    [userDefault setObject:code forKey:@"carrierCode"];
    [userDefault setObject:type forKey:@"carrierType"];
    [userDefault synchronize];
}


+ (void) saveCarrier:(NSString*)code carrierType:(NSString*)type area:(NSString*)area snsnum:(NSString*)snsnum snstext:(NSString*)snstext
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:area forKey:@"areaCode"];
    [userDefault setObject:code forKey:@"carrierCode"];
    [userDefault setObject:type forKey:@"carrierType"];
    [userDefault setObject:snsnum forKey:@"carrierSmsnum"];
    [userDefault setObject:snstext forKey:@"carrierSmstext"];
    [userDefault synchronize];
}


+ (void) savePictureQsLevel:(PictureQsLevel)level
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:level forKey:@"pictureQsLevel"];
    [userDefaults synchronize];
}


- (float) getTcTotal
{
    if ( ctTotal && ctTotal.length > 0 ) {
        return [ctTotal floatValue];
    }
    else {
        return TC_TOTAL;
    }
}


- (float) getTcUsed
{
    if ( ctUsed && ctUsed.length > 0 ) {
        return [ctUsed floatValue];
    }
    else {
        return 0.0f;
    }
}


- (NSString*) getIdcServer
{
    if ( idcServer && idcServer.length > 0 ) {
        return idcServer;
    }
    else {
        self.idcServer = P_HOST;
        return P_HOST;
    }
}


- (int) getTcDay
{
    if ( ctDay && ctDay.length > 0 ) {
        return [ctDay intValue];
    }
    else {
        return 1;
    }
}


- (NSArray*) idcArray
{
    return [IDCInfo parseIDCList:idcList];
}


- (IDCInfo*) currentIDC
{
    if ( idcList ) {
        NSArray* arr = [self idcArray];
        for ( IDCInfo* info in arr ) {
            if ( [info.host compare:self.proxyServer] == NSOrderedSame ) {
                return info;
            }
        }
    }
    
    return nil;
}

@end
