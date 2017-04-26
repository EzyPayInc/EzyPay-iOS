//
//  NotificationHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/24/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//
@protocol NotificationHandler<NSObject>

- (void)notificationAction:(NSDictionary *)notification;

@end
