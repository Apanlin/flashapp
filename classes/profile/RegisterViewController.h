//
//  RegisterViewController.h
//  flashapp
//
//  Created by 李 电森 on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate> {
    
    UITextField* phoneTextField;
    UITextField* passwordTextField;
    UIButton* getPasswdButton;
    UIScrollView* scrollView;
    
    TwitterClient* client;
    
    UILabel* label1;
    UILabel* label2;
    UILabel* label3;
    UILabel* label4;
    UILabel* label5;
    UILabel* label6;
    UILabel* label7;
    UILabel* label8;
    UIButton* registerButton;
    UIButton* skipButton;
    UIButton* getpasswdButton;
    
}

@property (nonatomic, retain) IBOutlet UITextField* phoneTextField;
@property (nonatomic, retain) IBOutlet UITextField* passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton* getPasswdButton;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UILabel* label1;
@property (nonatomic, retain) IBOutlet UILabel* label2;
@property (nonatomic, retain) IBOutlet UILabel* label3;
@property (nonatomic, retain) IBOutlet UILabel* label4;
@property (nonatomic, retain) IBOutlet UILabel* label5;
@property (nonatomic, retain) IBOutlet UILabel* label6;
@property (nonatomic, retain) IBOutlet UIButton* registerButton;
@property (nonatomic, retain) IBOutlet UIButton* skipButton;



- (IBAction) registerPhone;
- (IBAction) skip;
- (IBAction) getpassword:(id)sender;
- (IBAction) passwdFieldChanged;

@end
