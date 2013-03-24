//
//  SystemGlobals.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-24.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "SystemGlobals.h"

@implementation SystemGlobals

static SystemGlobals* instance = nil;


+ (SystemGlobals*) sharedInstance
{
    @synchronized ( self ) {
        if ( instance == nil ) {
            instance = [[SystemGlobals alloc] init];
        }
    }
    return instance;
}


+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}


- (id) retain
{
    return self;
}


- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}


- (oneway void) release
{
    
}


- (id) autorelease
{
    return self;
}


@end
