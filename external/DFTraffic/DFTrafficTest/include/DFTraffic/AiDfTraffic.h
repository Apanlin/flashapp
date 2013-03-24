//
//  AiDfTraffic
//  AiDfTraffic
//
//  Created by lz on 12-11-7.
//  Copyright (c) 2012年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AiDfTraffic: NSObject

+ (void)startAiDfTrafficPluginWithBussinessId:(NSString *)bussinessId;

+ (NSString *)setDfTrafficPluginHttpProxyWithUrlString:(NSString *)urlStr;
@end
