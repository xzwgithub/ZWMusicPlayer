//
//  ZWMusicTool.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZWMusicModel;

@interface ZWMusicTool : NSObject

+(ZWMusicModel *)willPlayingMusic;

//重新设置歌曲
+(void)setPlayingMusic:(ZWMusicModel *)music;

//所有歌曲
+(NSArray*)allMusics;

//下一首
+(ZWMusicModel *)nextMusic;

//上一首
+(ZWMusicModel *)previous;

@end
