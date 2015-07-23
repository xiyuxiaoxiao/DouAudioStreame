//
//  MusicDownLoadTool.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/20.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MusicDetailModel.h"
typedef void(^ProgressDownLoad)(double);

@interface MusicDownLoadTool : NSObject

@property(strong,nonatomic)MusicDetailModel *model;
@property(copy,nonatomic)ProgressDownLoad block;

-(void)downLoad;
@end
