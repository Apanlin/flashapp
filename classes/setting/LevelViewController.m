//
//  LevelViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LevelViewController.h"
#import "AppDelegate.h"
#import "UserSettings.h"

@interface LevelViewController ()

@end

@implementation LevelViewController

@synthesize bgImageView1;
@synthesize bgImageView2;
@synthesize barBgImageView;
@synthesize barImageView;
@synthesize currImageView;
@synthesize currLabel;
@synthesize currUnitLabel;
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize title;
@synthesize showCloseButton;
@synthesize descImageView;


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
    [bgImageView1 release];
    [bgImageView2 release];
    [barBgImageView release];
    [barImageView release];
    [currImageView release];
    [currLabel release];
    [currUnitLabel release];
    [label1 release];
    [label2 release];
    [label3 release];
    [descImageView release];
    [title release];

    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    if ( title ) {
        self.navigationItem.title = title;
    }
    else {
    	self.navigationItem.title = NSLocalizedString(@"set.levelView.navItem.title", nil);
    }
    
    if ( showCloseButton ) {
	    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeName", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    }
    
    UIImage* image = [[UIImage imageNamed:@"l_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    bgImageView1.image = image;
    bgImageView2.image = image;
    
    barBgImageView.image = [[UIImage imageNamed:@"l_bar_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    barImageView.image = [[UIImage imageNamed:@"l_bar_blue.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];

    label1.text = NSLocalizedString(@"set.levelView.label1.text", nil);
    label2.text = NSLocalizedString(@"set.levelView.label2.text", nil);
    label3.text = NSLocalizedString(@"set.levelView.label3.text", nil);
    descImageView.image =[UIImage imageNamed:NSLocalizedString(@"set.levelView.descImageView.iamgeName", nil)];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
     self.bgImageView1 = nil;
     self.bgImageView2 = nil;
     self.barBgImageView = nil;
     self.barImageView = nil;
     self.currImageView = nil;
     self.currLabel = nil;
     self.currUnitLabel = nil;
     self.title = nil;
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.descImageView = nil;
}


- (void) viewWillAppear:(BOOL)animated
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    float capacity = user.capacity;
    
    CGSize size1 = [@"MB" sizeWithFont:[UIFont boldSystemFontOfSize:10]];
    CGSize size2;
    NSString* s ;
    
    if ( ceil(capacity) == capacity ) {
        s = [NSString stringWithFormat:@"%.0f", capacity];
        currLabel.text = s;
    }
    else {
        s = [NSString stringWithFormat:@"%.1f", capacity];
        currLabel.text = s;
    }
    
    size2 = [s sizeWithFont:[UIFont boldSystemFontOfSize:18]];
    
    float width;
    CGRect barImageRect = barImageView.frame;
    
    if ( capacity >= 400 ) {
        barImageView.frame = barBgImageView.frame;
    }
    else if ( capacity >= 300 ) {
        width = ((capacity - 300) / 100) * 42;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, 20 + 42*6 + width, barImageRect.size.height);
    }
    else if ( capacity >= 220 ) {
        width = ((capacity - 220) / 80) * 42;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, 20 + 42*5 + width, barImageRect.size.height);
    }
    else if ( capacity >= 180 ) {
        width = ((capacity - 180) / 40) * 42;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, 20 + 42*4 + width, barImageRect.size.height);
    }
    else if ( capacity >= 140 ) {
        width = ((capacity - 140) / 40) * 42;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, 20 + 42*3 + width, barImageRect.size.height);
    }
    else if ( capacity >= 100 ) {
        width = ((capacity - 100) / 40) * 42;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, 20 + 42*2 + width, barImageRect.size.height);
    }
    else if ( capacity >= 80 ) {
        width = ((capacity - 80) / 20) * 42;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, 20 + 42 + width, barImageRect.size.height);
    }
    else if ( capacity >= 50 ) {
        width = ((capacity - 50) / 30) * 42;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, 20 + width, barImageRect.size.height);
    }
    else {
        width = capacity / 50 * 20;
        barImageView.frame = CGRectMake( barImageRect.origin.x, barImageRect.origin.y, width, barImageRect.size.height);
    }
    
    width = size1.width + size2.width + 8;
    float x = barImageView.frame.origin.x + barImageView.frame.size.width - (width * 26/49);
    if ( x < barImageView.frame.origin.x ) {
        x = barImageView.frame.origin.x;
    }
    else if ( x + width > barBgImageView.frame.origin.x + barBgImageView.frame.size.width ) {
        x = barBgImageView.frame.origin.x + barBgImageView.frame.size.width - width;
    }
    
    CGRect currImageRect = currImageView.frame;
    currImageView.frame = CGRectMake( x, currImageRect.origin.y, width, currImageRect.size.height);
    
    CGRect rect = currUnitLabel.frame;
    currUnitLabel.frame = CGRectMake( currImageView.frame.origin.x + currImageView.frame.size.width - size1.width - 5, 
                                     rect.origin.y, size1.width, rect.size.height);
    
    rect = currLabel.frame;
    currLabel.frame = CGRectMake( currUnitLabel.frame.origin.x - size2.width, rect.origin.y, size2.width, rect.size.height);

    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) close
{
    [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
}

@end
