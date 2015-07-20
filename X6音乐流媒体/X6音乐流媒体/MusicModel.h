//
//  musicModel.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject<NSCopying>
@property(copy,nonatomic)NSString *song_id;

@property(copy,nonatomic)NSString *song;//歌曲名
@property(copy,nonatomic)NSString *singer;//歌唱着
@property(copy,nonatomic)NSString *albumPicLarge;
@property(copy,nonatomic)NSString *albumPicSmall;


@end
