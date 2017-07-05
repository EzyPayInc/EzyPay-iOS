//
//  CardServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/8/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CardServiceClient.h"
#import "SessionHandler.h"
#import "User+CoreDataClass.h"

@interface CardServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation CardServiceClient

static NSString *const CARD_URL = @"card/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void)registerCard:(Card *)card user:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, CARD_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *cardHolderName = [NSString stringWithFormat:@"%@ %@", user.name, user.lastName];
    NSString *body = [NSString stringWithFormat:@"cardNumber=%@&cardHolderName=%@&customerId=%lld&ccv=%hd&expirationDate=%@&userId=%lld",
                      card.cardNumber, cardHolderName, user.customerId, card.ccv, card.expirationDate, card.user.id];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)getCardsByUserFromServer:(int64_t) userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BASE_URL, CARD_URL,@"getAll"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"userId=%ld",(long)userId];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
    
}

- (void)updateCard:(Card *)card user:(User *)user
    successHandler:(ConnectionSuccessHandler) successHandler
    failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lld", BASE_URL, CARD_URL, card.id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body =
    [NSString stringWithFormat:@"cardNumber=%@&ccv=%hd&expirationDate=%@&userId=%lld&serverId=%lld&customerId=%lld",
     card.cardNumber, card.ccv, card.expirationDate, card.user.id, card.serverId, user.customerId];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)deleteCard:(int64_t)serverId
              user:(User *)user
    successHandler:(ConnectionSuccessHandler) successHandler
    failureHandler:(ConnectionErrorHandler) failureHandler {
    NSString *parameters = [NSString stringWithFormat:@"%@%lld/customer/%lld",CARD_URL, serverId, user.customerId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, parameters]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    request.HTTPMethod = @"DELETE";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}



@end
