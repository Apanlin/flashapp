//
//  ImageCompressRadioViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-10-4.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "ImageCompressRadioViewController.h"
#import "AppDelegate.h"
#import "TwitterClient.h"

#define TAG_BG_TOP 101

#define PI 3.14159265

@interface ImageCompressRadioViewController ()

@end

@implementation ImageCompressRadioViewController

@synthesize leftTopLine;
@synthesize leftBottomLine;
@synthesize rightTopLine;
@synthesize rightBottomLine;
@synthesize leftTopLabel;
@synthesize leftBottomLabel;
@synthesize rightTopLabel;
@synthesize rightBottomLabel;
@synthesize knobImageView;
@synthesize radioLabel;
@synthesize picutureImageView;


#pragma mark - init & dealloc
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
    [leftTopLine release];
    [leftBottomLine release];
    [rightTopLine release];
    [rightBottomLine release];
    [leftTopLabel release];
    [leftBottomLabel release];
    [rightTopLabel release];
    [rightBottomLabel release];
    [knobImageView release];
    [picutureImageView release];
    [radioLabel release];
    [super dealloc];
}


#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.leveyTabBarController setTabBarTransparent:YES];
    
    self.navigationItem.title = @"图片压缩质量";
    
    UIImageView* imageView = (UIImageView*) [self.view viewWithTag:TAG_BG_TOP];
    imageView.image = [[UIImage imageNamed:@"si_bg.png"] stretchableImageWithLeftCapWidth:186 topCapHeight:20];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    picQsLevel = user.pictureQsLevel;
    if ( user.pictureQsLevel == PIC_QS_MIDDLE ) {
        knobButtonAngle = PI / 4;
    }
    else if ( user.pictureQsLevel == PIC_QS_HIGH ) {
        knobButtonAngle = 3 * PI / 4;
    }
    else if ( user.pictureQsLevel == PIC_QS_NOCOMPRESS ) {
        knobButtonAngle = 5 * PI / 4;
    }
    else if ( user.pictureQsLevel == PIC_QS_LOW ) {
        knobButtonAngle = 7 * PI / 4;
    }
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showPictureQsLevel];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [self save];
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.leftTopLine = nil;
    self.leftBottomLine = nil;
    self.rightTopLine = nil;
    self.rightBottomLine = nil;
    self.leftTopLabel = nil;
    self.leftBottomLabel = nil;
    self.rightTopLabel = nil;
    self.rightBottomLabel = nil;
    self.knobImageView = nil;
    self.picutureImageView = nil;
    self.radioLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - show

- (void) showPictureQsLevel
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
    
	CGAffineTransform transform = CGAffineTransformMakeRotation(knobButtonAngle);
	[knobImageView setTransform:transform];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(showLabelAndLines) withObject:nil afterDelay:0.5f];
}


- (void) showLabelAndLines
{
    UIColor* highlightColor = [UIColor greenColor];
    UIColor* normalColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0];
    
    if ( picQsLevel == PIC_QS_LOW ) {
        picutureImageView.image = [UIImage imageNamed:@"si_image15.jpg"];
        radioLabel.text = @"15％";
    }
    else if ( picQsLevel == PIC_QS_HIGH ) {
        picutureImageView.image = [UIImage imageNamed:@"si_image60.jpg"];
        radioLabel.text = @"60％";
    }
    else if ( picQsLevel == PIC_QS_NOCOMPRESS ) {
        //picutureImageView.image = [UIImage imageNamed:@"si_image.jpg"];
        picutureImageView.image = [UIImage imageNamed:@"si_image15.jpg"];
        radioLabel.text = @"0％";
    }
    else {
        picutureImageView.image = [UIImage imageNamed:@"si_image25.jpg"];
        radioLabel.text = @"25％";
    }
    [picutureImageView setNeedsDisplay];

    if ( picQsLevel == PIC_QS_LOW ) {
        leftTopLabel.textColor = highlightColor;
        leftTopLine.image = [UIImage imageNamed:@"si_lt_blue.png"];
    }
    else {
        leftTopLabel.textColor = normalColor;
        leftTopLine.image = [UIImage imageNamed:@"si_lt.png"];
    }

    if ( picQsLevel == PIC_QS_MIDDLE ) {
        rightTopLabel.textColor = highlightColor;
        rightTopLine.image = [UIImage imageNamed:@"si_rt_blue.png"];
    }
    else {
        rightTopLabel.textColor = normalColor;
        rightTopLine.image = [UIImage imageNamed:@"si_rt.png"];
    }

    if ( picQsLevel == PIC_QS_HIGH ) {
        rightBottomLabel.textColor = highlightColor;
        rightBottomLine.image = [UIImage imageNamed:@"si_rb_blue.png"];
    }
    else {
        rightBottomLabel.textColor = normalColor;
        rightBottomLine.image = [UIImage imageNamed:@"si_rb.png"];
    }

    if ( picQsLevel == PIC_QS_NOCOMPRESS ) {
        leftBottomLabel.textColor = highlightColor;
        leftBottomLine.image = [UIImage imageNamed:@"si_lb_blue.png"];
    }
    else {
        leftBottomLabel.textColor = normalColor;
        leftBottomLine.image = [UIImage imageNamed:@"si_lb.png"];
    }
}


#pragma mark - actions

- (IBAction) knobClick:(id)sender
{
    if ( picQsLevel == PIC_QS_LOW ) {
        picQsLevel = PIC_QS_MIDDLE;
    }
    else if ( picQsLevel == PIC_QS_MIDDLE ) {
        picQsLevel = PIC_QS_HIGH;
    }
    else if ( picQsLevel == PIC_QS_HIGH ) {
        picQsLevel = PIC_QS_NOCOMPRESS;
    }
    else if ( picQsLevel == PIC_QS_NOCOMPRESS ) {
        picQsLevel = PIC_QS_LOW;
    }
    
    knobButtonAngle += PI / 2;
    
    [self showPictureQsLevel];
}


#pragma mark - save data

- (void) save
{
    Reachability* reachable = [Reachability reachabilityWithHostName:P_HOST];
    if ( [reachable currentReachabilityStatus] == NotReachable ) {
        [AppDelegate showAlert:@"抱歉，连接网络失败。"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.pictureQsLevel == picQsLevel ) return;
    
    int qs = 0;
    if ( picQsLevel == PIC_QS_LOW ) {
        qs = 2;
    }
    else if ( picQsLevel == PIC_QS_MIDDLE ) {
        qs = 1;
    }
    else if ( picQsLevel == PIC_QS_HIGH ) {
        qs = 0;
    }
    else if ( picQsLevel == PIC_QS_NOCOMPRESS ) {
        qs = 2;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%d&host=%@&port=%d", 
                     API_BASE, API_SETTING_IMAGE_QUALITY, qs,
                     user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url response:&response error:&error];
    
    if ( response.statusCode == 200 ) {
        if ( !obj && ![obj isKindOfClass:[NSDictionary class]] ) {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
        
        NSDictionary* dic = (NSDictionary*) obj;
        NSNumber* number = (NSNumber*) [dic objectForKey:@"code"];
        int code = [number intValue];
        if ( code == 200 ) {
            user.pictureQsLevel = picQsLevel;
            [UserSettings savePictureQsLevel:picQsLevel];
        }
        else {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
    }
    else {
        [AppDelegate showAlert:@"抱歉，操作失败"];
    }
}



@end
