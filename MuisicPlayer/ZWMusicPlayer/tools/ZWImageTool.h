//
//  ZWImageTool.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZWImageTool : NSObject

/**
 *  压缩图片
 *
 *  @param img        原来的图片
 *  @param targetSize 要压缩的尺寸
 *
 *  @return 压缩后的图片
 */
+ (UIImage *)imageCompress:(UIImage *)img targetSize:(CGSize)targetSize;

/**
 *  给一张图片添加文字描述
 *
 *  @param img   图片
 *  @param mark  文字
 *  @param rect  文字所在范围
 *  @param font  文字字体
 *  @param color 文字颜色
 *
 *  @return 图片
 */
+ (UIImage *)addTextOnImage:(UIImage *)img mark:(NSString *)mark rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color;

/**
 *  将图片裁剪为带边框圆形
 *
 *  @param name        图片名
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return 被裁剪后的图片
 */
+ (UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
