//
//  SH_Settings.h
//  Smart_Home
//
//  Created by mobisys on 14-7-1.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import <Foundation/Foundation.h>
#define sql_filename                @"data.sqlite3"

enum SH_Content_State
{
    SH_Equipment_Show = 0 ,
    SH_Room_Show = 1<<0
};

@interface SH_Settings : NSObject
@property (nonatomic,retain) NSMutableArray* smartDeviceList ;
@property (nonatomic,retain) NSMutableArray* roomList ;
@property (nonatomic,retain) NSDictionary* smartDeviceDic ;//按设备种类分
@property (nonatomic,retain) NSDictionary* roomDeviceDic ;//按房间分
@property (nonatomic)        float iosVersion ;
@property (nonatomic,retain) NSString * serverAddress ;

+(id)sharedSettings ;
+(NSString *)getFilePath:(NSString*)file_name;
+(NSString *)sqlFilePath ;
@end
