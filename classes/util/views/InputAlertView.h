//
//  InputAlertView.h
//  flashapp
//
//  Created by 李 电森 on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAlertView : UIAlertView 
{
    UITextField* textField;
}


@property (nonatomic, retain) UITextField* textField;

@end
