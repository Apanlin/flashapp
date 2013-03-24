//
//  CLMView.h
//  DrawTest
//
//  Created by cocoa on 10-9-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface CLMView : UIView 
{

	float spaceHeight; //高度
	float scaleY ; 
	NSArray *titleArr ; //文字
	NSArray *valueArr; //值
	NSArray	*colorArr; //颜色
    
    int centerX;
    int centerY;
    int radius;
}

@property (nonatomic, assign) int centerX;
@property (nonatomic, assign) int centerY;
@property (nonatomic, assign) int radius;
@property(nonatomic, assign)  float spaceHeight;
@property(nonatomic, assign) float scaleY;
@property(nonatomic, retain) NSArray *titleArr;
@property(nonatomic, retain) NSArray *valueArr;
@property(nonatomic, retain) NSArray *colorArr;

@end
