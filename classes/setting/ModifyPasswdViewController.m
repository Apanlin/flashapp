//
//  ModifyPasswdViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModifyPasswdViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "TwitterClient.h"

@implementation ModifyPasswdViewController

@synthesize bgImageView;
@synthesize oldPasswordField;
//@synthesize newPasswordField;
@synthesize saveButton;
@synthesize oldPasswordLabel;



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
    [oldPasswordField release];
    [newPasswordField release];
    [saveButton release];
    [oldPasswordLabel release];
    [newPasswordLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"set.modifyPassWordView.navItem.title", nil);
    bgImageView.image = [[UIImage imageNamed:@"grayPannel.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:10];
    [saveButton setBackgroundImage:[[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
     [saveButton setTitle:NSLocalizedString(@"set.modifyPassWordView.saveButton.title", nil) forState:UIControlStateNormal];
     [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
     saveButton.titleLabel.font = [UIFont systemFontOfSize:18];

    oldPasswordLabel.text = NSLocalizedString(@"set.modifyPassWordView.oldPassword.label.text", nil);
    newPasswordLabel.text = NSLocalizedString(@"set.modifyPassWordView.newPassword.label.text", nil);
    oldPasswordField.placeholder = NSLocalizedString(@"set.modifyPassWordView.oldPassword.textField.placeholder", nil);
    newPasswordField.placeholder = NSLocalizedString(@"set.modifyPassWordView.newPassword.textField.placeholder", nil);
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 150, 130, 100)];
    loadingView.message = NSLocalizedString(@"set.modifyPassWordView.loading.message", nil);
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bgImageView = nil;
    self.oldPasswordField = nil;
    self.newPasswordField = nil;
    self.saveButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - tools methods

- (BOOL) saveUserInfo
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* username = user.username;
    
    NSString* oldPassword = [oldPasswordField.text trim];
    NSString* newPassword = [newPasswordField.text trim];
    
    if ( !oldPassword || oldPassword.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.modifyPassWordView.oldPassWord.isNull", nil)];
        return NO;
    }
    
    if ( newPassword.length < 6 || newPassword.length > 16 || ![newPassword checkAlphaAndNumber] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.modifyPassWordView.newPassWord.lengthError", nil)];
        return NO;
    }
    
    loadingView.hidden = NO;
    BOOL result = [TwitterClient modifyPassword:newPassword oldPasswd:oldPassword forUser:username];
    
    loadingView.hidden = YES;
    if ( !result ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.modifyPassWordView.saveNewPassWord.Error", nil)];
        return NO;
    }
    else {
        [AppDelegate showAlert:NSLocalizedString(@"set.modifyPassWordView.saveNewPassWord.Success", nil)];
        user.password = newPassword;
        [UserSettings savePassword:newPassword];
        return YES;
    }
}


- (IBAction) changePassword:(id)sender
{
    BOOL result = [self saveUserInfo];
    if ( result ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
