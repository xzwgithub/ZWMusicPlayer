//
//  ZWAudioManager.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/6.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWAudioManager.h"

@interface ZWAudioManager ()

@property (nonatomic,strong) NSMutableDictionary * musicPlayers;

@property (nonatomic,strong) NSMutableDictionary * soundIDs;

@property (nonatomic,assign) NSTimeInterval  currentPlayTime;

@property (nonatomic,assign) BOOL  isPause;


@end

static ZWAudioManager * _instance = nil;

@implementation ZWAudioManager

+(void)initialize
{
    //音频会话
    AVAudioSession * session = [AVAudioSession sharedInstance];
    //设置会话类型(播放类型，播放模式，会自动停止其他音乐的播放)
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //激活会话
    [session setActive:YES error:nil];
}

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

//初始化操作
-(instancetype)init
{
    __block ZWAudioManager * weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((weakSelf = [super init])) {
            
            _musicPlayers = [NSMutableDictionary dictionary];
            _soundIDs = [NSMutableDictionary dictionary];
            //监听事件中断通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
        }
    });
    self = weakSelf;
    return self;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

//播放音乐
-(AVAudioPlayer *)playingMusic:(NSString *)fileName
{
    if (fileName == nil || fileName.length == 0) return nil;
    
    //从缓存里面查找
    AVAudioPlayer * player = self.musicPlayers[fileName];
    
    //当播放上一首和下一首时清空记录从0开始播放
    if (player != self.currentPlayer) {
        
        self.currentPlayTime = 0;
    }
    
    if (!player) {
        
        NSURL * url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        if (!url) return nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        if (![player prepareToPlay]) return nil;
        self.musicPlayers[fileName] = player;//添加缓冲区
    }
    
    if (![player isPlaying]) {
        //解决中事件恢复后不能记录之前的播放时间
        if (self.isPause) {
           player.currentTime = self.currentPlayTime;
            self.isPause = NO;
        }
        [player play];
    }
    
    self.currentPlayer = player;
    
    return player;
}

-(void)pauseMusic:(NSString *)fileName
{
    if (fileName == nil || fileName.length == 0) return;
    
    AVAudioPlayer * player = self.musicPlayers[fileName];
    if ([player isPlaying]) {
        self.currentPlayTime = player.currentTime;
        self.isPause = YES;
        [player pause];
    }
}

-(void)stopMusic:(NSString *)fileName
{
    if (fileName == nil || fileName.length == 0) return;
    
    AVAudioPlayer * player = self.musicPlayers[fileName];
    [player stop];
    [self.musicPlayers removeObjectForKey:fileName];
    
}

//播放音效
-(void)playSound:(NSString *)fileName
{
    if (!fileName) return;
    //取出对应的音效id
    SystemSoundID soundID =(int) [self.soundIDs[fileName] unsignedLongValue];
    if (!soundID) {
        
        NSURL * url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        if (!url) return;
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
        
        self.soundIDs[fileName] = @(soundID);//加入缓存
        
    }
    
    //播放
    AudioServicesPlaySystemSound(soundID);
    
}

-(void)disposeSound:(NSString *)fileName
{
      if (!fileName) return;
    //取出对应的音效id
    SystemSoundID soundID =(int) [self.soundIDs[fileName] unsignedLongValue];
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [self.soundIDs removeObjectForKey:fileName];//从缓存中删除
    }
    
}

//监听中断通知调用的方法
-(void)audioSessionInterruptionNotification:(NSNotification *)notification
{
//        AVAudioSessionInterruptionOptionKey = 1;
//        AVAudioSessionInterruptionTypeKey = 0;
    
    NSInteger type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    if (self.block) {
        self.block(type);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
