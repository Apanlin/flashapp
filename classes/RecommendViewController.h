//
//  RecommendViewController.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-18.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MyNetWorkClass.h"

@interface RecommendViewController : UIViewController<UIScrollViewDelegate ,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,retain) MyNetWorkClass *myNetWork;
@property (retain, nonatomic) IBOutlet UIView *sectionView;

@property (retain, nonatomic) IBOutlet UIView *bannerView;
@property (retain, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (retain, nonatomic) IBOutlet UIButton *jingpinBtn;
@property (retain, nonatomic) IBOutlet UIButton *xianmianBtn;
@property (retain, nonatomic) IBOutlet UIButton *gamesBtn;
@property (retain, nonatomic) IBOutlet UIPageControl *adPage;
@property (retain, nonatomic) IBOutlet UITableView *appTableView;
@property (nonatomic ,retain) IBOutlet UIImageView *xianMianRedDian;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *scrollActivity;
@property (nonatomic ,retain) IBOutlet UIImageView *gamesRedDian;

+(id)getRecommendViewController;

@end
