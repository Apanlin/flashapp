//
//  DatastatsView.m
//  flashapp
//
//  Created by 李 电森 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsView.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "DateUtils.h"
#import "TCUtils.h"

@implementation DatastatsView

@synthesize startTime;
@synthesize endTime;
@synthesize currentStats;
@synthesize userAgentStats;
@synthesize viewcontroller;


#pragma mark - init & destroy

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        userAgentColors = [[NSArray alloc] initWithObjects:
         [UIColor colorWithRed:254.0f/255.0f green:227.0f/255.0f blue:4.0f/255.0f alpha:1.0f],
         [UIColor colorWithRed:237.0f/255.0f green:121.0f/255.0f blue:124.0f/255.0f alpha:1.0f],
         [UIColor colorWithRed:182.0f/255.0f green:140.0f/255.0f blue:197.0f/255.0f alpha:1.0f],
         [UIColor colorWithRed:136.0f/255.0f green:236.0f/255.0f blue:216.0f/255.0f alpha:1.0f],
         [UIColor colorWithRed:249.0f/255.0f green:183.0f/255.0f blue:212.0f/255.0f alpha:1.0f],
         [UIColor colorWithRed:125.0f/255.0f green:195.0f/255.0f blue:233.0f/255.0f alpha:1.0f],
         nil];

        //查看的日期显示
        sliderView = [[DatastatsMonthSliderView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
        [self addSubview:sliderView];

        //总的压缩的view
        totalView = [[DatastatsTotalView alloc] initWithFrame:CGRectMake(0, 38, 320, 149)];
        [totalView.shareButton addTarget:viewcontroller action:@selector(showShare) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:totalView];
        
        //label。text = 应用流量统计
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 187, 320, 30)];
        label.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
        label.text = NSLocalizedString(@"stats.application.static", nil);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        [self addSubview:label];
        [label release];
        
        //初始化每一个应用流量使用详情
        userAgentsView = [[DatastatsUserAgentsView alloc] initWithFrame:CGRectZero];
        userAgentsView.userAgentColors = userAgentColors;
        [self addSubview:userAgentsView];

        //流量使用比例图
        pieLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        pieLabel.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
        pieLabel.text = NSLocalizedString(@"stats.application.static.usedScale", nil);
        pieLabel.textColor = [UIColor whiteColor];
        pieLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:pieLabel];

        pieView = [[DatastatsPieView alloc] initWithFrame:CGRectZero];
        [self addSubview:pieView];

        //增加未处理流量的提示
        underProxyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        underProxyButton.frame = CGRectMake(177, 165, 130, 20);
        underProxyButton.backgroundColor = [UIColor clearColor];
        NSString *title = [NSString stringWithFormat:@"%@0m", NSLocalizedString(@"stats.unhandled.traffic", nil)];
        [underProxyButton setTitle:title forState:UIControlStateNormal];
        underProxyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [underProxyButton setImage:[UIImage imageNamed:@"downArrow.png"] forState:UIControlStateNormal];
        [underProxyButton addTarget:self action:@selector(showUnderProxyView) forControlEvents:UIControlEventTouchUpInside];
        
        UIEdgeInsets imageInsets;
        imageInsets.top = 4;
        imageInsets.left = 115;
        imageInsets.right = 0;
        imageInsets.bottom = 0;
        underProxyButton.imageEdgeInsets = imageInsets;
        
        UIEdgeInsets titleInsets;
        titleInsets.top = 2;
        titleInsets.left = -15;
        titleInsets.right = 10;
        titleInsets.bottom = 0;
        underProxyButton.titleEdgeInsets = titleInsets;
        [self addSubview:underProxyButton];
        
        //初始化未处理流量的页面
        [self preparedUnderProxyView];
        
        self.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
        
    }
    return self;
}


- (void) dealloc
{
    [sliderView release];
    [totalView release];
    [userAgentsView release];
    [pieLabel release];
    [pieView release];
    [userAgentStats release];
    [currentStats release];
    [userAgentColors release];
    [viewcontroller release];
    [super dealloc];
}


#pragma mark - geter & setter methods

- (void) setStartTime:(long)st
{
    userAgentsView.startTime = st;
    startTime = st;
}


- (void) setEndTime:(long)et
{
    userAgentsView.endTime = et;
    endTime = et;
}


#pragma mark - tool methods


- (void) setUserAgentStats:(NSArray *)arr
{
    [userAgentStats release];
    userAgentStats = [arr retain];
    userAgentsView.userAgentStats = arr;
}


- (void) show
{
    //sliderView.text = [DateUtils stringWithDateFormat:startTime format:@"YYYY年M月"];
    //NSString* start = [DateUtils stringWithDateFormat:startTime format:@"yyyy/MM/dd"];
    //NSString* end = [DateUtils stringWithDateFormat:endTime format:@"yyyy/MM/dd"];
    //sliderView.text = [NSString stringWithFormat:@"%@ - %@", start, end];
    
    //时间的view
    sliderView.text = [TCUtils monthDescForStartTime:startTime endTime:endTime];
    sliderView.delegate = viewcontroller;

    //设置总比咧图的分享 按钮是否显示
    totalView.stats = currentStats;
    if ( currentStats && userAgentStats && [userAgentStats count] > 0 ) {
        totalView.shareButton.hidden = NO;
    }
    else {
        totalView.shareButton.hidden = YES;
    }
 
    //设置流量统计详情的呢些view
    CGFloat height = [userAgentsView getHeight];
    CGFloat y = 38 + 149 + 30;
    userAgentsView.frame = CGRectMake( 5, y, 310, height );
    [userAgentsView setNeedsLayout];
    
    //设置 text ="流量使用比列图"  的位置
    y += height;
    pieLabel.frame = CGRectMake(0, y, 320, 38);
    
    //设置 比列图 图片的位置
    y += 38;
    pieView.userAgents = userAgentStats;
    pieView.frame = CGRectMake(5, y, 310, 160);

    if ( [userAgentStats count] > 0 ) {
        pieLabel.hidden = NO;
        pieView.hidden = NO;
    }
    else {
        pieLabel.hidden = YES;
        pieView.hidden = YES;
    }
    
    //未处理流量！
    UserSettings* user = [AppDelegate getAppDelegate].user;
    long used = [user getTcUsed];
    long underBytes = used - currentStats.bytesAfter;
    if ( underBytes <= 0 ) underBytes = 0;
    [underProxyButton setTitle:[NSString stringWithFormat:@"%@%.1fm", NSLocalizedString(@"stats.unhandled.traffic", nil),underBytes / 1024.0f / 1024.0f] forState:UIControlStateNormal];
}


- (void) refreshAppLockedStatus
{
    [userAgentsView refreshAppLockedStatus];
}


- (CGFloat) getHeight
{
    CGFloat height = 38 + 149 + 30 + [userAgentsView getHeight];
    if ( [userAgentStats count] > 0 ) {
        height += (38 + 165);
    }
    return height;
}


- (void) preparedUnderProxyView
{
    disableLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    disableLayerView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:0.8f];
    disableLayerView.hidden = YES;
    disableLayerView.userInteractionEnabled = NO;
    [self addSubview:disableLayerView];
    [disableLayerView release];
    
    NSArray* objs = [[NSBundle mainBundle] loadNibNamed:@"UnprocessFlowView" owner:self options:nil];
    underProxyView = (UIView*) [objs objectAtIndex:0];
    
    UIImageView* imageView = (UIImageView*) [underProxyView viewWithTag:101];
    imageView.image = [[UIImage imageNamed:@"unproxy_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    UIButton* button = (UIButton*) [underProxyView viewWithTag:102];
    [button setBackgroundImage:[[UIImage imageNamed:@"unproxy_button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:17] forState:UIControlStateNormal];
    [button setTitle:@"知道了" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hiddenUnderProxyView) forControlEvents:UIControlEventTouchUpInside];
    
    underProxyView.frame = CGRectMake( 30, 20, 260, 316);
    underProxyView.hidden = YES;
    [self addSubview:underProxyView];
}


- (void) showUnderProxyView
{
    UIScrollView* scrollview = (UIScrollView*) self.superview;
    CGPoint point = scrollview.contentOffset;
    disableLayerView.frame = CGRectMake(0, point.y, 320, 416);
    underProxyView.frame = CGRectMake(30, point.y + 20, 260, 316);
    
    disableLayerView.hidden = NO;
    underProxyView.hidden = NO;
    
    sliderView.userInteractionEnabled = NO;
    totalView.userInteractionEnabled = NO;
    scrollview.scrollEnabled = NO;
}

- (void) hiddenUnderProxyView
{
    disableLayerView.hidden = YES;
    underProxyView.hidden = YES;

    sliderView.userInteractionEnabled = YES;
    totalView.userInteractionEnabled = YES;

    UIScrollView* scrollview = (UIScrollView*) self.superview;
    scrollview.scrollEnabled = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
