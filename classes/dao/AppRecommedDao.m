//
//  AppRecommedDao.m
//  flashapp
//
//  Created by 朱广涛 on 13-5-7.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "AppRecommedDao.h"
#import "AppClasses.h"
#import "DBConnection.h"
#import "Statement.h"

@implementation AppRecommedDao


/*! @brief 创建应用推荐分类表到数据库中
 *
 * 需要创建应用推荐分类表，表中记录应用推荐分类最后一次更新的时间。
 * @param nil
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)createAppClassestable
{
    char * createTable = "create table if not exists APP_CLASSES(id integer primary key , icon text ,  name text , new integer , tim real) ";
    sqlite3 *conn = [DBConnection getDatabase];
    char *error;
    if (sqlite3_exec(conn, createTable, NULL, NULL, &error) == SQLITE_OK) {
        return YES;
    }
    return NO;
}

+ (void)insertAllAppRecommend:(NSArray *)arr
{
    sqlite3 *database = [DBConnection getDatabase];
    char *sql = "insert into APP_CLASSES(id,icon,name,new,tim) values(?,?,?,?,?)";
    for ( int i = 0 ; i < [arr count]; i++) {
        Statement *stat = [[Statement alloc] initWithDB:database sql:sql];
        NSDictionary *dic = [arr objectAtIndex:i];
        [stat bindInt32:[[dic objectForKey:@"id"] integerValue] forIndex:1];
        [stat bindString:[dic objectForKey:@"icon"] forIndex:2];
        [stat bindString:[dic objectForKey:@"name"] forIndex:3];
        [stat bindInt32:[[dic objectForKey:@"new"] integerValue] forIndex:4];
        [stat bindInt64:[[dic objectForKey:@"tim"] longLongValue] forIndex:5];
        //        NSLog(@"1 ------ dic is %@",dic);
        if ( [stat step] != SQLITE_DONE ) {
            [stat release];
            NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(database));
        }
        else {
            [stat release];
        }
    }
}

+ (void)updateAppRecommend:(AppClasses *)appClassess
{
    sqlite3 *database = [DBConnection getDatabase];
    char *sql = "update APP_CLASSES set tim = ? where name = ?";
    Statement *stat = [[Statement alloc] initWithDB:database sql:sql];
    [stat bindInt64:appClassess.appClasses_tim forIndex:1];
    [stat bindString:appClassess.appClasses_name forIndex:2];
    if ( [stat step] != SQLITE_DONE ) {
        [stat release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(database) );
	}
    else {
        [stat release];
    }
}

+ (NSDictionary *)fondAllAppRecommed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    char *sql = "select * from APP_CLASSES";
    
    sqlite3 *conn = [DBConnection getDatabase] ;
    
    Statement *stat = [[Statement alloc] initWithDB:conn sql:sql];
    
    while ([stat step] == SQLITE_ROW) {
        AppClasses *appClasses = [[AppClasses alloc] init];
        appClasses.appClasses_id = [stat getInt32:0];
        appClasses.appClasses_icon = [stat getString:1];
        appClasses.appClasses_name = [stat getString:2];
        appClasses.appClasses_new = [stat getInt32:3];
        appClasses.appClasses_tim = [stat getInt64:4];
        [dic setObject:appClasses forKey:appClasses.appClasses_name];
        [appClasses release];
    }
    [stat release];
    return dic;
    
}



@end
