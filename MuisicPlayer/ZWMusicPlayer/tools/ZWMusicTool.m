//
//  ZWMusicTool.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWMusicTool.h"
#import "ZWMusicModel.h"
#import <MJExtension/MJExtension.h>

static NSArray * _allMusics;
static ZWMusicModel * _willPlayingMusic;

@implementation ZWMusicTool

+(ZWMusicModel *)willPlayingMusic
{
    return _willPlayingMusic;
}

//重新设置歌曲
+(void)setPlayingMusic:(ZWMusicModel *)music
{
    if (music == nil || ![_allMusics containsObject:music] || music == _willPlayingMusic) {
        return;
    }
    
    _willPlayingMusic = music;
}


+(NSArray *)allMusics
{
    if (_allMusics == nil) {
        
        _allMusics = [ZWMusicModel mj_objectArrayWithFilename:@"Musics.plist"];
        
    }
    return _allMusics;
}

+(ZWMusicModel *)nextMusic
{
    NSInteger nextIndex = 0;
    if (_willPlayingMusic) {
        
        NSInteger  currentIndex = [[self allMusics] indexOfObject:_willPlayingMusic];
        nextIndex = currentIndex + 1;
        if (nextIndex >= [self allMusics].count) {
            nextIndex = 0;
        }
    }
    return [self allMusics][nextIndex];
}

+(ZWMusicModel *)previous
{
    NSInteger previous = 0;
    if (_willPlayingMusic) {
        
        NSInteger currentIndex = [[self allMusics] indexOfObject:_willPlayingMusic];
        previous = currentIndex - 1;
        if (previous < 0) {
            previous = [self allMusics].count - 1;
        }
    }
    return [self allMusics][previous];
}

@end
