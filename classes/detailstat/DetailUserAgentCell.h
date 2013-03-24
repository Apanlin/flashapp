//
//  DetailUserAgentCell.h
//  flashapp
//
//  Created by 李 电森 on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionBarView.h"
#import "StatsDetail.h"

@interface DetailUserAgentCell : UITableViewCell {
    
    UIImageView* iconImage;
    UILabel* userAgentLabel;
    UILabel* percentLabel;
    UILabel* dataLabel;
    SectionBarView* barView;
    
    StatsDetail* stats;
}


@property (nonatomic, retain) StatsDetail* stats;

@end
