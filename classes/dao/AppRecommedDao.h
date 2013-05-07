//
//  AppRecommedDao.h
//  flashapp
//
//  Created by 朱广涛 on 13-5-7.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppClasses;
@interface AppRecommedDao : NSObject

+ (BOOL)createAppClassestable;

+ (void)insertAllAppRecommend:(NSArray *)arr;

+ (void)updateAppRecommend:(AppClasses *)appClassess;

+ (NSDictionary *)fondAllAppRecommed;


@end
