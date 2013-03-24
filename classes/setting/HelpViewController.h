//
//  HelpViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController <UIWebViewDelegate> {
    UIWebView* webView;
    UIActivityIndicatorView* indicator;
    UILabel* waitLabel;
    BOOL showCloseButton;
    BOOL loaded;
    
    NSString* page;
}


@property (nonatomic,retain) IBOutlet UIWebView* webView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* indicator;
@property (nonatomic,retain) IBOutlet UILabel* waitLabel;
@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, retain) NSString* page;
@property (nonatomic, assign) BOOL loaded;

@end
