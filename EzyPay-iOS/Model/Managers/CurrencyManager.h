//
//  CurrencyManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 4/7/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"
#import "Currency+CoreDataClass.h"

@interface CurrencyManager : NSObject

#pragma - mark coredata methods
+ (Currency *)currencyFromDictionary:(NSDictionary *)currencyDictionary;
+ (NSArray *)currenciesFromArray:(NSArray *)currenciesArray;

#pragma - mark web service methods
- (void)getAllCurriencies:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
