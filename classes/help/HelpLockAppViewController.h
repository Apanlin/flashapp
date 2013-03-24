//
//  HelpLockAppViewController.h
//  flashapp
//
//  Created by Zhao Qi on 12-10-27.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@interface HelpLockAppViewController : UIViewController <UIAlertViewDelegate>
{
    UIImageView* bgImageView;
    UIButton* resumeButton;
    
    TwitterClient* client;
}

@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) IBOutlet UIButton* resumeButton;

- (IBAction) unlockButtonClick;

@end
