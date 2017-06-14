//
//  ChoosePaymentMethodViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/8/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface ChoosePaymentMethodViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) int64_t tableNumber;

@end
