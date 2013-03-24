//
//  FeedbackViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TwitterClient.h"

@interface FeedbackViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate> {
    UITextView* textView;
    UITextField* contactField;
    UIScrollView* scrollView;
    UIButton* submitButton;
    
    TwitterClient* client;
    
    BOOL showClose;
}


@property (nonatomic, retain) IBOutlet UITextView* textView;
@property (nonatomic, retain) IBOutlet UITextField* contactField;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIButton* submitButton;
@property (nonatomic, assign) BOOL showClose;

- (IBAction) save;

@end
