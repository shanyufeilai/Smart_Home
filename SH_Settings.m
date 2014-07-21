//
//  SH_Settings.m
//  Smart_Home
//
//  Created by mobisys on 14-7-1.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_Settings.h"
#import "SH_Light.h"
#import <sqlite3.h>

@implementation SH_Settings
{
    sqlite3 *dataBase ;
}
@synthesize smartDeviceList ;
@synthesize roomList ;
@synthesize smartDeviceDic ;
@synthesize iosVersion ;
@synthesize serverAddress ;
@synthesize roomDeviceDic;

+(id)sharedSettings
{
    static SH_Settings *settings = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[self alloc] init];
    });
    
    return settings ;
}

-(id)init
{
    if (self = [super init]) {
        serverAddress = @"" ;
        
        smartDeviceList = [[NSMutableArray alloc] initWithObjects:@"灯具",@"空调", nil];
        roomList = [[NSMutableArray alloc] initWithObjects:@"主卧",@"侧卧", nil];
        
        SH_Light *light1= [[SH_Light alloc] initWithName:@"侧卧主灯" withRoom:@"侧卧" withType:@"Normal" isSupportBrightness:NO withBrightness:100 isON:YES];
        SH_Light *light2 = [[SH_Light alloc] initWithName:@"主卧读书灯" withRoom:@"主卧"  withType:@"Normal" isSupportBrightness:YES withBrightness:40 isON:NO];
        
        smartDeviceDic = @{@"灯具":@[light1,light2],@"空调":@[]};
        //roomdic中嵌套的两个keys数量和名称必须和smartDeviceList和roomList匹配
        roomDeviceDic = @{@"主卧": @{@"灯具":@[light2],@"空调":@[]},
                          @"侧卧": @{@"灯具":@[light1],@"空调":@[]}
                          };
        
        iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue] ;
    }
    return self;
}

+(NSString *)getFilePath:(NSString*)file_name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDictionary = [paths objectAtIndex:0];
    return  [docDictionary stringByAppendingPathComponent:file_name];
}

+(NSString *)sqlFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDictionary = [paths objectAtIndex:0];
    return  [docDictionary stringByAppendingPathComponent:sql_filename];
}

@end
