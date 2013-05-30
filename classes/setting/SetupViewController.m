//
//  SetupViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SetupViewController.h"
#import "InstallProfileViewController.h"
#import "AppDelegate.h"
#import "TouchedView.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

@synthesize isSetup;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) loadView
{
    UIView* view;
    if ( isSetup ) {
        if ( iPhone5 ) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
        }
        else {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        }
    }
    else {
        if ( iPhone5 ) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 508)];
        }
        else {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        }
        self.navigationItem.title = @"新手上路";
    }
    self.view = view;
    
    
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SetupViewController" owner:self options:nil];
    for ( UIView* v in arr ) {
        if ( isSetup ) {
            if ( v.tag > 100 && v.tag < 200 ) {
                TouchedView* tv = (TouchedView*) v;
                if ( iPhone5 ) {
                    tv.frame = CGRectMake(0, 0, 320, 548);
                }
                else {
                    tv.frame = CGRectMake(0, 0, 320, 460);
                }
            }
        }
        else {
            if ( v.tag > 100 && v.tag < 200 ) {
                TouchedView* tv = (TouchedView*) v;
                if ( iPhone5 ) {
                    tv.frame = CGRectMake(0, 0, 320, 508);
                }
                else {
                    tv.frame = CGRectMake(0, 0, 320, 416);
                }
            }
        }

        if ( v.tag == 101 ) {
            tv1 = (TouchedView*) v;
            tv1.delegate = self;
            [self.view addSubview:tv1];
        }
        else if ( v.tag == 102 ) {
            tv2 = (TouchedView*) v;
            tv2.delegate = self;
            [self.view addSubview:tv2];
        }
        else if ( v.tag == 103 ) {
            tv3 = (TouchedView*) v;
            tv3.delegate = self;
            [self.view addSubview:tv3];
        }
        else if ( v.tag == 104 ) {
            tv4 = (TouchedView*) v;
            tv4.delegate = self;
            [self.view addSubview:tv4];
        }
        else if ( v.tag == 105 ) {
            tv5 = (TouchedView*) v;
            tv5.delegate = self;
            [self.view addSubview:tv5];
        }
    }
    
    [self prepareViews:tv1];
    [self prepareViews:tv2];
    [self prepareViews:tv3];
    [self prepareViews:tv4];
    [self prepareViews:tv5];
    
    [self.view bringSubviewToFront:tv1];
}


- (void) prepareViews:(UIView*)view
{
    NSArray* arr = view.subviews;
    
    for ( UIView* v in arr ) {
        if ( v.tag > 200 && v.tag < 300 ) {
            UIImageView* imageView = (UIImageView*) v;
            NSString* imageName = [NSString stringWithFormat:@"setup_step%d.png", v.tag - 200];
            imageView.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            if ( !isSetup ) {
                imageView.frame = CGRectMake(10, 10, 300, 338);
            }
        }
        else if ( v.tag > 300 && v.tag < 400 ) {
            UIButton* button = (UIButton*) v;
            [button setBackgroundImage:[[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8] forState:UIControlStateNormal];
            [button setTitle:@"继续" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [button setImage:[UIImage imageNamed:@"setup_rightarrow.png"] forState:UIControlStateNormal];
            
            button.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,30);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
            
            if ( button.tag == 305 ) {
                if ( isSetup ) {
                    [button addTarget:self action:@selector(installProfile) forControlEvents:UIControlEventTouchUpInside];
                }
                else {
                    [button setTitle:@"知道了" forState:UIControlStateNormal];
                    button.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
                    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    [button setImage:nil forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            else {
                [button addTarget:self action:@selector(viewTouchLeftSwipe:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if ( !isSetup ) {
                button.frame = CGRectMake(45, 364, 229, 42);
            }
        }
        else if ( v.tag == 405 ) {
            UILabel* label = (UILabel*) v;
            label.text = @"流量压缩仪已经开启";
        }
        else if ( v.tag == 505 ) {
            UILabel* label = (UILabel*) v;
            label.text = @"流量压缩仪已经开启，请您继续体验飞速流量压缩仪!";
        }
    }
    
    //呢一条线
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 243, 280, 2)];
    imageView.image = [[UIImage imageNamed:@"setup_line.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [view addSubview:imageView];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate getAppDelegate].customTabBar hiddenTabBar];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TouchedView Delegate

- (void) viewTouchLeftSwipe:(id)sender
{
    if ( index == 4 ) return;
    
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 0.35f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    index++;
    [self showView];
    
	[[self.view layer] addAnimation:animation forKey:@"animation"];
}


- (void) viewTouchRightSwipe:(id)sender
{
    if ( index == 0 ) return;
    
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 0.35f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    index--;
    [self showView];
    
	[[self.view layer] addAnimation:animation forKey:@"animation"];
}


- (void) showView
{
    if ( index == 0 ) {
        [self.view bringSubviewToFront:tv1];
    }
    else if ( index == 1 ) {
        [self.view bringSubviewToFront:tv2];
    }
    else if ( index == 2 ) {
        [self.view bringSubviewToFront:tv3];
    }
    else if ( index == 3 ) {
        [self.view bringSubviewToFront:tv4];
    }
    else if ( index == 4 ) {
        [self.view bringSubviewToFront:tv5];
    }
}


- (void) installProfile
{
//    [AppDelegate installProfile:nil apn:nil];
    
    [[AppDelegate getAppDelegate] performSelector:@selector(showInstallProfileView) withObject:nil afterDelay:0.3f];
    
//    for test
//    NSURL* url = [NSURL URLWithString:@"http://p.flashapp.cn/test.mobileconfig"];
//    [[UIApplication sharedApplication] openURL:url];
}


- (void) close
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
