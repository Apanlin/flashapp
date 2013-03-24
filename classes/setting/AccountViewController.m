//
//  AccountViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"
#import "ModifyPasswdViewController.h"
#import "ForgotPasswdViewController.h"
#import "AppDelegate.h"
#import "TwitterClient.h"
#import "StringUtil.h"

#define TAG_NICKNAME 101
#define TAG_PHONE 102

@interface AccountViewController (private)
- (BOOL) saveUserInfo;
@end

@implementation AccountViewController

@synthesize tableView;
@synthesize descriptionLabel;

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
    [tableView release];
    [descriptionLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:47.0f/255.0f blue:47.0f/255.0f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0f];

    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"set.accountView.navItem.title", nil);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    descriptionLabel.text = NSLocalizedString(@"set.accountView.description.label.text", nil);
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 150, 130, 100)];
    loadingView.message = NSLocalizedString(@"set.accountView.loading.message", nil);
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
    
    currentTextField = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
}


- (void) viewWillDisappear:(BOOL)animated
{
    [self saveUserInfo];
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableView Datasource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.snsDomain ) {
        return 2;
    }
    else {
        return 4;
    }
}


- (UITableViewCell*) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"] autorelease];
    cell.backgroundColor = [UIColor colorWithRed:41.0f/255.0f green:41.0f/255.0f blue:41.0f/255.0f alpha:1.0f];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    int row = indexPath.row;
    if ( row == 0 ) {
        cell.textLabel.text = NSLocalizedString(@"set.accountView.nickNameLabel.text", nil);
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, 200, 20)];
        textField.textAlignment = UITextAlignmentRight;
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:17];
        textField.returnKeyType = UIReturnKeyDone;
        textField.tag = TAG_NICKNAME;
        textField.delegate = self;
        textField.placeholder = NSLocalizedString(@"set.accountView.nickNameTextField.text", nil);
        textField.text = user.nickname;
        nicknameTextField = textField;
        [cell.contentView addSubview:textField];
        [textField release];
    }
    else if ( row == 1 ) {
        cell.textLabel.text = NSLocalizedString(@"set.accountView.mobilePhoneLabel.text", nil);
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 200, 20)];
        label.textAlignment = UITextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:132.0f/255.0f green:132.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
        label.font = [UIFont systemFontOfSize:16];
        
        if ( user.username ) {
            NSRange range = [user.username rangeOfString:@"_sinaWeibo" options:NSCaseInsensitiveSearch];
            if ( range.location != NSNotFound ) {
                label.text = @"新浪微博帐号";
            }
            
            if ( range.location == NSNotFound ) {
                range = [user.username rangeOfString:@"_renren" options:NSCaseInsensitiveSearch];
                if ( range.location != NSNotFound ) {
                    label.text = @"人人网帐号";
                }
            }

            if ( range.location == NSNotFound ) {
                range = [user.username rangeOfString:@"_qq" options:NSCaseInsensitiveSearch];
                if ( range.location != NSNotFound ) {
                    label.text = @"QQ帐号";
                }
            }
            
            if ( range.location == NSNotFound ) {
                range = [user.username rangeOfString:@"_baidu" options:NSCaseInsensitiveSearch];
                if ( range.location != NSNotFound ) {
                    label.text = @"百度帐号";
                }
            }

            if ( range.location == NSNotFound ) {
                range = [user.username rangeOfString:@"_wangyiWeibo" options:NSCaseInsensitiveSearch];
                if ( range.location != NSNotFound ) {
                    label.text = @"网易微博帐号";
                }
            }

            if ( range.location == NSNotFound ) {
                label.text = user.username;
            }
        }
        [cell.contentView addSubview:label];
        [label release];
        /*
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 12, 200, 20)];
        textField.textAlignment = UITextAlignmentRight;
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor colorWithRed:132.0f/255.0f green:132.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.font = [UIFont systemFontOfSize:16];
        textField.tag = TAG_PHONE;
        textField.delegate = self;
        textField.placeholder = @"请输入手机号码";
        textField.text = user.username;
        [cell.contentView addSubview:textField];
        [textField release];*/
    }
    else if ( row == 2 ) {
        cell.textLabel.text = NSLocalizedString(@"set.accountView.modifyPassWord.label.text", nil);
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_arrow.png"]] autorelease];
    }
    else if ( row == 3 ) {
        cell.textLabel.text = NSLocalizedString(@"set.accountView.forgetPassWord.label.text", nil);
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_arrow.png"]] autorelease];
    }
    
    return cell;
}


- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if ( row == 0 || row == 1 ) {
        return nil;
    }
    else {
        return indexPath;
    }
}


- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( currentTextField ) [currentTextField resignFirstResponder];
    
    int row = indexPath.row;
    if ( row == 2 ) {
        ModifyPasswdViewController* controller = [[ModifyPasswdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if ( row == 3 ) {
        ForgotPasswdViewController* controller = [[ForgotPasswdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if ( currentTextField ) [currentTextField resignFirstResponder];
    return YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"text end!!!");
}


#pragma mark - tools methods

- (BOOL) saveUserInfo
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* username = user.username;
    NSString* password = user.password;
    
    NSString* nickname = [nicknameTextField.text trim];
    if ( [nickname compare:user.nickname] == NSOrderedSame ) {
        return YES;
    }
    
    if ( !username || username.length == 0 ) {
        //[AppDelegate showAlert:@"请输入手机号"];
        return NO;
    }
    
    if ( !password || password.length == 0 ) {
        //[AppDelegate showAlert:@"请输入密码"];
        return NO;
    }
    
    if ( !nickname || nickname.length == 0 ) {
        //[AppDelegate showAlert:@"请输入昵称"];
        return NO;
    }
    
    loadingView.hidden = NO;
    
    BOOL result = [TwitterClient modifyUserInfo:username nickname:nickname password:password];
    
    loadingView.hidden = YES;
    if ( !result ) {
        //[AppDelegate showAlert:@"修改昵称失败"];
        return NO;
    }
    else {
        user.nickname = nickname;
        [UserSettings saveNickname:nickname];
        return YES;
    }
}


- (IBAction) logout:(id)sender
{
    UserSettings* user = [AppDelegate getAppDelegate].user;

    user.status = STATUS_NEW;
    user.proxyFlag = [AppDelegate getAppDelegate].user.proxyFlag;
    user.capacity = QUANTITY_INIT;
    user.day = nil;
    user.dayCapacity = 0;
    user.dayCapacityDelta = 0;
    user.month = nil;
    user.monthCapacity = 0;
    user.monthCapacityDelta = 0;
    user.password = nil;
    user.username = nil;
    
    [UserSettings saveUserSettings:user];
    
    [[AppDelegate getAppDelegate] switchUser];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
