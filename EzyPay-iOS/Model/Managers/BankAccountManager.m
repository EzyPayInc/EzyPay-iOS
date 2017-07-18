//
//  BankAccountManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/19/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "BankAccountManager.h"
#import "BankAccountServiceClient.h"

@implementation BankAccountManager

#pragma mark - CoreData methods
+ (BankAccount *)createBankAccountFromDictionary:(NSDictionary *)accountDictionary {
    BankAccount *bankAccount = [CoreDataManager createEntityWithName:@"BankAccount"];
    bankAccount.accountNumber = [accountDictionary objectForKey:@"accountNumber"];
    bankAccount.userIdentification = [accountDictionary objectForKey:@"userIdentification"];
    bankAccount.userAccount = [accountDictionary objectForKey:@"userAccount"];
    bankAccount.bank = [accountDictionary objectForKey:@"bank"];
    return bankAccount;
}


#pragma mark - Web Services methods
- (void)registerAccount:(BankAccount *)bankAccount
                  token:(NSString *)token
         successHandler:(ConnectionSuccessHandler) successHandler
         failureHandler: (ConnectionErrorHandler) failureHandler {
    BankAccountServiceClient *service = [[BankAccountServiceClient alloc] init];
    [service registerAccount:bankAccount
                       token:token
              successHandler:successHandler
              failureHandler:failureHandler];
}

- (void)getAccountByUserFromServer:(int64_t) userId
                             token:(NSString *)token
                    successHandler:(ConnectionSuccessHandler) successHandler
                    failureHandler: (ConnectionErrorHandler) failureHandler {
    BankAccountServiceClient *service = [[BankAccountServiceClient alloc] init];
    [service getAccountByUserFromServer:userId
                                  token:token
                         successHandler:successHandler
                         failureHandler:failureHandler];
}

- (void)updateAccount:(BankAccount *)bankAccount
                token:(NSString *)token
       successHandler:(ConnectionSuccessHandler) successHandler
       failureHandler: (ConnectionErrorHandler) failureHandler {
    BankAccountServiceClient *service = [[BankAccountServiceClient alloc] init];
    [service updateAccount:bankAccount
                     token:token
            successHandler:successHandler
            failureHandler:failureHandler];
}

@end
