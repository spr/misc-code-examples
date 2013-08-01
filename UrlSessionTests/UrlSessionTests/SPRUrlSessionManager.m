//
//  SPRUrlSessionManager.m
//  UrlSessionTests
//
//  Created by Scott Robertson on 7/28/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import "SPRUrlSessionManager.h"

// v1: Only safe on serial queues
// (this is better than NSURLConnection, but still requires me to do a lot for
// handling multiple requests with a single delegate.

// And now since the delegate is tied to the _session_ a master delegate for
// many connections seems more necessary.

// Previously you could write a light weight delegate and have one per connection.)
@interface SPRUrlSessionManager ()

@property (nonatomic,readwrite,strong) NSMutableSet *tasksBlockingRedirects;

@property (nonatomic,readwrite,strong) NSMutableDictionary *dataTaskCompletionHandlers;
@property (nonatomic,readwrite,strong) NSMutableDictionary *dataTaskDatas;

@property (nonatomic,readwrite,strong) NSMutableDictionary *downloadTaskCompletionHandlers;
@property (nonatomic,readwrite,strong) NSMutableDictionary *downloadTaskLocations;
@property (nonatomic,readwrite,strong) NSMutableDictionary *downloadTaskProgressCallbacks;

@property (nonatomic,readwrite,strong) NSMutableSet *dataTasksThatShouldBeDownloadTasks;
@property (nonatomic,readwrite,strong) NSMutableDictionary *dataOrDownloadCompletionHandlers;

@end

@implementation SPRUrlSessionManager

#pragma mark - Class methods

+ (NSURLSessionTask *)asyncFetchData:(NSURL *)url completion:(UrlSessionDataTaskResult)completion {
    NSURLSession *session = [NSURLSession sharedSession];
    return [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completion(data, response, error);
    }];
}

+ (NSURLSessionTask *)asyncDownloadURL:(NSURL *)url completion:(UrlSessionDownloadTaskResult)completion {
    NSURLSession *session = [NSURLSession sharedSession];
    return [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        completion(location, response, error);
    }];
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        _queue.name = @"Session Manager Queue";
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_queue];
        
        _tasksBlockingRedirects = [NSMutableSet setWithCapacity:5];
        _dataTaskCompletionHandlers = [NSMutableDictionary dictionaryWithCapacity:5];
        _dataTaskDatas = [NSMutableDictionary dictionaryWithCapacity:5];
        
        _downloadTaskCompletionHandlers = [NSMutableDictionary dictionaryWithCapacity:5];
        _downloadTaskLocations = [NSMutableDictionary dictionaryWithCapacity:5];
        _downloadTaskProgressCallbacks = [NSMutableDictionary dictionaryWithCapacity:5];
        
        _dataTasksThatShouldBeDownloadTasks = [NSMutableSet setWithCapacity:5];
        _dataOrDownloadCompletionHandlers = [NSMutableDictionary dictionaryWithCapacity:5];
        
    }
    return self;
}

#pragma mark - Public entry points

- (NSURLSessionDataTask *)fetchURL:(NSURL *)url completion:(UrlSessionDataTaskResult)completion {
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url];
    self.dataTaskCompletionHandlers[@(task.taskIdentifier)] = completion;
    self.dataTaskDatas[@(task.taskIdentifier)] = [NSMutableData dataWithCapacity:1024];
    [task resume];
    return task;
}

#pragma mark - Cleanup

- (void)removeAllReferencesForIdentifier:(NSUInteger)identifier {
    NSNumber *key = @(identifier);
    
    if ([self.dataTasksThatShouldBeDownloadTasks containsObject:key]) {
        [self.dataTasksThatShouldBeDownloadTasks removeObject:key];
    }
    if (self.dataTaskCompletionHandlers[key]) {
        [self.dataTaskCompletionHandlers removeObjectForKey:key];
    }
    if (self.dataTaskDatas[key]) {
        [self.dataTaskDatas removeObjectForKey:key];
    }
    if (self.downloadTaskCompletionHandlers[key]) {
        [self.downloadTaskCompletionHandlers removeObjectForKey:key];
    }
    if (self.downloadTaskLocations[key]) {
        [self.downloadTaskLocations removeObjectForKey:key];
    }
    if (self.downloadTaskProgressCallbacks[key]) {
        [self.downloadTaskProgressCallbacks removeObjectForKey:key];
    }
    if ([self.dataTasksThatShouldBeDownloadTasks containsObject:key]) {
        [self.dataTasksThatShouldBeDownloadTasks removeObject:key];
    }
    if (self.dataOrDownloadCompletionHandlers[key]) {
        [self.dataOrDownloadCompletionHandlers removeObjectForKey:key];
    }
    
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    NSLog(@"URLSession %@ become invalid: %@", session, error);
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {
    NSLog(@"%s: Response: %@, request: %@", __PRETTY_FUNCTION__, response, request);
    if ([self.tasksBlockingRedirects containsObject:@(task.taskIdentifier)]) {
        NSLog(@"Blocking redirect per-user request");
        completionHandler(nil);
    } else {
        NSLog(@"Allowing redirect");
        completionHandler(request);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"%s: Task: %@, Error: %@", __PRETTY_FUNCTION__, task, error);
    
    if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        UrlSessionDataTaskResult completion = self.dataTaskCompletionHandlers[@(task.taskIdentifier)];
        completion(self.dataTaskDatas[@(task.taskIdentifier)], task.response, error);
    } else if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        UrlSessionDownloadTaskResult completion = self.downloadTaskCompletionHandlers[@(task.taskIdentifier)];
        completion(self.downloadTaskLocations[@(task.taskIdentifier)], task.response, error);
    }
    [self removeAllReferencesForIdentifier:task.taskIdentifier];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSMutableData *data = nil;
    NSLog(@"%s: Task: %@, Response: %@", __PRETTY_FUNCTION__, dataTask, response);
    
    if ((data = self.dataTaskDatas[@(dataTask.taskIdentifier)])) {
        data.length = 0;
    }
    if ([self.dataTasksThatShouldBeDownloadTasks containsObject:dataTask]) {
        NSLog(@"Attempting to transform %@ (%d) into download task", dataTask, dataTask.taskIdentifier);
        completionHandler(NSURLSessionResponseBecomeDownload);
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    NSLog(@"%s: Data task: %@, Download task: %@", __PRETTY_FUNCTION__, dataTask, downloadTask);
    
    UrlSessionDataOrDownloadTaskResult oldCompletion = self.dataOrDownloadCompletionHandlers[@(dataTask.taskIdentifier)];
    UrlSessionDownloadTaskResult newCompletion = ^(NSURL *location, NSURLResponse *response, NSError *error) {
        oldCompletion(location, nil, response, error);
    };
    self.downloadTaskCompletionHandlers[@(downloadTask.taskIdentifier)] = newCompletion;
    
    if (downloadTask.taskIdentifier != dataTask.taskIdentifier) {
        NSLog(@"Task identifiers changed, cleaning up");
        [self removeAllReferencesForIdentifier:dataTask.taskIdentifier];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"%s: Task: %@", __PRETTY_FUNCTION__, dataTask);
    
    NSMutableData *storedData = self.dataTaskDatas[@(dataTask.taskIdentifier)];
    [storedData appendData:data];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%s: Task: %@, location: %@", __PRETTY_FUNCTION__, downloadTask, location);
    
    NSError *error = nil;
    NSURL *downloadDir = [[NSFileManager defaultManager] URLForDirectory:NSDownloadsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    if (!downloadDir) {
        NSLog(@"Error getting downloads directory: %@", error);
        return;
    }
    NSString *newFileName = [NSString stringWithFormat:@"%d-%@", downloadTask.taskIdentifier, downloadTask.response.URL.lastPathComponent];
    NSURL *newFileLocation = [downloadDir URLByAppendingPathComponent:newFileName];
    
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:location toURL:newFileLocation error:&error];
    if (!success) {
        NSLog(@"Error copying %@ to %@: %@", location, newFileLocation, error);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"%s: Task: %@, bytes: %lld, totalBytes: %lld, expectedBytes: %lld", __PRETTY_FUNCTION__, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    
    UrlSessionDownloadProgressCallback progressCallback = self.downloadTaskProgressCallbacks[@(downloadTask.taskIdentifier)];
    if (progressCallback) {
        progressCallback(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

@end
