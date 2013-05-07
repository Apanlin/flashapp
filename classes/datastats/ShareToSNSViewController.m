//
//  ShareToSNSViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareToSNSViewController.h"
#import "OpenUDID.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "DateUtils.h"
#import "StringUtil.h"

@interface ShareToSNSViewController ()

@end

@implementation ShareToSNSViewController

@synthesize webView;
@synthesize textLabel;
@synthesize indicatorView;
@synthesize image;
@synthesize content;
@synthesize sns;
@synthesize loaded;


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
    [textLabel release];
    [indicatorView release];
    [webView release];
    [image release];
    [content release];
    [sns release];
    [super dealloc];
}


#pragma mark - view lifecircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0f];

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = NSLocalizedString(@"shareToSNS.navItem.title", nil);
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeName", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = [button autorelease];
    
    loaded = NO;
    [indicatorView startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.textLabel = nil;
    self.indicatorView = nil;
    self.webView = nil;
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( !loaded ) {
        loaded = YES; 
        [self shareToSNS];
    }
}


- (void) viewWillDisappear:(BOOL)animated
{
    if (picClient) {
        [picClient cancel];
        [picClient release];
        picClient = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) close
{
//    [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - share methods

- (void) shareToSNS
{
    if (picClient) return;
    
    self.textLabel.text = NSLocalizedString(@"shareToSNS.share.label.text", nil);

    NSString* deviceId = [OpenUDID value];
    NSString* title = NSLocalizedString(@"shareToSNS.share.title", nil);
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceId forKey:@"deviceId"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:sns forKey:@"sns"];
    
    NSString* url = [NSString stringWithFormat:@"http://%@/loginsns/share/device.jsp", P_HOST];
    picClient = [[TwitPicClient alloc] initWithDelegate:self];
    [picClient upload:url image:image name:@"file" params:dic];
}


- (void) incrCapacity
{
    //给用户增加限额
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    time_t now;
    time( &now );
    NSString* month = [DateUtils stringWithDateFormat:now format:@"MM"];
    
    BOOL flag = YES;
    if ( user.month ) { //如果 month！= nil
        if ( [month compare:user.month] == NSOrderedSame ) { //如果是现在这个月
            if ( user.monthCapacity < QUANTITY_MONTH_SHARE_LIMIT ) { //如果分享次数小于5此
                user.monthCapacity += 1;
                user.monthCapacityDelta += 1;
                user.capacity += QUANTITY_PER_SHARE; //增加用户限额
            }
            else {  //如果分享次数大于5
                flag = NO;
            }
        }
        else { //如果不是现在这个月 
            user.month = month; //设置新的月
            user.monthCapacity = 1; //分享次数 设置为1
            user.monthCapacityDelta = 1; //设置为1
            user.capacity += QUANTITY_PER_SHARE;
        }
    }
    else { //如果motch为空
        user.month = month;
        user.monthCapacity = 1;
        user.monthCapacityDelta = 1;
        user.capacity += QUANTITY_PER_SHARE;
    }
    
    if ( flag ) { //判断分享次数是不是大于五 如果小于五 flag = YES ；
        [UserSettings saveUserSettings:user];
        
        //刷新Datasave页面
        [AppDelegate getAppDelegate].refreshDatasave = YES;

        //发送服务器请求getMemberInfo
        //client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetMemberInfo:obj:)];
        //[client getMemberInfo];
        [TwitterClient getMemberInfoSync];
    }
}


- (void) didGetMemberInfo:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*)obj;
    [TwitterClient parseMemberInfo:dic];
}


#pragma mark - TwitPicClient Delegate

- (void)twitPicClientDidFail:(TwitPicClient*)sender error:(NSString*)error detail:(NSString*)detail
{
    picClient =nil;
    self.image = nil;
    [indicatorView stopAnimating];
    [AppDelegate showAlert:error];
}


- (void)twitPicClientDidDone:(TwitPicClient*)sender content:(NSString*)response
{
    picClient = nil;
    self.image = nil;
    
    if ( !response ) return;
    
    NSObject* obj = [response JSONValue];
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    NSString* errorCode = [dic objectForKey:@"error_code"];
    if ( errorCode ) {
        [AppDelegate showAlert:NSLocalizedString(@"shareToSNS.share.error", nil)];
        return;
    }
    
    NSString* url = [dic objectForKey:@"redirect"];
    if ( !url ) return;
    
    /*
    //给用户增加限额
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    time_t now;
    time( &now );
    NSString* month = [DateUtils stringWithDateFormat:now format:@"MM"];
    
    BOOL flag = YES;
    if ( user.month ) {
        if ( [month compare:user.month] == NSOrderedSame ) {
            if ( user.monthCapacity < QUANTITY_MONTH_SHARE_LIMIT ) {
                user.monthCapacity += QUANTITY_PER_SHARE;
                user.monthCapacityDelta += QUANTITY_PER_SHARE;
                user.capacity += QUANTITY_PER_SHARE;
            }
            else {
                flag = NO;
            }
        }
        else {
            user.month = month;
            user.monthCapacity = QUANTITY_PER_SHARE;
            user.monthCapacityDelta = QUANTITY_PER_SHARE;
            user.capacity += QUANTITY_PER_SHARE;
        }
    }
    else {
        user.month = month;
        user.monthCapacity = QUANTITY_PER_SHARE;
        user.monthCapacityDelta = QUANTITY_PER_SHARE;
        user.capacity += QUANTITY_PER_SHARE;
    }
    
    if ( flag ) {
        [UserSettings saveUserSettings:user];
        //刷新Datasave页面
        [AppDelegate getAppDelegate].refreshDatasave = YES;
        //[self getAccessData];
    }
     */
    
    self.textLabel.text = NSLocalizedString(@"shareToSNS.share.loading", nil);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


#pragma mark - Webview Delegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [indicatorView stopAnimating];
    indicatorView.hidden = YES;
    textLabel.hidden = YES;
}


- (BOOL) webView:(UIWebView *)webView1 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString;
    NSString* scheme = request.URL.scheme;
    NSString* host = request.URL.host;
    NSDictionary* params = [TwitterClient urlParameters:url];
    NSLog(@"url = %@ \n scheme = %@ \n host = %@ \n params = %@",url , scheme , host , params);
    
    if ( [@"alert" compare:scheme] == NSOrderedSame ) {
        NSString* s = [url substringFromIndex:8];
        s = [s decodeFromPercentEscapeString];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"promptName", nil) message:s delegate:nil cancelButtonTitle:NSLocalizedString(@"defineName", nil) otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return NO;
    }
    else if ( [@"logout" compare:scheme] == NSOrderedSame ) {
        NSHTTPCookie *cookie;
        NSRange range;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            range = [cookie.domain rangeOfString:host];
            if ( range.location != NSNotFound ) {
                [storage deleteCookie:cookie];
            }
        }
        
        NSString* redirect = [params objectForKey:@"redirect"];
        if ( redirect ) {
            redirect = [redirect decodeFromPercentEscapeString];
            NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:redirect]];
            [webView1 loadRequest:req];
            return NO;
        }
    }
    else if ( [@"fail" compare:scheme] == NSOrderedSame ) {
        NSString* errorPage = [[NSBundle mainBundle] pathForResource:@"faq/erro" ofType:@"html"];
        [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:errorPage]]];
        [self performSelector:@selector(close) withObject:nil afterDelay:3.0f];
        return NO;
    }
    else if ( [@"succe" compare:scheme] == NSOrderedSame ) {
        //[self close];
        return NO;
    }
    else if ( [@"finish" compare:scheme] == NSOrderedSame ) {
        time_t startTime;
        time( &startTime );
        
        [self incrCapacity];
        
        time_t endTime;
        time( &endTime );
        
        time_t d = endTime - startTime;
        if ( d < 3 ) {
            sleep( 3 - d );
        }
        [self close];
        
        return NO;
    }
    
    return YES;
    
}


@end
