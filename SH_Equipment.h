//
//  SH_Equipment.h
//  Smart_Home
//
//  Created by mobisys on 14-7-13.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_Equipment : NSObject
{
    int id ;
    NSString* _name ;
    NSString* _room ;
    NSString* _type ;
    NSString* _picName ;
}

-(id)initWithName:(NSString*)name
         withRoom:(NSString*)roomName
         withType:(NSString*)type;

-(NSString*)getName ;

-(NSString*)getType ;

-(NSString*)getRoom;

-(NSString*)getPicName;

@end
