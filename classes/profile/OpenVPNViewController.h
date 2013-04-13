//
//  OpenVPNViewController.h
//  flashapp
//
//  Created by Zhao Qi on 13-4-12.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenVPNViewController : UIViewController {
    UIButton* button;
    UIScrollView* scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIButton* button;

@end
