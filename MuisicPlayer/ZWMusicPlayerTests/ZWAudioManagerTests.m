//
//  ZWAudioManagerTests.m
//  ZWMusicPlayer
//
//  Created by xzw on 17/6/6.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZWAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ZWAudioManagerTests : XCTestCase

@property (nonatomic,strong) AVAudioPlayer * player;

@end

static NSString * _fileName = @"1770040300_2031329_l.mp3";

@implementation ZWAudioManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



-(void)testAudioManagerSingle
{
    
    NSMutableArray * managers = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ZWAudioManager * temp = [[ZWAudioManager alloc] init];
        [managers addObject:temp];
        
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ZWAudioManager * temp = [[ZWAudioManager alloc] init];
        [managers addObject:temp];
        
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ZWAudioManager * temp = [[ZWAudioManager alloc] init];
        [managers addObject:temp];
        
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ZWAudioManager * temp = [[ZWAudioManager alloc] init];
        [managers addObject:temp];
        
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ZWAudioManager * temp = [[ZWAudioManager alloc] init];
        [managers addObject:temp];
        
    });
    
    ZWAudioManager * managerOne = [ZWAudioManager defaultManager];
    
    dispatch_group_notify(group,  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       [managers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           NSLog(@"%@",obj);
           
           XCTAssertEqualObjects(managerOne, obj,@"ZWAudioManager is not a single");
           
       }];
        
    });

}

/**
 *  测试是否可以正常播放音乐
 */
- (void)testPlayingMusic
{
    self.player = [[ZWAudioManager defaultManager] playingMusic:_fileName];
    XCTAssertTrue(self.player.playing, @"ZYAudioManager is not PlayingMusic");
}

/**
 *  测试是否可以正常停止音乐
 */
-(void)testStopMusic
{
    if (!self.player) {
        
        self.player = [[ZWAudioManager defaultManager] playingMusic:_fileName];
        
    }
    if (!self.player.isPlaying) {
        
        [self.player play];
    }
    [[ZWAudioManager defaultManager] pauseMusic:_fileName];
    XCTAssertFalse(self.player.isPlaying,@"ZYAudioManager is not StopMusic");
}

/**
 *  测试是否可以正常暂停音乐
 */

-(void)testPauseMusic
{
    if (self.player == nil) {
        self.player = [[ZWAudioManager defaultManager] playingMusic:_fileName];
    }
    if (self.player.playing == NO) [self.player play];
    [[ZWAudioManager defaultManager] pauseMusic:_fileName];
    XCTAssertFalse(self.player.playing, @"ZYAudioManager is not pauseMusic");
}


@end
