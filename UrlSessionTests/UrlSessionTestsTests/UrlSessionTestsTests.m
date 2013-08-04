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

- (void)testNoRedirection {
    NSURLSessionDataTask *task = [self.manager fetchWithoutRedirection:[NSURL URLWithString:@"http://scottr.org"] completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Completed task with response: %@", response);
        
        XCTAssert([response isKindOfClass:[NSHTTPURLResponse class]], @"Response is a %@ not NSHTTPURLResponse", [response class]);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        XCTAssertNotEqual(httpResponse.statusCode, 200, @"Shouldn't have received a 200 (%@)", httpResponse);
        XCTAssertEqualObjects(httpResponse.URL, [NSURL URLWithString:@"http://scottr.org/"], @"URL changed: %@", httpResponse.URL);
        
        dispatch_semaphore_signal(self.completed);
    }];
    
    dispatch_semaphore_wait(self.completed, DISPATCH_TIME_FOREVER);
    
    NSLog(@"Task done: %@. Original request: %@, Actual Request: %@", task, task.originalRequest, task.currentRequest);
}

- (void)testDataBecomingDownload {
    NSURLSessionDataTask *task = [self.manager fetchWithSwitchingToDownloadForTypes:@[@"pdf"] URL:[NSURL URLWithString:@"http://media.scottr.org/cs.pdf"] completion:^(NSURL *location, NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Received download at %@, response: %@", location, response);
        
        XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:[location path]], @"No file found at %@", location);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[location path]]) {
            [[NSFileManager defaultManager] removeItemAtURL:location error:nil];
        }
        
        dispatch_semaphore_signal(self.completed);
    }];
    
    dispatch_semaphore_wait(self.completed, DISPATCH_TIME_FOREVER);
    
    NSLog(@"Task done as download: %@", task);
}

@end
