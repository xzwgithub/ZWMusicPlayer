//
//  ZWPlayingViewController.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZWPlayStatusBlock)(BOOL isPlay);
@interface ZWPlayingViewController : UIViewController

@property (nonatomic,copy) ZWPlayStatusBlock block;

-(void)show;

@end
