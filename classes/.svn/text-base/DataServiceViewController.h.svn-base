//
//  FirstViewController.h
//  flashapp
//
//  Created by 李 电森 on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "StageStats.h"
#import "UserAgentTotalStatsView.h"


@interface DataServiceViewController : UIViewController <UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>
{
    UIImageView *imageView; 
    IBOutlet UILabel* monthLable;
    IBOutlet UILabel* totalUseLable;
    IBOutlet UILabel* netLable;
    UIButton* upgradeButton;
    UIButton* sampleButton;
    UIButton* shareButton;
    UIButton* profileButton;
    
    UserAgentTotalStatsView* userAgentView1;
    UserAgentTotalStatsView* userAgentView2;
    UIView* userAgentBgView;
    NSInteger currentStatsViewIndex;
    NSInteger currentUserAgentIndex;
    
    StageStats* totalStats;
    StageStats* monthStats;
    NSArray* userAgentStatsList;
    
    NSTimer* timer;
    
    BOOL justLoaded;
    NSLock* refreshLock;
}


@property (nonatomic, retain) UILabel *monthLable;
@property (nonatomic, retain) UILabel *totalUseLable;
@property (nonatomic, retain) UILabel *netLable;
@property (nonatomic, retain) IBOutlet UIButton* upgradeButton;
@property (nonatomic, retain) IBOutlet UIButton* sampleButton;
@property (nonatomic, retain) IBOutlet UIButton* profileButton;
@property (nonatomic, retain) IBOutlet UIButton* shareButton;
@property (nonatomic, retain) IBOutlet UserAgentTotalStatsView* userAgentView1;
@property (nonatomic, retain) IBOutlet UserAgentTotalStatsView* userAgentView2;
@property (nonatomic, retain) IBOutlet UIView* userAgentBgView;

@property (nonatomic, retain) StageStats* totalStats;
@property (nonatomic, retain) StageStats* monthStats;
@property (nonatomic, retain) NSArray* userAgentStatsList;

- (void) showUserAgentStatsView;
- (void) showSample;
- (void) showConnectMessage;
- (void) viewShowData;

- (void) refresh:(BOOL)downFromServer;
-(void)drawLineStyle;
- (IBAction) shareToFriends;
- (IBAction) installProfile;
- (IBAction) upgrade;
- (IBAction) openSampleView;
- (void) animateUserAgentView;

- (void) sendSMS:(NSString*)body;
- (void) displaySMSComposerSheet:(NSString*)body;
- (void) sendMail:(NSString*)subject body:(NSString*)body;

@end
