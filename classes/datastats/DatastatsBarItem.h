//
//  DatastatsBarItem.h
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatastatsBarItem : NSObject
{
    long number;
    NSString* description;
    
    BOOL showNumber;
    BOOL showPercent;
    BOOL showDesc;
}

@property (nonatomic, assign) long number;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, assign) BOOL showPercent;
@property (nonatomic, assign) BOOL showNumber;
@property (nonatomic, assign) BOOL showDesc;

@end
