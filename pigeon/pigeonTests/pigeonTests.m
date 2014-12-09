//
//  pigeonTests.m
//  pigeonTests
//
//  Created by familymrfan on 14-12-9.
//  Copyright (c) 2014年 familymrfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AsyncSocket.h"
#import "GCDAsyncSocket.h"

@interface pigeonTests : XCTestCase<AsyncSocketDelegate, GCDAsyncSocketDelegate>

@end

@implementation pigeonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMutiConnectionRunLoop {
    AsyncSocket* socket = [[AsyncSocket alloc] initWithDelegate:self];
    BOOL succuess = [socket connectToHost:@"imap.163.com" onPort:143 withTimeout:10 error:nil];
    if (succuess) {
        NSLog(@"%s connection success !", __func__);
    }
    
    NSRunLoop* runloop = [NSRunLoop currentRunLoop];
    [runloop run];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"%s host %@, port %hu", __func__, host, port);
}

- (void)testMutiConnectionGCD {
    GCDAsyncSocket* socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    BOOL success = [socket connectToHost:@"imap.163.com" onPort:143 withTimeout:10 error:nil];
    if (success) {
        NSLog(@"%s connection success !", __func__);
    }
    
    [socket readDataWithTimeout:10 tag:1];
    [socket readDataWithTimeout:10 tag:1];
    
    GCDAsyncSocket* socket2 = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    success = [socket2 connectToHost:@"imap.163.com" onPort:143 withTimeout:10 error:nil];
    if (success) {
        NSLog(@"%s connection success !", __func__);
    }
    [socket2 readDataWithTimeout:10 tag:2];
    
    GCDAsyncSocket* socket3 = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    success = [socket3 connectToHost:@"imap.163.com" onPort:143 withTimeout:10 error:nil];
    if (success) {
        NSLog(@"%s connection success !", __func__);
    }
    [socket3 readDataWithTimeout:10 tag:3];
    
    GCDAsyncSocket* socket4 = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    success = [socket4 connectToHost:@"imap.163.com" onPort:143 withTimeout:10 error:nil];
    if (success) {
        NSLog(@"%s connection success !", __func__);
    }
    [socket4 readDataWithTimeout:10 tag:4];
    
    GCDAsyncSocket* socket5 = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    success = [socket5 connectToHost:@"imap.163.com" onPort:143 withTimeout:10 error:nil];
    if (success) {
        NSLog(@"%s connection success !", __func__);
    }
    [socket5 readDataWithTimeout:10 tag:5];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString* login = @"1 login hzfanfei ilove163\r\n";
        [socket writeData:[login dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    });
    
    NSRunLoop* runloop = [NSRunLoop currentRunLoop];
    [runloop run];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s host %@, port %hu", __func__, host, port);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"read data %@, tag is %ld", string, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s tag is %ld", __func__, tag);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"sock is disconnect");
}

@end
