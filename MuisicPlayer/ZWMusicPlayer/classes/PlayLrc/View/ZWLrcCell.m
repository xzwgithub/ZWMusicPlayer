//
//  ZWLrcCell.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/8.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWLrcCell.h"
#import "ZWLrcLineModel.h"
#import "UIView+Extension.h"

static NSString * _identifier = @"ZWLrcCell";

@interface ZWLrcCell ()
@property (nonatomic,strong) UILabel * textLab;
@end
@implementation ZWLrcCell

+(instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    ZWLrcCell * cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!cell) {
        cell = [[ZWLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.numberOfLines = 0;
    }
    
    return self;
}

-(void)setLrcLine:(ZWLrcLineModel *)lrcLine
{
    _lrcLine = lrcLine;
    self.textLabel.text = lrcLine.word;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //解决iOS5中textLabel位置不居中问题
    self.textLabel.bounds = self.bounds;
}

@end
