//
//  LrcView.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LrcView : UIView
/**
 *  歌词的文件名
 */
@property (nonatomic, copy) NSString *lrcname;

@property (nonatomic, assign) NSTimeInterval currentTime;

-(void)clearLrc;
- (void)setLrcname:(NSString *)lrcLink;
- (void)setCurrentTime:(NSTimeInterval)currentTime;
@end
