//
//  SettingViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@interface SettingViewController : UITableViewController <UIAlertViewDelegate>
{
    UISwitch* profileSwitcher;
    
    int lockedAppCount;
    TwitterClient* client;
}

- (void) showProfileStatusCell;

@end
