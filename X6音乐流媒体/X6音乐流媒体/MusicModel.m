//
//  musicModel.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(id)copyWithZone:(NSZone *)zone
{
    MusicModel *copy = [[[self class] allocWithZone:zone] init];
    copy.song_id = [_song_id copy];
    copy.song = [_song copy];
    copy.singer = [_singer copy];
    copy.albumPicLarge = [_albumPicLarge copy];
    copy.albumPicSmall = [_albumPicSmall copy];
    return copy;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    return;
}
@end
