//
//  ASC_HTTPRequestAndHandler.m
//  ASC_APP
//
//  Created by 顾亚文 on 14-5-23.
//  Copyright (c) 2014年 顾亚文. All rights reserved.
//

#import "SH_HTTPRequestAndHandler.h"
#import "AFHTTPClient.h"

@interface SH_HTTPRequestAndHandler()
{
    SH_Settings *_settings ;
}
@property (retain, nonatomic) AFHTTPClient *sh_httpClient ;


@end

@implementation SH_HTTPRequestAndHandler
@synthesize sh_httpClient ;

+(SH_HTTPRequestAndHandler*)Shared
{
    static SH_HTTPRequestAndHandler * shared = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken,^{shared = [[self alloc]init];});
    return shared;
}

-(id)init
{
    if(self = [super init])
    {
        _settings= [SH_Settings sharedSettings];
        NSString *string_url =[NSString stringWithFormat:@"http://%@",_settings.serverAddress];
        sh_httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:string_url]];
        sh_httpClient.parameterEncoding = AFJSONParameterEncoding ;
    }
    return self ;
}

-(void)resetBaseURL:(NSString*)serverIP
{
    NSString *string_url =[NSString stringWithFormat:@"http://%@",serverIP];
    sh_httpClient = [sh_httpClient initWithBaseURL:[NSURL URLWithString:string_url]];
}

-(void)  httpRequest:(NSDictionary *)dic
         requestMethod:(enum HTTP_Requst_Method)type_code
       withURLString:(NSString *)request_url
           withBlock:(callBack)block
{
    NSString* requst_type ;
    if (type_code == HTTP_GET) {
        requst_type=@"GET" ;
    }
    else if (type_code == HTTP_POST)
    {
        requst_type=@"POST";
    }
    else{
        requst_type=@"PUT";
    }
    
    NSMutableURLRequest *re = [sh_httpClient requestWithMethod:requst_type path:request_url parameters:dic];
    [re setTimeoutInterval:5];
    AFHTTPRequestOperation * http_operation = [sh_httpClient HTTPRequestOperationWithRequest:re success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"reponse : \n%@",responseObject);
        block(responseObject,SH_Request_Success);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *error_string = [NSString stringWithFormat:@"%@",error];
        NSData* data = [error_string dataUsingEncoding:NSUTF8StringEncoding];
        block(data,SH_Request_Failed);
    }];
    [sh_httpClient enqueueHTTPRequestOperation:http_operation];
}


@end
