//
//  TCAdjustViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TCAdjustViewController.h"
#import "TCPhoneViewController.h"
#import "TCCarrierViewController.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "StringUtil.h"
#import "REString.h"
#import "TCUtils.h"
#import "IFData.h"
#import "IFDataService.h"
#import "DateUtils.h"
#import "InputAlertView.h"

#define TAG_ALERTVIEW_TOTAL 101
#define TAG_ALERTVIEW_DAY 102
#define TAG_ALERTVIEW_USED 103
#define TAG_ALERTVIEW_LOCATION 104


@interface TCAdjustViewController ()

@end

@implementation TCAdjustViewController

@synthesize bgImageView;
@synthesize bgImageView2;
@synthesize bgImageView3;
@synthesize queryButton;
@synthesize totalLabel;
@synthesize usedLabel;
@synthesize dayLabel;
@synthesize client;
@synthesize numberKeyboard;
@synthesize totalLabelDesc;
@synthesize usedLabelDesc;
@synthesize dayLabelDesc;
@synthesize adjustDescLabel;
@synthesize dayUnitLabel;
@synthesize locationSwitch;
@synthesize locationIcon;


#pragma mark - init & destroy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [bgImageView release];
    [bgImageView2 release];
    [bgImageView3 release];
    [queryButton release];
    [totalLabel release];
    [dayLabel release];
    [usedLabel release];
    [client release];
    [numberKeyboard release];
    [totalLabelDesc release];
    [usedLabelDesc release];
    [dayLabelDesc release];
    [adjustDescLabel release];
    [dayUnitLabel release];
    [locationSwitch release];
    [locationIcon release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - view lifecircle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = NSLocalizedString(@"taocan.TCAdjustView.navItem.title", nil);
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeName", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(close)] autorelease];
    
    bgImageView.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    bgImageView2.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    bgImageView3.image = [[UIImage imageNamed:@"black_bg_b.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
    [queryButton setBackgroundImage:[[UIImage imageNamed:@"blueButton2.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:8] forState:UIControlStateNormal];
    
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 52, 292, 1)];
    lineImageView.image = [UIImage imageNamed:@"blackline.png"];
    [self.view addSubview:lineImageView];
    [lineImageView release];

    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 150, 292, 1)];
    lineImageView.image = [UIImage imageNamed:@"blackline.png"];
    [self.view addSubview:lineImageView];
    [lineImageView release];
    
    totalLabelDesc.text = NSLocalizedString(@"taocan.TCAdjustView.totalLabel.text", nil);
    dayLabelDesc.text  = NSLocalizedString(@"taocan.TCAdjustView.dayLabel.text", nil);
    usedLabelDesc.text  = NSLocalizedString(@"taocan.TCAdjustView.usedLabel.text", nil);
    adjustDescLabel.text  = NSLocalizedString(@"taocan.TCAdjustView.adjustDescLabel.text", nil);
    dayUnitLabel.text  = NSLocalizedString(@"taocan.TCAdjustView.dayUnit.text", nil);
    [queryButton setTitle:NSLocalizedString(@"taocan.TCAdjustView.queryButton.title", nil) forState:UIControlStateNormal];
    
    messageView = [[ProfileTipView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
    messageView.hidden = YES;
    [messageView setMessage:NSLocalizedString(@"taocan.TCAdjustView.SMSSend.message", nil) button:nil];
    [self.view addSubview:messageView];
    [messageView release];


    BOOL locationEnabled = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
    BOOL opend = [[NSUserDefaults standardUserDefaults] boolForKey:UD_LOCATION_ENABLED];
    if ( locationEnabled && opend ) {
        locationSwitch.on = YES;
        locationIcon.image = [UIImage imageNamed:@"location_purplearrow.png"];
    }
    else {
        locationSwitch.on = NO;
        locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bgImageView = nil;
    self.bgImageView2 = nil;
    self.bgImageView3 = nil;
    self.queryButton = nil;
    self.totalLabel = nil;
    self.usedLabel = nil;
    self.dayLabel = nil;
    self.locationSwitch = nil;
    self.locationIcon = nil;
    
    [client cancel];
    [client release];
    client = nil;
    
    [numberKeyboard release];
    numberKeyboard = nil;
}


- (void) viewWillAppear:(BOOL)animated
{
    [self loadData];
    [super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated
{
    if ( dirty ) {
        NSString* total = [self.totalLabel.text trim];
        if ( ![self checkInputValue:total tag:TAG_ALERTVIEW_TOTAL] ) return;
        
        NSString* used = [self.usedLabel.text trim];
        if ( ![self checkInputValue:used tag:TAG_ALERTVIEW_USED] ) return;
        
        NSString* day = [self.dayLabel.text trim];
        if ( ![self checkInputValue:day tag:TAG_ALERTVIEW_DAY] ) return;
        
        [self save];
    }
    
    [super viewWillDisappear:animated];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    AppDelegate* appDelegate = [AppDelegate getAppDelegate];
    @synchronized (self) {
        if ( appDelegate.adjustSMSSend ) {
            appDelegate.adjustSMSSend = NO;
            [self performSelector:@selector(showMessage) withObject:NSLocalizedString(@"taocan.TCAdjustView.SMSSend.message", nil) afterDelay:0.5f];
        }
    }
}


//- (void) showMessage:(NSString*)message
//{
//    NSString* value = self.usedLabel.text;
//    [self showInputAlertView:NSLocalizedString(@"taocan.TCAdjustView.SMSSend.usedmessage", nil) value:value tag:TAG_ALERTVIEW_USED];
//}

#pragma mark - tool methods


- (void) loadData
{
    [TCUtils readIfData:-1];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* total = user.ctTotal;
    NSString* used = user.ctUsed;
    NSString* day = user.ctDay;
    
    if ( !total ) {
        //读取服务器的数值
        [self getDataFromServer];
        total = [NSString stringWithFormat:@"%d", TC_TOTAL];
        day = @"1";
    }
    
    if ( !used || used.length == 0 ) {
        used = @"0.0";
    }
    else {
        used = [NSString stringWithFormat:@"%.2f", [used longLongValue] / 1024.0f / 1024.0f];
    }
    
    self.dayLabel.text = day;
    self.totalLabel.text = total;
    self.usedLabel.text = used;
}


- (void) getDataFromServer
{
    if ( client ) return;

    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] == NotReachable ) return;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetDataFromServer:obj:)];
    [client getTaocanData:nil used:nil day:nil];
}


- (void) didGetDataFromServer:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:tc.errorDetail];
        return;
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*)obj;
    
    NSString* day = nil;
    NSString* total = nil;
    NSString* used = nil;
    
    NSObject* oo = [dic objectForKey:@"dat"];
    if ( oo && oo != [NSNull null] ) {
        day = (NSString*) oo;
    }
    
    oo = [dic objectForKey:@"total"];
    if ( oo && oo != [NSNull null] ) {
        total = (NSString*) oo;
    }
    
    oo = [dic objectForKey:@"use"];
    if ( oo && oo != [NSNull null] ) {
        used = (NSString*) oo;
    }
    
    time_t lastUpdate = 0;
    oo = [dic objectForKey:@"lastUpdate"];
    if ( oo && oo != [NSNull null] ) {
        lastUpdate = [DateUtils timeWithDateFormat:(NSString*)oo format:@"yyyy-MM-dd HH:mm:ss"];
    }

    if ( day.length == 0 ) day = nil;
    if ( total.length == 0 ) total = nil;
    if ( used.length == 0 ) used = nil;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    long long bytes = [user getTcUsed];
    
    float totalm = (total ? [total floatValue] : TC_TOTAL);
    int daym = ( day ? [day intValue] : 1 );
    
    time_t peroid[2];
    time_t now;
    time( &now );
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    if ( used && used.length > 0 ) {
        if ( lastUpdate >= peroid[0] && lastUpdate <= peroid[1] && [used floatValue] > bytes ) {
            bytes = [used longLongValue];
        }
    }
    
    //判断是否修改过
    NSString* curTotal = user.ctTotal;
    NSString* curUsed = user.ctUsed;
    NSString* curDay = user.ctDay;
    
    if ( !curTotal || curTotal.length == 0 ) {
        self.totalLabel.text = [NSString stringWithFloatTrim:totalm decimal:2];
        dirty = YES;
    }
    
    if ( !curDay || curDay.length == 0 ) {
        self.dayLabel.text = [NSString stringWithFormat:@"%d", daym];
        dirty = YES;
    }
    
    if ( !curUsed || curUsed.length == 0 ) {
        self.usedLabel.text = [NSString stringWithFormat:@"%.2f", bytes / 1024.0f / 1024.0f];
        dirty = YES;
    }
}


- (void) close
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (BOOL) checkInputValue:(NSString*)value tag:(NSInteger)tag
{
    value = [value trim];
    if ( !value || value.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.valueLength", nil)];
        return NO;
    }

    if ( tag == TAG_ALERTVIEW_TOTAL ) {
        NSString* total = [value trim];
        if ( total.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.totalValueLength", nil)];
            return NO;
        }
        
        BOOL b = [total matches:@"^([0-9]{1,4}(\\.[0-9]{1,2})*)$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.totalValueMatch", nil)];
            return NO;
        }
        
    }
    else if ( tag == TAG_ALERTVIEW_USED ) {
        NSString* used = [value trim];
        if ( used.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.usedValueLength", nil)];
            return NO;
        }
        
        BOOL b = [used matches:@"^([0-9]{1,4}(\\.[0-9]{1,2})*)$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.usedValueMatch", nil)];
            return NO;
        }
    }
    else if ( tag == TAG_ALERTVIEW_DAY ) {
        NSString* day = [value trim];
        if ( day.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayValueLength", nil)];
            return NO;
        }
        
        BOOL b = [day matches:@"^[0-9]{1,2}$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayValueMatch", nil)];
            return NO;
        }
        
        int d = [day intValue];
        if ( d <=0 || d > 31 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayIntValue", nil)];
            return NO;
        }
    }
    
    return YES;
}


- (void) save
{
    if ( !dirty ) return;
    
    NSString* total = [self.totalLabel.text trim];
    NSString* used = [self.usedLabel.text trim];
    NSString* day = [self.dayLabel.text trim];

    long long bytes = [used floatValue] * 1024.0f * 1024.0f;
    [TCUtils saveTCUsed:bytes total:[total floatValue] day:[day intValue]];
    
    //发送页面刷新通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCChangedNotification object:nil];

    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] != NotReachable ) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [TwitterClient saveTaocanData:total used:[NSString stringWithFormat:@"%lld", bytes] day:day];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    dirty = NO;
}


//短信免费查询 按钮
- (void) adjust
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.username && user.username.length > 0 ) {
        //检索网络是 wifi 还是 3G
        NetworkStatus status = [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus];
        if ( (!user.areaCode || user.areaCode.length == 0) && status != NotReachable  ) {
            if ( client ) return; //如果client 不为空 退出函数。
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetCarrierInfo:obj:)];
            [client getCarrierInfo:user.username area:nil code:nil type:nil];
        }
        else {
            [self openCarrierView];
        }
    }
    else {
        [self openCarrierView];
    }
}


- (void) didGetCarrierInfo:(TwitterClient*)tc obj:(NSObject*)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    client = nil;
    
    [TwitterClient parseCarrierInfo:obj];
    [self openCarrierView];
}


- (void) openCarrierView
{
    TCCarrierViewController* controller = [[TCCarrierViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (IBAction) setTotal
{
    NSString* value = self.totalLabel.text;
    [self showInputAlertView:NSLocalizedString(@"taocan.TCAdjustView.setPackageFlow", nil) value:value tag:TAG_ALERTVIEW_TOTAL];
}

- (IBAction) setDay
{
    NSString* value = self.dayLabel.text;
    [self showInputAlertView:NSLocalizedString(@"taocan.TCAdjustView.setDay", nil) value:value tag:TAG_ALERTVIEW_DAY];
}


- (IBAction) setUsed
{
    NSString* value = self.usedLabel.text;
    [self showInputAlertView:NSLocalizedString(@"taocan.TCAdjustView.setUsedFlow", nil) value:value tag:TAG_ALERTVIEW_USED];
}


- (void) showInputAlertView:(NSString*)title value:(NSString*)value tag:(NSInteger)tag
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithFrame:CGRectMake(10, 20, 300, 100)];
    dialog.tag = tag;
    [dialog setDelegate:self];
    [dialog setTitle:title];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:NSLocalizedString(@"cancleName", nil)];
    [dialog addButtonWithTitle:NSLocalizedString(@"defineName", nil)];
    
    UITextField* nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [nameField setBackgroundColor:[UIColor whiteColor]];
    nameField.text = value;
    
    //nameField.keyboardType = UIKeyboardTypeNumberPad;
    [dialog addSubview:nameField];
    [nameField becomeFirstResponder];
    [dialog show];

    /*if ( !numberKeyboard ) {
        self.numberKeyboard = [NumberKeypadDecimalPoint keypadForTextField:nameField];
    }
    else {
        self.numberKeyboard.currentTextField = nameField;
    }*/
    
    [dialog release];
    [nameField release];
}


- (void) showMessage
{
    messageView.hidden = NO;
    for ( UIView* view in self.view.subviews ) {
        if ( view != messageView ) {
            CGPoint p = view.center;
            p.y += 28;
            view.center = p;
        }
    }
    
    [self performSelector:@selector(hiddenMessage) withObject:nil afterDelay:15.0];
}


- (void) hiddenMessage
{
    messageView.hidden = YES;
    for ( UIView* view in self.view.subviews ) {
        if ( view != messageView ) {
            CGPoint p = view.center;
            p.y -= 28;
            view.center = p;
        }
    }
}


- (void) locationSetting:(id)sender
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* desc = nil;
    if ( [device.systemVersion compare:@"6.0"] == NSOrderedAscending ) {
        desc = @"设置>定位服务";
    }
    else {
        desc = @"设置>隐私>位置";
    }
    
    UISwitch* switcher = (UISwitch*) sender;
    if ( switcher.on ) {
        if ( ![CLLocationManager locationServicesEnabled] ) {
            [AppDelegate showAlert:[NSString stringWithFormat:@"您的设备未开启定位服务\n请在\"%@\"中打开定位服务！", desc]];
            switcher.on = NO;
            locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
        }
        else if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized && [[NSUserDefaults standardUserDefaults] objectForKey:UD_LOCATION_ENABLED]) {
            //判断是否是第一次使用
            [AppDelegate showAlert:[NSString stringWithFormat:@"您现在禁止飞速使用定位服务\n请在\"%@\"中打开飞速的开关",desc]];
            switcher.on = NO;
            locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
        }
        else {
            [[AppDelegate getAppDelegate] startLocationManager];
            [[NSUserDefaults standardUserDefaults] setBool:switcher.on forKey:UD_LOCATION_ENABLED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            locationIcon.image = [UIImage imageNamed:@"location_purplearrow.png"];
        }
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭精确流量监控将无法实时统计流量，可能造成流量统计不准确！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = TAG_ALERTVIEW_LOCATION;
        [alertView show];
        [alertView release];
    }
}




#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == TAG_ALERTVIEW_LOCATION ) {
        if ( buttonIndex == 0 ) {
            locationSwitch.on = YES;
            locationIcon.image = [UIImage imageNamed:@"location_purplearrow.png"];
        }
        else {
            //关闭精确流量监控
            [[AppDelegate getAppDelegate] stopLocationManager];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_LOCATION_ENABLED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
        }
    }
    else {
        if ( buttonIndex == 0 ) return;
        
        UITextField* textField = [self getTextFieldOfAlertView:alertView];
        if ( !textField ) return;
        
        NSString* value = [textField.text trim];
        if ( value.length == 0 ) return;
        
        if ( ![self checkInputValue:value tag:alertView.tag] ) return;
        
        if ( alertView.tag == TAG_ALERTVIEW_TOTAL ) {
            self.totalLabel.text = value;
            dirty = YES;
        }
        else if ( alertView.tag == TAG_ALERTVIEW_DAY ) {
            self.dayLabel.text = value;
            dirty = YES;
        }
        else if ( alertView.tag == TAG_ALERTVIEW_USED ) {
            self.usedLabel.text = value;
            dirty = YES;
        }
    }
}


- (UITextField*) getTextFieldOfAlertView:(UIAlertView*)alertView
{
    if ( !alertView ) return nil;
    
    for ( UIView* v in [alertView subviews] ) {
        if ( [v isKindOfClass:[UITextField class]] ) return (UITextField*) v;
    }
    
    return nil;
}


/*
#pragma mark - UITextField Delegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	if (numberKeyPad) {
		numberKeyPad.currentTextField = textField;
	}
	return YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {	
	if (![textField isEqual:dayTextField]) {
		// Show the numberKeyPad 
		if (!self.numberKeyPad) {
			self.numberKeyPad = [NumberKeypadDecimalPoint keypadForTextField:textField];
		}else {
			//if we go from one field to another - just change the textfield, don't reanimate the decimal point button
			self.numberKeyPad.currentTextField = textField;
		}
	}	
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	//if (![textField isEqual:normal]) {
	if (textField == numberKeyPad.currentTextField) {
		// Hide the number keypad
		[self.numberKeyPad removeButtonFromKeyboard];
		self.numberKeyPad = nil;
	}
	
	if (numberKeyPad.currentTextField == dayTextField) {
		// Hide the number keypad
		[self.numberKeyPad removeButtonFromKeyboard];
		self.numberKeyPad = nil;
	}
}	
*/

@end
