//
//  SH_Light.h
//  Smart_Home
//
//  Created by mobisys on 14-7-1.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SH_Equipment.h"
@interface SH_Light : SH_Equipment

-(id)initWithName:(NSString*)name
         withRoom:(NSString*)roomName
         withType:(NSString*)type
isSupportBrightness:(BOOL)sup
   withBrightness:(int)brightness
             isON:(BOOL)isOn;

-(void)setName:(NSString*)name;

-(BOOL)turnLight:(BOOL)isToOn ;

-(int )setBrightness:(int)brightness ;

-(BOOL)isOn ;

-(int )getBrightness ;

-(BOOL)isSupportBrightness ;

-(NSString*)getPicName;
@end
