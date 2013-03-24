//
//  TCPhoneViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@interface TCPhoneViewController : UIViewController
{
    UITextField* phoneTextField;
    UIButton* button;
    UIImageView* bgImageView;
    UILabel* phoneLabel;
    
    TwitterClient* client;
}

@property (nonatomic, retain) IBOutlet UITextField* phoneTextField;
@property (nonatomic, retain) IBOutlet UIButton* button;
@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) IBOutlet UILabel* phoneLabel;

- (IBAction) save;

@end
