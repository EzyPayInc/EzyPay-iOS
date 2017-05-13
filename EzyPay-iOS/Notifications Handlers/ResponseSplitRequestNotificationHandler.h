//
//  ResponseSplitRequestNotificationHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 5/1/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationHandler.h"
#import "User+CoreDataClass.h"

@interface ResponseSplitRequestNotificationHandler : NSObject<NotificationHandler>

@property (nonatomic, strong)User *user;

@end
