//
//  LoginNewViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "LoginNewViewController.h"
#import "RegisterNewViewController.h"
#import "ForgotPasswdViewController.h"
#import "SNSLoginViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "OpenUDID.h"


#define TAG_BG_IMAGEVIEW 101
#define TAG_SCROLLVIEW 102

@interface LoginNewViewController ()

@end

@implementation LoginNewViewController

@synthesize sinaButton;
@synthesize renrenButton;
@synthesize qqButton;
@synthesize baiduButton;

#pragma mark - init & destroy

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
    [sinaButton release];
    [renrenButton release];
    [qqButton release];
    [baiduButton release];
    [registerButton release];
    [forgotPasswdButton release];
    [loginButton release];
    [phoneTextField release];
    [passwordTextField release];
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:YES];
    
    self.navigationItem.title = @"注册/登录";
    
    scrollView = (UIScrollView*) [self.view viewWithTag:TAG_SCROLLVIEW];
    scrollView.contentSize = CGSizeMake(320, 310);
    
    bgImageView = (UIImageView*) [self.view viewWithTag:TAG_BG_IMAGEVIEW];
    bgImageView.image = [[UIImage imageNamed:@"help_ok_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 36, 310, 1)];
    imageView.image = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    [scrollView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 98, 310, 1)];
    imageView.image = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    [scrollView addSubview:imageView];
    [imageView release];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(84, 43, 1, 47)];
    imageView.image = [[UIImage imageNamed:@"v_line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:23];
    [scrollView addSubview:imageView];
    [imageView release];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(154, 43, 1, 47)];
    imageView.image = [[UIImage imageNamed:@"v_line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:23];
    [scrollView addSubview:imageView];
    [imageView release];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 43, 1, 47)];
    imageView.image = [[UIImage imageNamed:@"v_line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:23];
    [scrollView addSubview:imageView];
    [imageView release];
    
    UIImage* image = [[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    [loginButton setBackgroundImage:image forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登    录" forState:UIControlStateNormal];
    
    registerButton.titleUnderlined = YES;
    forgotPasswdButton.titleUnderlined = YES;

    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 60, 130, 100)];
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
}


- (void)viewDidUnload
{
//    [self setBackView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.sinaButton = nil;
    self.renrenButton = nil;
    self.qqButton = nil;
    self.baiduButton = nil;
    
    if ( client ) {
        [client cancel];
        [client release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - opertion methods

- (void) didLogin:(TwitterClient*)cli obj:(NSObject*)obj
{
    loadingView.hidden = YES;
    client = nil;
    
    if ( cli.hasError ) {
        [AppDelegate showAlert:cli.errorMessage];
    }
    else {
        //login & switch view
        NSString* passwd = [passwordTextField.text trim];
        BOOL result = [TwitterClient doLogin:obj passwd:passwd];
        if ( result ) {
            [AppDelegate showAlert:@"您已经成功登录。"];
            [[AppDelegate getAppDelegate] switchUser];
            //[self.navigationController popViewControllerAnimated:YES];
            
            if ( self.navigationController == [[AppDelegate getAppDelegate] currentNavigationController] ) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
            }
        }
        else {
            [AppDelegate showAlert:@"请输入正确的手机号和密码。"];
        }
    }
}


- (void) doRegister
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] currentNavigationController];
    if ( self.navigationController == nav ) {
        [nav popViewControllerAnimated:NO];
        [self performSelector:@selector(showRegister:) withObject:@"false" afterDelay:0.1f];
    }
    else {
        [self showRegister:@"true"];
    }
}


- (void) showRegister:(NSString*)modalMode
{
    UINavigationController* currNav = [[AppDelegate getAppDelegate] currentNavigationController];
    AppDelegate *appDelegate = [AppDelegate getAppDelegate];
    if ( [@"false" compare:modalMode] == NSOrderedSame ) {
        RegisterNewViewController* controller = [[RegisterNewViewController alloc] init];
        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
        controller.hidesBottomBarWhenPushed = YES;
        [currNav pushViewController:controller animated:YES];
        [controller release];
    }
    else {
        RegisterNewViewController* controller = [[RegisterNewViewController alloc] init];
        controller.showCloseButton = YES;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
//        [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
//        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController presentModalViewController:nav animated:YES];
        [controller release];
        [nav release];
    }
}


- (void) forgotPassword
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ForgotPasswdViewController* controller = [[ForgotPasswdViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


- (void) close
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] currentNavigationController];
    if ( self.navigationController == nav ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark - sns login methods

- (void) loginSNS:(NSString*)domain
{
    SNSLoginViewController* controller = [[SNSLoginViewController alloc] init];
    controller.domain = domain;
    AppDelegate *appDelegate = [AppDelegate getAppDelegate];
    [appDelegate.leveyTabBarController hidesTabBar:YES animated:YES];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction) loginBySina
{
    [self loginSNS:@"sinaWeibo"];
}


- (IBAction) loginByRenren
{
    [self loginSNS:@"renren"];
}


- (IBAction) loginByQQ
{
    [self loginSNS:@"QQ"];
}

- (IBAction) loginByWangyiweibo
{
    [self loginSNS:@"wangyiWeibo"];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    scrollView.frame = CGRectMake(0, 0, 320, 200);
    scrollView.contentOffset = CGPointMake(0, 100);
    bgImageView.frame = CGRectMake(5, 10, 310, 296);
    return YES;
}


/*
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    scrollView.frame = CGRectMake(0, 0, 320, 416);
    scrollView.contentOffset = CGPointMake(0, 0);
    bgImageView.frame = CGRectMake(5, 10, 310, 296);
}*/

@end
