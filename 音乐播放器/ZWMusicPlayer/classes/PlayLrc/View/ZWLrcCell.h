//
//  ZWLrcCell.h
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/8.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWLrcLineModel;
@interface ZWLrcCell : UITableViewCell

@property (nonatomic,strong) ZWLrcLineModel * lrcLine;

+(instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
