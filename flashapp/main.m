//
//  main.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-31.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#include "GetAddress.h"

extern char **if_names;
extern char **ip_names;
extern char **hw_addrs;
extern unsigned long* ip_addrs;

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSLog(@"1 nextAddr=%d", nextAddr);
        InitAddresses();
        NSLog(@"2 nextAddr=%d", nextAddr);
        GetIPAddresses();
        NSLog(@"3 nextAddr=%d", nextAddr);
        GetHWAddresses();
        NSLog(@"4 nextAddr=%d", nextAddr);
        
        for ( int i=0; i<1; i++ ) {
            NSLog(@"ip_names[%d]=%s", i, ip_names[i]);
            NSLog(@"if_names[%d]=%s", i, if_names[i]);
            NSLog(@"hw_addrs[%d]=%s", i, hw_addrs[i]);
        }
    
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
