//
//  DatastatsTotalView.h
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageStats.h"
#import "DatastatsTotalBarView.h"

@interface DatastatsTotalView : UIView
{
    StageStats* stats;
    
    UILabel* percentLabel;
    UILabel* jieshengLabel;
    DatastatsTotalBarView* barView;
    
    UIButton* shareButton;
}


@property (nonatomic, retain) StageStats* stats;
@property (nonatomic, assign) UIButton* shareButton;

@end
