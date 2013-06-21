//
//  MyNetWorkClass.m
//  flashapp
//
//  Created by 朱广涛 on 13-4-18.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AppDelegate.h"
#import "MyNetWorkClass.h"
#import "DeviceInfo.h"
#import "StringUtil.h"
#import "NSString+SBJson.h"
#import "BannerImageUtil.h"
#import "ASIDownloadCache.h"
#import "OpenUDID.h"


@implementation MyNetWorkClass
@synthesize delegate;

static MyNetWorkClass *newWork;

+(MyNetWorkClass *)getMyNetWork
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        newWork = [[MyNetWorkClass alloc] init];
    });
    return newWork;
}


//------------------------------应用推荐--------------------------//
-(void)startAppFenLei:(void (^)(NSDictionary *))result
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
        
        CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = tni.subscriberCellularProvider;
        [tni release];
        
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        
        double cpi = [[NSUserDefaults standardUserDefaults] doubleForKey:@"catsucp"];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        NSString *scr =[NSString stringWithFormat:@"%.0f*%.0f",rect.size.width,rect.size.height];
        
        NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/catsu?deviceId=%@&platform=%@&cpi=%.0f&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,[device.platform encodeAsURIComponent],cpi,APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],scr,carrier ?carrier.mobileNetworkCode:@"",carrier?carrier.mobileCountryCode:@"",version,CHANNEL,API_VER];
        
        [self jsonRequestNoCacheWithURL:str completion:result];
    });
}

-(void)startBannerRequestWithCompletion:(void(^)(NSDictionary *))result
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
        //获得Sim卡运行商
        CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier* carrier = tni.subscriberCellularProvider;
        [tni release];
        //获得版本信息
        NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        //获得屏幕尺寸 width * height
        CGRect rect = [[UIScreen mainScreen] bounds];
        NSString *scr =[NSString stringWithFormat:@"%.0f*%.0f",rect.size.width,rect.size.height];
        
        NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/banner?deviceId=%@&platform=%@&cpi=%d&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,[device.platform encodeAsURIComponent],[[BannerImageUtil getBanerImageUtil] getTimeStamp],APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],scr,carrier?carrier.mobileNetworkCode:@"",carrier?carrier.mobileCountryCode:@"",version,CHANNEL,API_VER ];
        
        [self jsonRequestWithURL:str completion:result];
    });
}

-(void)startAppsRequestCateid:(NSString *)cateID Page:(NSString *)page completion:(void (^)(NSDictionary *))result
{
    //device.platform = iOS
    //device.version = 4.0 or 5.1.1 or 6.1
    //device.hardware = iphone 4 or iphone 4s or iphone 5 or something
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
        CGRect rect = [[UIScreen mainScreen] bounds];
        NSString *src =[NSString stringWithFormat:@"%.0f_%.0f",rect.size.width,rect.size.height];
        //获得Sim卡运行商
        CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier* carrier = tni.subscriberCellularProvider;
        [tni release];
        NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        
        NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/apps?deviceId=%@&platform=%@&cateid=%@&pageNo=%@&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,[device.platform encodeAsURIComponent],cateID,page,APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],src,carrier ? carrier.mobileNetworkCode : @"",carrier ? carrier.mobileCountryCode : @"",version,CHANNEL,API_VER];
        
        [self jsonRequestWithURL:str completion:result];
    });
}

-(void)startAppXiangQingWithApid:(NSString *)apid completion:(void(^)(NSDictionary *))result
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        NSString *src = [NSString stringWithFormat:@"%.0f_%.0f",rect.size.width,rect.size.height];
        
        CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = tni.subscriberCellularProvider;
        [tni release];
        
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        
        NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/app?deviceId=%@&apid=%@&platform=%@&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,apid,[device.platform encodeAsURIComponent],APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],src,carrier?carrier.mobileNetworkCode:@"",carrier?carrier.mobileCountryCode:@"",version,CHANNEL,API_VER];
        
        [self jsonRequestWithURL:str completion:result];
    });
}

//--------------------------------登陆--------------------------------------//
- (void)startThirdLoginOKBackRequestType:(NSDictionary *)loginDic completion:(void(^)(NSDictionary *))result
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlString = [NSString stringWithFormat:@"http://p.flashapp.cn/api/users/registsns.json?appid=%d&deviceId=%@&nickname=%@&snsid=%@&snstype=%@&token=%@",APP_ID,[OpenUDID value],[loginDic objectForKey:@"nickname"],[loginDic objectForKey:@"snsid"],[loginDic objectForKey:@"snstype"],[loginDic objectForKey:@"token"]];
         urlString = [self addcChlAndrdAndCodeAndVer:urlString requestTypeDic:loginDic];
        
        NSString *newURL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
        
        [self jsonRequestNoCacheWithURL:newURL completion:result];
    });
}

- (NSString *)addcChlAndrdAndCodeAndVer:(NSString *)urlStr requestTypeDic:(NSDictionary *)dic
{
    //随机数
    int rd = ((float) rand()) / RAND_MAX * 10000;
    
    NSString* deviceId = [OpenUDID value];
    //MD5加密
    NSString* s = [NSString stringWithFormat:@"%@%@%@%@%@%d", deviceId, CHANNEL, [dic objectForKey:@"snsid"],[dic objectForKey:@"snstype"], API_KEY,rd ];
    //MD5加密
    NSString* code = [s md5HexDigest];
    
    //生成新的url
    NSString *newUrl = [NSString stringWithFormat:@"%@&chl=%@&rd=%d&code=%@&ver=%@",urlStr,CHANNEL,rd,code,API_VER];
    
    return newUrl;
}

#pragma mark -- 请求服务器 然后将服务器返回的结果通过 block 返给前面调用的接口方法 ， 一个带缓存 ， 一个不带缓存
-(void)jsonRequestNoCacheWithURL:(NSString *)urlString completion:(void (^)(NSDictionary *))result
{
//    NSLog(@"request URL is : %@",urlString);
    NSMutableDictionary *jsonRequest = [[NSMutableDictionary alloc] initWithCapacity:3];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    [request setTimeOutSeconds:10];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (error == nil) {
        NSString *responseString = [request responseString];
        [jsonRequest setDictionary:[responseString JSONValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            result(jsonRequest);
        });
    }else{
        NSLog(@"%@",[error localizedDescription]);
    }
    [jsonRequest release];
}

-(void)jsonRequestWithURL:(NSString *)urlString completion:(void(^)(NSDictionary *))result
{
    
//    NSLog(@"request URL is : %@",urlString);
    
    NSMutableDictionary *jsonRequest = [[[NSMutableDictionary alloc] initWithCapacity:3] autorelease];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    [request setTimeOutSeconds:10]; //设置请求超时时间
    [request setNumberOfTimesToRetryOnTimeout:2]; //设置请求超时时，重新请求的次数
    
    //打开缓存机制
    request.downloadCache = [ASIDownloadCache sharedCache];
    //设置是否按服务器在Header里指定的是否可被缓存或过期策略进行缓存：
    [[ASIDownloadCache sharedCache ] setShouldRespectCacheControlHeaders:NO];
    //cache策略:每次都向服务器询问是否有新的内容可用，如果请求失败, 使用cache的数据，即使这个数据已经过期了
    request.cachePolicy = ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy;
    //cache存储策略:默认只在当前会话期间存储
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    [request setSecondsToCache:60]; // 设置request缓存的有效时间   缓存
    
    [request startSynchronous];
    NSError *error = [request error];
    if (error == nil) {
       NSString *responseString = [request responseString] ;
        [jsonRequest setDictionary:[responseString JSONValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            result(jsonRequest);
        });
    }
}



#pragma mark ------- ASIHttpRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{

}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

@end
