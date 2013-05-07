//
//  BannerImageUtil.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-19.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerImageUtil : NSObject

+(id)getBanerImageUtil;

-(void)setTimeStamp:(NSInteger)timesTamp;

-(int)getTimeStamp;

-(void)saveBannerImage:(NSData *)imgData andLink:(NSString *)link;

@end
