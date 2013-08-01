//
//  UrlSessionTestsTests.m
//  UrlSessionTestsTests
//
//  Created by Scott Robertson on 7/28/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SPRUrlSessionManager.h"

@interface UrlSessionTestsTests : XCTestCase

@property (nonatomic,readwrite,strong) SPRUrlSessionManager *manager;

@property (nonatomic,readwrite,strong) __block dispatch_semaphore_t completed;

@end

@implementation UrlSessionTestsTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.manager = [[SPRUrlSessionManager alloc] init];
    self.completed = dispatch_semaphore_create(0);
}

- (void)tearDown
{
    // Tear-down code here.
    self.manager = nil;
    self.completed = nil;
    
    [super tearDown];
}

- (void)testNSURLSessionDirectly {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://www.google.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Success!");
        dispatch_semaphore_signal(self.completed);
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(self.completed, DISPATCH_TIME_FOREVER);
    task = nil;
}

- (void)testShortcutDataTask {
    NSURLSessionTask *task = [SPRUrlSessionManager asyncFetchData:[NSURL URLWithString:@"http://media.scottr.org/desk.html"] completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Completed async data task");
        
        dispatch_semaphore_signal(self.completed);
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(self.completed, DISPATCH_TIME_FOREVER);
    task = nil;
}

- (void)testBasicDataTask {
    NSURLSessionDataTask *task = [self.manager fetchURL:[NSURL URLWithString:@"http://media.scottr.org/desk.html"] completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Completed data task");
        
        dispatch_semaphore_signal(self.completed);
    }];
    
    dispatch_semaphore_wait(self.completed, DISPATCH_TIME_FOREVER);
    task = nil;
}

@end
