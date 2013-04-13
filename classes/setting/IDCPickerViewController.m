//
//  IDCPickerViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <sys/timeb.h>
#import "IDCPickerViewController.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "StringUtil.h"

#define TAG_NAMELABEL 101
#define TAG_SPEEDLABEL 102
#define TAG_INDICATOR 103
#define TAG_SELECTRADIO 104

@interface IDCPickerViewController ()

@end

@implementation IDCPickerViewController


#pragma mark - init & destroy

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [idcArray release];
    [speedDic release];
    [idcOrderArray release];
    [items release];
    [children release];
    if ( queue ) {
        [queue cancelAllOperations];
        [queue release];
    }
    
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:47.0f/255.0f blue:47.0f/255.0f alpha:1.0f];
    self.navigationItem.title = NSLocalizedString(@"set.IDCView.navItem.title", nil);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"saveName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClick:)] autorelease];
    
    self.tableView.separatorColor = [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0f];
    self.view.backgroundColor = [UIColor colorWithRed:40.0/255 green:40.0/255 blue:40.0/255 alpha:1.0f];
    self.tableView.backgroundView = nil;
    
    //初始化变量
    children = [[NSMutableArray array]retain];
    selectedIDC = nil;
    [self loadData]; //加载速度
    //  [self ping];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [idcArray release];
    idcArray = nil;
    
    [idcOrderArray release];
    idcOrderArray = nil;
    
    [items release];
    items = nil;
    
    [children release];
    children = nil;
    [speedDic release];
    speedDic = nil;
    
    if ( queue ) {
        [queue cancelAllOperations];
        [queue release];
        queue = nil;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int count = [items count];
    return  count ;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 95;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 55;
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 95)] autorelease];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 60)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 100;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.text = NSLocalizedString(@"set.IDCView.header.message", nil);
    [view addSubview:label];
    [label release];
    
    return view;
}


- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)] autorelease];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 100, 20, 120, 35);
    [button setBackgroundImage:[[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"set.IDCView.footerButton.title", nil) forState:UIControlStateNormal];
    //[button setTitle:@"正在加载" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(ping) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor* bgColor = [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:1.0f];
    UIColor* textColor = [UIColor whiteColor];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"idcCell"];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idcCell"] autorelease];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 31, 20)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = TAG_SPEEDLABEL;
        imageView.hidden = YES;
        [cell.contentView addSubview:imageView];
        [imageView release];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 20, 20)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = TAG_INDICATOR;
        imageView.hidden = YES;
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
        label.textColor = textColor;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.tag = TAG_NAMELABEL;
        [cell.contentView addSubview:label];
        [label release];
        
        UIButton *checkbox = [[UIButton alloc]initWithFrame: CGRectMake(260,5,30,30)]; //单选框按钮
        [checkbox setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
        [checkbox setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
        checkbox.tag = TAG_SELECTRADIO;
        checkbox.userInteractionEnabled = NO;
//        [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:checkbox];
        [checkbox release];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel* nameLabel = (UILabel*) [cell.contentView viewWithTag:TAG_NAMELABEL];
    UIImageView* speedImage = (UIImageView*) [cell.contentView viewWithTag:TAG_SPEEDLABEL];
    UIImageView* indicatorImage = (UIImageView*) [cell.contentView viewWithTag:TAG_INDICATOR];
    UIButton* selectButton = (UIButton*)[cell.contentView viewWithTag:TAG_SELECTRADIO];
    
    selectButton.selected = NO;
    NSInteger rowNum = indexPath.row;
    IDCInfo* idc = [idcArray objectAtIndex:rowNum];
    nameLabel.text = idc.name;
    
    NSNumber* number = [speedDic objectForKey:idc.code];
    if ( number && number.intValue >= 0 ) {
         UIImage *image = [UIImage imageNamed:@"signal-4.png"];
        int speedNumber = [number intValue];
        if(speedNumber < 1000){
            image = [UIImage imageNamed:@"signal-3.png"];
        }
        speedImage.image = image;
        speedImage.hidden = NO;
        indicatorImage.hidden = YES;
    }
    else if ( number && number.intValue == -1 ) {
        UIImage *image = [UIImage imageNamed:@"signal-load.png"];
        indicatorImage.image = image;
        indicatorImage.hidden = NO;
        speedImage.hidden = YES;
    }
    else {
        speedImage.hidden = YES;
        speedImage.hidden = YES;
    }
        
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    if ( selectedIDC ) {
        if ( [selectedIDC.code isEqualToString:idc.code] ) {
            selectButton.selected = YES;
        }
        else {
            selectButton.selected = NO;
        }
    }
    else {
        if ( [idc.code compare:user.idcCode] == NSOrderedSame ) {
            selectedIDC = idc;
            selectButton.selected = YES;
        }
        else {
            selectButton.selected = NO;
        }
    }
    
    cell.backgroundColor = bgColor;
    return cell;
}



#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIDC = [idcArray objectAtIndex:indexPath.row];
    
    NSArray* cells = [tableView visibleCells];
    for ( UITableViewCell* cell in cells ) {
        UIButton* radio = (UIButton*) [cell.contentView viewWithTag:TAG_SELECTRADIO];
        radio.selected = NO;
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton* radio = (UIButton*) [cell.contentView viewWithTag:TAG_SELECTRADIO];
    radio.selected = YES;
    
    //    IDCInfo* idc = [idcArray objectAtIndex:indexPath.row];
    //    UserSettings* user = [AppDelegate getAppDelegate].user;
    //    if ( [idc.host compare:user.idcServer] == NSOrderedSame ) return;
    //
    //    selectedRow = indexPath.row;
    //    NSString* message = [NSString stringWithFormat:@"您是否将上网代理更换到“%@”?", idc.name];
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"确定", nil];
    //    [alertView show];
    //    [alertView release];
}

/*
 点击保存后触发该动作
 */
-(void)saveButtonClick:(id)sender
{
    if ( selectedIDC ) {
        NSString* message = [NSString stringWithFormat:@"%@“%@”?", NSLocalizedString(@"set.IDCView.saveButton.message",nil),selectedIDC.name];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"promptName", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"giveUpName", nil) otherButtonTitles:NSLocalizedString(@"defineName", nil), nil];
        [alertView show];
        [alertView release];
    }
}


//添加数据到列表:
-(void) appendTableWith:(NSMutableArray *)data
{
    
    [self.tableView beginUpdates];
    for (int i=0;i<[data count];i++) {
        [items addObject:[data objectAtIndex:i]];
    }
    
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[items indexOfObject:[data objectAtIndex:ind]] inSection:0];
        
        [insertIndexPaths addObject:newPath];
    }
    if(insertIndexPaths.count > 0){
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
    
}

/*
 机房数据都加载完成后，进行按照速度的降序排序
 */
-(void) sortTable
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"speed" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [idcOrderArray allValues];;
    
    [idcArray release];
    idcArray = nil;
    idcArray = [[sortedArray sortedArrayUsingDescriptors:sortDescriptors]retain];
    
    //[sortedArray release];
    [sortDescriptors release];
    [sorter release];
    
    children = nil;
    [children release];
    children = [[NSMutableArray array]retain];
    
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:YES];
}


- (void) refreshTable
{
    [self.tableView reloadData];
}


#pragma mark - load Data

- (void) loadData
{
    if ( !idcOrderArray ) {
        [idcOrderArray release];
        idcOrderArray = [[NSMutableDictionary alloc] init];
    }
    
    [idcOrderArray removeAllObjects];
    items = [[NSMutableArray array]retain];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] != NotReachable ) {
        if ( client ) return;
        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetIDCList:obj:)];
        [client getIDCList];
    }
    else {
        NSString* s = user.idcList;
        if ( s ) {
            idcArray = [[user idcArray] retain];
        }
    }
}


- (void) didGetIDCList:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    
    if ( tc.hasError ) return;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* s = [obj JSONRepresentation];
    user.idcList = s;
    [UserSettings saveUserSettings:user];
    idcArray = [[user idcArray] retain];
    [self ping];
    
    // [self.tableView reloadData];
}


- (void) initSpeedDic
{
    if ( !speedDic ) {
        speedDic = [[NSMutableDictionary alloc] init];
    }
    
    [speedDic removeAllObjects];
    for ( IDCInfo* info in idcArray ) {
        [speedDic setObject:[NSNumber numberWithInt:-1] forKey:info.code];
    }
}


#pragma mark - network speed methods

- (void) ping
{
    items = nil;
    [items release];
    items = [[NSMutableArray array]retain];
    
    children = nil;
    [children release];
    children = [[NSMutableArray array]retain];
    
    [self initSpeedDic];
    [self.tableView reloadData];
    
    if ( !queue ) {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
    }
    else {
        [queue cancelAllOperations];
    }
    
    idcCount = 0;
    
    if ( !idcOrderArray ) {
        [idcOrderArray release];
        idcOrderArray = [[NSMutableDictionary alloc] init];
    }
    
    [idcOrderArray removeAllObjects];
    
    
    for ( IDCInfo* idc in idcArray ) {
        
        NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(connectToHost:) object:idc];
        [queue addOperation:operation];
        
        
        NSMutableArray *more = [NSMutableArray array];
        [more addObject:idc];
        
        // [idcOrderArray addObject:idc]; //机房算出速度后，放进新数组中
        [idcOrderArray setObject:idc forKey:idc.code];
        
        //单个加载数据
        [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:YES];
        
    }
    //  [self sortTable];
    
    
}


- (void) connectToHost:(IDCInfo*)idc
{
    
    long long totalTime = 0;
    int totalLen = 0;
    
    for ( int i=0; i<3; i++ ) {
        long long time1 = [self currentTime];
        NSString* s = [TFConnection httpGet:idc.host port:80 location:@"/speed.txt"];
        //NSString* s = [TFConnection httpGet:@"www.flashapp.cn" port:80 location:@"/"];
        long long time2 = [self currentTime];
        
        if ( time2 > time1 && s ) {
            totalTime += (time2 - time1);
            totalLen += s.length;
        }
    }
    
    float speed = 0;
    if ( totalTime > 0 ) {
        speed = 1000.0f * totalLen / totalTime;
    }
    
    idc.speed = speed;
    [speedDic setObject:[NSNumber numberWithInt:(int)speed] forKey:idc.code];
    NSLog(@"test %@ OK, speed:%f", idc.name, speed);
    idcCount ++;
    [idcOrderArray setObject:idc forKey:idc.code];
    
    // [idcOrderArray addObject:idc]; //机房算出速度后，放进新数组中
    
    //    if(idcCount == idcArray.count){
    //        //[self sortTable];
    //        [button setTitle:@"重新测速" forState:UIControlStateNormal];
    //    }
    
    [self sortTable];
    //     [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:YES];
}




- (long long) currentTime
{
    struct timeb t;
    ftime( &t );
    return (long long)1000 * t.time + t.millitm;
}


/*
 - (void) ping
 {
 [self initSpeedDic];
 [self.tableView reloadData];
 
 if ( !queue ) {
 queue = [[ASINetworkQueue alloc] init];
 }
 
 [queue reset];
 [queue setDownloadProgressDelegate:progressIndicator];
 [queue setRequestDidFinishSelector:@selector(pingComplete:)];
 [queue setRequestDidFailSelector:@selector(pingFailed:)];
 [queue setDelegate:self];
 [queue setShouldCancelAllRequestsOnFailure:NO];
 [queue setMaxConcurrentOperationCount:4];
 
 for ( IDCInfo* idc in idcArray ) {
 NSString* url = [NSString stringWithFormat:@"http://%@/api/%@", idc.host, API_IDC_SPEED];
 ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
 request.userInfo = [NSDictionary dictionaryWithObject:idc forKey:@"idc"];
 [queue addOperation:request];
 }
 
 if ( idcArray.count > 0 ) {
 [queue go];
 }
 }
 
 
 - (void) pingComplete:(ASIHTTPRequest*)request
 {
 IDCInfo* idc = [request.userInfo objectForKey:@"idc"];
 
 NSString* responseString = request.responseString;
 if ( !responseString || responseString.length == 0 ) {
 [speedDic setObject:[NSNumber numberWithInt:0] forKey:idc.code];
 }
 else {
 NSObject* obj = [responseString JSONValue];
 if ( ![obj isKindOfClass:[NSDictionary class]] ) {
 [speedDic setObject:[NSNumber numberWithInt:0] forKey:idc.code];
 }
 else {
 NSDictionary* dic = (NSDictionary*) obj;
 id value = [dic objectForKey:@"speed"];
 if ( !value || value == [NSNull null] ) {
 [speedDic setObject:[NSNumber numberWithInt:0] forKey:idc.code];
 }
 else {
 int speed = [value intValue];
 [speedDic setObject:[NSNumber numberWithInt:speed] forKey:idc.code];
 }
 }
 }
 
 [self.tableView reloadData];
 }
 
 
 - (void) pingFailed:(ASIHTTPRequest*)request
 {
 IDCInfo* idc = [request.userInfo objectForKey:@"idc"];
 [speedDic setObject:[NSNumber numberWithInt:0] forKey:idc.code];
 [self.tableView reloadData];
 }
 */

#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        if ( selectedIDC ) {
            //刷新访问数据
            [TwitterClient getStatsData];
            
            //开始安装profile
            [AppDelegate installProfileForServiceType:@"apn" nextPage:@"datasave" apn:nil idc:selectedIDC.code];
        }
    }
}

@end
