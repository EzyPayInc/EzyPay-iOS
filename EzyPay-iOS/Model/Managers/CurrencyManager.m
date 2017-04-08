//
//  CurrencyManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "CurrencyManager.h"
#import "CurrencyServiceClient.h"
#import "CoreDataManager.h"

@implementation CurrencyManager

#pragma - mark coredata methods
+ (Currency *)currencyFromDictionary:(NSDictionary *)currencyDictionary {
    Currency *currency = [CoreDataManager createEntityWithName:@"Currency"];
    currency.id = [[currencyDictionary objectForKey:@"id"] integerValue];
    currency.name = [currencyDictionary objectForKey:@"name"];
    currency.code = [currencyDictionary objectForKey:@"code"];
    return currency;
}

+ (NSArray *)currenciesFromArray:(NSArray *)currenciesArray {
    [CurrencyManager deleteCurrencies];
    NSMutableArray *currencies = [NSMutableArray array];
    for (NSDictionary *curencyDictionary in currenciesArray) {
        Currency *currency = [CurrencyManager currencyFromDictionary:curencyDictionary];
        [currencies addObject:currency];
    }
    if ([currencies count] > 0) {
        [CoreDataManager saveContext];
    }
    return currencies;
}

+ (void)deleteCurrencies
{
    [CoreDataManager deleteDataFromEntity:@"Currency"];
}

#pragma - mark web service methods
- (void)getAllCurriencies:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    CurrencyServiceClient *service = [[CurrencyServiceClient alloc] init];
    [service getAllCurriencies:token successHandler:successHandler failureHandler:failureHandler];
}

@end
