//
//  SendBillNotificationHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/25/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationHandler.h"
#import "User+CoreDataClass.h"

@interface SendBillNotificationHandler : NSObject<NotificationHandler>

@property (nonatomic, strong)User *user;

@end
