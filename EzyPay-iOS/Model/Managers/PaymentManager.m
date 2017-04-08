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

@implementation PaymentManager

#pragma mark - CoreData Methods
+ (Payment *)paymentFromDictionary:(NSDictionary *)paymentDictionary {
    Payment *payment = [CoreDataManager createEntityWithName:@"Payment"];
    User *commerce = [CoreDataManager createEntityWithName:@"User"];
    Currency *currency = [CurrencyManager currencyFromDictionary:[paymentDictionary objectForKey:@"Currency"]];
    NSDictionary *commerceData = [paymentDictionary objectForKey:@"Commerce"];
    commerce.id = [[commerceData objectForKey:@"id"] integerValue];
    commerce.name = [commerceData objectForKey:@"name"];
    payment.commerce = commerce;
    payment.tableNumber = [[paymentDictionary objectForKey:@"tableNumber"] integerValue];
    payment.cost = [[paymentDictionary objectForKey:@"cost"] floatValue];
    payment.currency = currency;
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

+ (void)deletePayment {
    [CoreDataManager deleteDataFromEntity:@"Payment"];
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


@end
