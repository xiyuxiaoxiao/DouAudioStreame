//
//  WYJAudioFile.h
//  xcode5音乐
//
//  Created by lanou3g on 15/7/9.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioStreamer.h"
@interface WYJAudioFile : NSObject<DOUAudioFile>

- (instancetype)initWithURL:(NSString *)urlString;

-(NSURL *)audioFileURL;
@end
