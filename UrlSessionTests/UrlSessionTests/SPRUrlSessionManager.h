//
//  SPRUrlSessionManager.h
//  UrlSessionTests
//
//  Created by Scott Robertson on 7/28/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UrlSessionDataTaskResult)(NSData *data, NSURLResponse *response, NSError *error);

typedef void (^UrlSessionDownloadTaskResult)(NSURL *location, NSURLResponse *response, NSError *error);

typedef void (^UrlSessionDataOrDownloadTaskResult)(NSURL *location, NSData *data, NSURLResponse *response, NSError *error);

typedef void (^UrlSessionDownloadProgressCallback)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

@interface SPRUrlSessionManager : NSObject <NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>

// Uses the shortcut methods for sessions (always uses shared session)
+ (NSURLSessionTask *)asyncFetchData:(NSURL *)url completion:(UrlSessionDataTaskResult)completion;
+ (NSURLSessionTask *)asyncDownloadURL:(NSURL *)url completion:(UrlSessionDownloadTaskResult)completion;

// Data Task backed
- (NSURLSessionDataTask *)fetchURL:(NSURL *)url completion:(UrlSessionDataTaskResult)completion;

- (void)fetchWithoutRedirection:(NSURL *)url completion:(UrlSessionDataTaskResult)completion;

// Fun stuff
- (void)fetchWithSwitchingToDownloadForTypes:(NSArray *)downloadTypes URL:(NSURL *)url completion:(UrlSessionDataOrDownloadTaskResult)completion;

// Download Task backed
- (void)downloadURL:(NSURL *)url withProgress:(UrlSessionDownloadProgressCallback)progressCallback completion:(UrlSessionDownloadTaskResult)completion;

- (void)downloadWithRetries:(NSUInteger)numberOfRetries url:(NSURL *)url completion:(UrlSessionDownloadTaskResult)completion;

// Here so we can investigate the session properties
// Wouldn't actually make this public
@property (nonatomic,readonly,strong) NSURLSession *session;
@property (nonatomic,readonly,strong) NSURLSessionConfiguration *configuration;
@property (nonatomic,readonly,strong) NSOperationQueue *queue;

@end
