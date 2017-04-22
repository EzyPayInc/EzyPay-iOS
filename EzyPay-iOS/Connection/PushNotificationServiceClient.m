//
//  PushNotificationServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PushNotificationServiceClient.h"
#import "SessionHandler.h"

@interface PushNotificationServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation PushNotificationServiceClient

//constants
static NSString *const NOTIFICATIONS_URL = @"notifications/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void)callWaiterNotification:(Payment *)payment token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/callWaiter", BASE_URL, NOTIFICATIONS_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"tableNumber=%lld&commerceId=%lld",
                      payment.tableNumber, payment.commerce.id];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}


@end
