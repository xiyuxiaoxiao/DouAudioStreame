//
//  WYJAudioFile.m
//  xcode5音乐
//
//  Created by lanou3g on 15/7/9.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "WYJAudioFile.h"
#import "ZHNetWorkManger.h"
@interface WYJAudioFile ()<NetWorkDelegate>
@property(strong,nonatomic)NSURL *url;
@end

@implementation WYJAudioFile


- (instancetype)initWithURL:(NSString *)urlString
{
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:urlString];
    }
    return self;
}

//- (instancetype)initWithURL:(NSString *)music_id Withindex:(NSInteger)index
//{
//   NSString *urlString = [NSString stringWithFormat:@"http://ting.baidu.com/data/music/links?songIds=%@",music_id];
//    
//    ZHNetWorkManger *manger = [[ZHNetWorkManger alloc] init];
//    [manger requestWithUrlString:urlString withDelegate:self withTflag:(200 + index)];
//    
//}



-(NSURL *)audioFileURL
{
//   return [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"燕归巢.mp3" ofType:nil]];
//    return [NSURL URLWithString:@"http:\/\/zhangmenshiting.baidu.com\/data2\/music\/134380880\/3823382175600.mp3?xcode=0543c3fb6c4301b1718197b4a0f16666"];
    return self.url;
}
@end
