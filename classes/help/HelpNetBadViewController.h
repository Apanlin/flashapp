//
//  HelpNetBadViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-7-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpItemView.h"

typedef enum {
    CONN_CHECK_BAD,
    CONN_CHECK_SLOW
} ConnectionCheckType;

@interface HelpNetBadViewController : UIViewController <UIAlertViewDelegate>
{
    HelpItemView* cellItem;
    HelpItemView* flashappItem;
    
    ConnectionCheckType checkType;
}

@property (nonatomic, assign) ConnectionCheckType checkType;

- (void) refreshProfileStatus;

@end
