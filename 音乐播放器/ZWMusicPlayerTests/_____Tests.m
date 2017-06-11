//
//  _____Tests.m
//  ZWMusicPlayerTests
//
//  Created by xzw on 17/6/6.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface _____Tests : XCTestCase

@end

@implementation _____Tests

- (void)setUp {
    [super setUp];
    
    //每个test方法执行前调用
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    
    //每个test方法执行后调用
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    //测试方法样例
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    
    //主要是做性能测试，评估一段代码执行的时间
    
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
