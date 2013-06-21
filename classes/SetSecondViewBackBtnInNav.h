//
//  SetSecondViewBackBtnInNav.h
//  flashapp
//
//  Created by 朱广涛 on 13-6-8.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetSecondViewBackBtnInNav : NSObject
{

}

@property (nonatomic ,retain)UIViewController *viewController;

@property (nonatomic ,retain)NSString *itemName;

+ (id)setBackController:(UIViewController *)newController anditemName:(NSString *)itemName;
//
//+ (id)getSetSecondViewBackBtnInNav;

- (id)initWithViewController:(UIViewController*)newViewController anditemName:(NSString *)newItemName;

- (void)show;

@end
