//
//  PaymentServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PaymentServiceClient.h"
#import "SessionHandler.h"
#import "Payment+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Currency+CoreDataClass.h"

@interface PaymentServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

//constants
static NSString *const PAYMENT_URL = @"payment/";


@implementation PaymentServiceClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}


- (void) registerPayment:(Payment *)payment
                    user:(User *)user
          successHandler:(ConnectionSuccessHandler)successHandler
          failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, PAYMENT_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    int64_t  currency = payment.currency.id == 0 ? 1 : payment.currency.id;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *paymentDate = [dateFormatter stringFromDate:payment.paymentDate];
    NSString *body = [NSString stringWithFormat:@"commerceId=%lld&userId=%lld&cost=%f&tableNumber=%lld&isCanceled=%d&currencyId=%lld&employeeId=%lld&paymentDate=%@", payment.commerce.id, user.id, payment.cost, payment.tableNumber,0,currency , payment.employeeId,paymentDate];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void) updatePayment:(Payment *)payment
                  user:(User *)user
        successHandler:(ConnectionSuccessHandler)successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%lld", BASE_URL, PAYMENT_URL, payment.id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *paymentDate = [dateFormatter stringFromDate:payment.paymentDate];
    NSString *body = [NSString stringWithFormat:@"commerceId=%lld&userId=%lld&cost=%f&tableNumber=%lld&isCanceled=%d&paymentDate=%@",
                      payment.commerce.id, user.id, payment.cost, payment.tableNumber,payment.isCanceled,paymentDate];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)getActivePaymentByUser:(User *)user
                successHandler:(ConnectionSuccessHandler)successHandler
                failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@activePayment/%lld",BASE_URL, PAYMENT_URL, user.id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    request.HTTPMethod = @"GET";
    [request addValue:
     [NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request
                                successHandeler:successHandler
                                 failureHandler:failureHandler];
}

- (void)getPaymentById:(int64_t)paymentId
                 token:(NSString *)token
        successHandler:(ConnectionSuccessHandler)successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@/%lld",BASE_URL, PAYMENT_URL, paymentId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    request.HTTPMethod = @"GET";
    [request addValue:
     [NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request
                                successHandeler:successHandler
                                 failureHandler:failureHandler];
}

- (void)deletePayment:(int64_t)paymentId
                token:(NSString *)token
        successHandler:(ConnectionSuccessHandler)successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@/%lld",BASE_URL, PAYMENT_URL, paymentId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    request.HTTPMethod = @"DELETE";
    [request addValue:
    [NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request
                                successHandeler:successHandler
                                 failureHandler:failureHandler];
}

- (void)updatePaymentAmount:(int64_t)paymentId
                    currencyId:(int64_t)currencyId
                        amount:(float)amount
                        token:(NSString *)token
               successHandler:(ConnectionSuccessHandler)successHandler
               failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%lld", BASE_URL, PAYMENT_URL, paymentId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"currencyId=%lld&cost=%f", currencyId, amount];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)performPayment:(Payment *)payment
                 token:(NSString *)token
        successHandler:(ConnectionSuccessHandler)successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/pay", BASE_URL, PAYMENT_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *body = [NSString stringWithFormat:@"id=%lld", payment.id];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}



@end
