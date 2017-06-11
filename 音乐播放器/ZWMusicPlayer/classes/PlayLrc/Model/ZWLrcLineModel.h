//
//  ZWLrcLineModel.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/8.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWLrcLineModel : NSObject

/**
 *  时间点
 */
@property (nonatomic,copy) NSString * time;
/**
 *  词
 */
@property (nonatomic,copy) NSString * word;

/**
 *  返回所有的歌词
 */

+(NSMutableArray *)lrcLinesWithFileName:(NSString *)fileName;

@end
