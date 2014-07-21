//
//  SqlData.m
//  ASC
//
//  Created by gussa on 13-9-13.
//  Copyright (c) 2013年 gussa. All rights reserved.
//

#import "SqlData.h"
#import <sqlite3.h>
#import "SH_Settings.h"
@interface SqlData()
{
    dispatch_queue_t queue ;
}
@end

@implementation SqlData
@synthesize database;

+(SqlData*)shared
{
    static SqlData *sqldata;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqldata = [[SqlData alloc] init];
    });
    return sqldata;
}

- (id)init
{
    self = [super init];
    if (self) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        sqlite3_shutdown();
        //Settings *settings = [Settings sharedManager];
        NSString * sqlFileName = [SH_Settings sqlFilePath];
        sqlite3_config(SQLITE_CONFIG_SERIALIZED);
        
        //NSLog(@"the result of sqlite3_config = %@",i == SQLITE_OK?@"ok":@"no");
        if (sqlite3_open([sqlFileName UTF8String], &database)!=SQLITE_OK) {
            NSLog(@"创建数据库失败");
            sqlite3_close(database);
        }
        
        char  **sqlerror = NULL ;
        if (sqlite3_exec(database, "PRAGMA journal_mode=WAL;", NULL, NULL, sqlerror) != SQLITE_OK)
        {
            NSLog(@"Failed to set WAL mode: %s",*sqlerror);
        }
        
        NSString * createNewTable = @"CREATE TABLE IF NOT EXISTS LIGHTS (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,ISON INTEGER,BRIGHTNESS INTEGER);";
        dispatch_async(queue,^{
            if (sqlite3_exec(database, [createNewTable UTF8String], NULL, NULL, sqlerror)!=SQLITE_OK)
            {
                NSLog( @"Error Msg create Table:%s", *sqlerror);
            }
        
        });
        
        
    }
    return self;
}
#pragma mark - 写入WiFi和WWAN流量记录 使用  USAGE_TABLE
-(BOOL)write_usage_in_USAGE_TABLE:(u_int64_t)usage month:(int)month type:(NSString *)connect
{
    __block BOOL return_now = NO ;
    //查看table中现在的记录是不是本月的
    NSString * check_date = @"SELECT MONTH FROM USAGE_TABLE ";
    __block int month_table = -1 ;
    void(^check_month)(void) = ^(void)
    {
        sqlite3_stmt *check_day ;
        if(sqlite3_prepare_v2(database, [check_date UTF8String], -1, &check_day, nil)==SQLITE_OK)
        {
            while (sqlite3_step(check_day)==SQLITE_ROW) {
                month_table=sqlite3_column_int(check_day, 0);
                break ;
            }
        }
        else
        {
            return_now = YES ;
        }
    };
    dispatch_sync(queue, check_month);
    
    if (return_now) {
        return NO ;
    }
    //如果不是同一月份，先清除table
    if (month_table != month) {
        void(^clear_table)(void) = ^(void)
        {
            char * clear = "DELETE FROM USAGE_TABLE";
            if (sqlite3_exec(database, clear, NULL, NULL, nil)!=SQLITE_OK) {
                NSLog(@"clear hour table error #: %s", sqlite3_errmsg(database));
                return_now = YES ;
            }
        };
        dispatch_sync(queue, clear_table);
        if (return_now) {
            return NO ;
        }
    }
    //是同一月份，直接在表中插入
    char *insert  = "INSERT INTO USAGE_TABLE (DATA,MONTH,TYPE) VALUES (?,?,?);";
    void(^insert_data)(void) = ^(void){
        sqlite3_stmt *stmt_of_write ;
        if (sqlite3_prepare_v2(database, insert, -1, &stmt_of_write, nil)==SQLITE_OK) {
            sqlite3_bind_int64(stmt_of_write, 1, usage);
            sqlite3_bind_int(stmt_of_write, 2, month);
            sqlite3_bind_text(stmt_of_write, 3, [connect UTF8String], -1, NULL);
        }
        else
        {
            NSLog(@"插入每小时%@流量统计失败, Step-error #: %s",connect,sqlite3_errmsg(database));
            return_now = YES ;
        }
        
        if (sqlite3_step(stmt_of_write) != SQLITE_DONE) {
            return_now = YES ;
        }
        sqlite3_finalize(stmt_of_write);
    };
    dispatch_sync(queue,insert_data);
    
    if (return_now) {
        return NO ;
    }
    //int i = [self check_hour_table_num];
    return YES;
}

-(int64_t)check_month_usage_in_USAGE_TABLE:(NSDate *)date type:(NSString *)connect
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    int month = [comps month];
    NSString * Check_string = [[NSString alloc] initWithFormat:@"SELECT SUM(DATA) FROM USAGE_TABLE WHERE MONTH ==%d AND TYPE == '%@';",month,connect];
    
    __block int64_t data_usage = -1 ;
    void(^check_month_data)(void) = ^(void)
    {
        sqlite3_stmt *stmt_of_check_month_data ;
        if( sqlite3_prepare_v2(database, [Check_string UTF8String], -1, &stmt_of_check_month_data, nil) == SQLITE_OK)
        {
            //获取整天的记录总和
            while (sqlite3_step(stmt_of_check_month_data)==SQLITE_ROW) {
                data_usage=sqlite3_column_int64(stmt_of_check_month_data, 0);
            }
        }
        else
        {
            NSLog(@"查看本月%@流量统计失败 Prepare-error #: %s",connect, sqlite3_errmsg(database));
            data_usage = 0 ;
        }
        sqlite3_finalize(stmt_of_check_month_data);
    };
    dispatch_sync(queue, check_month_data);
    return data_usage;
}

@end

































