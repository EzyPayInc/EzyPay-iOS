//
//  PushNotificationServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PushNotificationServiceClient.h"
#import "SessionHandler.h"
#import "Payment+CoreDataClass.h"
#import "Currency+CoreDataClass.h"
#import "Friend+CoreDataClass.h"

@interface PushNotificationServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation PushNotificationServiceClient

//constants
static NSString *const NOTIFICATIONS_URL = @"notifications/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}

- (void)callWaiterNotification:(Payment *)payment
                         token:(NSString *)token
                successHandler:(ConnectionSuccessHandler) successHandler
                failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/callWaiter", BASE_URL, NOTIFICATIONS_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"tableNumber=%lld&commerceId=%lld",
                      payment.tableNumber, payment.commerce.id];
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0]
                            componentsSeparatedByString:@"-"] objectAtIndex:0];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [request addValue:language forHTTPHeaderField:@"lang"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)billRequestNotification:(Payment *)payment
                          token:(NSString *)token
                 successHandler:(ConnectionSuccessHandler) successHandler
                 failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/billRequest", BASE_URL, NOTIFICATIONS_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"tableNumber=%lld&commerceId=%lld",
                      payment.tableNumber, payment.commerce.id];
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0]
                            componentsSeparatedByString:@"-"] objectAtIndex:0];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [request addValue:language forHTTPHeaderField:@"lang"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)sendBillNotification:(int64_t)clientId
                currencyCode:(NSString *)currencyCode
                      amount:(CGFloat)amount
                       token:(NSString *)token
              successHandler:(ConnectionSuccessHandler) successHandler
              failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/sendBill", BASE_URL, NOTIFICATIONS_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"clientId=%lld&currencyCode=%@&amount=%f",
                      clientId, currencyCode, amount];
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0]
                            componentsSeparatedByString:@"-"] objectAtIndex:0];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [request addValue:language forHTTPHeaderField:@"lang"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)splitRequestNotification:(User *)user
                         payment:(Payment *)payment
                  successHandler:(ConnectionSuccessHandler) successHandler
                  failureHandler: (ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/splitRequest", BASE_URL, NOTIFICATIONS_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSDictionary *paymentDictionary = @{@"paymentId": [NSNumber numberWithLongLong:payment.id],
                                        @"currency": payment.currency.code,
                                        @"cost": [NSNumber numberWithFloat:payment.cost]};
    NSDictionary *data = @{@"friends": [self getFriends:payment.friends], @"payment": paymentDictionary};

    NSDictionary *postData = @{@"data": data};

    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0]
                            componentsSeparatedByString:@"-"] objectAtIndex:0];
    NSData *body = [NSJSONSerialization dataWithJSONObject:postData options:NSUTF8StringEncoding error:nil];
    request.HTTPBody = body;
    request.HTTPMethod = @"POST";
    [request addValue:
     [NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:language forHTTPHeaderField:@"lang"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];

}

- (NSArray *)getFriends:(NSSet *)friends {
    NSMutableArray *friensToSend = [NSMutableArray array];
    for (Friend *friend in friends) {
        NSMutableDictionary *friendDictionary = [NSMutableDictionary dictionary];
        [friendDictionary setObject:[NSNumber numberWithLongLong:friend.id] forKey:@"id"];
        [friendDictionary setObject:[NSNumber numberWithFloat:friend.cost] forKey:@"cost"];
        [friensToSend addObject:friendDictionary];
    }
    return friensToSend;
}


@end
