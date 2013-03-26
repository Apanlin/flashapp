//
//  LocationManager.m
//  flashapp
//
//  Created by Qi Zhao on 12-11-18.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "TCLocationManager.h"
#import "AppDelegate.h"
#import "TCUtils.h"
#import "GetAddress.h"


@implementation TCLocationManager


@synthesize manager;


- (void) dealloc
{
    if ( manager ) [manager release];
    manager = nil;
    [super dealloc];
}


- (void) startManager
{
    if ( !manager ) {
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        manager.distanceFilter = 10.0f;
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [manager startMonitoringSignificantLocationChanges];
    }
}


- (void) stopManager
{
    [manager stopMonitoringSignificantLocationChanges];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"locationManager didUpdateLocation!!!!");
    
    //    [TCUtils readIfData:-1];
    //    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    //    if ( state == UIApplicationStateActive ) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];
    //    }
    //    else {
    //        //WIFI下开启了VPN，或者cell下没有开启VPN，则推送本地消息
    //        [self checkVPN];
    //    }
    
}


- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError!!!!");
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_LOCATION_ENABLED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"locationManager didChangeAuthorizationStatus!!!!");
}


- (void) checkVPN
{
    if ( [@"appstore" compare:CHANNEL] != NSOrderedSame ) return;
    
    ConnectionType type = [UIDevice connectionType];
    NSString* desc = nil;
    
    BOOL vpnStarted = NO;
    GetAddress* ga = [[GetAddress alloc] init];
    [ga getIPAddress];
    NSArray* ipNames = ga.ipNames;
    NSArray* ifNames = ga.ifNames;
    int len = [ipNames count];
    NSString* ifName;
    NSString* ipName;
    for ( int i=0; i<len; i++ ) {
        ifName = [ifNames objectAtIndex:i];
        ipName = [ipNames objectAtIndex:i];
        NSRange r = [ifName rangeOfString:@"utun"];
        if ( r.location == NSNotFound ) {
            continue;
        }
        else {
            vpnStarted = YES;
            break;
        }
    }
    [ga release];
    
    switch (type) {
        case WIFI:
            if ( vpnStarted ) {
                desc = @"在WIFI下没有上网流量限制，飞速提示您请关闭VPN。";
                [self scheduleNotification:desc andAction:@"关闭飞速VPN" afterSeconds:3];
            }
            break;
        case CELL_2G:
        case CELL_3G:
        case CELL_4G:
            if ( !vpnStarted ) {
                desc = @"您在移动蜂窝网络下上网，请您开启飞速服务，飞速上网，节省流量！";
                [self scheduleNotification:desc andAction:@"开启飞速VPN" afterSeconds:3];
            }
        default:
            break;
    }
}


- (void)scheduleNotification:(NSString*)message andAction:(NSString*)action afterSeconds:(int)seconds
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    double lastTime = [userDefaults doubleForKey:@"lastVPNMessageTime"];
    double now = [[NSDate date] timeIntervalSince1970];
    //    if ( now - lastTime < 300 ) return;
    [userDefaults setDouble:now forKey:@"lastVPNMessageTime"];
    [userDefaults synchronize];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) return;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:seconds];
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = message;
    localNotif.alertAction = action;
    localNotif.hasAction = YES;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}


@end
