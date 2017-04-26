//
//  NotificationHandlerFactory.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/24/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationHandler.h"

typedef enum {
    CALLWAITER = 1,
    BILLREQUEST = 2,
    SENDBILL = 3
}NotificationCategories;

@interface NotificationHandlerFactory : NSObject

+ (id)initNotificationHandler:(NSString *)category;

@end
