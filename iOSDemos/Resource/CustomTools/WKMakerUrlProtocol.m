//
//  WKMakerUrlProtocol.m
//  iOSDemos
//
//  Created by Ke Wang on 2019/1/7.
//  Copyright © 2019年 Ke Wang. All rights reserved.
//

#import "WKMakerUrlProtocol.h"

static NSString * const hasInitializationKey = @"WKMakerUrlProtocolKey";

@interface WKMakerUrlProtocol ()<NSURLSessionTaskDelegate ,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSOperationQueue *sessionDelegateQueue;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation WKMakerUrlProtocol

#pragma mark - baseMethod

//!< 判断子类是否能响应该请求
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if ([NSURLProtocol propertyForKey:hasInitializationKey inRequest:request]) {
        return NO;
    }
    //!< 判断scheme是否为http或者https
    if (![request.URL.scheme isEqualToString:@"http"] || ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    return YES;
}

//!< 自定义网络请求
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


- (void)startLoading {
    NSMutableURLRequest *request = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:hasInitializationKey inRequest:request];
    
    NSURLSessionConfiguration *configuretion = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionDelegateQueue = [[NSOperationQueue alloc] init];
    self.sessionDelegateQueue.maxConcurrentOperationCount = 1;
    self.sessionDelegateQueue.name = @"com.WKMakerProtocol.session.queue";
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuretion delegate:self delegateQueue:self.sessionDelegateQueue];
    
    self.dataTask = [session dataTaskWithRequest:request];
    [self.dataTask resume];
}

- (void)stopLoading {
    [self.dataTask cancel];
}


#pragma mark -  NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        //!< 正常取消, 不做动作
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
    self.dataTask = nil;
}

#pragma mark - NSURLSessionDataDelegate

//!< 服务器返回信息时, 这个回调函数会被ULS(URL Loading System)调用 在这里实现对返回信息的拦截
- (void)URLSession:(NSURLSession *)session
          dataTask:(nonnull NSURLSessionDataTask *)dataTask
    didReceiveData:(nonnull NSData *)data{
    //!< 首先将返回信息回传给ULS
    [self.client URLProtocol:self didLoadData:data];
    
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (dataStr) {
        NSLog(@"http拦截信息:dataStr = %@", dataStr);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session
              task:(nonnull NSURLSessionTask *)task
willPerformHTTPRedirection:(nonnull NSHTTPURLResponse *)response
        newRequest:(nonnull NSURLRequest *)request
 completionHandler:(nonnull void (^)(NSURLRequest * _Nullable))completionHandler {
    if (response != nil) {
        self.response = response;
        [self.client URLProtocol:self
          wasRedirectedToRequest:request
                redirectResponse:response];
    }
    
}

#pragma mark - 目前为止，我们上面的代码已经能够监控到绝大部分的网络请求。但是呢，如果你使用AFNETworking，你会发现，你的代码根本没有被调用。实际上 ULS允许加载多个NSURLProtocol，它们被存在一个数组里，默认情况下，AFNETWorking只会使用数组里的第一个protocol。



@end
