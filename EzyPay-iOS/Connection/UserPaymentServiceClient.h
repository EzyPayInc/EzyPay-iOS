//
//  UserPaymentServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"

@class User, Payment;
@interface UserPaymentServiceClient : NSObject

- (void)addFriendsToPayment:(Payment *)payment
                       user:(User *)user
                   userCost:(float)userCost
             successHandler:(ConnectionSuccessHandler) successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler;
-(void)updateUserPayment:(User *)user
               paymentId:(int64_t)paymentId
                   state:(int16_t)state
          successHandler:(ConnectionSuccessHandler) successHandler
          failureHandler:(ConnectionErrorHandler) failureHandler;

@end
