//
//  PaymentManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/21/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "PaymentManager.h"
#import "User+CoreDataClass.h"
#import "CoreDataManager.h"
#import "PaymentServiceClient.h"
#import "CurrencyManager.h"
#import "FriendManager.h"
#import "Friend+CoreDataClass.h"

@implementation PaymentManager

#pragma mark - CoreData Methods
+ (Payment *)paymentFromDictionary:(NSDictionary *)paymentDictionary {
    Payment *payment = [CoreDataManager createEntityWithName:@"Payment"];
    User *commerce = [CoreDataManager createEntityWithName:@"User"];
    if (![[paymentDictionary valueForKey:@"Friends"] isKindOfClass:[NSNull class]]) {
        payment.friends = [NSSet setWithArray:[FriendManager friendsFromArray:[paymentDictionary valueForKey:@"Friends"]]];
    }
    Currency *currency = [CurrencyManager currencyFromDictionary:[paymentDictionary objectForKey:@"Currency"]];
    currency = currency.code == nil ? nil: currency;
    NSDictionary *commerceData = [paymentDictionary objectForKey:@"Commerce"];
    commerce.id = [[commerceData objectForKey:@"id"] integerValue];
    commerce.name = [commerceData objectForKey:@"name"];
    payment.commerce = commerce;
    payment.tableNumber = [[paymentDictionary objectForKey:@"tableNumber"] integerValue];
    payment.cost = [[paymentDictionary objectForKey:@"cost"] floatValue];
    payment.currency = currency;
    payment.paymentDate = [PaymentManager dateFromString:[paymentDictionary objectForKey:@"paymentDate"]];
    payment.employeeId = [[paymentDictionary objectForKey:@"employeeId"] integerValue];
    payment.userCost = [[paymentDictionary objectForKey:@"userCost"] isKindOfClass:[NSNull class]] ?
    0 : [[paymentDictionary objectForKey:@"userCost"] floatValue];
    payment.id = [[paymentDictionary objectForKey:@"id"] integerValue];
    return payment;
}

+ (Payment *)getPayment {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Payment"];
    NSError *error;
    NSArray *array = [[[CoreDataManager sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    if(!error && [array count] > 0){
        return [array firstObject];
    }
    return nil;
}

+ (void)updateFriendStateWithId:(int64_t)friendId withState:(int16_t)state; {
    Payment *payment = [PaymentManager getPayment];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %lld", friendId];
    NSArray *array = [[payment.friends allObjects] filteredArrayUsingPredicate:predicate];
    if([array count] > 0){
        Friend *friend = [array firstObject];
        friend.state = state;
        NSLog(@"%d", friend.state);
        [CoreDataManager saveContext];
    }
}

+ (void)deletePayment {
    [CoreDataManager deleteDataFromEntity:@"Payment"];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    if([dateString isKindOfClass:[NSNull class]]) {
        return [NSDate date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}

#pragma mark - Web Service Methods
- (void) registerPayment:(Payment *)payment user:(User *)user successHandler:(ConnectionSuccessHandler)successHandler failureHandler:(ConnectionErrorHandler) failureHandler {
    PaymentServiceClient *service = [[PaymentServiceClient alloc] init];
    [service registerPayment:payment user:user successHandler:successHandler failureHandler:failureHandler];
}

- (void) updatePayment:(Payment *)payment user:(User *)user successHandler:(ConnectionSuccessHandler)successHandler failureHandler:(ConnectionErrorHandler) failureHandler {
    PaymentServiceClient *service = [[PaymentServiceClient alloc] init];
    [service updatePayment:payment user:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)getActivePaymentByUser:(User *)user
                successHandler:(ConnectionSuccessHandler)successHandler
                failureHandler:(ConnectionErrorHandler) failureHandler {
    PaymentServiceClient *service = [[PaymentServiceClient alloc] init];
    [service getActivePaymentByUser:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)getPaymentById:(int64_t)paymentId
                 token:(NSString *)token
        successHandler:(ConnectionSuccessHandler)successHandler
        failureHandler:(ConnectionErrorHandler) failureHandler {
    PaymentServiceClient *service = [[PaymentServiceClient alloc] init];
    [service getPaymentById:paymentId
                      token:token
             successHandler:successHandler
             failureHandler:failureHandler];
    
}

- (void)deletePayment:(int64_t)paymentId
                token:(NSString *)token
       successHandler:(ConnectionSuccessHandler)successHandler
       failureHandler:(ConnectionErrorHandler) failureHandler {
    PaymentServiceClient *service = [[PaymentServiceClient alloc] init];
    [service deletePayment:paymentId
                     token:token
            successHandler:successHandler
            failureHandler:failureHandler];
}

- (void)updatePaymentAmount:(int64_t)paymentId
                 currencyId:(int64_t)currencyId
                     amount:(float)amount
                      token:(NSString *)token
             successHandler:(ConnectionSuccessHandler)successHandler
             failureHandler:(ConnectionErrorHandler) failureHandler {
    PaymentServiceClient *service = [[PaymentServiceClient alloc] init];
    [service updatePaymentAmount:paymentId
                      currencyId:currencyId
                          amount:amount
                           token:token
                  successHandler:successHandler
                  failureHandler:failureHandler];
}

@end
