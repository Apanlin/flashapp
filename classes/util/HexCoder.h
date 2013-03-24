//
//  HexCoder.h
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexCoder : NSObject

+ (NSString *) parseByte2HexString:(Byte *) bytes;
+ (NSString *) parseByteArray2HexString:(Byte[]) bytes;

@end
