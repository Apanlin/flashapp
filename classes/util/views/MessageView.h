//
//  MessageView.h
//  flashapp
//
//  Created by 李 电森 on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchedView.h"

@interface MessageView : TouchedView
{
    UILabel* messageLabel;
    UIImageView* backgroudImageView;
    int messageType;
}


@property (nonatomic, assign) NSString* message;
@property (nonatomic, assign) int messageType;
@property (nonatomic, assign) UILabel* messageLabel;

- (void) setBackgroundImage:(UIImage*)image;

@end
