//
//  SplitRequestNotificationHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationHandler.h"
#import "User+CoreDataClass.h"

@interface SplitRequestNotificationHandler : NSObject<NotificationHandler>

@property (nonatomic, strong)User *user;

@end
