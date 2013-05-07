//
//  AboutViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "TwitterClient.h"

#ifdef DFTraffic
#import "AiDfTraffic.h"
#endif

@implementation AboutViewController

@synthesize versionLabel;


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
    [versionLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:YES];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"set.aboutView.navItem.title", nil);
    
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    if ( [@"1.4" compare:version] == NSOrderedSame ) {
        versionLabel.text = [NSString stringWithFormat:@"%@: V1.3.1",NSLocalizedString(@"set.aboutview.version.text", nil)];
    }
    else if ( [@"1.5" compare:version] == NSOrderedSame ) {
        versionLabel.text = [NSString stringWithFormat:@"%@: V1.4",NSLocalizedString(@"set.aboutview.version.text", nil)];
    }
    else if ( [@"1.6" compare:version] == NSOrderedSame ) {
        versionLabel.text = [NSString stringWithFormat:@"%@: V1.5",NSLocalizedString(@"set.aboutview.version.text", nil)];
    }
    else if ( [@"1.7" compare:version] == NSOrderedSame ) {
        versionLabel.text = [NSString stringWithFormat:@"%@: V1.6",NSLocalizedString(@"set.aboutview.version.text", nil)];
    }
    else if ( [@"1.8" compare:version] == NSOrderedSame || [@"1.9" compare:version] == NSOrderedSame ) {
        versionLabel.text = [NSString stringWithFormat:@"%@: V1.7",NSLocalizedString(@"set.aboutview.version.text", nil)];
    }
    else if ( [@"1.9" compare:version] == NSOrderedSame || [@"1.9.1" compare:version] == NSOrderedSame ) {
        versionLabel.text = [NSString stringWithFormat:@"%@: V1.8",NSLocalizedString(@"set.aboutview.version.text", nil)];
    }
    else {
        versionLabel.text = [NSString stringWithFormat:@"%@: V%@",NSLocalizedString(@"set.aboutview.version.text", nil), version];
    }

    //for 91
//    versionLabel.text = [NSString stringWithFormat:@"%@: V1.93",NSLocalizedString(@"set.aboutview.version.text", nil)];
    
    client = nil;
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#ifdef DFTraffic
    if ( !client ) {
        NSString* url = [NSString stringWithFormat:@"%@/%@.json", API_BASE, API_IDC_ZLIST];
        url = [TwitterClient composeURLVerifyCode:url];
        NSString* redirectUrl= [AiDfTraffic setDfTrafficPluginHttpProxyWithUrlString:url];
        
        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetIDCList:obj:)];
        [client get:redirectUrl];
    }
#endif
}


- (void) didGetIDCList:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.versionLabel = nil;
    
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
