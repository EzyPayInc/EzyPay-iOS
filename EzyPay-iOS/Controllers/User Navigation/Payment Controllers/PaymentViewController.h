//
//  PaymentViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 2/12/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSArray *splitContacts;

@end
