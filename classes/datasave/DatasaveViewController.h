//
//  DatasaveViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "EGORefreshTableHeaderView.h"
#import "MessageView.h"
#import "DatasaveDialView.h"
#import "ProfileTipView.h"
#import "LoadingView.h"
#import "TwitterClient.h"
#import "StageStats.h"
#import "CapacityAnimateView.h"

@interface DatasaveViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate> {
    UIScrollView* scrollView;
    UIView* contentView;
    UIImageView* inviteBgView;
    UIImageView* dataBgView;
    UIImageView* taocanBgView;
    UILabel* capacityLabel;
    UILabel* capacityUnitLabel;
    UILabel* balanceLabel;
    UILabel* balanceUnitLabel;
    
    DatasaveDialView* dialView;
    ProfileTipView* messageView;
    UIImageView* levelImageView;
    UILabel* levelLabel;
    UIButton* levelImageButton;
    
    UIImageView* nicknameView;
    UILabel* nicknameLabel;
    UIButton* regButton;
    CapacityAnimateView* caView;
    
    UILabel* taocanLabel;
    UILabel* taocanLabel2;
    UILabel* taocanLeftLabel;
    UILabel* taocanUnitLabel;
    UILabel* taocanUsedLabel;
    UILabel* taocanUsedUnitLabel;
    UIButton* taocanButton;
    UIButton* taocanAdjectButton;
    UIImageView* taocanBarBgImageView;
    UIImageView* taocanUsedBarImageView;
    UIImageView* taocanExceedBarImageView;
    UIImageView* taocanBarTriangleImageView;
    UILabel* taocanAxisLabel1;
    UILabel* taocanAxisLabel2;
    UILabel* taocanAxisLabel3;
    UILabel* taocanAxisLabel4;
    UILabel* taocanAxisLabel5;
    UILabel* taocanAxisUsedLabel;
    
    NSInteger currentStatsViewIndex;
    NSInteger currentUserAgentIndex;
    
    TwitterClient* twitterClient;
    StageStats* totalStats;
    StageStats* monthStats;
    StageStats* stepStats;
    NSArray* userAgentStatsList;
    
    NSTimer* timer;
    
    BOOL justLoaded;
    NSLock* refreshLock;

	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    //是否刚刚安装完profile
    BOOL installingProfile;
    
    UIButton* inviteUpButton;
    UIButton* inviteDownButton;
    
    LoadingView* loadingView;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView* contentView;
@property (nonatomic, retain) IBOutlet UIImageView* inviteBgView;
@property (nonatomic, retain) IBOutlet UIImageView* dataBgView;
@property (nonatomic, retain) IBOutlet UIImageView* taocanBgView;
@property (nonatomic, retain) IBOutlet UILabel* capacityLabel;
@property (nonatomic, retain) IBOutlet UILabel* capacityUnitLabel;
@property (nonatomic, retain) IBOutlet UILabel* balanceLabel;
@property (nonatomic, retain) IBOutlet UILabel* balanceUnitLabel;
@property (nonatomic, retain) IBOutlet UIImageView* levelImageView;
@property (nonatomic, retain) IBOutlet UIButton* levelImageButton;
@property (nonatomic, retain) IBOutlet UILabel* levelLabel;
@property (nonatomic, retain) IBOutlet UIImageView* nicknameView;
@property (nonatomic, retain) IBOutlet UILabel* nicknameLabel;
@property (nonatomic, retain) IBOutlet CapacityAnimateView* caView;
@property (nonatomic, retain) IBOutlet UIButton* regButton;
@property (nonatomic, retain) IBOutlet UILabel* taocanLabel;
@property (nonatomic, retain) IBOutlet UIButton* taocanButton;
@property (nonatomic, retain) IBOutlet UILabel* taocanLeftLabel;
@property (nonatomic, retain) IBOutlet UILabel* taocanUnitLabel;
@property (nonatomic, retain) IBOutlet UILabel* taocanUsedLabel;
@property (nonatomic, retain) IBOutlet UILabel* taocanUsedUnitLabel;
@property (nonatomic, retain) IBOutlet UIButton* taocanAdjectButton;
@property (nonatomic, retain) IBOutlet UILabel* taocanLabel2;
@property (nonatomic, retain) IBOutlet UIImageView* taocanBarBgImageView;
@property (nonatomic, retain) IBOutlet UIImageView* taocanUsedBarImageView;
@property (nonatomic, retain) IBOutlet UIImageView* taocanExceedBarImageView;
@property (nonatomic, retain) IBOutlet UIImageView* taocanBarTriangleImageView;

@property (nonatomic, retain) DatasaveDialView* dialView;

@property (nonatomic, retain) StageStats* totalStats;
@property (nonatomic, retain) StageStats* monthStats;
@property (nonatomic, retain) NSArray* userAgentStatsList;

@property (nonatomic, assign) BOOL installingProfile;

@property (nonatomic, retain) IBOutlet UIButton* inviteUpButton;
@property (nonatomic, retain) IBOutlet UIButton* inviteDownButton;

- (IBAction) inviteFriend;
- (IBAction) registerPhone;
- (IBAction) openTaocanSetting;
- (IBAction) showLevelDesc;
- (void) loadAndShowData;
- (void) checkProfile;

#ifdef MJOY_91_APPID
- (IBAction) showMjoy91OfferWall;
#endif

@end
