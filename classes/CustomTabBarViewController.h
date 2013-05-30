//
//  CustomTabBarViewController.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-17.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTabBarViewController : UITabBarController
{
    double _y;
}

@property (nonatomic ,assign)BOOL selfInstallProfile;

@property (nonatomic ,assign) int currentSelectedIndex;

//@property (nonatomic , assign)BOOL btnHidden;

- (id)initWithInstallingProfile:(BOOL)installingProfile;

-(void)selectJumeViewPage:(int)jumpViewPage;

- (void)showTabBar;

- (void)hiddenTabBar;


@end

