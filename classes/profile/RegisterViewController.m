//
//  RegisterViewController.m
//  flashapp
//
//  Created by 李 电森 on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"

@implementation RegisterViewController

@synthesize phoneTextField;
@synthesize passwordTextField;
@synthesize getPasswdButton;
@synthesize scrollView;
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize label6;
@synthesize registerButton;
@synthesize skipButton;

#pragma mark - init & destroy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [phoneTextField release];
    [passwordTextField release];
    [getPasswdButton release];
    [scrollView release];
    [label6 release];
    [label5 release];
    [label4 release];
    [label3 release];
    [label2 release];
    [label1 release];
    [registerButton release];
    [skipButton release];

    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"profile.registerView.navItem.title", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"helpName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showHelp)];
    
    self.scrollView.contentSize = CGSizeMake(320, 600);
    
    label1.text = NSLocalizedString(@"profile.registerView.register.label1", nil);
    label2.text = NSLocalizedString(@"profile.registerView.register.label2", nil);
    label3.text = NSLocalizedString(@"profile.registerView.register.label3", nil);
    label4.text = NSLocalizedString(@"profile.registerView.register.label4", nil);
    label5.text = NSLocalizedString(@"profile.registerView.register.label5", nil);
    label6.text = NSLocalizedString(@"profile.registerView.register.label6", nil);
    
    phoneTextField.placeholder = NSLocalizedString(@"set.loginView.phone.lengthError", nil);
    passwordTextField.placeholder = NSLocalizedString(@"set.loginView.password.lengthError", nil);
     
    [registerButton setTitle:NSLocalizedString(@"profile.registerView.register.registerButton.title", nil) forState:UIControlStateNormal];
    [skipButton setTitle:NSLocalizedString(@"profile.registerView.register.skipButton.title", nil) forState:UIControlStateNormal];
    [getpasswdButton setImage:[UIImage imageNamed:NSLocalizedString(@"profile.registerView.register.getPasswdButton.imageNamee", nil)] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.passwordTextField = nil;
    self.phoneTextField = nil;
    self.getPasswdButton = nil;
    self.scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - bussinuess methods

- (IBAction) getpassword:(id)sender
{
    NSString* phone = self.phoneTextField.text;
    if ( [phone length] == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.lengthError" , nil)];
        return;
    }
    
    if ( ![phone checkPhone] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.checkPhoneError" , nil)];
        return;
    }
    
    if ( client ) return;
    
    NSString* userId = [NSString stringWithRandomNum:11];
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetPassword:obj:)];
    [client registerAtGziWithUserId:userId phone:phone];
}


- (void) didGetPassword:(TwitterClient*)twitterClient obj:(NSObject*)obj
{
    client = nil;
    
    if ( [twitterClient hasError] ) {
        [AppDelegate showAlert:NSLocalizedString(@"profile.registerView.getPasswd.error", nil)];
    }
    else {
        [AppDelegate showAlert:NSLocalizedString(@"profile.registerView.getPasswd.success", nil)];
    }
}


- (IBAction) registerPhone
{
    NSString* phone = phoneTextField.text;
    NSString* password = passwordTextField.text;
    
    if ( [phone length] == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.lengthError", nil)];
        return;
    }
    
    if ( [password length] == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.password.lengthError", nil)];
        return;
    }
    
    if ( ![phone checkPhone] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.checkPhoneError", nil)];
        return;
    }
    
    if ( client ) return;
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didRegisterPhone:obj:)];
    [client login:phone password:password];
}


- (void) didRegisterPhone:(TwitterClient*)twitterClient obj:(NSObject*)obj
{
    client = nil;
    
    if ( [twitterClient hasError] ) {
        [AppDelegate showAlert:NSLocalizedString(@"profile.registerView.requestClient.error", nil)];
        return;
    }
    
    DeviceInfo* deviceInfo = [[DeviceInfo alloc] initWithJSON:obj];
    [AppDelegate getAppDelegate].user.capacity = [deviceInfo.quantity floatValue];
    [AppDelegate getAppDelegate].user.status = [deviceInfo.status intValue];
    [UserSettings saveCapacity:[deviceInfo.quantity floatValue] status:[deviceInfo.status intValue]];

    float quantity = [deviceInfo.quantity floatValue];
    if ( ceil(quantity) == quantity ) {
        [AppDelegate showAlert:[NSString stringWithFormat:@"%@%dM/%@。", NSLocalizedString(@"profile.registerView.register.success",nil),[deviceInfo.quantity intValue],NSLocalizedString(@"monthName",nil)]];
    }
    else {
        [AppDelegate showAlert:[NSString stringWithFormat:@"%@%.1fM/%@。", NSLocalizedString(@"profile.registerView.register.success",nil),[deviceInfo.quantity floatValue],NSLocalizedString(@"monthName",nil)]];
    }
    [[AppDelegate getAppDelegate] showDatasaveView:NO];
}


- (IBAction) skip
{
    if ( self.navigationController && [[AppDelegate getAppDelegate] currentNavigationController] ) {
        //在服务界面中安装(DataServiceViewController)
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
    else {
        [[AppDelegate getAppDelegate] showDatasaveView:NO];
    }
}


- (void) showHelp
{
    [AppDelegate showHelp];
}


#pragma mark - Textfield delegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint offset = self.scrollView.contentOffset;
    if ( offset.y == 0 ) {
        self.scrollView.contentOffset = CGPointMake(0, 190);
    }
    
    return YES;
}



- (IBAction) passwdFieldChanged
{
    if ( [passwordTextField.text length] > 0 ) {
        self.getPasswdButton.hidden = YES;
    }
    else {
        self.getPasswdButton.hidden = NO;
    }
}


@end
