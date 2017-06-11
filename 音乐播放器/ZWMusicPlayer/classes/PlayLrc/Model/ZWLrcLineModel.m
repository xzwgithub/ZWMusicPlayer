//
//  ZWLrcLineModel.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/8.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWLrcLineModel.h"

@implementation ZWLrcLineModel

+(NSMutableArray *)lrcLinesWithFileName:(NSString *)fileName
{
    NSMutableArray * lrcLines = [NSMutableArray array];
    NSURL * url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSString * lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    //分割字符串，以换行符进行分割，将一句句歌词单独分割出来
   NSArray * lrcCmps = [lrcStr componentsSeparatedByString:@"\n"];
    [lrcCmps enumerateObjectsUsingBlock:^(NSString * lineStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZWLrcLineModel * lrcLine = [[ZWLrcLineModel alloc] init];
        [lrcLines addObject:lrcLine];
        
        //如果是歌词的头部信息(歌名，歌手，专辑)
        if ([lineStr hasPrefix:@"[ti:"] || [lineStr hasPrefix:@"[ar:"] || [lineStr hasPrefix:@"[al:"])
        {
            NSString * word = [lineStr componentsSeparatedByString:@":"].lastObject;
            lrcLine.word = [word substringToIndex:word.length - 1];
            
        }else if ([lineStr hasPrefix:@"["])
        {
            NSArray * arr = [lineStr componentsSeparatedByString:@"]"];
            lrcLine.word = arr.lastObject;
            lrcLine.time = [arr.firstObject substringFromIndex:1];
        }
        
    }];
    
    if (lrcLines.count == 0) {
        
        return nil;
    }else
    {
        return lrcLines;
    }
    
}

@end
