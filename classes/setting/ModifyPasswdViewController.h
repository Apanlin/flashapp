//
//  ModifyPasswdViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface ModifyPasswdViewController : UIViewController
{
    UIImageView* bgImageView;
    UITextField* oldPasswordField;
    UITextField* newPasswordField;
    UIButton* saveButton;
    
    UILabel* oldPasswordLabel;
    UILabel* newPasswordLabel;
    
    LoadingView* loadingView;
}

@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) IBOutlet UITextField* oldPasswordField;
@property (nonatomic, retain) IBOutlet UITextField* newPasswordField;
@property (nonatomic, retain) IBOutlet UIButton* saveButton;
@property (nonatomic, retain) IBOutlet UILabel* oldPasswordLabel;
@property (nonatomic, retain) IBOutlet UILabel* newPasswordLabel;

- (IBAction) changePassword:(id)sender;

@end
