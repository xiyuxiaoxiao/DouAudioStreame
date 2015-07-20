//
//  RequstController.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "MusicStreamerController.h"
#import "ZHNetWorkManger.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
#import "musicModelCell.h"

#import "AudioController.h"
@interface MusicStreamerController ()<NetWorkDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *modelArray;

@property(strong,nonatomic)AudioController *audioVC;
@end

@implementation MusicStreamerController

-(AudioController *)audioVC
{
    if (!_audioVC) {
        _audioVC = [[AudioController alloc] init];
    }
    return _audioVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelArray = [NSMutableArray array];
    
    self.textField.delegate = self;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && self.view.window == nil) {
        self.view = nil;
    }
}


//搜索
- (IBAction)searchRequest:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"http://mp3.baidu.com/dev/api/?tn=getinfo&ct=0&word=%@&ie=utf-8&format=json",self.textField.text];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ZHNetWorkManger *manager = [[ZHNetWorkManger alloc] init];
    [manager requestWithUrlString:urlString withDelegate:self withTflag:100];
}


//网络请求代理
-(void)receviceTheObject:(id)object WithError:(NSError *)error Withflag:(NSInteger)flag
{
    if (error) {
        return;
    }else {
        NSArray *array = object;
        if (array.count > 0) {
            [self.modelArray removeAllObjects];
        }
        for (NSDictionary *dict in array) {
            MusicModel *model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            [self.modelArray addObject:model];
        }
        
        [self.tableView reloadData];
        
        //数据更新 对AudioController的数据也立即更新
        self.audioVC.musicModelArray = [NSMutableArray arrayWithArray:self.modelArray];
        self.audioVC.currentIndex = 0;
        [self.audioVC removeDataOfMusicDetailModel];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

-(musicModelCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    musicModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicModelCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"musicModelCell" owner:self options:nil] lastObject];
    }
    MusicModel *model = self.modelArray[indexPath.row];
    cell.songLabel.text = model.song;
    cell.singerLabel.text = model.singer;
    
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.albumPicSmall] placeholderImage:nil options:SDWebImageRetryFailed];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


#pragma mark 点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.audioVC.currentIndex = indexPath.row;
    [self.audioVC updateCurrentMusicDetailModel];
    [self.audioVC showWithChangeMusic:YES];
}

#warning mark 需要注意播放控制器没有数据，就不能跳转
- (IBAction)showAudio {
    [self.audioVC showWithChangeMusic:NO];
}


#pragma mark 键盘撤销
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    //如果有观察者 就移除
    if (self.audioVC.isObserver) {
        [self.audioVC removeObserve];
    }
}
@end
