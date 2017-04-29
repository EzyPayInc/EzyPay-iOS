//
//  NotificationHandlerFactory.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/24/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "NotificationHandlerFactory.h"
#import "BillRequestNotificationHandler.h"
#import "GeneralNotificationHandler.h"
#import "SendBillNotificationHandler.h"
#import "SplitRequestNotificationHandler.h"


@implementation NotificationHandlerFactory


+ (id)initNotificationHandler:(NSString *)category {
    NSInteger notificationCategory = [category integerValue];
    id<NotificationHandler> handler;
    switch (notificationCategory) {
        case BILLREQUEST: 
            handler = [[BillRequestNotificationHandler alloc] init];
            break;
        case SENDBILL:
            handler = [[SendBillNotificationHandler alloc] init];
            break;
        case SPLITREQUEST:
            handler = [[SplitRequestNotificationHandler alloc] init];
            break;
        case CALLWAITER:
        default:
            handler = [[GeneralNotificationHandler alloc] init];
            break;
    }
    return handler;
}



@end
