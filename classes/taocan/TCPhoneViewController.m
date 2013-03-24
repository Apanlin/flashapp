//
//  TCPhoneViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TCPhoneViewController.h"
#import "TCCarrierViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"

@interface TCPhoneViewController ()

@end

@implementation TCPhoneViewController

@synthesize phoneTextField;
@synthesize button;
@synthesize bgImageView;
@synthesize phoneLabel;


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
    [phoneTextField release];
    [button release];
    [bgImageView release];
    [phoneLabel release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title =  NSLocalizedString(@"taocan.TCAdjustView.navItem.title", nil);
    
    bgImageView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [button setBackgroundImage:[UIImage imageNamed:@"blueButton3.png"] forState:UIControlStateNormal];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    phoneTextField.text = user.phone;
    
    phoneTextField.placeholder = NSLocalizedString(@"taocan.TCPhoneView.phoneTextField.placeholder", nil);
    phoneLabel.text = NSLocalizedString(@"set.loginView.phoneLabel.text", nil);
    
    [self.phoneTextField becomeFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.phoneTextField = nil;
    self.button = nil;
    self.bgImageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) save
{
    NSString* s = [phoneTextField.text trim];
    if ( s.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.lengthError", nil)];
        return;
    }
    
    if ( ![s checkPhone] ) {
        [AppDelegate showAlert:NSLocalizedString(@"set.loginView.phone.checkPhoneError", nil)];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( [s compare:user.phone] == NSOrderedSame ) {
        if ( user.areaCode && user.areaCode.length > 0 && user.carrierCode && user.carrierCode.length > 0 && user.carrierType && user.carrierType.length > 0 ) {
            [self openCarrierInfoView];
        }
        else {
            [self getCarrierInfo];
        }
    }
    else {
        user.phone = s;
        [UserSettings saveUserSettings:user];
        [self getCarrierInfo];
    }
}


- (void) getCarrierInfo
{
    NetworkStatus status = [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus];
    if ( status != NotReachable ) {
        if ( client ) return;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* s = [phoneTextField.text trim];
        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetCarrierInfo:obj:)];
        [client getCarrierInfo:s area:nil code:nil type:nil];
    }
    else {
        [self openCarrierInfoView];
    }
}


- (void) didGetCarrierInfo:(TwitterClient*)tc obj:(NSObject*)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    client = nil;

    [TwitterClient parseCarrierInfo:obj];
    
    [self openCarrierInfoView];
}


- (void) openCarrierInfoView
{
    
    TCCarrierViewController* controller = [[TCCarrierViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


@end
