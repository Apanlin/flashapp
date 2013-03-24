//
//  DatastatsBarView.h
//  flashapp
//
//  Created by 李 电森 on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatastatsBarItem.h"

@interface DatastatsBarView : UIView {

    DatastatsBarItem* item1;
    DatastatsBarItem* item2;
    
    UIImageView* imageView1;
    UIImageView* imageView2;
    UIImageView* triangleView;
    UILabel* descLabel1;
    UILabel* descLabel2;
    UIView* seperateView;
}

@property (nonatomic, retain) DatastatsBarItem* item1;
@property (nonatomic, retain) DatastatsBarItem* item2;

@end
