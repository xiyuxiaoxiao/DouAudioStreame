//
//  AudioController.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

/*
 
 歌词：加前缀http://ting.baidu.com（为搜索获取到数据的路径）在拼接lrcLink字段
 
 */

#warning message 在缓冲的时候没有缓冲完，控制器还不能销毁，销毁就崩溃，因为正在网络请求
#warning message 在重新请求的数据后没有清空上次字典里面的数据

#import <UIKit/UIKit.h>

@interface AudioController : UIViewController
@property(strong,nonatomic)NSMutableArray *musicModelArray;
@property(assign,nonatomic)NSInteger currentIndex;

@property(assign,nonatomic)BOOL isObserver;

-(void)showWithChangeMusic:(BOOL)change;
-(void)removeObserve;

-(void)updateCurrentMusicDetailModel;
-(void)removeDataOfMusicDetailModel;
@end
