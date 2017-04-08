//
//  QRPaymentViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/13/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "Payment+CoreDataClass.h"

@interface QRPaymentViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) CGFloat cost;
@property (nonatomic, assign) int64_t tableNumber;
@property (nonatomic, strong) Payment *payment;

@end
