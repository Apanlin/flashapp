//
//  CategoryClass.m
//  flashapp
//
//  Created by 朱广涛 on 13-4-24.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "CategoryClass.h"

@implementation CategoryClass
@synthesize jingpinTim;
@synthesize xianmianTim;
@synthesize gamesTim;

+(id)getCategoryClass
{
    static CategoryClass *categoryClass ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categoryClass = [[CategoryClass alloc] init];
        categoryClass.jingpinTim = [[NSUserDefaults standardUserDefaults] doubleForKey:@"jingpinTim"];
        categoryClass.xianmianTim = [[NSUserDefaults standardUserDefaults] doubleForKey:@"xianmianTim"];
        categoryClass.gamesTim = [[NSUserDefaults standardUserDefaults] doubleForKey:@"gamesTim"];
    });
    return categoryClass;
}

@end
