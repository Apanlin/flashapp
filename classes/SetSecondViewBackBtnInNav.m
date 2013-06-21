//
//  SetSecondViewBackBtnInNav.m
//  flashapp
//
//  Created by 朱广涛 on 13-6-8.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "SetSecondViewBackBtnInNav.h"
#import "AppDelegate.h"

@implementation SetSecondViewBackBtnInNav
SetSecondViewBackBtnInNav *secondViewSet;
@synthesize viewController;
@synthesize itemName;


- (void)dealloc
{
    [viewController release];
    [itemName release];
    [super dealloc];
}

- (id)initWithViewController:(UIViewController*)newViewController anditemName:(NSString *)newItemName
{
    self = [super init];
    if (self) {
        self.viewController = newViewController;
        self.itemName = newItemName;
    }
    return self;
}

+ (id)setBackController:(UIViewController *)newController anditemName:(NSString *)itemName
{
    secondViewSet = [[self alloc] initWithViewController:newController anditemName:itemName];
    [secondViewSet show];
    return secondViewSet;
}

- (void)show
{
    viewController.navigationItem.title = itemName;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 32);
    [btn setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"appBackBtn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    viewController.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
}

- (void)close
{
    if (viewController.navigationController == [[AppDelegate getAppDelegate] currentNavigationController]) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }else{
        [viewController.navigationController dismissModalViewControllerAnimated:YES];
    }
    
    [secondViewSet release];
}


@end
