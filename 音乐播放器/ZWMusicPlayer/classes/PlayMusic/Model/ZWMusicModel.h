//
//  ZWMusicModel.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWMusicModel : NSObject

/**
 *  歌曲名字
 */
@property (nonatomic,copy) NSString * name;

/**
 *  歌曲大图
 */
@property (nonatomic,copy) NSString * icon;

/**
 *   歌曲的文件名
 */
@property (nonatomic,copy) NSString * filename;

/**
 *  歌词的文件名
 */
@property (nonatomic,copy) NSString * lrcname;

/**
 *  歌手
 */
@property (nonatomic,copy) NSString * singer;
/**
 *  歌手图标
 */
@property (nonatomic,copy) NSString * singerIcon;

@property (nonatomic,assign,getter=isPlaying) BOOL  playing;

@property (nonatomic,assign,getter=isAnimating) BOOL  animating;

@end
