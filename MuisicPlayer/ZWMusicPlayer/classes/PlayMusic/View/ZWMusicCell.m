//
//  ZWMusicCell.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/7.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWMusicCell.h"
#import "ZWMusicModel.h"
#import "ZWImageTool.h"

static NSString * _identifier = @"ZWMusicCell";
@implementation ZWMusicCell

+(instancetype)musicCellWithTableView:(UITableView *)tableView
{
   ZWMusicCell * cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!cell) {
        
        cell = [[ZWMusicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    return self;
}

-(void)setMusicModel:(ZWMusicModel *)musicModel
{
    _musicModel = musicModel;
    
    self.textLabel.text = musicModel.name;
    self.detailTextLabel.text = musicModel.singer;
    if (musicModel.isPlaying) {
        self.imageView.image = [ZWImageTool circleImageWithName:musicModel.singerIcon borderWidth:1.0 borderColor:[UIColor redColor]];
    }else
    {
        self.imageView.image = [ZWImageTool circleImageWithName:musicModel.singerIcon borderWidth:1.0 borderColor:[UIColor blueColor]];
    }
    
    [self addAnimationWith:musicModel];
    
}


//添加动画
-(void)addAnimationWith:(ZWMusicModel *)music
{
    if (music.isAnimating) {
        
        CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        baseAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI ];
        baseAnimation.duration = 8.0f;
        baseAnimation.repeatCount = NSIntegerMax;
        baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.imageView.layer addAnimation:baseAnimation forKey:@"baseAnimation"];
    }else
    {
        [self.imageView.layer removeAnimationForKey:@"baseAnimation"];
    }

}

@end
