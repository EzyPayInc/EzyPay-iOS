//
//  RestaurantDetailViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/2/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ticket;
@interface RestaurantDetailViewController : UIViewController

@property(nonatomic, assign) Ticket *ticket;

@end
