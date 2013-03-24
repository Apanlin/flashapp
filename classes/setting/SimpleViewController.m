//
//  SimpleViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SimpleViewController.h"
#import "AppDelegate.h"

@implementation SimpleViewController

@synthesize navBar;
@synthesize touchedView;
@synthesize imageView;
@synthesize pageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        index = 0;
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
    [navBar release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    touchedView.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navBar = nil;
}


- (void) viewWillAppear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    //[self.view setNeedsLayout];
    [super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) close
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - TouchedViewDelegate

- (void) viewTouchTap:(id)sender
{
    navBar.hidden = !navBar.hidden;
}


- (void) viewTouchLeftSwipe:(id)sender
{
    navBar.hidden = YES;
    if ( index == 2 ) return;

	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 0.35f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    index++;
    if ( index == 0 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample1.image", nil)];
    }
    else if ( index == 1 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample2.image", nil)];
    }
    else if ( index == 2 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample3.image", nil)];
    }
    
    pageControl.currentPage = index;
    
	[[self.view layer] addAnimation:animation forKey:@"animation"];
}


- (void) viewTouchRightSwipe:(id)sender
{
    navBar.hidden = YES;
    if ( index == 0 ) return;
    
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 0.35f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    index--;
    if ( index == 0 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample1.image", nil)];
    }
    else if ( index == 1 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample2.image", nil)];
    }
    else if ( index == 2 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample3.image", nil)];
    }
    
    pageControl.currentPage = index;

	[[self.view layer] addAnimation:animation forKey:@"animation"];
}

- (IBAction) pageClick:(id)sender
{
	CATransition *animation = [CATransition animation];

    int currentPage = pageControl.currentPage;
    if ( currentPage > index ) {
        animation.subtype = kCATransitionFromRight;
    }
    else if ( currentPage < index ) {
        animation.subtype = kCATransitionFromLeft;
    }
    else {
        return;
    }
    
    navBar.hidden = YES;
	animation.delegate = self;
	animation.duration = 0.35f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    
    index = currentPage;
    if ( index == 0 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample1.image", nil)];
    }
    else if ( index == 1 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample2.image", nil)];
    }
    else if ( index == 2 ) {
        imageView.image = [UIImage imageNamed:NSLocalizedString(@"set.sampleView.sample3.image", nil)];
    }
    
    pageControl.currentPage = index;
    
	[[self.view layer] addAnimation:animation forKey:@"animation"];
}

@end
