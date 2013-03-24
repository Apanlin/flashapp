//
//  TCAdjustViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTipView.h"
#import "TwitterClient.h"
#import "NumberKeypadDecimalPoint.h"

@interface TCAdjustViewController : UIViewController <UIAlertViewDelegate>
{
    UIImageView* bgImageView;
    UIImageView* bgImageView2;
    UIImageView* bgImageView3;
    UIButton* queryButton;
    ProfileTipView* messageView;
    
    UILabel* totalLabel;
    UILabel* dayLabel;
    UILabel* usedLabel;
    
    TwitterClient* client;
    NumberKeypadDecimalPoint* numberKeyboard;
    BOOL dirty;
    
    UILabel* totalLabelDesc;
    UILabel* dayLabelDesc;
    UILabel* usedLabelDesc;
    UILabel* adjustDescLabel;
    UILabel* dayUnitLabel;
    UISwitch* locationSwitch;
    UIImageView* locationIcon;
}


@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) IBOutlet UIImageView* bgImageView2;
@property (nonatomic, retain) IBOutlet UIImageView* bgImageView3;
@property (nonatomic, retain) IBOutlet UIButton* queryButton;
@property (nonatomic, retain) IBOutlet UILabel* totalLabel;
@property (nonatomic, retain) IBOutlet UILabel* dayLabel;
@property (nonatomic, retain) IBOutlet UILabel* usedLabel;
@property (nonatomic, retain) TwitterClient* client;
@property (nonatomic, retain) NumberKeypadDecimalPoint* numberKeyboard;
@property (nonatomic, retain) IBOutlet UILabel* totalLabelDesc;
@property (nonatomic, retain) IBOutlet UILabel* dayLabelDesc;
@property (nonatomic, retain) IBOutlet UILabel* usedLabelDesc;
@property (nonatomic, retain) IBOutlet UILabel* adjustDescLabel;
@property (nonatomic, retain) IBOutlet UILabel* dayUnitLabel;
@property (nonatomic, retain) IBOutlet UISwitch* locationSwitch;
@property (nonatomic, retain) IBOutlet UIImageView* locationIcon;

- (IBAction) adjust;
- (IBAction) setTotal;
- (IBAction) setDay;
- (IBAction) setUsed;
- (IBAction) locationSetting:(id)sender;

@end
