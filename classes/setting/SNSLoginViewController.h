//
//  SNSLoginViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNSLoginViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView* webview;
    UILabel* label;
    UIActivityIndicatorView* indicator;
    
    NSString* domain;
}

@property (nonatomic, retain) IBOutlet UIWebView* webview;
@property (nonatomic, retain) IBOutlet UILabel* label;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;
@property (nonatomic, retain) NSString* domain;

@end
