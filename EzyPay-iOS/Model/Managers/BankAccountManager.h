//
//  BankAccountManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/19/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankAccount+CoreDataClass.h"
#import "Connection.h"

@interface BankAccountManager : NSObject


#pragma mark - Web Services methods
- (void)registerAccount:(BankAccount *)bankAccount
                  token:(NSString *)token
         successHandler:(ConnectionSuccessHandler) successHandler
         failureHandler: (ConnectionErrorHandler) failureHandler;

- (void)getAccountByUserFromServer:(int64_t) userId
                             token:(NSString *)token
                    successHandler:(ConnectionSuccessHandler) successHandler
                    failureHandler: (ConnectionErrorHandler) failureHandler;

- (void)updateAccount:(BankAccount *)bankAccount
                token:(NSString *)token
       successHandler:(ConnectionSuccessHandler) successHandler
       failureHandler: (ConnectionErrorHandler) failureHandler;

@end
