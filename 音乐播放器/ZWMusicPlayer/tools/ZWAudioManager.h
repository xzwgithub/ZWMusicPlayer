//
//  ZWAudioManager.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/6.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^ZWInterruptionBlock)(NSInteger tag);
@interface ZWAudioManager : NSObject

//处理中断回调
@property (nonatomic,copy) ZWInterruptionBlock block;
@property (nonatomic,strong) AVAudioPlayer * currentPlayer;

+(instancetype)defaultManager;

//播放音乐
-(AVAudioPlayer *)playingMusic:(NSString *)fileName;
-(void)pauseMusic:(NSString *)fileName;
-(void)stopMusic:(NSString *)fileName;

//播放音效
-(void)playSound:(NSString *)fileName;
-(void)disposeSound:(NSString *)fileName;

@end
