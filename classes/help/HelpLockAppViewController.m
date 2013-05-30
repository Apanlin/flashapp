//
//  HelpLockAppViewController.m
//  flashapp
//
//  Created by Zhao Qi on 12-10-27.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "HelpLockAppViewController.h"
#import "UserAgentLockDAO.h"
#import "AppDelegate.h"

@interface HelpLockAppViewController ()

@end

@implementation HelpLockAppViewController

@synthesize bgImageView;
@synthesize resumeButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [bgImageView release];
    [resumeButton release];
    [client release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"锁网功能";
    
    bgImageView.image = [[UIImage imageNamed:@"help_triangle_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:20];
    [resumeButton setBackgroundImage:[[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8] forState:UIControlStateNormal];
}


- (void) viewDidUnload
{
    self.bgImageView = nil;
    self.resumeButton = nil;
    
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate getAppDelegate].customTabBar hiddenTabBar];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ( client ) {
        [client cancel];
    }
    [super viewWillDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) unlockButtonClick
{
    if ( client ) return;
    
    NSDictionary* dic = [UserAgentLockDAO getAllLockedApps];
    if ( [dic count] == 0 ) {
        [AppDelegate showAlert:@"当前没有已经锁网的应用！"];
        return;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
            message:[NSString stringWithFormat:@"您已经锁网了%d个应用。确定要将这些应用解锁吗？", [dic count]]
            delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self unlockAllApps];
    }
}


- (void) unlockAllApps
{
    if ( client ) return;
    
    if ( ![AppDelegate networkReachable] ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败!"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?host=%@&port=%d",
                     API_BASE, API_SETTING_RESETUA,
                     user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didUnlockAllApps:obj:)];
    [client get:url];
}


- (void) didUnlockAllApps:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败"];
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    if ( [dic objectForKey:@"code"] && [dic objectForKey:@"code"] != [NSNull null] ) {
        int code = [[dic objectForKey:@"code"] intValue];
        if ( code == 200 ) {
            [UserAgentLockDAO deleteAll];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
            [AppDelegate showAlert:@"应用已经解锁！"];
            return;
        }
    }
    
    [AppDelegate showAlert:@"抱歉，操作失败!"];
}


@end
