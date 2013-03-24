//
//  SetupViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-8-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchedView.h"

@interface SetupViewController : UIViewController
{
    NSInteger index;
    BOOL isSetup;
    
    TouchedView* tv1;
    TouchedView* tv2;
    TouchedView* tv3;
    TouchedView* tv4;
    TouchedView* tv5;
}

@property (nonatomic, assign) BOOL isSetup;

- (IBAction) close;

@end
