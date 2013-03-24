//
//  DatastatsBarItem.m
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsBarItem.h"

@implementation DatastatsBarItem

@synthesize number;
@synthesize description;
@synthesize showDesc;
@synthesize showPercent;
@synthesize showNumber;


- (void) dealloc
{
    [description release];
    [super dealloc];
}


@end
