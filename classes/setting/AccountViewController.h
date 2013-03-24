//
//  AccountViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface AccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UITableView* tableView;
    UITextField* currentTextField;
    UITextField* nicknameTextField;
    UILabel* descriptionLabel;
    
    LoadingView* loadingView;
}


@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UILabel* descriptionLabel;

- (IBAction) logout:(id)sender;

@end
