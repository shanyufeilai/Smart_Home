//
//  SqlData.h
//  ASC
//
//  Created by gussa on 13-9-13.
//  Copyright (c) 2013年 gussa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class Settings;

@interface SqlData : NSObject

@property (nonatomic) sqlite3 *database;

+(SqlData *)shared ;
-(BOOL)write_usage_in_USAGE_TABLE:(u_int64_t)usage month:(int)month type:(NSString *)connect;
-(int64_t)check_month_usage_in_USAGE_TABLE:(NSDate *)date type:(NSString *)connect;
@end
