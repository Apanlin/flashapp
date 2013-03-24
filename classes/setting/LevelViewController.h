//
//  LevelViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelViewController : UIViewController
{
    UIImageView* bgImageView1;
    UIImageView* bgImageView2;
    UIImageView* barBgImageView;
    UIImageView* barImageView;
    UIImageView* currImageView;
    UILabel* currLabel;
    UILabel* currUnitLabel;
    
    UILabel* label1;
    UILabel* label2;
    UILabel* label3;
    UIImageView* descImageView;
    BOOL showCloseButton;
    NSString* title;
}

@property (nonatomic, retain) IBOutlet UIImageView* bgImageView1;
@property (nonatomic, retain) IBOutlet UIImageView* bgImageView2;
@property (nonatomic, retain) IBOutlet UIImageView* barBgImageView;
@property (nonatomic, retain) IBOutlet UIImageView* barImageView;
@property (nonatomic, retain) IBOutlet UIImageView* currImageView;
@property (nonatomic, retain) IBOutlet UILabel* currLabel;
@property (nonatomic, retain) IBOutlet UILabel* currUnitLabel;
@property (nonatomic, retain) IBOutlet UILabel* label1;
@property (nonatomic, retain) IBOutlet UILabel* label2;
@property (nonatomic, retain) IBOutlet UILabel* label3;
@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, retain) IBOutlet UIImageView* descImageView;
@property (nonatomic, retain) NSString* title;

@end
