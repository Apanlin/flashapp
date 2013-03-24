//
//  AboutViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@interface AboutViewController : UIViewController
{
    UILabel* versionLabel;
    TwitterClient* client;
    
}

@property (nonatomic, retain) IBOutlet UILabel* versionLabel;

@end
