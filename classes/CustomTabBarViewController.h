//
//  CustomTabBarViewController.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-17.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTabBarViewController : UIViewController

@property (nonatomic ,assign) int currentSelectedIndex;

@property (nonatomic , assign)BOOL btnHidden;


+(id)CustomTabBar:(BOOL)justinstallProfile;

-(void)selectJumeViewPage:(int)jumpViewPage;


@end

