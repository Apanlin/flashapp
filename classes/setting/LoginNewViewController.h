//
//  LoginNewViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "AttributedButton.h"
#import "TwitterClient.h"
#import "LoadingView.h"

@interface LoginNewViewController : UIViewController <UITextFieldDelegate , TencentSessionDelegate>
{
    UIButton* sinaButton;
    UIButton* renrenButton;
    UIButton* qqButton;
    UIButton* baiduButton;
    AttributedButton* registerButton;
    AttributedButton* forgotPasswdButton;
    UIButton* loginButton;
    UIScrollView* scrollView;
    UIImageView* bgImageView;
    
    UITextField* phoneTextField;
    UITextField* passwordTextField;
    LoadingView* loadingView;
    
    TwitterClient* client;
    
    //第三方登陆类型
    NSString *thirdType;
    
}

@property (nonatomic, retain) IBOutlet UIButton* sinaButton;
@property (nonatomic, retain) IBOutlet UIButton* renrenButton;
@property (nonatomic, retain) IBOutlet UIButton* qqButton;
@property (nonatomic, retain) IBOutlet UIButton* baiduButton;


@end
