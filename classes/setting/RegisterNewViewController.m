//
//  RegisterViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "RegisterNewViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"

#define TAG_BG_IMAGEVIEW 101

@interface RegisterNewViewController ()

@end

@implementation RegisterNewViewController

@synthesize registerButton;
@synthesize registerPhoneField;
@synthesize registerPasswdField;
@synthesize registerNicknameField;
@synthesize showCloseButton;


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
    [registerPasswdField release];
    [registerButton release];
    [registerNicknameField release];
    [registerPhoneField release];
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"注册";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:YES];
    
    UIImageView* imageView = (UIImageView*) [self.view viewWithTag:TAG_BG_IMAGEVIEW];
    imageView.image = [[UIImage imageNamed:@"help_ok_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
    
    UIImage* image = [[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    [registerButton setBackgroundImage:image forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"注    册" forState:UIControlStateNormal];

    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 60, 130, 100)];
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
    
    if (showCloseButton) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.registerPhoneField = nil;
    self.registerPasswdField = nil;
    self.registerNicknameField = nil;
    self.registerButton = nil;
    
    if ( client ) {
        [client cancel];
        [client release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - operation methods

- (IBAction)registerPhone:(id)sender
{
    NSString* phone = [registerPhoneField.text trim];
    if ( phone.length == 0 ) {
        [AppDelegate showAlert:@"请输入您的手机号！"];
        return;
    }
    
    if ( ![phone checkPhone] ) {
        [AppDelegate showAlert:@"请输入正确的手机号!"];
    }
    
    NSString* passwd = [registerPasswdField.text trim];
    if ( passwd.length < 6 || passwd.length > 16 || ![passwd checkAlphaAndNumber] ) {
        [AppDelegate showAlert:@"密码必须是6－16位字母或数字！"];
        return;
    }
    
    NSString* nickname = [registerNicknameField.text trim];
    if ( nickname.length < 4 || nickname.length > 20 ) {
        [AppDelegate showAlert:@"昵称必须是4－20位汉字，字母或数字！"];
        return;
    }
    
    if ( client ) return;
    loadingView.hidden = NO;
    
    [self checkPhoneUnique];
}


- (void) didRegisterPhone:(TwitterClient*)cli obj:(NSObject*)obj
{
    client = nil;
    loadingView.hidden = YES;
    
    if ( cli.hasError ) {
        [AppDelegate showAlert:cli.errorMessage];
        return;
    }
    else {
        //login user and switch view
        NSString* passwd = [registerPasswdField.text trim];
        BOOL result = [TwitterClient doLogin:obj passwd:passwd];
        if ( result ) {
            [AppDelegate showAlert:@"您已经成功注册。"];
            [[AppDelegate getAppDelegate] switchUser];
            [self close];
        }
        else {
            [AppDelegate showAlert:@"抱歉，注册失败。"];
        }
    }
}


- (void) checkPhoneUnique
{
    NSString* phone = [registerPhoneField.text trim];
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?username=%@", API_BASE, API_USER_VERIFY, [phone encodeAsURIComponent]];
    url = [TwitterClient composeURLVerifyCode:url];
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didCheckPhoneUnique:obj:)];
    [client get:url];
}


- (void) didCheckPhoneUnique:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    
    if ( tc.hasError ) {
        loadingView.hidden = YES;
        [AppDelegate showAlert:@"抱歉，访问服务器出错"];
        return;
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) {
        loadingView.hidden = YES;
        [AppDelegate showAlert:@"您输入的参数有错误"];
        return;
    }
    
    NSDictionary* dic = (NSDictionary*) obj;
    NSNumber* n = [dic objectForKey:@"exit"];
    BOOL b = [n boolValue];
    if ( b ) {
        loadingView.hidden = YES;
        [AppDelegate showAlert:@"您输入的手机号已经注册了。如果您忘记密码，请使用“找回密码”功能。"];
        return;
    }
    
    
    time_t now;
    time( &now );
    long long currTime = now * 1000LL;
    
    NSString* phone = [registerPhoneField.text trim];
    NSString* passwd = [registerPasswdField.text trim];
    NSString* nickname = [registerNicknameField.text trim];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?username=%@&password=%@&nickname=%@&startQuantity=%.1f&shareQuantity=%.1f&currTime=%lld", 
                     API_BASE, API_USER_REGISTER, [phone encodeAsURIComponent], 
                     [passwd encodeAsURIComponent], [nickname encodeAsURIComponent], 
                     user.dayCapacityDelta, user.monthCapacityDelta, currTime];
    url = [TwitterClient composeURLVerifyCode:url];
    
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didRegisterPhone:obj:)];
    [client get:url];
}


- (void) close
{
    if ( self.navigationController == [[AppDelegate getAppDelegate] currentNavigationController] ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
    }
}



@end
