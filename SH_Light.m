//
//  SH_Light.m
//  Smart_Home
//
//  Created by mobisys on 14-7-1.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_Light.h"


@implementation SH_Light
{
    BOOL _isSupportBrightness ;
    BOOL isON ;
    int _brightness ;
}

-(id)initWithName:(NSString*)name withRoom:(NSString *)roomName withType:(NSString*)type isSupportBrightness:(BOOL)sup withBrightness:(int)brightness isON:(BOOL)isOn
{
    if (self = [super init]) {
        _name = [[NSString alloc] initWithString:name] ;
        _room = roomName ;
        _type = type ;
        _isSupportBrightness = sup ;
        _brightness = brightness ;
        isON = isOn ;
    }
    return self ;
}

-(id)init
{
    if (self = [super init]) {
        _name = @"灯" ;
        _brightness = 0 ;
        isON = NO ;
    }
    return self ;
}

#pragma mark - setter methods

-(void)setName:(NSString*)name
{
    _name = name ;
}

-(BOOL)turnLight:(BOOL)isToOn
{
    isON = isToOn ;
    return isON ;
}

-(int )setBrightness:(int)brightness
{
    _brightness = brightness ;
    return  _brightness ;
}

#pragma mark - getter methods

-(BOOL)isSupportBrightness
{
    return _isSupportBrightness ;
}

-(BOOL)isOn
{
    return isON ;
}

-(int )getBrightness
{
    return _brightness ;
}

-(NSString*)getPicName
{
    return @"Light.jpg";
}

@end
