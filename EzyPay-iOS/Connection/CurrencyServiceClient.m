//
//  CurrencyServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "CurrencyServiceClient.h"
#import "SessionHandler.h"

@interface CurrencyServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation CurrencyServiceClient

static NSString *const TABLE_URL = @"currency/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void)getAllCurriencies:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BASE_URL, TABLE_URL,@"getAll"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
    
}

@end
