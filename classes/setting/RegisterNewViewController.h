//
//  RegisterViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "LoadingView.h"

@interface RegisterNewViewController : UIViewController
{
    UIButton* registerButton;
    UITextField* registerPhoneField;
    UITextField* registerPasswdField;
    UITextField* registerNicknameField;
    LoadingView* loadingView;
    
    TwitterClient* client;
    BOOL showCloseButton;
}


@property (nonatomic, retain) IBOutlet UIButton* registerButton;
@property (nonatomic, retain) IBOutlet UITextField* registerPhoneField;
@property (nonatomic, retain) IBOutlet UITextField* registerPasswdField;
@property (nonatomic, retain) IBOutlet UITextField* registerNicknameField;
@property (nonatomic, assign) BOOL showCloseButton;

@end
