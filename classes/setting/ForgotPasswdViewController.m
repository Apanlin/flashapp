//
//  ForgotPasswdViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ForgotPasswdViewController.h"
#import "AppDelegate.h"
#import "TwitterClient.h"
#import "StringUtil.h"

@implementation ForgotPasswdViewController

@synthesize bgImageView;
@synthesize phoneField;
@synthesize codeField;
@synthesize passwordField;
@synthesize getCodeButton;
@synthesize submitButton;
@synthesize scrollView;
@synthesize phoneLabel;
@synthesize codeLabel;
@synthesize passwordLabel;


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
    [bgImageView release];
    [phoneField release];
    [codeField release];
    [passwordField release];
    [getCodeButton release];
    [submitButton release];
    [scrollView release];
    [phoneLabel release];
    [codeLabel release];
    [phoneLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"set.forgetPasswordView.navItem.title", nil);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"defineName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submit:)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
    
    bgImageView.image = [[UIImage imageNamed:@"grayPannel.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
    
    [getCodeButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [getCodeButton setTitle:NSLocalizedString(@"set.forgetPasswordView.getCodeButton.title", nil) forState:UIControlStateNormal];
    [getCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [getCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    getCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 22, 100, 256, 1)];
    lineImageView.image = [UIImage imageNamed:@"line.png"];
    [self.scrollView addSubview:lineImageView];
    [lineImageView release];
    
    [submitButton setBackgroundImage:[[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
    [submitButton setTitle:NSLocalizedString(@"set.forgetpasswordView.submitButton.title", nil) forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    phoneLabel.text = NSLocalizedString(@"set.forgetPasswordView.phoneLabel.text", nil);
    codeLabel.text = NSLocalizedString(@"set.forgetPasswordView.codeLabel.text", nil);
    passwordLabel.text = NSLocalizedString(@"set.forgetPasswordView.passwordLabel.text", nil);
    
    phoneField.placeholder = NSLocalizedString(@"set.forgetPasswordView.phoneTextField.placeholder", nil);
    codeField.placeholder = NSLocalizedString(@"set.forgetPasswordView.codeTextField.placeholder", nil);
    passwordField.placeholder = NSLocalizedString(@"set.forgetPasswordView.passwordTextField.placeholder", nil);

    //doingView = [[LoadingView alloc] initWithFrame:CGRectMake( , <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    scrollView.contentSize = CGSizeMake(320, 276);
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bgImageView = nil;
    self.phoneField = nil;
    self.codeField = nil;
    self.passwordField = nil;
    self.getCodeButton = nil;
    self.submitButton = nil;
    self.scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) submit:(id)sender
{
    NSString* phone = [phoneField.text trim];
    if ( phone.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.phone.lengthError", nil)];
        return;
    }
    
    if ( ![phone checkPhone] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.phone.checkPhoneError", nil)];
        return;
    }
    
    NSString* code = [codeField.text trim];
    if ( code.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.code.isNull", nil)];
        return;
    }
    
    NSString* password = [passwordField.text trim];
    if ( password.length < 6 || password.length > 16 || ![password checkAlphaAndNumber] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.checkAlphaAndNumber.Error", nil)];
        return;
    }
    
    BOOL result = [TwitterClient forgetPasswd:phone vericode:code password:password];
    if ( !result ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.save.error", nil)];
    }
    else {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.save.success", nil)];
        
        UserSettings* user = [AppDelegate getAppDelegate].user;
        user.password = password;
        [UserSettings savePassword:password];
        [self close];
    }
}


- (void) close
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] currentNavigationController];
    if ( self.navigationController == nav ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [nav dismissModalViewControllerAnimated:YES];
    }
}


- (IBAction) getCode:(id)sender
{
    NSString* phone = [phoneField.text trim];
    if ( phone.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.phone.isNull", nil)];
        return;
    }
    
    if ( ![phone checkPhone] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.checkPhone.error", nil)];
        return;
    }
    
    if ( client ) return;
    
    doingView.hidden = NO;
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?username=%@", API_BASE, API_USER_GETCODE, phone];
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetCode:obj:)];
    [client get:url];
}


- (void) didGetCode:(TwitterClient*)twitterClient obj:(NSObject*)obj
{
    client = nil;
    doingView.hidden = YES;
    
    if ( twitterClient.hasError ) {
        [AppDelegate showAlert:twitterClient.errorMessage];
    }
    else {
        [AppDelegate showAlert:NSLocalizedString(@"set.forgetPasswordView.getCode.success", nil)];
    }
    
}




#pragma mark - UITextField Delegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    scrollView.frame = CGRectMake(0, 0, 320, 216);
    scrollView.contentSize = CGSizeMake(320, 276);
    bgImageView.frame = CGRectMake(10, 13, 300, 192);
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    scrollView.frame = CGRectMake(0, 0, 320, 276);
    scrollView.contentSize = CGSizeMake(320, 276);
    bgImageView.frame = CGRectMake(10, 13, 300, 192);
    return YES;
}

@end
