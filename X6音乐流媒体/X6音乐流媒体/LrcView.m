//
//  LrcView.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "LrcView.h"
#import "UIView+Extension.h"
#import "LrcLine.h"
#import "LrcCell.h"
#import "Colours.h"
#import "ZHNetWorkManger.h"
@interface LrcView ()<UITableViewDataSource, UITableViewDelegate,NetWorkDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *lrcLines;
@property (nonatomic, assign) int currentIndex;
@end


@implementation LrcView

- (NSMutableArray *)lrcLines
{
    if (_lrcLines == nil) {
        self.lrcLines = [NSMutableArray array];
    }
    return _lrcLines;
}

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 1.添加表格控件
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
}

#pragma mark - 公共方法

-(void)clearLrc
{
    [self.lrcLines removeAllObjects];
    [self.tableView reloadData];
}


- (void)setLrcname:(NSString *)lrcLink
{
    
    
//    _lrcname = [lrcname copy];
    
    // 0.清空之前的歌词数据
    [self.lrcLines removeAllObjects];
    
    
    
    NSString *lrc = [NSString stringWithFormat:@"http://ting.baidu.com%@",lrcLink];
    
    // 1.加载歌词文件
    
    NSURL *url = [NSURL URLWithString:lrc];

    NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];

    NSArray *lrcCmps = [lrcStr componentsSeparatedByString:@"\n"];
    
    // 2.输出每一行歌词
    for (NSString *lrcCmp in lrcCmps) {
        LrcLine *line = [[LrcLine alloc] init];
        
        if (![lrcCmp hasPrefix:@"["]) continue;
        
        // 如果是歌词的头部信息（歌名、歌手、专辑）
        if ([lrcCmp hasPrefix:@"[ti:"] || [lrcCmp hasPrefix:@"[ar:"] || [lrcCmp hasPrefix:@"[al:"] ) {
            NSString *word = [[lrcCmp componentsSeparatedByString:@":"] lastObject];
            line.word = [word substringToIndex:word.length - 1];
        } else { // 非头部信息
            NSArray *array = [lrcCmp componentsSeparatedByString:@"]"];
            line.time = [[array firstObject] substringFromIndex:1];
            line.word = [array lastObject];
        }
        [self.lrcLines addObject:line];
    }
    
    // 3.刷新表格
    NSLog(@"%ld",self.lrcLines.count);
    [self.tableView reloadData];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    if (currentTime < _currentTime) {
        self.currentIndex = -1;
    }
    
    _currentTime = currentTime;
    
    int minute = currentTime / 60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d", minute, second, msecond];

    for (int idx = self.currentIndex + 1; idx < self.lrcLines.count; idx++) {

        LrcLine *currentLine = self.lrcLines[idx];
        // 当前模型的时间
        NSString *currentLineTime = currentLine.time;
        // 下一个模型的时间
        NSString *nextLineTime = nil;
        NSUInteger nextIdx = idx + 1;
        if (nextIdx < self.lrcLines.count) {
            LrcLine *nextLine = self.lrcLines[nextIdx];
            nextLineTime = nextLine.time;
        }
        
        // 判断是否为正在播放的歌词
        if (
            ([currentTimeStr compare:currentLineTime] != NSOrderedAscending)
            && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending)
            && self.currentIndex != idx) {
            // 刷新tableView
            NSArray *reloadRows = @[
                                    [NSIndexPath indexPathForRow:self.currentIndex inSection:0],
                                    [NSIndexPath indexPathForRow:idx inSection:0]
                                    ];
            self.currentIndex = idx;
            [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            
            
            // 滚动到对应的行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LrcCell *cell = [LrcCell cellWithTableView:tableView];
    cell.lrcLine = self.lrcLines[indexPath.row];
    
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.textLabel.textColor = [UIColor skyBlueColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return cell;
}

@end
