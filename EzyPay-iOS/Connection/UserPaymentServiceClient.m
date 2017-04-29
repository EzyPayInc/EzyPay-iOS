//
//  UserPaymentServiceClient.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/28/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "UserPaymentServiceClient.h"
#import "SessionHandler.h"
#import "User+CoreDataClass.h"
#import "Payment+CoreDataClass.h"
#import "Friend+CoreDataClass.h"

@interface UserPaymentServiceClient()

@property(nonatomic,strong) SessionHandler *sessionHandler;

@end

@implementation UserPaymentServiceClient

//constants
static NSString *const USERPAYMENT_URL = @"userPayment/";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionHandler = [[SessionHandler alloc] init];
    }
    return self;
}


-(void)updateUserPayment:(User *)user
               paymentId:(int64_t)paymentId
                   state:(int16_t)state
          successHandler:(ConnectionSuccessHandler) successHandler
          failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@%lld", BASE_URL, USERPAYMENT_URL, paymentId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSMutableDictionary *postData = [self createUserPayment:user.id paymentId:paymentId cost:0 state:state];
    [postData removeObjectForKey:@"cost"];
    NSData *body = [NSJSONSerialization dataWithJSONObject:postData options:0 error:nil];
    request.HTTPBody = body;
    request.HTTPMethod = @"PUT";
    [request addValue:
    [NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}

- (void)addFriendsToPayment:(Payment *)payment
                      user:(User *)user
                   userCost:(float)userCost
             successHandler:(ConnectionSuccessHandler) successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler {
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@/addFriends", BASE_URL, USERPAYMENT_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSDictionary *postArray = @{@"friends": [self setPaymentIdToFriends:payment user:user userCost:userCost]};
    NSData *body = [NSJSONSerialization dataWithJSONObject:postArray options:0 error:nil];
    request.HTTPBody = body;
    request.HTTPMethod = @"POST";
    [request addValue:
     [NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.sessionHandler sendRequestWithRequest:request successHandeler:successHandler failureHandler:failureHandler];
}


- (NSArray *)setPaymentIdToFriends:(Payment *)payment user:(User *)user userCost:(float)userCost {
    NSMutableArray *friends = [NSMutableArray array];
    NSDictionary *friendDictionary = [self createUserPayment:user.id
                                                   paymentId:payment.id
                                                        cost:userCost
                                                       state:1];
    [friends addObject:friendDictionary];
    for (Friend *friend in payment.friends) {
        friendDictionary = [self createUserPayment:friend.id
                                         paymentId:payment.id
                                              cost:friend.cost
                                             state:friend.state];
        [friends addObject:friendDictionary];
    }
    return friends;
}

- (NSMutableDictionary *)createUserPayment:(int64_t)userId
                          paymentId:(int64_t)paymentId
                               cost:(float)cost
                              state:(int16_t) state {
    NSMutableDictionary *friendDictionary = [NSMutableDictionary dictionary];
    [friendDictionary setObject:[NSNumber numberWithLongLong:userId] forKey:@"userId"];
    [friendDictionary setObject:[NSNumber numberWithLongLong:paymentId]  forKey:@"paymentId"];
    [friendDictionary setObject:[NSNumber numberWithFloat:cost] forKey:@"cost"];
    [friendDictionary setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    return friendDictionary;
}

@end
