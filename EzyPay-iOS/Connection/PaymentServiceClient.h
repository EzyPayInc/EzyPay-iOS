//
//  PaymentServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@class Payment, User;
@interface PaymentServiceClient : NSObject

- (void) registerPayment:(Payment *)payment user:(User *)user successHandler:(ConnectionSuccessHandler)successHandler failureHandler:(ConnectionErrorHandler) failureHandler;
- (void) updatePayment:(Payment *)payment user:(User *)user successHandler:(ConnectionSuccessHandler)successHandler failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)getActivePaymentByUser:(User *)user
                successHandler:(ConnectionSuccessHandler)successHandler
                failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)getPaymentById:(int64_t)paymentId
                 token:(NSString *)token
        successHandler:(ConnectionSuccessHandler)successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)deletePayment:(int64_t)paymentId
                token:(NSString *)token
       successHandler:(ConnectionSuccessHandler)successHandler
       failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)updatePaymentAmount:(int64_t)paymentId
                 currencyId:(int64_t)currencyId
                     amount:(float)amount
                      token:(NSString *)token
             successHandler:(ConnectionSuccessHandler)successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler;
- (void)performPayment:(Payment *)payment
                 token:(NSString *)token
        successHandler:(ConnectionSuccessHandler)successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler;
@end
