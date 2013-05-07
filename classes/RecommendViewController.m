//
//  RecommendViewController.m
//  flashapp
//
//  Created by 朱广涛 on 13-4-18.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "RecommendViewController.h"
#import "AppDelegate.h"
#import "MyNetWorkClass.h"
#import "BannerImageUtil.h"
#import "AppClass.h"
#import "AppDetailClass.h"
#import "ASIDownloadCache.h"
#import "DetailViewController.h"
#import "AppButton.h"

@interface RecommendViewController ()

@property (nonatomic ,retain)NSMutableArray *bannerArray;

@property (nonatomic ,retain)NSMutableArray *appArray;

@property (nonatomic ,retain)NSMutableDictionary *appImgDic;

@property (nonatomic ,assign)int currentCount;

@property (nonatomic ,assign)int currentPageforPage;

@property (nonatomic ,retain)NSTimer *timer;

@property (nonatomic , copy)NSString *cateids;

@property (nonatomic ,assign)int pages;

@property (nonatomic ,retain) NSMutableArray *requestArray;

@end

@implementation RecommendViewController
@synthesize adScrollView;
@synthesize jingpinBtn;
@synthesize xianmianBtn;
@synthesize gamesBtn;
@synthesize adPage;
@synthesize appTableView;
@synthesize myNetWork;
@synthesize bannerView;
@synthesize bannerArray;
@synthesize currentCount;
@synthesize timer;
@synthesize currentPageforPage;
@synthesize appArray;
@synthesize appImgDic;
@synthesize cateids;
@synthesize pages;
@synthesize xianMianRedDian;
@synthesize scrollActivity;
@synthesize gamesRedDian;
@synthesize requestArray;

- (void)dealloc {
    [adScrollView release];
    [jingpinBtn release];
    [xianmianBtn release];
    [gamesBtn release];
    [adPage release];
    [appTableView release];
    [bannerArray release];
    [appArray release];
    [appImgDic release];
    [cateids release];
    [bannerView release];
    [scrollActivity release];
    [requestArray release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAdScrollView:nil];
    [self setJingpinBtn:nil];
    [self setXianmianBtn:nil];
    [self setGamesBtn:nil];
    [self setAdPage:nil];
    [self setAppTableView:nil];
    [self setBannerView:nil];
    [self setScrollActivity:nil];
    
    if (timer) {
        [timer invalidate];
    }
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


+(id)getRecommendViewController
{
    static dispatch_once_t onceToken;
    static RecommendViewController *rvc;
    dispatch_once(&onceToken, ^{
       rvc =  [[RecommendViewController alloc] init];
    });
    return rvc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.appArray = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
        self.appImgDic = [[[NSMutableDictionary alloc] initWithCapacity:3] autorelease];
        self.requestArray = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //给banner 加点击手势，点击的时候进入appstore
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePressed)];
    [self.bannerView addGestureRecognizer:tapGR];
    [tapGR release];
    
    myNetWork = [MyNetWorkClass getMyNetWork];
    
    self.navigationController.navigationBar.tintColor =[UIColor blackColor];
    
    self.navigationItem.title = @"应用推荐";

    
    [self.scrollActivity startAnimating];
    
    self.adScrollView.delegate = self;
    self.appTableView.delegate = self;
    self.appTableView.dataSource = self;
    self.appTableView.backgroundColor = RGB(48, 48, 50);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 32);
    [btn setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"appBackBtn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    self.appTableView.tableHeaderView = bannerView;
    
    self.bannerView.userInteractionEnabled = NO;
    
    [self jingpinBtnPressed:jingpinBtn];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bannerimageutil"];
    
    //请求scrollView 的图片
    if (![bannerArray count]) {
        [myNetWork startBannerRequestWithCompletion:^(NSDictionary *request) {
//            NSLog(@"request is :%@",request);
            [[BannerImageUtil getBanerImageUtil] setTimeStamp:[[request objectForKey:@"cp"] integerValue]];
            self.bannerArray =[request objectForKey:@"banner"];
            currentCount = [bannerArray count];
            if (self.bannerArray) {
                [self initScrollView];
                [self setBannerImage];
            }
        }];
    }
    
    BOOL xsmf = [[NSUserDefaults standardUserDefaults] boolForKey:XSMF_APP];
    BOOL rmyx = [[NSUserDefaults standardUserDefaults] boolForKey:RMYX_APP];

    if (xsmf) {
        xianMianRedDian.hidden = NO;
    }else{
        xianMianRedDian.hidden = YES;
    }
    if (rmyx) {
        gamesRedDian.hidden  = NO ;
    }else{
        gamesRedDian.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i = 0 ;  i < [requestArray count ]; i++) {
       ASIHTTPRequest *request = [requestArray objectAtIndex:i];
        [request clearDelegatesAndCancel];
    }
}

#pragma mark -- timer method
-(void)scrollViewAnimate:(NSTimer *)timer
{
    CGSize scrollsize = self.adScrollView.frame.size;
    if (currentPageforPage > [bannerArray count]) {
        currentPageforPage = 0 ;
        adPage.currentPage = currentPageforPage;
        CGRect rect =CGRectMake(scrollsize.width*currentPageforPage, 0, scrollsize.width, scrollsize.height);
        [self.adScrollView scrollRectToVisible:rect animated:YES];
    }else{
        adPage.currentPage = currentPageforPage;
        CGRect rect = CGRectMake(scrollsize.width*currentPageforPage, 0, scrollsize.width, scrollsize.height);
        [self.adScrollView scrollRectToVisible:rect animated:YES];
    }
    currentPageforPage ++;
}

#pragma mark -- request delegate method
-(void)changeBannerImg:(ASIHTTPRequest *)request
{
    UIImageView *imgView = (UIImageView *)[adScrollView viewWithTag:currentCount];
    imgView.image =  [UIImage imageWithData:[request responseData]];
    if (currentCount -1 < 0) { 
//        currentCount -- ;
        return;
    }
    [[BannerImageUtil getBanerImageUtil] saveBannerImage:[request responseData] andLink:[[bannerArray objectAtIndex:currentCount -1 ] objectForKey:@"link"]];
    
    if(currentCount - 2 < 0){// 说明是最后一张
        
        //定时器
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewAnimate:) userInfo:nil repeats:YES];
        
        //设置可以和用户交互
        bannerView.userInteractionEnabled = YES;
        
        //暂停滚动，影藏它
        [scrollActivity stopAnimating];
        scrollActivity.hidden = YES;
        
        //请求玩最后一张的时候在出现滑动的情况
        currentPageforPage = 0 ;
        self.adPage.numberOfPages = [bannerArray count];
        self.adPage.currentPage = currentPageforPage;

        //currentCount == 0 
        currentCount -- ;
        return;
    }
    
    [self startImgRequestWithURL:[[bannerArray objectAtIndex:currentCount-2] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg:)];
    currentCount--;
}

-(void)requestAppImg:(ASIHTTPRequest *)request
{
    
}

#pragma mark -- self method
-(void)initScrollView
{
    for (UIView *view in [adScrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = [bannerArray count] - 1; i>=0; i--) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 105)];
        img.tag = i+1; //后面用 currentCount 来获得 bannerArray 的 值
        [adScrollView addSubview:img];
        [img release];
    }
    
    self.adScrollView.contentSize = CGSizeMake(320*[bannerArray count], 105);
}

-(void)setBannerImage
{
    [self startImgRequestWithURL:[[bannerArray lastObject] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg:)];
}

-(void)startImgRequestWithURL:(NSString *)url FinishMethod:(SEL)sel
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDidFinishSelector:sel];
    request.delegate = self;
    [request startAsynchronous];
//    [requestArray addObject:request];
}

-(void)insertAppClaaWithAppArray:(NSDictionary *)result
{
    NSLog(@"result is %@",result);
    NSArray *array = [result objectForKey:@"apps"];
    for (int i = 0 ; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        AppClass *appClass = [[AppClass alloc] init];
        appClass.appID = [dic objectForKey:@"apid"];
        appClass.appName = [dic objectForKey:@"apname"];
        appClass.appdesc = [dic objectForKey:@"apdesc"];
        appClass.apprkm = [dic objectForKey:@"rkm"];
        appClass.appPicSize = [dic objectForKey:@"picslen"];
        appClass.appStar = [[dic objectForKey:@"star"] integerValue];
        appClass.appSize = [dic objectForKey:@"fsize"];
        appClass.appIcon = [dic objectForKey:@"icon"];
        appClass.appLink = [dic objectForKey:@"link"];
        appClass.appOprice = [dic objectForKey:@"oprice"];
        appClass.appCprice = [dic objectForKey:@"cprice"];
        appClass.appLimfree = [dic objectForKey:@"limfree"];
        [appArray addObject:appClass];
        [appClass release];
    }
}

#pragma mark ----------- 按钮

-(void)gesturePressed
{
    NSString *urlStr = [[bannerArray objectAtIndex:self.adPage.currentPage] objectForKey:@"link"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (IBAction)jingpinBtnPressed:(id)sender
{
    self.jingpinBtn.enabled = NO;
    self.xianmianBtn.enabled = YES;
    self.gamesBtn.enabled = YES;
    [appArray removeAllObjects];
    [appTableView reloadData];
    [myNetWork startAppsRequestCateid:@"1" Page:@"0" completion:^(NSDictionary *result) {
//        NSLog(@"request is %@", result);
        [self insertAppClaaWithAppArray:result];
        self.cateids = [result objectForKey:@"cateid"];
        self.pages = [[result objectForKey:@"page"] intValue];
     [appTableView reloadData];
    }];

}

- (IBAction)xianmianBtnPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setDouble:NO forKey:XSMF_APP];
    
    self.xianMianRedDian.hidden =YES;
    
    self.jingpinBtn.enabled = YES;
    self.xianmianBtn.enabled = NO;
    self.gamesBtn.enabled = YES;
    [appArray removeAllObjects];
    [appTableView reloadData];
    [myNetWork startAppsRequestCateid:@"2" Page:@"0" completion:^(NSDictionary *result) {
        [self insertAppClaaWithAppArray:result];
        self.cateids = [result objectForKey:@"cateid"];
        self.pages = [[result objectForKey:@"page"] intValue];
        [appTableView reloadData];
    }];
}

- (IBAction)gamesBtnPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setDouble:NO forKey:RMYX_APP];

    self.gamesRedDian.hidden = YES;
    
    self.jingpinBtn.enabled = YES;
    self.xianmianBtn.enabled = YES;
    self.gamesBtn.enabled = NO;
    [appArray removeAllObjects];
    [appTableView reloadData];
    [myNetWork startAppsRequestCateid:@"3" Page:@"0" completion:^(NSDictionary *result) {
        [self insertAppClaaWithAppArray:result];
        self.cateids = [result objectForKey:@"cateid"];
        self.pages = [[result objectForKey:@"page"] intValue];
        [appTableView reloadData];
    } ];
}

-(void)loadMoreApp:(UIButton *)sender
{
    sender.enabled = NO;
    [sender setTitle:@"正在加载请稍后..." forState:UIControlStateDisabled];
    
    [myNetWork startAppsRequestCateid:cateids Page:[NSString stringWithFormat:@"%d",pages] completion:^(NSDictionary * result) {
//        int beforeCount = [appArray count];
        [self insertAppClaaWithAppArray:result];
//        int afterCount = [appArray count];
//        NSMutableArray *indexPathArray = [NSMutableArray array];
//        for (int i = beforeCount; i < afterCount ; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [indexPathArray addObject:indexPath];
//        }
//        [appTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        self.cateids = [result objectForKey:@"cateid"];
        self.pages = [[result objectForKey:@"page"] intValue];
        [appTableView reloadData];
    }];
}

-(void)buyBtn:(AppButton *)sender
{
    
//    NSLog(@"appClass.appLink is %@",sender.appLink);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sender.appLink]];
}

#pragma mark -- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([appArray count]) {
        return [appArray count]+1;
    }else{
        return [appArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *moreBtnCell = @"morecell";
    NSString *appCell = @"Identifier";
    
    if ([appArray count] == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreBtnCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreBtnCell] autorelease];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //添加cell后面的线
        UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_line.png"]];
        lineView.frame = CGRectMake(0, 65, 320, 1);
        [cell.contentView addSubview:lineView];
        [lineView release];

        UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.tag=110;
        moreBtn.frame=CGRectMake(23, 6, 274, 53);
        [moreBtn addTarget:self action:@selector(loadMoreApp:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.enabled=YES;
        [[moreBtn titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [moreBtn setTitle:@"点击加载更多..." forState:UIControlStateNormal];
        UIImage*image=[UIImage imageNamed:@"app_more_btn.png"];
        [moreBtn setBackgroundImage:image forState:UIControlStateNormal];
        [cell.contentView addSubview:moreBtn];
        
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:appCell];
        
        AppClass *appClass = [appArray objectAtIndex:indexPath.row];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appCell];
            
            //添加cell后面的线
            UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_line.png"]];
            lineView.frame = CGRectMake(0, 64, 320, 1);
            [cell.contentView addSubview:lineView];
            [lineView release];
        
            //应用的图片
            UIImageView *appImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 55, 55)];
            appImg.tag = 101;
            appImg.image = [UIImage imageNamed:@"tuijian_loading.png"];
            [cell.contentView addSubview:appImg];
            [appImg release];
            
            //添加应用图片的边框
            UIImageView *bkImg =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appKuang.png"]];
            bkImg.frame = CGRectMake(5, 5, 55, 55);
            [cell.contentView addSubview:bkImg];
            [bkImg release];
        
            //应用名称
            UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 150, 25)];
            appNameLabel.tag = 102;
            appNameLabel.backgroundColor = [UIColor clearColor];
            appNameLabel.textColor = [UIColor whiteColor];
            appNameLabel.numberOfLines = 2;
            [cell.contentView addSubview:appNameLabel];
            [appNameLabel release];
        
            //应用大小
            UILabel *appSizeLabel =[[UILabel alloc] initWithFrame:CGRectMake(160, 52, 42, 21)];
            appSizeLabel.tag = 103;
            appSizeLabel.textColor = [UIColor grayColor];
            appSizeLabel.font = [UIFont systemFontOfSize:11];
            appSizeLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:appSizeLabel];
            [appSizeLabel release];
        
        
            //添加星星
            for (int i = 0 ; i < 5 ; i++) {
                UIImageView *starImg =[[ UIImageView alloc] init];
                starImg.tag = 110 +i ;
                starImg.frame = CGRectMake(65+(15*i), 38, 15, 15);
                [cell.contentView addSubview:starImg];
                [starImg release];
            }
            int quan =appClass.appStar / 2;
            int ban = appClass.appStar % 2;
        
            for (int i = 0 ; i<quan ; i++) {
                UIImageView *quanImg = (UIImageView *)[cell.contentView viewWithTag:110+i];
                quanImg.image = [UIImage imageNamed:@"quanxing.png"];
            }
        
            UIImageView *banImage = (UIImageView *)[cell.contentView viewWithTag:110+quan];
            banImage.image = [UIImage imageNamed:@"banxing.png"];
        
            for (int i = quan + ban ; i < 5; i++) {
                UIImageView *wuImage = (UIImageView *)[cell.contentView viewWithTag:110+quan+ban];
                wuImage.image = [UIImage imageNamed:@"meixing.png"];
            }
            
            //添加安装 Button
            AppButton *btn = [AppButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(253, 17.5, 55, 30);
            btn.tag = 104 ;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setBackgroundImage:[UIImage imageNamed:@"appAnniu.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
        
        UIImageView *appImg = (UIImageView *)[cell.contentView viewWithTag:101];
        NSData *imgDate = [appImgDic objectForKey:appClass.appIcon];
        if (!imgDate) {
            UIImage *img=[UIImage imageNamed:@"tuijian_loading.png"];
            appImg.image = img;
            ASIHTTPRequest *imgReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:appClass.appIcon]];           
            [imgReq setCompletionBlock:^{
                NSData *data = [imgReq responseData];
                [appImgDic setObject:data forKey:[[imgReq url] absoluteString]];
                [appTableView reloadData];
            }];
            [imgReq startAsynchronous];
            [requestArray addObject:imgReq];
        }else{
            appImg.image = [UIImage imageWithData:imgDate];
        }
        
        UILabel *appNameLabel = (UILabel *)[cell.contentView viewWithTag:102];
        appNameLabel.text = appClass.appName;
        
        UILabel *appSizeLabel = (UILabel *)[cell.contentView viewWithTag:103];
        appSizeLabel.text = appClass.appSize;
        
        AppButton *btn = (AppButton *)[cell.contentView viewWithTag:104];
        [btn setTitle:@"免费" forState:UIControlStateNormal];
        if (![appClass.appOprice isEqualToString:@"0.00000"]) {
            [btn setTitle:[NSString stringWithFormat:@"￥%.2f",[appClass.appOprice floatValue]] forState:UIControlStateNormal];
        }
        btn.appID = appClass.appID;
        btn.appLink = appClass.appLink;
        btn.appOprice = appClass.appOprice;

       
        return cell;
    }
    
}

#pragma mark -- tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppClass *appClass = [appArray objectAtIndex:indexPath.row];
    AppDetailClass *detailClass = [AppDetailClass getAppDetailClass];
    detailClass.apid = appClass.appID;
    detailClass.apname = appClass.appName;
    detailClass.apdesc = @"";
    detailClass.rkm = appClass.apprkm; 
//    detailClass.rkm = @"我是推荐理由哦";
    detailClass.picslen = appClass.appPicSize;
//    detailClass.picslen = @"(3.5MB)";
    detailClass.star = appClass.appStar;
    detailClass.fsize = appClass.appSize;
    detailClass.icon = appClass.appIcon;
    detailClass.link = appClass.appLink;
    detailClass.oprice = appClass.appOprice;
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.appImgDic = self.appImgDic;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([appArray count] == indexPath.row) {
//        return nil;
//    }
//    return indexPath;
//}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section == 0 ) {
        
        return 38;
    }
    return 0;
}
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  _sectionView;
}

#pragma mark -- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.adScrollView.frame.size.width;
    int page = floor((self.adScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    adPage.currentPage = page;
    currentPageforPage += page;
}

#pragma mark -- ASIHttpRequest Delegate


-(void)close
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
