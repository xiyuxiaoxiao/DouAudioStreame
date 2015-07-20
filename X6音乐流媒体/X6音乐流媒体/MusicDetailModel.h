//
//  musicDetailModel.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYJAudioFile.h"
@interface MusicDetailModel : NSObject

/*
 
 歌词：加前缀http://ting.baidu.com（为搜索获取到数据的路径）在拼接lrcLink字段
 
 */

@property(copy,nonatomic)NSString *albumName;
@property(copy,nonatomic)NSString *artistName;
@property(copy,nonatomic)NSString *format;
@property(copy,nonatomic)NSString *lrcLink;
@property(copy,nonatomic)NSString *songLink;
@property(copy,nonatomic)NSString *songName;
@property(copy,nonatomic)NSString *songPicBig;
@property(copy,nonatomic)NSString *songPicRadio;
@property(copy,nonatomic)NSString *songPicSmall;

@property(strong,nonatomic)WYJAudioFile *audioFile;
@end
