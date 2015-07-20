//
//  WYJNetWorkBolck.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "WYJNetWorkBolck.h"

@interface WYJNetWorkBolck ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
//设置全局网络请求属性
@property (nonatomic, strong)NSURLConnection *connection;
//声明Block

//用于接收请求回来的二进制数据流
@property (nonatomic, strong)NSMutableData *data;
//储存请求类型的标记
@property (nonatomic, assign)NSInteger flag;
@end


@implementation WYJNetWorkBolck

//主要的网络请求方法
- (void)requestWithUrlString:(NSString *)urlStr withDelegate:(id)delegate withTflag:(NSInteger)flag
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //初始化全局变量，如果是局部变量可能会提前释放，没法进行代理回调
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];

    //储存全局标记
    self.flag = flag;
    //开始网络请求
    [self.connection start];
}
#pragma mark -- 网络请求代理回调方法
//服务器接收到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //初始化全局二进制流
    self.data = [NSMutableData data];
}
//接收到网络数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    //将数据拼接到全局可变data
    [self.data appendData:data];
}
//网络请求成功，即请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //声明一个error
    NSError *error;
    //进行数据解析，如果出现错误，error指针讲指向错误地址
    id object = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&error];
    //    [self.delegate receviceTheObject:object];
    //判断是否解析出错
    if (error) {
        //代理回调错误信息，二进制流，以及标记
        self.block(self.data,error,self.flag);
    } else {
        //代理回调解析成功的数据，以及对应的标记
        self.block(object,nil,self.flag);
    }
}
//解析出错
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.block(self.data,error,self.flag);
}

@end
