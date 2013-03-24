//
//  IDCInfoDAO.m
//  flashapp
//
//  Created by Zhao Qi on 12-12-13.
//  Copyright (c) 2012年 Home. All rights reserved.
//
#import <sqlite3.h>
#import "SystemVariablesDAO.h"
#import "DBConnection.h"
#import "Statement.h"

@implementation SystemVariablesDAO


+ (NSString*) getValue:(NSString*)key
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "select value from system_variables where key = ?";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:key forIndex:1];
    
    NSString* value = nil;
	if ( [stmt step] == SQLITE_ROW ) {
        value = [stmt getString:0];
	}
    
    [stmt release];
    return value;
}


+ (void) updateKeyValue:(NSString*)key value:(NSString*)value
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "insert or replace into system_variables (key, value) values (?,?)";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:key forIndex:1];
    [stmt bindString:value forIndex:2];
    
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}
	else {
        [stmt release];
    }
}

@end
