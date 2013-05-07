//
//  HelpCompressViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-8-4.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpCompressViewController : UIViewController
{
    UIImageView* iconImageView;
    UIActivityIndicatorView* indicatorView;
    UILabel* resultLabel;
    UIButton* openServiceButton;
    UIButton* feedbackButton;
    
    UIImageView* checkBgImageView;
    UIImageView* resultBgImageView;
}

@property (nonatomic, retain) IBOutlet UIImageView* iconImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicatorView;
@property (nonatomic, retain) IBOutlet UILabel* resultLabel;
@property (nonatomic, retain) IBOutlet UIButton* openServiceButton;
@property (nonatomic, retain) IBOutlet UIButton* feedbackButton;
@property (nonatomic, retain) IBOutlet UIImageView* checkBgImageView;
@property (nonatomic, retain) IBOutlet UIImageView* resultBgImageView;
@property (retain, nonatomic) IBOutlet UILabel *lianxiLabel;

- (void) check;

@end
