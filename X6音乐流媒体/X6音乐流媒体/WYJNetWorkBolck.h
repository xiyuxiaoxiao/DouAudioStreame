//
//  WYJNetWorkBolck.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetBlock)(id,NSError*,NSInteger);

//- (void)receviceTheObject:(id)object WithError:(NSError *)error Withflag:(NSInteger)flag;
@interface WYJNetWorkBolck : NSObject
- (void)requestWithUrlString:(NSString *)urlStr withDelegate:(id)delegate withTflag:(NSInteger)flag;
@property(copy,nonatomic)NetBlock block;
@end
