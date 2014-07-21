//
//  SH_Equipment.m
//  Smart_Home
//
//  Created by mobisys on 14-7-13.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_Equipment.h"

@implementation SH_Equipment

-(id)initWithName:(NSString*)name
         withRoom:(NSString*)roomName
         withType:(NSString*)type
{
    if (self = [super init]) {
        _name = [[NSString alloc] initWithString:name] ;
        _room = roomName ;
        _type = type ;
        _picName=@"" ;
    }
    return self ;
}
-(NSString*)getName
{
    return _name ;
}

-(NSString*)getType
{
    return _type ;
}

-(NSString*)getRoom
{
    return _room ;
}

-(NSString*)getPicName
{
    return _picName ;
}

@end
