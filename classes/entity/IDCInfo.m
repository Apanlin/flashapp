//
//  IDCInfo.m
//  flashapp
//
//  Created by 李 电森 on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IDCInfo.h"
#import "JSON.h"

@implementation IDCInfo

@synthesize code;
@synthesize name;
@synthesize host;
@synthesize speed;
@synthesize lastAccessTime;


+ (NSArray*) parseIDCList:(NSString*)idcString
{
    NSMutableArray* idcList = [NSMutableArray array];
    //NSArray* idcOrderList = [NSMutableArray array];
    if ( !idcString || idcString.length == 0 ) return idcList;
    
    NSObject* obj = [idcString JSONValue];
    if ( ![obj isKindOfClass:[NSArray class]] ) return idcList;
    
    NSArray* arr = (NSArray*) obj;
    
    id value;
    IDCInfo* idc;
    NSString* scode = nil;
    NSString* sname = nil;
    NSString* shost = nil;
    int i = 300;
    
    for ( NSDictionary* dic in arr ) {
        i++;
        value = [dic objectForKey:@"code"];
        if ( value && value != [NSNull null] ) scode = value;
        
        value = [dic objectForKey:@"name"];
        if ( value && value != [NSNull null] ) sname = value;
        
        value = [dic objectForKey:@"host"];
        if ( value && value != [NSNull null] ) shost = value;
        
        if ( scode && sname && shost && scode.length > 0 && sname.length > 0 && shost.length > 0 ) {
            idc = [[IDCInfo alloc] init];
            idc.code = scode;
            idc.name = sname;
            idc.host = shost;
         
            [idcList addObject:idc];
            [idc release];
        }
    }
    

    
    return idcList;
}


- (void) dealloc
{
    [code release];
    [name release];
    [host release];
    [super dealloc];
}

@end
