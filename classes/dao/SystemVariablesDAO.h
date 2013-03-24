//
//  IDCInfoDAO.h
//  flashapp
//
//  Created by Zhao Qi on 12-12-13.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCInfo.h"

@interface SystemVariablesDAO : NSObject

+ (NSString*) getValue:(NSString*)key;
+ (void) updateKeyValue:(NSString*)key value:(NSString*)value;

@end
