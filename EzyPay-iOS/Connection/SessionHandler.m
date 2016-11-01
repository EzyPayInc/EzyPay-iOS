//
//  SessionHandler.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 10/31/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "SessionHandler.h"

@interface SessionHandler()

@property(nonatomic, strong)NSURLSession* session;

@end

@implementation SessionHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

- (void )sendRequestWithRequest:(NSURLRequest *)request successHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) successHandler {
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:successHandler];
    [task resume];
}

@end
