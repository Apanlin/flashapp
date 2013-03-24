//
//  MonthTotalCell.h
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthTotalCell : UITableViewCell 
{
    UILabel* headerLabel;
    UILabel* dataLabel;
    UILabel* unitLabel;
    
    long compressBytes;
}


@property (nonatomic, assign) long compressBytes;

@end
