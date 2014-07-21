//
//  ASC_HTTPRequestAndHandler.h
//  ASC_APP
//
//  Created by 顾亚文 on 14-5-23.
//  Copyright (c) 2014年 顾亚文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SH_Settings.h"


enum SH_HTTP_Request_State
{
    SH_Request_Success = 0 ,
    SH_Request_Failed = 1<<0 ,
    SH_Request_Unknown = 1<<1
};

enum HTTP_Requst_Method
{
    HTTP_GET = 0 ,
    HTTP_POST = 1<<0 ,
    HTTP_PUT = 1<<1
};

@interface SH_HTTPRequestAndHandler : NSObject

typedef void (^callBack)(NSData* info, enum SH_HTTP_Request_State state) ;

+(SH_HTTPRequestAndHandler*)Shared;

-(void)resetBaseURL:(NSString*)serverIP ;

-(void)  httpRequest:(NSDictionary *)dic
         requestMethod:(enum HTTP_Requst_Method)type_code
       withURLString:(NSString *)request_url
           withBlock:(callBack)block
;
@end
