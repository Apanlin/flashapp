//
//  ImageCompressViewController.h
//  flashapp
//
//  Created by 朱广涛 on 13-5-22.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CAN_SAVE 110

#import "UserSettings.h"

@interface ImageCompressViewController : UIViewController<UIAlertViewDelegate>
{
    int qs ;
    int sel_btn_tag ;
    PictureQsLevel picLevel;
    CGPoint starPoint;
    CGPoint endPoint;
}
@property (retain, nonatomic) IBOutlet UIView *btnBgView;
@property (retain, nonatomic) IBOutlet UIImageView *compressImgView;
@property (retain, nonatomic) IBOutlet UIImageView *changeBlackLine;
@property (retain, nonatomic) IBOutlet UIImageView *changeGreenLine;

//button
@property (assign, nonatomic)UIButton *saveBtn;
@property (retain, nonatomic)UIBarButtonItem *rightBar;

@property (retain, nonatomic) IBOutlet UIButton *noCompressBtn;
@property (retain, nonatomic) IBOutlet UIButton *imgHeightBtn;
@property (retain, nonatomic) IBOutlet UIButton *imgMiddleBtn;
@property (retain, nonatomic) IBOutlet UIButton *imgLowBtn;

@end

