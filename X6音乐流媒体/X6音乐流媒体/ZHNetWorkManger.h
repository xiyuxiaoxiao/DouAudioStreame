//
//  ZHNetWorkManger.h
//  ZHNetworkManger_delegate
//
//  Created by 邹浩 on 15/6/22.
//  Copyright (c) 2015年 蓝鸥. All rights reserved.
//

#import <Foundation/Foundation.h>
//协议声明
@protocol NetWorkDelegate <NSObject>
//协议方法，用于回调请求数据，以及错误信息和请求标记
- (void)receviceTheObject:(id)object WithError:(NSError *)error Withflag:(NSInteger)flag;

@end


@interface ZHNetWorkManger : NSObject
//网络请求主要调用的方法，实例方法
- (void)requestWithUrlString:(NSString *)urlStr withDelegate:(id)delegate withTflag:(NSInteger)flag;



@end
