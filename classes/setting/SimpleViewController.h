//
//  SimpleViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchedView.h"

@interface SimpleViewController : UIViewController 
{
    UINavigationBar* navBar;
    
    TouchedView* touchedView;
    UIImageView* imageView;
    UIPageControl* pageControl;
    
    NSInteger index;
}


@property (nonatomic, retain) IBOutlet UINavigationBar* navBar;
@property (nonatomic, retain) IBOutlet TouchedView* touchedView;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

- (IBAction) close;
- (IBAction) pageClick:(id)sender;

@end
