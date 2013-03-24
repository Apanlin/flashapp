//
//  LoginViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "TwitterClient.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UIScrollView* scrollView;
    UIView* loginView;
    UIView* registerView;
    UIImageView* loginImageView;
    UIImageView* registerImageView;
    UIButton* loginButton;
    UIButton* registerButton;
    UITextField* currentTextField;
    UIButton* loginSaveButton;
    UIButton* registerSaveButton;
    
    UIImageView* loginLineImageView;
    UIImageView* registerLineImageView;
    
    UITextField* loginPhoneField;
    UITextField* loginPasswdField;
    UITextField* registerPhoneField;
    UITextField* registerPasswdField;
    UITextField* registerNicknameField;
  
    UILabel* loginPhoneLabel;
    UILabel* loginPasswdLabel;
    UILabel* registerPhoneLabel;
    UILabel* registerPasswdLabel;
    UILabel* registerNicknameLabel;
    UIButton* forgetPassWdButton;
    
    LoadingView* loadingView;
    
    int tabNumber;
    TwitterClient* client;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView* loginView;
@property (nonatomic, retain) IBOutlet UIView* registerView;
@property (nonatomic, retain) IBOutlet UIImageView* loginImageView;
@property (nonatomic, retain) IBOutlet UIImageView* registerImageView;
@property (nonatomic, retain) IBOutlet UIButton* loginButton;
@property (nonatomic, retain) IBOutlet UIButton* registerButton;
@property (nonatomic, retain) IBOutlet UIButton* loginSaveButton;
@property (nonatomic, retain) IBOutlet UIButton* registerSaveButton;
@property (nonatomic, retain) IBOutlet UITextField* loginPhoneField;
@property (nonatomic, retain) IBOutlet UITextField* loginPasswdField;
@property (nonatomic, retain) IBOutlet UITextField* registerPhoneField;
@property (nonatomic, retain) IBOutlet UITextField* registerPasswdField;
@property (nonatomic, retain) IBOutlet UITextField* registerNicknameField;
@property (nonatomic, retain) IBOutlet UILabel* loginPhoneLabel;
@property (nonatomic, retain) IBOutlet UILabel* loginPasswdLabel;
@property (nonatomic, retain) IBOutlet UILabel* registerPhoneLabel;
@property (nonatomic, retain) IBOutlet UILabel* registerPasswdLabel;
@property (nonatomic, retain) IBOutlet UILabel* registerNicknameLabel;
@property (nonatomic, retain) IBOutlet UIButton* forgetPassWdButton;
@property (nonatomic, assign) int tabNumber;


- (IBAction) showLoginView:(id)sender;
- (IBAction) showRegisterView:(id)sender;
- (IBAction) login:(id)sender;
- (IBAction) forgotPassword:(id)sender;

@end
