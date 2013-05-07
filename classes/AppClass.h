//
//  AppClass.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-21.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppClass : NSObject

@property (nonatomic ,copy)NSString *appID; //应用id;

@property (nonatomic ,copy)NSString *appName; //应用名称

@property (nonatomic ,copy)NSString *appdesc; //应用简介

@property (nonatomic ,copy)NSString *apprkm; //推荐理由

@property (nonatomic ,assign)int appStar; //应用星级

@property (nonatomic ,copy)NSString *appPicSize; //详细图片大小

@property (nonatomic ,copy)NSString *appSize; //应用大小

@property (nonatomic ,copy)NSString *appIcon; //应用图片

@property (nonatomic ,copy)NSString *appLink; //应用链接

@property (nonatomic ,copy)NSString *appOprice; //原价

@property (nonatomic ,copy)NSString *appCprice; //现价

@property (nonatomic ,copy)NSString *appLimfree; //0 不是现免， 1 现免

@end
