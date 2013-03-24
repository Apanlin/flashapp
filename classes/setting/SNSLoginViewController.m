//
//  SNSLoginViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "SNSLoginViewController.h"
#import "AppDelegate.h"
#import "TwitterClient.h"
#import "OpenUDID.h"
#import "StringUtil.h"

@interface SNSLoginViewController ()

@end

@implementation SNSLoginViewController

@synthesize webview;
@synthesize indicator;
@synthesize label;
@synthesize domain;


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
    [webview release];
    [indicator release];
    [label release];
    [domain release];
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ( [@"sinaWeibo" compare:domain] == NSOrderedSame ) {
        self.navigationItem.title = @"微博账号登录";
    }
    else if ( [@"renren" compare:domain] == NSOrderedSame ) {
        self.navigationItem.title = @"人人网账号登录";
    }
    else if ( [@"QQ" compare:domain] == NSOrderedSame ) {
        self.navigationItem.title = @"QQ账号登录";
        webview.scalesPageToFit = YES;
    }
    else if ( [@"baidu" compare:domain] == NSOrderedSame ) {
        self.navigationItem.title = @"百度账号登录";
    }
    else if ( [@"wangyiWeibo" compare:domain] == NSOrderedSame ) {
        self.navigationItem.title = @"网易微博登录";
        webview.scalesPageToFit = YES;
    }
    
    [indicator startAnimating];
    [self loadPage];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webview = nil;
    self.indicator = nil;
    self.label = nil;
    self.domain = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - tool methods

- (void) loadPage
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"http://%@/loginsns/login?_method=loginSNS&domain=%@&type=2&startQuantity=%f&shareQuantity=%f&uniqueId=%@", 
                     P_HOST, domain, user.dayCapacityDelta, user.monthCapacityDelta, [OpenUDID value]];

    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
    indicator.hidden = YES;
    label.hidden = YES;
}


- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString;
    url = [url decodeFromPercentEscapeString];
    NSString* scheme = request.URL.scheme;
    NSDictionary* params = [TwitterClient urlParameters:url];
    NSLog(@"login url = %@",url);
    if ( [@"regist" compare:scheme] == NSOrderedSame ) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        NSString* userId = [params objectForKey:@"id"];
        NSString* userName = [params objectForKey:@"username"];
        NSString* nickname = [params objectForKey:@"nickname"];
        NSString* capacity = [params objectForKey:@"num"]; //用户限额
        NSString* level = [params objectForKey:@"lv"];
        [dic setObject:userId forKey:@"id"];
        [dic setObject:userName forKey:@"username"];
        [dic setObject:nickname forKey:@"nickname"];
        [dic setObject:capacity forKey:@"curentNum"];
        [dic setObject:level forKey:@"level"];
        
        [AppDelegate getAppDelegate].user.snsDomain = domain;
        [TwitterClient doLogin:dic];
        [self performSelector:@selector(afterLogin) withObject:nil afterDelay:0.2f];
        NSLog(@"params dic = %@",params);
        NSLog(@"dic = %@",dic);
        return NO;
    }
    else {
        return YES;
    }
}


- (void) afterLogin
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] currentNavigationController];
    if ( nav == self.navigationController ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [nav dismissModalViewControllerAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:self];
}


@end
