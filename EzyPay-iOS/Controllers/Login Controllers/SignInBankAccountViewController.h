//
//  SignInBankAccountViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/19/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface SignInBankAccountViewController : UIViewController

@property(nonatomic, assign)NSInteger tables;
@property(nonatomic, strong)User *user;
@property(nonatomic, strong)UIImage *commerceLogo;

@end
