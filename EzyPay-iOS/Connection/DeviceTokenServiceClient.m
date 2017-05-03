//
//  DeviceTokenServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/20/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "DeviceTokenServiceClient.h"
#import "SessionHandler.h"

@interface DeviceTokenServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation DeviceTokenServiceClient

static NSString *const DEVICE_TOKEN_URL = @"deviceToken/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}


- (void)registerDeviceToken:(LocalToken *)localToken
                       user:(User *)user
             successHandler:(ConnectionSuccessHandler) successHandler
             failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, DEVICE_TOKEN_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"deviceId=%@&deviceToken=%@&devicePlatform=iOS&userId=%lld",localToken.deviceId, localToken.deviceToken, user.id];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)deleteDeviceToken:(NSString *)deviceId
                     user:(User *)user
           successHandler:(ConnectionSuccessHandler) successHandler
           failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", BASE_URL, DEVICE_TOKEN_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"deviceId=%@",deviceId];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"DELETE";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:
     [NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request
                                successHandeler:successHandler
                                 failureHandler:failureHandler];
}


@end
