//
//  FeedbackViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "UIDevice-Reachability.h"
#import "OpenUDID.h"

#define TEXT_PLACEHOLDER @"请详细描述您的意见和建议，谢谢！"

#define SCROLLVIEW_FRAME_OUT_TEXT CGRectMake(0,0,320,256)
#define SCROLLVIEW_FRAME_IN_TEXT CGRectMake(0,0,320,216)

@interface FeedbackViewController(private)
- (void) sendSMS:(NSString*)body;
- (void) displaySMSComposerSheet:(NSString*)body;
@end


@implementation FeedbackViewController

@synthesize textView;
@synthesize contactField;
@synthesize submitButton;
@synthesize scrollView;
@synthesize showClose;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void) dealloc
{
    [textView release];
    [contactField release];
    [scrollView release];
    [submitButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    if ( showClose ) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    }
    
    textView.text = TEXT_PLACEHOLDER;
    textView.layer.masksToBounds = YES;
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 7.0;
    
    [submitButton setBackgroundImage:[[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
    [submitButton setTitle:@"发   送" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    scrollView.contentSize = CGSizeMake(320, 256);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.textView = nil;
    self.contactField = nil;
    self.submitButton = nil;
    self.scrollView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - business method
- (IBAction) save
{
    NSString* content = [textView.text trim];
    NSString* contact = [contactField.text trim];
    
    if ( content.length == 0 ) {
        [AppDelegate showAlert:@"请输入您的反馈内容，谢谢"];
        return;
    }
    
    if ( contact.length == 0 ) {
        [AppDelegate showAlert:@"请输入您的联系方式，谢谢"];
        return;
    }
    
    if ( client ) return;
    
    content = [NSString stringWithFormat:@"#%@#%@", [OpenUDID value], content];
    
    BOOL reachable = [UIDevice reachableToHost:P_HOST];
    //BOOL reachable = NO;
    if ( reachable ) {
        UserSettings* user = [AppDelegate getAppDelegate].user;
        NSString* url = [NSString stringWithFormat:@"%@/%@.json", API_BASE, API_FEEDBACK_FEEDBACK];
        NSString* body = [NSString stringWithFormat:@"content=%@&email=%@&username=%@", [content encodeAsURIComponent], [contact encodeAsURIComponent], user.username ];
        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didSave:obj:)];
        [client post:url body:body];
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的网络无法使用，采用短信方式发送反馈？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];
    }
}


- (void) didSave:(TwitterClient*)cli obj:(NSObject*)obj
{
    client = nil;
    
    if ( cli.hasError ) {
        [AppDelegate showAlert:@"抱歉，访问网络失败"];
        return;
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) {
        [AppDelegate showAlert:@"抱歉，请求网络失败"];
        return;
    }
    
    NSDictionary* dic = (NSDictionary*) obj;
    NSObject* value = [dic objectForKey:@"result"];
    if ( value ) {
        Boolean* b = (Boolean*)value;
        if ( b ) {
            [AppDelegate showAlert:@"已经成功发送了您的反馈信息。"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        else {
            [AppDelegate showAlert:@"抱歉，请求网络失败"];
            return;
        }
    }
    else {
        [AppDelegate showAlert:@"抱歉，请求网络失败"];
        return;
    }
}


- (void) close
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] currentNavigationController];
    if ( nav == self.navigationController ) {
        [nav popViewControllerAnimated:YES];
    }
    else {
        [[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)v
{
    if ( [v.text compare:TEXT_PLACEHOLDER] == NSOrderedSame ) v.text = @"";
    return YES;
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
    scrollView.frame = SCROLLVIEW_FRAME_IN_TEXT;
}


#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    scrollView.frame = SCROLLVIEW_FRAME_IN_TEXT;
}


#pragma mark - sms methods

- (void) sendSMS:(NSString*)body
{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet:body];
		}
		else {
            [AppDelegate showAlert:@"设备没有短信功能" message:@"您的设备不能发送短信"];
		}
	}
	else {
        [AppDelegate showAlert:@"iOS版本过低" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
	}
}


- (void) displaySMSComposerSheet:(NSString*)body
{
    [textView resignFirstResponder];
    [contactField resignFirstResponder];
    scrollView.frame = SCROLLVIEW_FRAME_OUT_TEXT;
    
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"18611737301", nil];
	picker.body = body;
    picker.title = @"发送短信";
    
    [self.navigationController presentModalViewController:picker animated:YES];
	[picker release];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)messageComposeViewController
				 didFinishWithResult:(MessageComposeResult)result {
	switch (result)
	{
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
            [AppDelegate showAlert:@"您的反馈信息已经发送成功，谢谢对我们工作的支持"];
			break;
		case MessageComposeResultFailed:
            [AppDelegate showAlert:@"抱歉，短信发送失败"];
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        NSString* content = [NSString stringWithFormat:@"#%@#%@ 【联系方式】%@", [OpenUDID value], textView.text, contactField.text];
        [self sendSMS:content];
    }
}


@end
