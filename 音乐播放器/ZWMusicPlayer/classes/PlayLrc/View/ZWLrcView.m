//
//  ZWLrcView.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/8.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWLrcView.h"
#import "ZWLrcLineModel.h"
#import "ZWLrcCell.h"
#import "UIView+Extension.h"
#import "ZWMusicModel.h"
#import "ZWMusicTool.h"
#import "ZWAudioManager.h"
#import <AVFoundation/AVFoundation.h>


@interface ZWLrcView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * lrcLines;

//记录当前显示的歌词序号
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation ZWLrcView

-(NSMutableArray *)lrcLines
{
    if (!_lrcLines) {
        
        //加载歌词
        _lrcLines = [NSMutableArray array];
        
    }
    return _lrcLines;
}

-(void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
    
    self.lrcLines = [ZWLrcLineModel lrcLinesWithFileName:fileName];
    
}

#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    self.image = [UIImage imageNamed:@"28131977_1383101943208"];
    self.contentMode = UIViewContentModeScaleToFill;
    self.clipsToBounds = YES;
    UITableView * tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView = tableView;
    [self addSubview:tableView];
    
}

-(void)setCurrentTime:(NSTimeInterval)currentTime
{
    if (_currentTime > currentTime) {
        self.currentIndex = 0;
    }
    _currentTime = currentTime;
    
    int minute = currentTime/60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString * currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d",minute,second,msecond];
    
    for (NSInteger i = self.currentIndex; i < self.lrcLines.count; i++) {
        
        ZWLrcLineModel * currentM = self.lrcLines[i];
        NSString * currentTime = currentM.time;
        NSString * nextLineTime = nil;
        
        if (i + 1 < self.lrcLines.count) {
            
            ZWLrcLineModel * nextM = self.lrcLines[i+1];
            nextLineTime = nextM.time;
        }
        if (([currentTimeStr compare:currentTime] != NSOrderedAscending) && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending) && (self.currentIndex != i)) {
            
            
            NSArray *reloadLines = @[
                                     [NSIndexPath indexPathForItem:self.currentIndex inSection:0],
                                     [NSIndexPath indexPathForItem:i inSection:0]
                                     ];
            self.currentIndex = i;
            
            [self.tableView reloadData];
            
            [self.tableView reloadRowsAtIndexPaths:reloadLines withRowAnimation:UITableViewRowAnimationNone];
            
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }

        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLines.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWLrcCell * cell = [ZWLrcCell lrcCellWithTableView:tableView];
    ZWLrcLineModel * model = self.lrcLines[indexPath.row];
    cell.lrcLine = model;
    if (indexPath.row == self.currentIndex) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [UIColor redColor];
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
    }

    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
    self.tableView.contentInset = UIEdgeInsetsMake(self.frame.size.height / 2, 0, self.frame.size.height / 2, 0);
}

@end
