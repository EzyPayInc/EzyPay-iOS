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
@end
