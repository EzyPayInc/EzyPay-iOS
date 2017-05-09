//
//  CallWaiterNotificationHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 5/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationHandler.h"
#import "UserManager.h"

@interface CallWaiterNotificationHandler : NSObject<NotificationHandler>

@property (nonatomic, strong)User *user;

@end
