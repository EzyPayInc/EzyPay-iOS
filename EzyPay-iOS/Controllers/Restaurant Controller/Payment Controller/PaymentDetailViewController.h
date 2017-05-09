//
//  PaymentDetailViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface PaymentDetailViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) int64_t tableNumber;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, assign) int64_t clientId;
@property (nonatomic, assign) int64_t paymentId;

@end
