//
//  LrcLine.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcLine : NSObject
/**
 *  时间点
 */
@property (nonatomic, copy) NSString *time;
/**
 *  词
 */
@property (nonatomic, copy) NSString *word;
@end
