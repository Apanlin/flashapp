//
//  InstallProfileViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstallProfileViewController : UIViewController
{
    UIView* bgView;
    UIButton* installAPNButton;
    UIButton* installVPNButton;
    
    UILabel* label1;
    UILabel* label2;
    UILabel* label3;
    UILabel* label4;
    UILabel* label5;
    UILabel* label6;
    UILabel* label7;
    UILabel* label8;
    UIButton* linkButton;
    UIImageView* imageView;
    
}

@property (nonatomic, retain) IBOutlet UIView* bgView;
@property (nonatomic, retain) IBOutlet UIButton* installAPNButton;
@property (nonatomic, retain) IBOutlet UIButton* installVPNButton;
@property (nonatomic, retain) IBOutlet UILabel* label1;
@property (nonatomic, retain) IBOutlet UILabel* label2;
@property (nonatomic, retain) IBOutlet UILabel* label3;
@property (nonatomic, retain) IBOutlet UILabel* label4;
@property (nonatomic, retain) IBOutlet UILabel* label5;
@property (nonatomic, retain) IBOutlet UILabel* label6;
@property (nonatomic, retain) IBOutlet UILabel* label7;
@property (nonatomic, retain) IBOutlet UILabel* label8;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIButton* linkButton;

- (IBAction) installAPNProfile:(id)sender;
- (IBAction) installVPNProfile:(id)sender;
- (IBAction) copyInstallURL:(id)sender;

@end
