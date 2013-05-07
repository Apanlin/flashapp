//
//  WeiboViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboViewController : UIViewController 
{
    UIImageView* weiboImageView;
    UIButton* sinaButton;
    UIButton* qqButton;
    UILabel* weiboLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView* weiboImageView;
@property (nonatomic, retain) IBOutlet UIButton* sinaButton;
@property (nonatomic, retain) IBOutlet UIButton* qqButton;
@property (nonatomic, retain) IBOutlet UILabel* weiboLabel;
@property (retain, nonatomic) IBOutlet UIView *bgView;


- (IBAction) openSinaweibo:(id)sender;
- (IBAction) openQQweibo:(id)sender;

@end
