//
//  ZWPlayingViewController.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWPlayingViewController.h"
#import "UIView+Extension.h"
#import "ZWMusicModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ZWMusicTool.h"
#import "ZWAudioManager.h"
#import "ZWLrcView.h"
#import "ZWLrcLineModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZWPlayingViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,strong) ZWMusicModel * currentMusic;
@property (nonatomic,strong) AVAudioPlayer* audioPlayer;
@property (nonatomic,strong) NSTimer * sliderTimer;
@property (nonatomic,assign) BOOL  isInterruption;
@property (nonatomic,strong) NSMutableArray * lrcLines;
@property (nonatomic,assign) NSInteger  currentIndex;//记录当前歌词序号
@property (nonatomic,assign) NSTimeInterval  currentTime;

@property (nonatomic,strong) CADisplayLink * lrcTimer;
@property (nonatomic,strong) ZWLrcView * lrcView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *songImagView;
@property (weak, nonatomic) IBOutlet UIButton *lrcOrPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *showProgressBtn;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *slider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *singerLab;
@property (weak, nonatomic) IBOutlet UILabel *songLab;
@property (weak, nonatomic) IBOutlet UIView *exitBtn;
@property (weak, nonatomic) IBOutlet UIButton *lrcBtn;

@end

@implementation ZWPlayingViewController

-(NSMutableArray *)lrcLines
{
    if (!_lrcLines) {
        _lrcLines = [NSMutableArray array];
    }
    return _lrcLines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //处理中断事件
    [self handleInterrup];
    //创建歌词界面
    [self setupLrcView];

    
}

//添加歌词界面
-(void)setupLrcView
{
    ZWLrcView * lrcView = [[ZWLrcView alloc] init];
    self.lrcView = lrcView;
    lrcView.hidden = YES;
    [self.topView addSubview:lrcView];
    [self.topView insertSubview:lrcView atIndex:2];
    lrcView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topView.height + 50);
//    [self.topView insertSubview:self.exitBtn aboveSubview:lrcView];
//    [self.topView insertSubview:self.lrcBtn aboveSubview:lrcView];
}


//处理中断时间
-(void)handleInterrup
{
    [ZWAudioManager defaultManager].block = ^(NSInteger tag){
        
        switch (tag) {
            case AVAudioSessionInterruptionTypeBegan:
            {
                if (self.audioPlayer.isPlaying) {
                    
                    self.isInterruption = YES;
                     [self playOrPauseBtn:nil];
                }
                
            }
                break;
            case AVAudioSessionInterruptionTypeEnded:
            {
                if (self.isInterruption) {
                    
                    self.isInterruption = NO;
                      [self playOrPauseBtn:nil];
                }
            }
                break;
                
            default:
                break;
        }
    };

}

//重置播放数据
-(void)resetPlayMusic
{
    self.songImagView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.songLab.text = nil;
    self.singerLab.text = nil;
    
    [[ZWAudioManager defaultManager] stopMusic:self.currentMusic.filename];
    self.audioPlayer = nil;
   
    self.timeLabel.text = [self timeStrFrom:0];
    self.slider.x = 0;
    self.progressView.width = self.slider.center.x;
    [self.slider setTitle:[self timeStrFrom:0] forState:UIControlStateNormal];
    
    //清空歌词
    self.lrcView.fileName = @"";
    self.lrcView.currentTime = 0;
    
    [self removeSliderTimer];
    [self removeLrcTimer];
}

//显示界面
-(void)show
{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    self.view.frame = keyWindow.bounds;
    self.view.y = self.view.height;
    [keyWindow addSubview:self.view];
    self.view.hidden = NO;
    keyWindow.userInteractionEnabled = NO;
    
    //切换歌曲
    if (self.currentMusic != [ZWMusicTool willPlayingMusic]) {
        
        //清空数据
        [self resetPlayMusic];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.y = 0;
        
    } completion:^(BOOL finished) {
        
        keyWindow.userInteractionEnabled = YES;
        [self startPlayMusic];
    }];
    
}

//添加滑块定时器
-(void)addSliderTimer
{
    if (!self.sliderTimer) {
        
        [self updateSlider];//理解触发执行
        self.sliderTimer = [NSTimer timerWithTimeInterval:1
                                                   target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.sliderTimer forMode:NSRunLoopCommonModes];
    }
   
}

//添加歌词定时器
-(void)addLrcTimer
{

    if (!self.lrcTimer) {
    
        self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcTimer)];
        [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    
}

//更新歌词
-(void)updateLrcTimer
{
    self.lrcView.currentTime = self.audioPlayer.currentTime;
    [self setCurrentTime:self.audioPlayer.currentTime];
}

-(void)setCurrentTime:(NSTimeInterval)currentTime
{
    if (_currentTime > currentTime) {
        self.currentIndex = 0;
    }
    _currentTime = currentTime;
    
    int minute = currentTime/60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString * currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d",minute,second,msecond];
    
    for (NSInteger i = self.currentIndex; i < self.lrcLines.count; i++) {
        
        ZWLrcLineModel * currentM = self.lrcLines[i];
        NSString * currentTime = currentM.time;
        NSString * nextLineTime = nil;
        
        if (i + 1 < self.lrcLines.count) {
            
            ZWLrcLineModel * nextM = self.lrcLines[i+1];
            nextLineTime = nextM.time;
        }
        if (([currentTimeStr compare:currentTime] != NSOrderedAscending) && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending) && (self.currentIndex != i)) {
            
            self.currentIndex = i;
             [self setLockScreenMusicShow];
          
        }
        
        
    }
    
   
    
}


//更新滑块
-(void)updateSlider
{
    double percentage = self.audioPlayer.currentTime / self.audioPlayer.duration;
    self.slider.x = percentage * (self.view.width - self.slider.width);
    [self.slider setTitle:[self timeStrFrom:self.audioPlayer.currentTime] forState:UIControlStateNormal];
    self.progressView.width = self.slider.center.x;
}

//移除滑块定时器
-(void)removeSliderTimer
{
    if (self.sliderTimer) {
        
        [self.sliderTimer invalidate];
        self.sliderTimer = nil;
    }
}

//移除歌词定时器
-(void)removeLrcTimer
{
    if (self.lrcTimer) {
        [self.lrcTimer invalidate];
        self.lrcTimer = nil;
    }
}

//开始播放
-(void)startPlayMusic
{
    //如果这次播放歌曲和当前播放的歌曲一样，不用重新赋值，开始定时器就可以了(隐藏界面的时候有销毁定时器)
    if (self.currentMusic == [ZWMusicTool willPlayingMusic]) {
        [self addSliderTimer];
        [self addLrcTimer];
        return;
    }
    
    //初始化赋值
    self.currentMusic = [ZWMusicTool willPlayingMusic];
    self.songImagView.image = [UIImage imageNamed:self.currentMusic.icon];
    self.songLab.text = self.currentMusic.name;
    self.singerLab.text = self.currentMusic.singer;
    
    //播放
    self.audioPlayer = [[ZWAudioManager defaultManager] playingMusic:self.currentMusic.filename];
    self.audioPlayer.delegate = self;
    self.playOrPauseBtn.selected = YES;
    self.timeLabel.text = [self timeStrFrom:self.audioPlayer.duration];
    [self addSliderTimer];
    self.lrcView.fileName = self.currentMusic.lrcname;
    self.lrcLines = [ZWLrcLineModel lrcLinesWithFileName:self.currentMusic.lrcname];
    [self addLrcTimer];

    
    
}

//切换歌词界面
- (IBAction)lrcOrPhotoBtn:(UIButton *)sender {
    
    if (self.lrcView.isHidden) {
        
        self.lrcView.hidden = NO;
        sender.selected = YES;
        
    }else
    {
        self.lrcView.hidden = YES;
        sender.selected = NO;
    }
    
}

// 退出界面
- (IBAction)exitBtn:(id)sender {
    
    !self.block ?:self.block(self.audioPlayer.isPlaying);
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.y = self.view.height;
        
    } completion:^(BOOL finished) {
        
        self.view.hidden = YES;
        self.lrcView.hidden = YES;
        window.userInteractionEnabled = YES;
        //移除定时器
        [self removeLrcTimer];
        [self removeSliderTimer];
        
    }];
    
}

//播放、暂停
- (IBAction)playOrPauseBtn:(id)sender {
    
    if (self.playOrPauseBtn.selected == NO) {
        self.playOrPauseBtn.selected = YES;
        [[ZWAudioManager defaultManager] playingMusic:self.currentMusic.filename];
    }else
    {
        self.playOrPauseBtn.selected = NO;
        [[ZWAudioManager defaultManager] pauseMusic:self.currentMusic.filename];
    }
    
}

//上一首
- (IBAction)previousBtn:(id)sender {
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    [[ZWAudioManager defaultManager] stopMusic:self.currentMusic.filename];
    [ZWMusicTool setPlayingMusic:[ZWMusicTool previous]];
    [self removeSliderTimer];
    [self removeLrcTimer];
    [self startPlayMusic];
    window.userInteractionEnabled = YES;
}

//下一首
- (IBAction)nextBtn:(id)sender {
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    [[ZWAudioManager defaultManager] stopMusic:self.currentMusic.filename];
    [ZWMusicTool setPlayingMusic:[ZWMusicTool nextMusic]];
    [self removeSliderTimer];
    [self removeLrcTimer];
    [self startPlayMusic];
    window.userInteractionEnabled = YES;
    
}

//拖拽滑块
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    
    //得到移动的距离
   CGPoint point = [sender translationInView:sender.view];
    
    //将translation清空，免得重复叠加
    [sender setTranslation:CGPointZero inView:sender.view];
    
    CGFloat translationMax = self.view.width - sender.view.width;
    
    sender.view.x += point.x;
    
    if (sender.view.x < 0) {
        sender.view.x = 0;
    }
    if (sender.view.x > translationMax) {
        
        sender.view.x = translationMax;
    }
    
    CGFloat time = (sender.view.x / translationMax) * self.audioPlayer.duration;
    [self.showProgressBtn setTitle:[self timeStrFrom:time] forState:UIControlStateNormal];
    [self.slider setTitle:[self timeStrFrom:time]  forState:UIControlStateNormal];
    self.progressView.width = self.slider.center.x;
    self.showProgressBtn.x = self.slider.x;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        [self removeSliderTimer];
        self.showProgressBtn.hidden = NO;
        self.showProgressBtn.y = self.showProgressBtn.superview.height - self.showProgressBtn.height - 15;
        
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        self.audioPlayer.currentTime = time;
        [self addSliderTimer];
        self.showProgressBtn.hidden = YES;
    }
    
}

//点击滑块上的view
- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender {
    
    CGPoint ponit = [sender locationInView:sender.view];
    self.audioPlayer.currentTime = (ponit.x / sender.view.width) * self.audioPlayer.duration;
    [self updateSlider];
    
}

//时间转字符串
-(NSString *)timeStrFrom:(NSTimeInterval)timeInterval
{
    NSInteger min = timeInterval / 60;
    NSInteger sec = (int)timeInterval % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)sec];
}

#pragma mark - AVAudioPlayerDelegate

//播放结束自动播放下一首
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self nextBtn:nil];//下一首
}

//锁屏的时候设置
-(void)setLockScreenMusicShow
{
    if (!self.lrcLines.count) return;
    
    ZWMusicModel * currentMusicModel = self.currentMusic;
    UIImage * currentImage = [UIImage imageNamed:currentMusicModel.icon];
    
    //展示三句歌词
    ZWLrcLineModel * currentLrcModel = self.lrcLines[self.currentIndex];
    ZWLrcLineModel * previousLrc = nil;
    if (self.currentIndex > 0) {
        previousLrc = self.lrcLines[self.currentIndex - 1];
    }
    ZWLrcLineModel * nextLrc = nil;
    if (self.currentIndex < self.lrcLines.count - 1) {
        
        nextLrc = self.lrcLines[self.currentIndex + 1];
    }
    
    //生成图片
    UIGraphicsBeginImageContextWithOptions(currentImage.size, NO, 0.0);//yes:不透明
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    CGFloat textHeight = 30;
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary * preDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                              NSForegroundColorAttributeName:[UIColor whiteColor],
                              NSParagraphStyleAttributeName:style};
    
    NSDictionary *currentLrcAttrDic = @{NSFontAttributeName : [UIFont systemFontOfSize:22],
                                        NSForegroundColorAttributeName : [UIColor redColor],
                                        NSParagraphStyleAttributeName : style};
    
    [previousLrc.word drawInRect:CGRectMake(0, currentImage.size.height - 3 * textHeight, currentImage.size.width, currentImage.size.height) withAttributes:preDic];
    [nextLrc.word drawInRect:CGRectMake(0, currentImage.size.height - textHeight, currentImage.size.width,currentImage.size.height) withAttributes:preDic];
    [currentLrcModel.word drawInRect:CGRectMake(0, currentImage.size.height - 2 * textHeight, currentImage.size.width, currentImage.size.height) withAttributes:currentLrcAttrDic];
    
    UIImage * lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //即时播放中心
    MPNowPlayingInfoCenter * center = [MPNowPlayingInfoCenter defaultCenter];
    //初始化播放信息
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //歌曲名字
    info[MPMediaItemPropertyTitle] =[NSString stringWithFormat:@"%@ - %@",currentMusicModel.singer,currentMusicModel.name] ;
    //歌手
    //info[MPMediaItemPropertyArtist] = self.currentMusic.singer;
    //专辑
    // info[MPMediaItemPropertyAlbumTitle] = self.currentMusic.name;
    //设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    //播放总时间
    info[MPMediaItemPropertyPlaybackDuration] = @(self.audioPlayer.duration);
    //播放当前时间
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.audioPlayer.currentTime);
    
    center.nowPlayingInfo = info;
    
    //远程控制事件，加速计事件，触摸事件
    [self becomeFirstResponder];//成为第一响应者
    //开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
     UIGraphicsEndImageContext();
    
}


#pragma mark -远程控制事件监听
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPauseBtn:nil];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextBtn:nil];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousBtn:nil];
            break;
            
        default:
            break;
    }
}

@end
