//
//  AudioController.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//



#import "AudioController.h"
#import "DOUAudioStreamer.h"
#import "WYJAudioFile.h"

#import "MusicStreamerController.h"
#import "ZHNetWorkManger.h"
#import "MusicModel.h"
#import "MusicDetailModel.h"
#import "UIView+Extension.h"
#import "LrcView.h"

#import "UIImageView+WebCache.h"
#import "AlertViewAutoDismiss.h"
#define StreamerStatus @"status"
#define StreamerCurrentTime @"currentTime"
#define StreamerBufferingRatio @"bufferingRatio"

@interface AudioController ()<NetWorkDelegate>
@property(strong,nonatomic)DOUAudioStreamer *streamer;
@property(strong,nonatomic)NSMutableDictionary *modelDict;


@property(strong,nonatomic)MusicDetailModel *currentMusicDetailModel;

@property(strong,nonatomic)LrcView *lrcView;
@property (strong, nonatomic) IBOutlet UIView *addLrcView;

@property(strong,nonatomic)NSTimer *time;

@property (strong, nonatomic) IBOutlet UIImageView *backImageView;



@property (strong, nonatomic) IBOutlet UIButton *playButton;

//进度条

@property (strong, nonatomic) IBOutlet UILabel *labelSongName;

@property (strong, nonatomic) IBOutlet UIView *viewBuffer;
@property (strong, nonatomic) IBOutlet UIView *viewPlay;
@property (strong, nonatomic) IBOutlet UIButton *buttonSlide;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalTime;


@property (strong, nonatomic) IBOutlet UISlider *sliderVolume;
@property (strong, nonatomic) IBOutlet UIView *viewVolume;
@property (strong, nonatomic) IBOutlet UIButton *buttonVolume;
@property(assign,nonatomic)BOOL isSingleLoop;

@end

@implementation AudioController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
    self.lrcView = [[LrcView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.addLrcView.height - 20)];

    [self.addLrcView addSubview:self.lrcView];
    
    //旋转音量的View
    self.viewVolume.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    [self.buttonVolume setBackgroundImage:[UIImage imageNamed:@"volume.png"] forState:UIControlStateNormal];
    self.sliderVolume.hidden = YES;
 
    [self.sliderVolume setThumbTintColor:[UIColor whiteColor]];
    
    [self.sliderVolume setThumbImage:[UIImage imageNamed:@"huakuai.png"] forState:UIControlStateHighlighted];
    [self.sliderVolume setThumbImage:[UIImage imageNamed:@"huakuai.png"] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && self.view.window == nil) {
        self.view = nil;
    }
}

//---------------懒加载

//value:音乐详情的模型  key:音乐模型id
-(NSMutableDictionary *)modelDict
{
    if (_modelDict == nil) {
        _modelDict = [NSMutableDictionary dictionary];
    }
    return _modelDict;
}

-(DOUAudioStreamer *)streamer
{
    if (!(_streamer.audioFile == self.currentMusicDetailModel.audioFile)) {
/*
         1.先移除上一次的观察者
         2.初始化
         3.重新添加KVO监听_streamer
*/
        if (self.isObserver) {
            [self removeObserve];
        }
        _streamer = [[DOUAudioStreamer alloc] initWithAudioFile:self.currentMusicDetailModel.audioFile];
        [self addObserver];
    }
    
    return _streamer;
}

//移除 、添加  观察者； KVO监听响应方法
/*
       注意：
                因为当前控制器在上一个控制器里面创建的页面在将要消失的那些方法不走；
            所以要想再页面消失的时候实现一些功能：
                在上个控制器的页面消失的时候，通过属性控制器来调用方法实现

       下面的方法：
           1.移除观察者（注意在控制器消失的时候如果还有观察者 需要移除观察者，不然下次播放的时候出错）
           2.添加观察者
           3.利用KVO监听的属性改变了响应方法
 */
-(void)removeObserve
{
    [_streamer removeObserver:self forKeyPath:StreamerStatus];
    [_streamer removeObserver:self forKeyPath:StreamerBufferingRatio];
    
    self.isObserver = NO;
}
-(void)addObserver
{
    [_streamer addObserver:self forKeyPath:StreamerStatus options:NSKeyValueObservingOptionOld context:nil];
    [_streamer addObserver:self forKeyPath:StreamerBufferingRatio options:NSKeyValueObservingOptionOld context:nil];
    
    self.isObserver = YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    /*
     这个方法不在主线程，而要更新UI界面就应该回到主线程
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //监听到播放器状态改变,也有缓冲状态
        if ([keyPath isEqualToString:StreamerStatus]) {
            
            if (_streamer.status == DOUAudioStreamerPlaying || _streamer.status == DOUAudioStreamerBuffering) {
                
                if (_streamer.status == DOUAudioStreamerPlaying) {
                    self.labelTotalTime.text = [self stringWithTime:_streamer.duration];
                    
                    NSLog(@"开始：%f",_streamer.currentTime);
                    //定时器（当播放刚开始时，会监听好几次）
                    if (self.time != nil) {
                        [self.time invalidate];
                        self.time = nil;
                    }
                    self.time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
                }
                
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateNormal];
                
            }else {
                
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"play@2x.png"] forState:UIControlStateNormal];
                
                [self.time invalidate];
                self.time = nil;
                
                if(_streamer.status == DOUAudioStreamerFinished) {
                   
                    NSLog(@"完成：%f",_streamer.currentTime);
                    
                    [self stop:nil];
                    
                    if (self.isSingleLoop) {
                        [self start];
                    }else {//列表播放
                        [self next:nil];
                    }
    
                }
            }
        }
        
        
        if ([keyPath isEqualToString:StreamerBufferingRatio]) {//监听到缓冲状态改变
            
            double unit = 1000.0;
            
            // 总长度
            double expectedLength = self.streamer.expectedLength / unit / unit;
            // 已经下载长度
            double receivedLength = self.streamer.receivedLength / unit / unit;
            // 下载速度
            double downloadSpeed = self.streamer.downloadSpeed / unit;
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            
            //进度条
            self.viewBuffer.width = receivedLength / expectedLength * width;
        }
        
    });
}


//更新当前将要播放的音乐模型
-(void)updateCurrentMusicDetailModel
{
    MusicModel *model = self.musicModelArray[self.currentIndex];
    MusicDetailModel *musicDetailModel = self.modelDict[model.song_id];
    self.currentMusicDetailModel = musicDetailModel;
}

//更新当前播放时间
-(void)updateCurrentTime
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    double playProgress = 0;
    
    //判断里面的值是不是NAN 是的话返回true
    if (!isnan(_streamer.currentTime / _streamer.duration)) {
        playProgress = self.streamer.currentTime / self.streamer.duration;
    }
    
    self.buttonSlide.x = (width - self.buttonSlide.width) * playProgress;
    self.viewPlay.width = self.buttonSlide.x;
    
    [self.buttonSlide setTitle:[self stringWithTime:_streamer.currentTime] forState:UIControlStateNormal];
}

-(NSString *)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%d:%.02d", minute, second];
}

-(void)removeDataOfMusicDetailModel
{
    [self.modelDict removeAllObjects];
}

#pragma mark 展示播放页面
//先暂停掉上一首  也可以通过传参在show方法里面判断是不是点击歌曲了
-(void)showWithChangeMusic:(BOOL)change
{
    
    if (change) {
        [self stop:nil];
    }else {
        
        //是同一首歌，添加观察者
        if (!self.isObserver) {
            [self addObserver];
        }
    }
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //当window正在显示或隐藏的时候 不允许有交互事件
    window.userInteractionEnabled = NO;
    
    self.view.hidden = NO;
    [window addSubview:self.view];
    self.view.height = [UIScreen mainScreen].bounds.size.height;
    self.view.y = self.view.height;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        if (change) {
            [self start];
        }
    }];
}

//定时器响应
-(void)timeAction
{
    //跟踪歌词
    [self.lrcView setCurrentTime:self.streamer.currentTime];
    [self updateCurrentTime];
}

//添加歌词，背景图片
-(void)setLrcAndImage
{
    //添加歌词
    [self.lrcView setLrcname:self.currentMusicDetailModel.lrcLink];
    
    //添加背景图片
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.currentMusicDetailModel.songPicRadio] placeholderImage:[UIImage imageNamed:@"backImage.png"] options:SDWebImageRetryFailed];
    //设置歌名，歌手
    self.labelSongName.text = [NSString stringWithFormat:@"%@ ： %@",self.currentMusicDetailModel.artistName,self.currentMusicDetailModel.songName];
}

//清除界面，歌词，背景图片，进度等
-(void)clearAll
{
    //清除歌词
    [self.lrcView clearLrc];
    
    //清除图片
    [self.backImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"backImage.png"] options:SDWebImageRetryFailed];
    
    //还原进度条
    self.buttonSlide.x = 0;
    self.viewPlay.width = 0;
    self.viewBuffer.width = 0;
    [self.buttonSlide setTitle:@"" forState:UIControlStateNormal];
    self.labelTotalTime.text = @"";
    
    //清除歌名
    self.labelSongName.text = [NSString stringWithFormat:@""];
}


#pragma mark 网络请求musicDetail
-(void)request
{
    MusicModel *model = self.musicModelArray[self.currentIndex];
    
    NSString *urlString = [NSString stringWithFormat:@"http://ting.baidu.com/data/music/links?songIds=%@",model.song_id];
    NSLog(@"%@",model.song_id);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ZHNetWorkManger *manger = [[ZHNetWorkManger alloc] init];
    [manger requestWithUrlString:urlString withDelegate:self withTflag:(200 + self.currentIndex)];
    
}

//网络请求代理
-(void)receviceTheObject:(id)object WithError:(NSError *)error Withflag:(NSInteger)flag
{
    if (error) {
        return;
    }else {
        
        //判断是不是当前需要请求的数据
        if (!(flag - 200 == self.currentIndex)) {
            return;
        }
        
        //判断请求的数据是否符合
        if (![[object objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        
        //解析数据，创建musicDetailModel 模型
        NSDictionary *data = [(NSDictionary *)object objectForKey:@"data"];

        NSDictionary *dict = [[data objectForKey:@"songList"] firstObject];
        
        MusicDetailModel *detailModel = [[MusicDetailModel alloc] init];
        [detailModel setValuesForKeysWithDictionary:dict];
        
/*
         model作为key需要实现copy协议(如果把model作为key，字典没法判断model类型的key值相等)；
         所以改用model的一个属性 song_id 作为key
*/
        MusicModel * musicModel = self.musicModelArray[self.currentIndex];
        [self.modelDict setObject:detailModel forKey:musicModel.song_id];
        
        //设置musicDetailModel的WYJAudioFile
        
        NSString *songID = [[detailModel.songLink componentsSeparatedByString:@"?"] firstObject];
        
        NSString *address = [NSString stringWithFormat:@"%@?xcode=%@",songID,[data objectForKey:@"xcode"]];
        NSLog(@"%@",address);
        
        detailModel.audioFile = [[WYJAudioFile alloc] initWithURL:address];
        
        
        
        [self updateCurrentMusicDetailModel];
        //播放
        [self play];
    }
}


#pragma mark button事件

#pragma mark 下拉、歌词控制
//隐藏：
- (IBAction)exit:(UIButton *)sender {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
    
    //移除观察者
    if (self.isObserver) {
        [self removeObserve];
    }
}

//显示歌词的事件
- (IBAction)lrcAction:(UIButton *)sender {
    
    if (self.addLrcView.isHidden) {
        self.addLrcView.hidden = NO;
        sender.selected = YES;
    }else {
        self.addLrcView.hidden = YES;
        sender.selected = NO;
    }
}


#pragma mark 播放\暂停 按钮

// 播放\暂停
- (IBAction)onePlay:(id)sender {
    if (_streamer.status == DOUAudioStreamerPlaying) {
        [self pause];
    }else {
        [self start];
    }
}

// 开始播放（只是先获取到streamer）
- (void)start {

    if (!(self.musicModelArray.count > 0)) {
        //没有歌曲
        return;
    }

    /*
            先判断字典里面有没有对应的MusicDetailModel
            没有就创建，有就直接用
     */
  
    if (self.currentMusicDetailModel) {
        [self play];
    }else {
        [self request];
    }
}

//播放
-(void)play{
    [self.streamer play];
    
    //设置歌词图片
    [self setLrcAndImage];
}
- (void)pause {
    NSLog(@"%f",_streamer.volume);
    [_streamer pause];
}
- (IBAction)stop:(UIButton *)sender {
   
    [_streamer stop];

    [self clearAll];
}
//下一首
- (IBAction)next:(UIButton *)sender {
    
    [self stop:nil];
    
    if (self.currentIndex < self.musicModelArray.count - 1) {
        self.currentIndex ++;
    }else {
        self.currentIndex = 0;
    }
    [self updateCurrentMusicDetailModel];
    [self start];
}
//上一首
- (IBAction)last:(UIButton *)sender {
    
    [self stop:nil];
    
    if (self.currentIndex > 0 && self.currentIndex < self.musicModelArray.count) {
        self.currentIndex --;
    }else if(self.currentIndex == 0 && self.musicModelArray.count > 0){
        self.currentIndex = self.musicModelArray.count - 1;
    }else {
        self.currentIndex = 0;
    }
    
    [self updateCurrentMusicDetailModel];
    [self start];
}


//总进度条点击手势 (已经被注释掉)
- (IBAction)tapprogressAction:(UITapGestureRecognizer *)sender {
    
    //设置当前时间后，在连续播放同一首歌，歌曲的当前时间会加载最后更新的当前的时间上，所以取消
/*
 
     CGPoint point = [sender locationInView:sender.view];
     self.streamer.currentTime = (point.x / sender.view.width) * self.streamer.duration;
     
     [self updateCurrentTime];
 
*/
    
}


#pragma mark 音量响应

- (IBAction)slideVolume:(UISlider *)sender {
    
    _streamer.volume = sender.value;
    
    if (sender.value == 0) {
        [self.buttonVolume setBackgroundImage:[UIImage imageNamed:@"jingyin.png"] forState:UIControlStateNormal];
    }else {
        [self.buttonVolume setBackgroundImage:[UIImage imageNamed:@"volume.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)buttonVolume:(UIButton *)sender {
    if (self.sliderVolume.hidden) {
        self.sliderVolume.hidden = NO;
    }else {
        self.sliderVolume.hidden = YES;
    }
}

#pragma mark 播放模式
- (IBAction)playModel:(UIButton *)sender {
    if (self.isSingleLoop) {
        self.isSingleLoop = NO;
        sender.selected = NO;
        
        AlertViewAutoDismiss *alert = [[AlertViewAutoDismiss alloc] initWithTitle:@"列表播放" message:nil];
        [alert show];
        
    }else {
        self.isSingleLoop = YES;
        sender.selected = YES;
        
        AlertViewAutoDismiss *alert = [[AlertViewAutoDismiss alloc] initWithTitle:@"单曲循环" message:nil];
        [alert show];
    }
}


@end
