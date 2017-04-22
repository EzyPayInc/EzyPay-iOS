//
//  PushNotificationServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "Payment+CoreDataProperties.h"
#import "User+CoreDataProperties.h"

@interface PushNotificationServiceClient : NSObject

- (void)callWaiterNotification:(Payment *)payment token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
