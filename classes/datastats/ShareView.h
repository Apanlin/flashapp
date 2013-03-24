//
//  ShareView.h
//  flashapp
//
//  Created by 李 电森 on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialogView.h"
#import "TwitterClient.h"
#import "TwitPicClient.h"

@interface ShareView : DialogView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* tableView;
    TwitterClient* client;
}


- (void) reloadData;
- (void) open;

@end
