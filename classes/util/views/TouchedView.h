//
//  TouchedLabel.h
//  flashapp
//
//  Created by 李 电森 on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchedView : UIView
{
    id delegate;
    
    CGPoint guestureStartPoint;
}


@property (nonatomic, retain) id delegate;

@end
