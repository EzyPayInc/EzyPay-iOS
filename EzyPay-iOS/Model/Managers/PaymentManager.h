//
//  PaymentManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Payment+CoreDataClass.h"
#import "Connection.h"

@class User;
@interface PaymentManager : NSObject

#pragma mark - CoreData Methods
+ (Payment *)paymentFromDictionary:(NSDictionary *)paymentDictionary;
+ (Payment *)getPayment;
+ (void)updateFriendStateWithId:(int64_t)friendId withState:(int16_t)state;
+ (void)deletePayment;

#pragma mark - Web Service Methods
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
