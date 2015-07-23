//
//  MusicDownLoadTool.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/20.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "MusicDownLoadTool.h"

@interface MusicDownLoadTool ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    //总大小
    long long _total;
    
    //当前已经下载的大小
    long long _current;
}

//文件句柄
@property(nonatomic,strong) NSFileHandle *fileHandle;

//网络请求对象
@property(nonatomic,strong) NSURLConnection *conn;

//进度条
@end

@implementation MusicDownLoadTool

-(void)downLoad
{
    
    NSString *songID = [[self.model.songLink componentsSeparatedByString:@"?"] firstObject];
    
    NSString *address = [NSString stringWithFormat:@"%@?xcode=%@",songID,self.model.xcode];

    NSURL *url = [NSURL URLWithString:address];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    NSString *range = [NSString stringWithFormat:@"bytes:%lld",_current];
    
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [self.conn start];
}

-(void)cancelDownLoad
{
    [self.conn cancel];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _total = [response expectedContentLength];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    //创建文件
    NSFileManager *manage = [NSFileManager defaultManager];
    
    NSString *filePath = [caches stringByAppendingString:@"/localMusic"];
    [manage createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *musicFile = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@.mp3",self.model.songName]];
    [manage createFileAtPath:musicFile contents:nil attributes:nil];
    NSLog(@"%@",musicFile);
    
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:musicFile];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //总共下载的大小
    _current += data.length;

    //指向文件最末尾处
    [self.fileHandle seekToEndOfFile];;
    
    //向文件中写数据
    [self.fileHandle writeData:data];
  
    [self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:YES];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"over");
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"错误");
}

-(void)updateProgress
{
    self.block((double)_current / _total);
}
@end
