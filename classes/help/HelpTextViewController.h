//
//  HelpTextViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-8-4.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpTextViewController : UIViewController
{
    UILabel* titleLabel;
    UILabel* textLabel;
    UIImageView* bgImageView;
    
    NSString* title;
    NSString* text;
}

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UILabel* textLabel;
@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) NSString* titleText;
@property (nonatomic, retain) NSString* answerText;

@end
