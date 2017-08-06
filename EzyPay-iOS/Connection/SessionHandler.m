//
//  SessionHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SessionHandler.h"
#import "Connection.h"
#import "CompletionHandler.h"
#import <UIKit/UIKit.h>

@interface SessionHandler()<NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property(nonatomic, strong)NSURLSession* session;
@property(nonatomic, strong)NSMutableDictionary* connections;
@property(nonatomic, strong)CompletionHandler* completionHandler;
@end

@implementation SessionHandler

//NSString *const BASE_URL = @"https://ugwo-platform.appspot.com/";
NSString *const BASE_URL = @"http://192.168.1.54:8080/";
NSString *const IMAGE_URL = @"https://storage.googleapis.com/ugwo-contact-pictures/";
NSString *const CLIENT_ID  = @"ceWZ_4G8CjQZy7,8";
NSString *const SECRET_KEY = @"9F=_wPs^;W]=Hqf!3e^)ZpdR;MUym+";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.connections = [[NSMutableDictionary alloc] init];
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                     delegate:self
                                                delegateQueue:[NSOperationQueue mainQueue]];
        self.completionHandler = [[CompletionHandler alloc] init];
    }
    return self;
}

- (void)sendRequestWithRequest:(NSURLRequest *)request successHandeler:(id)successHandler failureHandler:(id)failureHandler {
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    Connection *connection = [[Connection alloc]init];
    connection.dataTask = task;
    connection.successHandler = successHandler;
    connection.errorHandler = failureHandler;
    
    [self.connections setObject:connection forKey:@(task.taskIdentifier)];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler
{
    Connection *connection = [self.connections objectForKey: @(dataTask.taskIdentifier)];
    connection.response = (NSHTTPURLResponse *)response;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    Connection *connection = [self.connections objectForKey: @(dataTask.taskIdentifier)];
    if(!connection.data) {
        connection.data = [[NSMutableData alloc] init];
    }
    [connection.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    Connection *connection = [self.connections objectForKey: @(task.taskIdentifier)];
    connection.error = error;
    [self.completionHandler handleResponse:connection];
    [self.connections removeObjectForKey:@(task.taskIdentifier)];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if(response) {
        NSMutableURLRequest *mutableRequest = request.mutableCopy;
        mutableRequest.allHTTPHeaderFields = task.originalRequest.allHTTPHeaderFields;
        completionHandler(mutableRequest);
    } else {
        completionHandler(nil);
    }
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

@end
