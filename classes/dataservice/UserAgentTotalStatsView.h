//
//  UserAgentTotalStatsView.h
//  flashapp
//
//  Created by 李 电森 on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsDetail.h"

@interface UserAgentTotalStatsView : UIView
{
    UIImageView* iconImageView;
    UILabel* titleLabel;
    UILabel* percentLabel;
    UILabel* descLabel;
    UIButton* detailButton;
    
    StatsDetail* stats;
}


@property (nonatomic, assign) StatsDetail* stats;

@end
