//
//  BankAccountViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/22/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"


typedef enum {
    ViewBankAccount,
    AddBankAccount,
    EditBankAccount
}BankAccountDetailViewType;

@interface BankAccountViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BankAccountDetailViewType viewMode;

@end
