//
//  LoginViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPasswdViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "OpenUDID.h"

@interface LoginViewController (private)
- (void) switchTab:(int)selectedTab;
- (BOOL) doLogin:(NSObject*)obj afterRegister:(BOOL)reg;
@end


@implementation LoginViewController

@synthesize scrollView;
@synthesize loginView;
@synthesize registerView;
@synthesize loginImageView;
@synthesize registerImageView;
@synthesize loginButton;
@synthesize registerButton;
@synthesize loginSaveButton;
@synthesize registerSaveButton;
@synthesize registerPhoneField;
@synthesize registerPasswdField;
@synthesize registerNicknameField;
@synthesize loginPhoneField;
@synthesize loginPasswdField;
@synthesize loginPhoneLabel;
@synthesize loginPasswdLabel;
@synthesize registerPhoneLabel;
@synthesize registerPasswdLabel;
@synthesize registerNicknameLabel;
@synthesize forgetPassWdButton;
@synthesize tabNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentTextField = nil;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void) dealloc
{
    [scrollView release];
    [loginView release];
    [registerView release];
    [loginImageView release];
    [registerImageView release];
    [loginButton release];
    [registerButton release];
    [loginSaveButton release];
    [registerSaveButton release];
    [loginPhoneField release];
    [loginPasswdField release];
    [registerPhoneField release];
    [registerPasswdField release];
    [registerNicknameField release];
    [loginPasswdLabel release];
    [loginPhoneLabel release];
    [registerPhoneLabel release];
    [registerNicknameLabel release];
    [registerPasswdLabel release];
    [forgetPassWdButton release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = NSLocalizedString(@"set.loginView.navItem.title", nil);
    
    self.loginImageView.image = [[UIImage imageNamed:@"cell_bg.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
    self.registerImageView.image = [[UIImage imageNamed:@"cell_bg.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
    
    [loginSaveButton setBackgroundImage:[[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
    
    [registerSaveButton setBackgroundImage:[[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
    
    [loginButton setTitle:NSLocalizedString(@"set.loginView.loginButton.title", nil) forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [registerButton setTitle:NSLocalizedString(@"set.loginView.registerButton.title", nil) forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    UIImage* lineImage = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    loginLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 32, 46, 100, 1)];
    loginLineImageView.image = lineImage;
    [scrollView addSubview:loginLineImageView];
    [loginLineImageView release];
    
    registerLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 190, 46, 100, 1)];
    registerLineImageView.image = lineImage;
    [scrollView addSubview:registerLineImageView];
    [registerLineImageView release];
    registerLineImageView.hidden = YES;
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 60, 130, 100)];
    loadingView.hidden = YES;
    [self.scrollView addSubview:loadingView];
    [loadingView release];
    
    registerPhoneLabel.text = NSLocalizedString(@"set.loginView.phoneLabel.text", nil);
    registerPasswdLabel.text = NSLocalizedString(@"set.loginView.passwordLabel.text", nil);
    registerNicknameLabel.text = NSLocalizedString(@"set.loginView.nickNameLabel.text", nil);
    loginPhoneLabel.text = NSLocalizedString(@"set.loginView.phoneLabel.text", nil);
    loginPasswdLabel.text =  NSLocalizedString(@"set.loginView.passwordLabel.text", nil);
    
    registerPhoneField.placeholder = NSLocalizedString(@"set.loginView.phoneTextField.placeholder", nil);
    registerPasswdField.placeholder = NSLocalizedString(@"set.loginView.passwdTextField.placeholder", nil);
    registerNicknameField.placeholder = NSLocalizedString(@"set.loginView.nickNameTextField.placeholder", nil);
    [registerSaveButton setTitle:NSLocalizedString(@"set.loginView.registerButton.title", nil) forState:UIControlStateNormal];
    
    loginPhoneField.placeholder = NSLocalizedString(@"set.loginView.phoneTextField.placeholder", nil);
    loginPasswdField.placeholder = NSLocalizedString(@"set.loginView.loginpasswdTextField.placeholder", nil);
    [loginSaveButton setTitle:NSLocalizedString(@"set.loginView.loginButton.title", nil) forState:UIControlStateNormal];
    [forgetPassWdButton setTitle:NSLocalizedString(@"set.loginView.forgetpasswdTextField.placeholder", nil) forState:UIControlStateNormal];
    
    [self switchTab:tabNumber];

    scrollView.contentSize = CGSizeMake( 320, 416 );
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.loginView = nil;
    self.registerView = nil;
    self.loginImageView = nil;
    self.registerImageView = nil;
    self.loginButton = nil;
    self.registerButton = nil;
    self.loginSaveButton = nil;
    self.registerSaveButton = nil;
    self.loginPhoneField = nil;
    self.loginPasswdField = nil;
    self.registerPhoneField = nil;
    self.registerPasswdField = nil;
    self.registerNicknameField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - bussiness methods

- (void) switchTab:(int)selectedTab
{
    tabNumber = selectedTab;
    
    if ( tabNumber == 0 ) {
        loginButton.frame = CGRectMake(8, 11, 149, 42);
        [loginButton setBackgroundImage:[UIImage imageNamed:@"tab_left_h.png"] forState:UIControlStateNormal];
        registerButton.frame = CGRectMake( 164, 12, 149, 42);
        [registerButton setBackgroundImage:[UIImage imageNamed:@"tab_right_n.png"] forState:UIControlStateNormal];

        loginView.hidden = NO;
        loginLineImageView.hidden = NO;
        registerView.hidden = YES;
        registerLineImageView.hidden = YES;
    }
    else {
        loginButton.frame = CGRectMake(8, 12, 149, 42);
        [loginButton setBackgroundImage:[UIImage imageNamed:@"tab_left_n.png"] forState:UIControlStateNormal];
        registerButton.frame = CGRectMake( 164, 11, 149, 42);
        [registerButton setBackgroundImage:[UIImage imageNamed:@"tab_right_h.png"] forState:UIControlStateNormal];
        
        loginView.hidden = YES;
        loginLineImageView.hidden = YES;
        registerView.hidden = NO;
        registerLineImageView.hidden = NO;
    }

    if ( currentTextField ) {
        [self textFieldDidEndEditing:currentTextField];
    }
}


- (IBAction) showLoginView:(id)sender
{
    [self switchTab:0];
}


- (IBAction) showRegisterView:(id)sender
{
    [self switchTab:1];
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
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.requestClient.error", nil)];
        return;
    }

    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) {
        loadingView.hidden = YES;
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.kindOfClass.error", nil)];
        return;
    }
    
    NSDictionary* dic = (NSDictionary*) obj;
    NSNumber* n = [dic objectForKey:@"exit"];
    BOOL b = [n boolValue];
    if ( b ) {
        loadingView.hidden = YES;
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phonenumber.exit", nil)];
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


- (IBAction)registerPhone:(id)sender
{
    NSString* phone = [registerPhoneField.text trim];
    if ( phone.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.registphone.lengthError", nil)];
        return;
    }
    
    if ( ![phone checkPhone] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.checkPhoneError", nil)];
    }
    
    NSString* passwd = [registerPasswdField.text trim];
    if ( passwd.length < 6 || passwd.length > 16 || ![passwd checkAlphaAndNumber] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.checkAlphaAndNumber.Error", nil)];
        return;
    }
    
    NSString* nickname = [registerNicknameField.text trim];
    if ( nickname.length < 4 || nickname.length > 20 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.nickName.lengthError", nil)];
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
        BOOL result = [self doLogin:obj afterRegister:YES];
        if ( result ) {
            [AppDelegate showAlert:NSLocalizedString(@"set.loginView.regist.success", nil)];
            [[AppDelegate getAppDelegate] switchUser];
            [self cancel];
        }
        else {
            [AppDelegate showAlert:NSLocalizedString(@"set.loginView.regist.error", nil)];
        }
    }
}


- (IBAction) login:(id)sender
{
    NSString* phone = [loginPhoneField.text trim];
    if ( phone.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.lengthError", nil)];
        return;
    }
    
    NSString* passwd = [loginPasswdField.text trim];
    if ( passwd.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.password.lengthError", nil)];
        return;
    }
    
    if ( client ) return;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    time_t now;
    time( &now );
    long long currTime = now * 1000LL;
    
    srand( time(0) );
    int rd = ((double) rand() / RAND_MAX) * 10000;
    
    NSString* deviceId = [OpenUDID value];
    NSString* code = [[NSString stringWithFormat:@"%@%@%@%d", deviceId, CHANNEL, API_KEY, rd] md5HexDigest];

    loadingView.hidden = NO;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?deviceId=%@&username=%@&password=%@&startQuantity=%f&shareQuantity=%f&currTime=%lld&chl=%@&rd=%d&code=%@&ver=%@", 
        API_BASE, API_USER_LOGIN, deviceId, [phone encodeAsURIComponent], [passwd encodeAsURIComponent], 
        user.dayCapacityDelta, user.monthCapacityDelta, currTime,
        CHANNEL, rd, code, API_VER];
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didLogin:obj:)];
    [client get:url];
}


- (void) didLogin:(TwitterClient*)cli obj:(NSObject*)obj
{
    loadingView.hidden = YES;
    client = nil;
    
    if ( cli.hasError ) {
        [AppDelegate showAlert:cli.errorMessage];
    }
    else {
        //login & switch view
        BOOL result = [self doLogin:obj afterRegister:NO];
        if ( result ) {
            [AppDelegate showAlert:NSLocalizedString(@"set.loginView.login.success", nil)];
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
            [AppDelegate showAlert:NSLocalizedString(@"set.loginView.login.error", nil)];
        }
    }
}


- (BOOL) doLogin:(NSObject*)obj afterRegister:(BOOL)reg
{
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return NO;
    
    NSDictionary* dic = (NSDictionary*)obj;
    NSObject* userId = [dic objectForKey:@"id"];
    NSObject* username = [dic objectForKey:@"username"];
    NSObject* nickname = [dic objectForKey:@"nickname"];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    if ( reg ) {
        NSString* passwd = [registerPasswdField.text trim];
        NSLog(@"passwd = %@", passwd);
        user.password = passwd;
    }
    else {
        NSString* passwd = [loginPasswdField.text trim];
        NSLog(@"passwd = %@", passwd);
        user.password = passwd;
    }
    
    if ( userId && userId != [NSNull null] ) {
        user.userId = [(NSString*)userId intValue];
    }
    
    if ( username && username != [NSNull null] ) {
        user.username = (NSString*)username;
    }
    
    if ( nickname && nickname != [NSNull null] ) {
        user.nickname = (NSString*)nickname;
    }
    
    NSObject* capacity = [dic objectForKey:@"curentNum"];
    NSObject* status = [dic objectForKey:@"status"];

    if ( capacity && capacity != [NSNull null] ) {
        user.capacity = [(NSDecimalNumber*)capacity floatValue];
    }
    
    if ( status && status != [NSNull null] ) {
        user.status = [(NSDecimalNumber*)status intValue];
        user.status = STATUS_REGISTERED_ACTIVE;
    }
    
    user.day = nil;
    user.dayCapacity = 0;
    user.dayCapacityDelta = 0;
    user.month = nil;
    user.monthCapacity = 0;
    user.monthCapacityDelta = 0;
    
    [UserSettings saveUserSettings:user];
    return YES;
}


- (void) cancel
{
    if ( self.navigationController == [[AppDelegate getAppDelegate] currentNavigationController] ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
    }
}


- (void) forgotPassword:(id)sender
{
    ForgotPasswdViewController* controller = [[ForgotPasswdViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");
    currentTextField = textField;
    scrollView.frame = CGRectMake( 0, 0, 320, 216 );
    scrollView.contentSize = CGSizeMake( 320, 416 );
    return YES;
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    [textField resignFirstResponder];
    
    if ( currentTextField == textField ) {
        scrollView.frame = CGRectMake( 0, 0, 320, 416 );
    }
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
