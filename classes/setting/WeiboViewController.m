//
//  WeiboViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboViewController.h"
#import "AppDelegate.h"

@implementation WeiboViewController

@synthesize weiboImageView;
@synthesize sinaButton;
@synthesize qqButton;
@synthesize weiboLabel;


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
    [weiboImageView release];
    [sinaButton release];
    [qqButton release];
    [weiboLabel release];
    [_bgView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:YES];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"set.weiboView.navItem.title", nil);
    self.view.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:47.0f/255.0f blue:47.0f/255.0f alpha:1.0f];
    
    UIImage* image = [[UIImage imageNamed:@"cell_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:14];
    weiboImageView.image = image;
    
    weiboLabel.text = NSLocalizedString(@"set.weiboView.label.text", nil);
    
    [sinaButton setBackgroundImage:image forState:UIControlStateNormal];
    [sinaButton setTitle:NSLocalizedString(@"set.weiboView.sinaButton.title", nil) forState:UIControlStateNormal];
    sinaButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [sinaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sinaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [qqButton setBackgroundImage:image forState:UIControlStateNormal];
    [qqButton setTitle:NSLocalizedString(@"set.weiboView.qqButton.title", nil) forState:UIControlStateNormal];
    qqButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [qqButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qqButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setBgView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.weiboImageView = nil;
    self.sinaButton = nil;
    self.qqButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) openSinaweibo:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"set.weiboView.sinaUrl", nil)]];
}


- (IBAction) openQQweibo:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"set.weiboView.qqUrl", nil)]];
}


@end
