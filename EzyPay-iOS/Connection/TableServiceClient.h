//
//  TableServiceClient.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/11/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//
#import "Table+CoreDataClass.h"
#import "Connection.h"

@interface TableServiceClient : NSObject

- (void)registerTable:(Table *)table token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;
- (void)getTablesByRestaurantFromServer:(int64_t) restaurantId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler;

@end
