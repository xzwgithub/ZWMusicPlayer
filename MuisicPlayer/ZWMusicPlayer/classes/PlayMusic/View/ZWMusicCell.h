//
//  ZWMusicCell.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWMusicModel;
@interface ZWMusicCell : UITableViewCell

@property (nonatomic,strong) ZWMusicModel * musicModel;

+(instancetype)musicCellWithTableView:(UITableView *)tableView;

@end
