//
//  HexCoder.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "HexCoder.h"

@implementation HexCoder

+ (NSString *) parseByte2HexString:(Byte *) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes) {
        while (bytes[i] != '\0') {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else 
                [hexStr appendFormat:@"%@", hexByte];

            i++;
        }
    }
    return hexStr;
}


+ (NSString *) parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes) {
        while (bytes[i] != '\0')  {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else 
                [hexStr appendFormat:@"%@", hexByte];

            i++;
        }
    }
    return hexStr;
}

@end
