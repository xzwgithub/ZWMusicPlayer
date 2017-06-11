//
//  ZWMusicPlayingController.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWMusicPlayingController.h"
#import "ZWMusicTool.h"
#import "ZWMusicCell.h"
#import "ZWPlayingViewController.h"
#import "ZWMusicModel.h"
#import <NAKPlaybackIndicatorView.h>
#import "UIView+Extension.h"

@interface ZWMusicPlayingController ()

@property (nonatomic,strong) ZWPlayingViewController * playVC;

@property (nonatomic,assign) NSInteger  currentIndex;

@property (nonatomic,strong) NAKPlaybackIndicatorView * indicatorView;


@end

@implementation ZWMusicPlayingController

-(NAKPlaybackIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        
        _indicatorView = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectMake(self.view.width - 50, 0, 50, 44)];
        _indicatorView.hidesWhenStopped = NO;
        _indicatorView.tintColor = [UIColor redColor];
        _indicatorView.state = NAKPlaybackIndicatorViewStateStopped;
    }
    return _indicatorView;
}

-(ZWPlayingViewController *)playVC
{
    if (!_playVC) {
        
        _playVC = [[ZWPlayingViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        _playVC.block = ^(BOOL isPlay){
            
            if (isPlay) {
                
                  weakSelf.indicatorView.state = NAKPlaybackIndicatorViewStatePlaying;
                
            }else
            {
               weakSelf.indicatorView.state = NAKPlaybackIndicatorViewStateStopped;
               ZWMusicModel * musicM = [ZWMusicTool allMusics][weakSelf.currentIndex];
                musicM.animating = NO;
                [weakSelf.tableView reloadData];
                
            }
            
        };
    }
    return _playVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"音乐播放器";
    [self.navigationController.navigationBar addSubview:self.indicatorView];
    self.tableView.rowHeight = 70;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTabView) name:UIApplicationWillEnterForegroundNotification object:nil];
   
}

//解决应用进入后台，再返回前台动画消失
-(void)refreshTabView
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [ZWMusicTool allMusics].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWMusicCell * cell = [ZWMusicCell musicCellWithTableView:tableView];
    cell.musicModel = [ZWMusicTool allMusics][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    //重置歌曲
    [ZWMusicTool setPlayingMusic:[ZWMusicTool allMusics][indexPath.row]];
    
    ZWMusicModel * lastM = [ZWMusicTool allMusics][_currentIndex];
    lastM.playing = NO;
    lastM.animating = NO;
    
    ZWMusicModel * currentM = [ZWMusicTool allMusics][indexPath.row];
    currentM.playing = YES;
    currentM.animating = YES;
    
    
    //刷新上次点击和当前点击的cell
    NSArray * indexPaths = @[indexPath,
                             [NSIndexPath indexPathForRow:_currentIndex inSection:0]
                             
                             ];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
      _currentIndex = indexPath.row;
    
    [self.playVC show];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
