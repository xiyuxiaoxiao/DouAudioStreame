//
//  LrcCell.h
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LrcLine;
@interface LrcCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) LrcLine *lrcLine;
@end
