//
//  BannerImageUtil.m
//  flashapp
//
//  Created by 朱广涛 on 13-4-19.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "BannerImageUtil.h"

@implementation BannerImageUtil

+(id)getBanerImageUtil
{
    static id banerImageUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        banerImageUtil = [[[self class] alloc] init];
    });
    return banerImageUtil;
}

-(void)setTimeStamp:(NSInteger)timesTamp
{
    [[NSUserDefaults standardUserDefaults] setInteger:timesTamp forKey:@"bannertimestamp"];
}

-(int)getTimeStamp{
   return [[NSUserDefaults standardUserDefaults] integerForKey:@"bannertimestamp"];
}

-(void)saveBannerImage:(NSData *)imgData andLink:(NSString *)link
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:imgData,@"imgData",link,@"link", nil ];
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"bannerimageutil"];
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:3];
    [arr1 addObject:dic];
    [dic release];
    if ([arr count]) {
        [arr1 addObjectsFromArray:arr];
    }
    [[NSUserDefaults standardUserDefaults] setValue:arr1 forKey:@"bannerimageutil"];
    [arr1 release];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
