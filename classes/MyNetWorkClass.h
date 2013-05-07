//
//  MyNetWorkClass.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-18.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpRequest.h"

@protocol MyNetWorkClassDelegate <NSObject>

-(void)getObjectWithRequest:(ASIHTTPRequest *)request completion:(void(^)(NSDictionary *))handler;

@end

@interface MyNetWorkClass : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic ,assign) id<MyNetWorkClassDelegate> delegate;

+(MyNetWorkClass *)getMyNetWork;

//根据不同的应用分类来添加应用程序；
-(void)startAppsRequestCateid:(NSString *)cateID Page:(NSString *)page completion:(void (^)(NSDictionary *))result;

//请求广告横幅图片
-(void)startBannerRequestWithCompletion:(void(^)(NSDictionary *))result;

//应用分类列表
-(void)startAppFenLei:(void (^)(NSDictionary *))result;

//应用分类详细
-(void)startAppXiangQingWithApid:(NSString *)apid completion:(void(^)(NSDictionary *))result;

@end
