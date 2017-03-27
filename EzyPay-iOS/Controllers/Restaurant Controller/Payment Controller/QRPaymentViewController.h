//
//  QRPaymentViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/13/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableManager.h"

@interface QRPaymentViewController : UIViewController

@property (nonatomic, strong) Table *table;
@property (nonatomic, assign) CGFloat cost;

@end
