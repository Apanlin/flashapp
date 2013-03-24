//
//  SectionBarItem.h
//  flashapp
//
//  Created by 李 电森 on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionBarItem : NSObject {
    
    float percent;
    NSString* text;
    UIColor* color;
    UIFont* font;
}


@property (nonatomic, assign) float percent;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) UIColor* color;
@property (nonatomic, retain) UIFont* font;

@end
