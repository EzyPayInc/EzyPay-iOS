//
//  SplitViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/11/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment+CoreDataClass.h"

@interface SplitViewController : UIViewController

@property (nonatomic, strong) Payment *payment;

@end
