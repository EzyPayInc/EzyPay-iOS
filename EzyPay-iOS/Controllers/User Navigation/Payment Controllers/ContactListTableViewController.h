//
//  ContactListTableViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/2/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment+CoreDataClass.h"

@interface ContactListTableViewController : UITableViewController

@property (nonatomic, strong) Payment *payment;

@end
