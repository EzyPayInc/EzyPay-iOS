//
//  PushNotificationManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/22/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@class Payment;
@interface PushNotificationManager : NSObject

#pragma mark - web service clients
- (void)callWaiterNotification:(Payment *)payment token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
