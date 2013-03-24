//
//  MonthSliderView.h
//  flashapp
//
//  Created by 李 电森 on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LableView.h"

@interface DatastatsMonthSliderView : UIView {
    id delegate;
    UIButton* leftButton;
    UIButton* rightButton;
    UILabel* textLabel;
    
    UIActivityIndicatorView* activityView;
}


@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) NSString* text;

@end
