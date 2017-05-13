//
//  PushNotificationManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/22/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PushNotificationManager.h"
#import "PushNotificationServiceClient.h"

@implementation PushNotificationManager

- (void)callWaiterNotification:(Payment *)payment token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    PushNotificationServiceClient *service = [[PushNotificationServiceClient alloc] init];
    [service callWaiterNotification:payment
                              token:token
                     successHandler:successHandler
                     failureHandler:failureHandler];
}

- (void)billRequestNotification:(Payment *)payment
                          token:(NSString *)token
                 successHandler:(ConnectionSuccessHandler) successHandler
                 failureHandler: (ConnectionErrorHandler) failureHandler {
    PushNotificationServiceClient *service = [[PushNotificationServiceClient alloc] init];
    [service billRequestNotification:payment
                               token:token
                      successHandler:successHandler
                      failureHandler:failureHandler];
}

- (void)sendBillNotification:(int64_t)clientId
                currencyCode:(NSString *)currencyCode
                      amount:(CGFloat)amount
                   paymentId:(int64_t)paymentId
                       token:(NSString *)token
              successHandler:(ConnectionSuccessHandler) successHandler
              failureHandler: (ConnectionErrorHandler) failureHandler {
    PushNotificationServiceClient *service = [[PushNotificationServiceClient alloc] init];
    [service sendBillNotification:clientId
                     currencyCode:currencyCode
                           amount:amount
                        paymentId:paymentId
                            token:token
                   successHandler:successHandler
                   failureHandler:failureHandler];
}

- (void)splitRequestNotification:(User *)user
                         payment:(Payment *)payment
                  successHandler:(ConnectionSuccessHandler) successHandler
                  failureHandler: (ConnectionErrorHandler) failureHandler {
    PushNotificationServiceClient *service = [[PushNotificationServiceClient alloc] init];
    [service splitRequestNotification:user payment:payment successHandler:successHandler failureHandler:failureHandler];
    
}


- (void)responseSplitNotification:(User *)user
                       paymentId:(int64_t)paymentId
                         response:(NSInteger)response
                        clientId:(int64_t)clientId
                  successHandler:(ConnectionSuccessHandler) successHandler
                  failureHandler: (ConnectionErrorHandler) failureHandler {
    PushNotificationServiceClient *service = [[PushNotificationServiceClient alloc] init];
    [service responseSplitNotification:user
                              paymentId:paymentId
                              response:response
                              clientId:clientId
                        successHandler:successHandler
                        failureHandler:failureHandler];
}


@end
