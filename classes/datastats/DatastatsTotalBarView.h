//
//  DatastatsBarView.h
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatastatsBarItem.h"

@interface DatastatsTotalBarView : UIView {

    DatastatsBarItem* item1;
    DatastatsBarItem* item2;
    
    UIImageView* imageView1;
    UIImageView* imageView2;
    UIImageView* triangleView;
    UIImageView* imageView1_d;
    UIImageView* imageView2_d;
    UILabel* descLabel1;
    UILabel* descLabel2;
    UILabel* numberLabel1;
    UILabel* numberLabel2;
    UILabel* unitLabel1;
    UILabel* unitLabel2;
    UIView* seperateView;
}

@property (nonatomic, retain) DatastatsBarItem* item1;
@property (nonatomic, retain) DatastatsBarItem* item2;

@end
