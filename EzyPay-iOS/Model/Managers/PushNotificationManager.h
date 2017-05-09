//
//  PushNotificationManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/22/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"

@class Payment, User;
@interface PushNotificationManager : NSObject

#pragma mark - web service clients
- (void)callWaiterNotification:(Payment *)payment
                         token:(NSString *)token
                successHandler:(ConnectionSuccessHandler) successHandler
                failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)billRequestNotification:(Payment *)payment
                          token:(NSString *)token
                 successHandler:(ConnectionSuccessHandler) successHandler
                 failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)sendBillNotification:(int64_t)clientId
                currencyCode:(NSString *)currencyCode
                      amount:(CGFloat)amount
                   paymentId:(int64_t)paymentId
                       token:(NSString *)token
              successHandler:(ConnectionSuccessHandler) successHandler
              failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)splitRequestNotification:(User *)user
                         payment:(Payment *)payment
                  successHandler:(ConnectionSuccessHandler) successHandler
                  failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)responseSplitNotification:(User *)user
                         response:(NSInteger)response
                         clientId:(int64_t)clientId
                   successHandler:(ConnectionSuccessHandler) successHandler
                   failureHandler: (ConnectionErrorHandler) failureHandler;

@end
