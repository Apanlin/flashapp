//
//  GetAddress.h
//  flashapp
//
//  Created by Zhao Qi on 13-3-24.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#ifndef flashapp_GetAddress_h
#define flashapp_GetAddress_h

#define MAXADDRS 20

#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))

#define BUFFERSIZE  4000

static int   nextAddr;

void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();

#endif
