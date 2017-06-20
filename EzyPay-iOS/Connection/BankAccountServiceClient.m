//
//  BankAccountServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/19/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "BankAccountServiceClient.h"
#import "SessionHandler.h"
#import "User+CoreDataClass.h"

@interface BankAccountServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation BankAccountServiceClient

static NSString *const BANK_ACCOUNT_URL = @"bankAccount/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void)registerAccount:(BankAccount *)bankAccount
                  token:(NSString *)token
         successHandler:(ConnectionSuccessHandler) successHandler
         failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, BANK_ACCOUNT_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"userIdentification=%@&accountNumber=%@&userId=%lld",bankAccount.userIdentification, bankAccount.accountNumber, bankAccount.user.id];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)getAccountByUserFromServer:(int64_t) userId
                             token:(NSString *)token
                    successHandler:(ConnectionSuccessHandler) successHandler
                    failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BASE_URL, BANK_ACCOUNT_URL,@"getAll"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"userId=%ld",(long)userId];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
    
}

- (void)updateAccount:(BankAccount *)bankAccount
                token:(NSString *)token
       successHandler:(ConnectionSuccessHandler) successHandler
       failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lld", BASE_URL, BANK_ACCOUNT_URL, bankAccount.user.id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"userIdentification=%@&accountNumber=%@&userId=%lld",bankAccount.userIdentification, bankAccount.accountNumber, bankAccount.user.id];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}


@end
