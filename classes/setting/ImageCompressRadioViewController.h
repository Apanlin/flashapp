//
//  ImageCompressRadioViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-10-4.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSettings.h"


@interface ImageCompressRadioViewController : UIViewController
{
    UIImageView* leftTopLine;
    UIImageView* leftBottomLine;
    UIImageView* rightTopLine;
    UIImageView* rightBottomLine;
    UILabel* leftTopLabel;
    UILabel* leftBottomLabel;
    UILabel* rightTopLabel;
    UILabel* rightBottomLabel;
    UIImageView* knobImageView;
    UIImageView* picutureImageView;
    UILabel* radioLabel;
    
    PictureQsLevel picQsLevel;
    float knobButtonAngle;
}

@property (nonatomic, retain) IBOutlet UIImageView* leftTopLine;
@property (nonatomic, retain) IBOutlet UIImageView* leftBottomLine;
@property (nonatomic, retain) IBOutlet UIImageView* rightTopLine;
@property (nonatomic, retain) IBOutlet UIImageView* rightBottomLine;
@property (nonatomic, retain) IBOutlet UILabel* leftTopLabel;
@property (nonatomic, retain) IBOutlet UILabel* leftBottomLabel;
@property (nonatomic, retain) IBOutlet UILabel* rightTopLabel;
@property (nonatomic, retain) IBOutlet UILabel* rightBottomLabel;
@property (nonatomic, retain) IBOutlet UIImageView* knobImageView;
@property (nonatomic, retain) IBOutlet UIImageView* picutureImageView;
@property (nonatomic, retain) IBOutlet UILabel* radioLabel;

- (IBAction) knobClick:(id)sender;

@end
