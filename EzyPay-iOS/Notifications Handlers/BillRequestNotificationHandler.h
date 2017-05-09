//
//  BillRequestNotificationHandler.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/24/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationHandler.h"
#import "UserManager.h"

@interface BillRequestNotificationHandler : NSObject<NotificationHandler>

@property (nonatomic, strong)User *user;

@end
