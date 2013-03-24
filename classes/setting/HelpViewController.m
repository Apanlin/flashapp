//
//  HelpViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"

@implementation HelpViewController

@synthesize webView;
@synthesize waitLabel;
@synthesize indicator;
@synthesize showCloseButton;
@synthesize page;
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
    [webView release];
    [page release];
    [waitLabel release];
    [indicator release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    NSString* title = self.navigationItem.title;
    if ( !title ) {
        self.navigationItem.title = NSLocalizedString(@"set.helpView.navItem.title", nil);
    }
    
    //如果是新建nav打开的，则显示“关闭”按钮；否则不显示
    if ( showCloseButton ) {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeName", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
        self.navigationItem.rightBarButtonItem = [button autorelease];
    }
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( loaded ) return;
    
    indicator.hidden = NO;
    [indicator startAnimating];
    waitLabel.hidden = NO;
    
    if ( !page || page.length == 0 ) page = @"faq/faq";
    
    NSRange range1 = [page rangeOfString:@"http://"];
    NSRange range2 = [page rangeOfString:@"https://"];
    if ( range1.location != NSNotFound || range2.location != NSNotFound ) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:page]]];
    }
    else {
        range1 = [page rangeOfString:@"/" options:NSBackwardsSearch];
        NSString* url;
        if ( range1.location == NSNotFound ) {
            url = [[NSBundle mainBundle] pathForResource:page ofType:@"html"];
        }
        else {
            NSString* dir = [page substringToIndex:range1.location];
            NSString* file = [page substringFromIndex:range1.location + 1];
            url = [[NSBundle mainBundle] pathForResource:file ofType:@"html" inDirectory:dir];
        }
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:url]]];
    }
    
    loaded = YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
    self.indicator = nil;
    self.waitLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) close
{
    [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIWebView Delegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
    indicator.hidden = YES;
    waitLabel.hidden = YES;
}


- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [indicator stopAnimating];
    indicator.hidden = YES;
    waitLabel.hidden = NO;
    waitLabel.text = @"抱歉，加载网页失败。";
}



@end
