//
//  DatastatsPieView.h
//  flashapp
//
//  Created by 李 电森 on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatastatsPieView : UIView
{
    NSMutableArray* userAgents;
    NSArray* colors;
}


@property (nonatomic, retain) NSArray* userAgents;

@end
