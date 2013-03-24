//
//  ForgotPasswdViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "TwitterClient.h"

@interface ForgotPasswdViewController : UIViewController <UITextFieldDelegate>
{
    UIScrollView* scrollView;
    UIImageView* bgImageView;
    UITextField* phoneField;
    UITextField* codeField;
    UITextField* passwordField;
    UIButton* getCodeButton;
    UIButton* submitButton;
    
    UILabel* phoneLabel;
    UILabel* codeLabel;
    UILabel* passwordLabel;
    
    LoadingView* doingView;
    TwitterClient* client;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) IBOutlet UITextField* phoneField;
@property (nonatomic, retain) IBOutlet UITextField* codeField;
@property (nonatomic, retain) IBOutlet UITextField* passwordField;
@property (nonatomic, retain) IBOutlet UIButton* getCodeButton;
@property (nonatomic, retain) IBOutlet UIButton* submitButton;
@property (nonatomic, retain) IBOutlet UILabel* phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel* codeLabel;
@property (nonatomic, retain) IBOutlet UILabel* passwordLabel;

- (IBAction) submit:(id)sender;
- (IBAction) getCode:(id)sender;

@end
